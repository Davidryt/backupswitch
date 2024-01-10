package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"syscall"
	"time"

	"github.com/asavie/xdp"
	"github.com/vishvananda/netlink"
	"golang.org/x/sys/unix"
)

//	__________________________________________  COLAS  __________________________________________

type PacketQueue struct {
	Queues [][]xdp.Desc // Un slice de slices, donde cada slice interno es una cola
}

func Createqueues(numberOfQueues int) *PacketQueue {
	packetQueue := &PacketQueue{
		Queues: make([][]xdp.Desc, numberOfQueues),
	}

	// Inicializar cada cola
	for i := range packetQueue.Queues {
		packetQueue.Queues[i] = make([]xdp.Desc, 0)
	}

	return packetQueue
}

func (pq *PacketQueue) AddPacketDesc(queueIndex int, packetDesc xdp.Desc) {
	// Asegurarse de que queueIndex esté dentro de los límites
	if queueIndex < 0 || queueIndex >= len(pq.Queues) {
		// Manejar el error o ignorar la adición
		return
	}
	pq.Queues[queueIndex] = append(pq.Queues[queueIndex], packetDesc)
}

func (pq *PacketQueue) GetPacketDescs(queueIndex int) []xdp.Desc {
	// Asegurarse de que queueIndex esté dentro de los límites
	if queueIndex < 0 || queueIndex >= len(pq.Queues) {
		// Retornar una lista vacía o manejar el error
		return []xdp.Desc{}
	}
	return pq.Queues[queueIndex]
}

//	__________________________________________  MAIN  __________________________________________

func main() {
	var inLinkName string
	var inLinkQueueID int
	var outLinkName string
	var outLinkQueueID int
	var queues int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -inlink <network link name> -outlink <network link name> -queues <number of queues>\n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&inLinkName, "inlink", "", "Input network link name.")
	flag.IntVar(&inLinkQueueID, "inlinkqueue", 0, "The queue ID to attach to on input link.")
	flag.StringVar(&outLinkName, "outlink", "", "Output network link name.")
	flag.IntVar(&outLinkQueueID, "outlinkqueue", 0, "The queue ID to attach to on output link.")
	flag.IntVar(&queues, "queues", 0, "Number of queues (between 1 and 6).")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if inLinkName == "" || outLinkName == "" || queues == 0 {
		flag.Usage()
		os.Exit(1)
	}

	inLink, err := netlink.LinkByName(inLinkName)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", inLinkName, err)
	}

	outLink, err := netlink.LinkByName(outLinkName)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", outLinkName, err)
	}

	if queues < 1 || queues > 6 {
		fmt.Println("Error: The 'queues' flag must be between 1 and 6.")
		os.Exit(1)
	}

	launchswitch(verbose, inLink, inLinkQueueID, outLink, outLinkQueueID, queues)
}

func launchswitch(verbose bool, inLink netlink.Link, inLinkQueueID int, outLink netlink.Link, outLinkQueueID int, queues int) {
	//HERE WE DO INTERFACE 1

	log.Printf("attaching XDP program for %s...", inLink.Attrs().Name)
	inProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load xdp program: %v\n", err)
	}

	if err := inProg.Attach(inLink.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer inProg.Detach(inLink.Attrs().Index)
	log.Printf("opening XDP socket for %s...", inLink.Attrs().Name)
	inXsk, err := xdp.NewSocket(inLink.Attrs().Index, inLinkQueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", inLink.Attrs().Name, err)
	}
	log.Printf("registering XDP socket for %s...", inLink.Attrs().Name)
	if err := inProg.Register(inLinkQueueID, inXsk.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer inProg.Unregister(inLinkQueueID)

	//HERE WE DO INTERFACE 2

	log.Printf("attaching XDP program for %s...", outLink.Attrs().Name)
	outProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load xdp program: %v\n", err)
	}

	if err := outProg.Attach(outLink.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer outProg.Detach(outLink.Attrs().Index)

	log.Printf("opening XDP socket for %s...", outLink.Attrs().Name)
	outXsk, err := xdp.NewSocket(outLink.Attrs().Index, outLinkQueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", outLink.Attrs().Name, err)
	}

	if err := outProg.Register(outLinkQueueID, outXsk.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer outProg.Unregister(outLinkQueueID)

	log.Printf("starting TSN Switch...")

	packetQueues := Createqueues(queues)

	log.Printf("Created %d queues", len(packetQueues.Queues))

	numBytesTotal := uint64(0)
	numFramesTotal := uint64(0)
	if verbose {
		go func() {
			var numBytesPrev, numFramesPrev uint64
			var numBytesNow, numFramesNow uint64
			for {
				numBytesPrev = numBytesNow
				numFramesPrev = numFramesNow
				time.Sleep(time.Duration(1) * time.Second)
				numBytesNow = numBytesTotal
				numFramesNow = numFramesTotal
				pps := numFramesNow - numFramesPrev
				bps := (numBytesNow - numBytesPrev) * 8
				log.Printf("%9d pps / %6d Mbps", pps, bps/1000000)
			}
		}()
	}

	var fds [2]unix.PollFd
	fds[0].Fd = int32(inXsk.FD())
	fds[1].Fd = int32(outXsk.FD())
	go func() {
		for {

			inXsk.Fill(inXsk.GetDescs(inXsk.NumFreeFillSlots(), true))

			fds[0].Events = unix.POLLIN

			if inXsk.NumTransmitted() > 0 {
				fds[0].Events |= unix.POLLOUT
			}
			fds[0].Revents = 0

			_, err := unix.Poll(fds[:], -1)
			if err == syscall.EINTR {
				// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
				continue
			} else if err != nil {
				fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
				os.Exit(1)
			}

			if (fds[0].Revents & unix.POLLIN) != 0 {
				storepackets(inXsk, packetQueues)
				//numBytes, numFrames := forwardFrames(inXsk, outXsk)
				numBytes, numFrames := forwardFrames3(inXsk, packetQueues, outXsk, 1, true)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}
			if (fds[0].Revents & unix.POLLOUT) != 0 {
				inXsk.Complete(inXsk.NumCompleted())
			}
		}
	}()

	for {
		outXsk.Fill(outXsk.GetDescs(outXsk.NumFreeFillSlots(), true))

		fds[1].Events = unix.POLLIN
		if outXsk.NumTransmitted() > 0 {
			fds[1].Events |= unix.POLLOUT
		}

		fds[1].Revents = 0

		_, err := unix.Poll(fds[:], -1)
		if err == syscall.EINTR {
			// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
			continue
		} else if err != nil {
			fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
			os.Exit(1)
		}

		if (fds[1].Revents & unix.POLLIN) != 0 {
			storepackets(outXsk, packetQueues)
			//numBytes, numFrames := forwardFrames(outXsk, inXsk)
			numBytes, numFrames := forwardFrames3(inXsk, packetQueues, outXsk, 1, true)
			numBytesTotal += numBytes
			numFramesTotal += numFrames
		}
		if (fds[1].Revents & unix.POLLOUT) != 0 {
			outXsk.Complete(outXsk.NumCompleted())
		}
	}

}

/*func forwardFrames(input *xdp.Socket, output *xdp.Socket) (numBytes uint64, numFrames uint64) {
	inDescs := input.Receive(input.NumReceived())
	outDescs := output.GetDescs(output.NumFreeTxSlots(), false)

	if len(inDescs) > len(outDescs) {
		inDescs = inDescs[:len(outDescs)]
	}
	numFrames = uint64(len(inDescs))

	for i := 0; i < len(inDescs); i++ {
		outFrame := output.GetFrame(outDescs[i])
		inFrame := input.GetFrame(inDescs[i])
		numBytes += uint64(len(inFrame))
		outDescs[i].Len = uint32(copy(outFrame, inFrame))
	}
	outDescs = outDescs[:len(inDescs)]

	output.Transmit(outDescs)

	return
}

func forwardFrames2(packetQueues *PacketQueue, output *xdp.Socket, gate bool) (numBytes uint64, numFrames uint64) {
	if !gate {
		return 0, 0 // If the gate is closed, do not process any packets
	}

	for _, queue := range packetQueues.Queues {
		for _, desc := range queue {
			inFrame := // Replace with actual function to get a frame data from a descriptor

			if len(inFrame) == 0 {
				continue // Skip empty or invalid frames
			}

			// Prepare to send the packet
			outDescs := output.GetDescs(1, false) // Get one descriptor for output
			outFrame := output.GetFrame(outDescs[0])
			numBytes += uint64(len(inFrame))

			// Copy the frame data to the output descriptor
			outDescs[0].Len = uint32(copy(outFrame, inFrame))
			output.Transmit(outDescs) // Transmit the packet

			numFrames++
		}
	}

	return numBytes, numFrames
}*/

func forwardFrames3(input *xdp.Socket, packetQueues *PacketQueue, output *xdp.Socket, priority int, gate bool) (numBytes uint64, numFrames uint64) {

	if !gate || priority < 0 || priority >= len(packetQueues.Queues) {
		log.Printf("Error, aborting")
		return 0, 0 // Exit if the gate is closed or priority is out of range
	}

	queue := packetQueues.Queues[priority-1] // Select the queue based on the priority index
	numToProcess := min(len(queue), output.NumFreeTxSlots())
	log.Printf("Packets to process: %d", numToProcess)
	log.Printf("queue to foward: %d", queue)
	for _, desc := range queue {
		if numToProcess == 0 {
			break // Break if no more packets to process
		}
		inFrame := input.GetFrame(desc) // Replace with actual function to get frame data from descriptor
		log.Printf("inframe: %d", inFrame)
		if len(inFrame) == 0 {
			log.Printf("Bad Frame, skyping")
			continue // Skip empty or invalid frames
		}

		// Prepare to send the packet
		outDescs := output.GetDescs(1, false) // Get one descriptor for output
		outFrame := output.GetFrame(outDescs[0])
		numBytes += uint64(len(inFrame))

		// Copy the frame data to the output descriptor
		outDescs[0].Len = uint32(copy(outFrame, inFrame))
		output.Transmit(outDescs) // Transmit the packet

		numFrames++
		numToProcess--
	}

	return numBytes, numFrames
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func storepackets(xsk *xdp.Socket, packetQueues *PacketQueue) error {
	// Verifica cuántos paquetes han sido recibidos
	numReceived := xsk.NumReceived()
	if numReceived == 0 {
		return nil
	}

	// Recibe los descriptores de los paquetes
	descs := xsk.Receive(numReceived)
	log.Printf("descs: %d", descs)
	for _, desc := range descs {
		log.Printf("desc: %+v\n", desc)
	}

	// Obtiene las prioridades de los descriptores
	priorities, err := getPriority(xsk, descs)
	log.Printf("prio: %d", priorities)
	if err != nil {
		return fmt.Errorf("error obteniendo prioridades: %w", err)
	}

	// Asigna descriptores a las colas basado en prioridades
	for i, desc := range descs {
		priority := priorities[i]
		queueIndex := priority - 1 // Ajusta el índice de la cola si es necesario
		log.Printf("desc %d : %d", i, desc)
		// Verifica que la prioridad sea válida y que la cola exista
		if queueIndex >= 0 && queueIndex < len(packetQueues.Queues) {
			log.Printf("Almacenando")
			packetQueues.AddPacketDesc(queueIndex, desc)
			log.Printf("Array: %d", packetQueues.GetPacketDescs(queueIndex))
		}
	}

	return nil
}

func getPriority(xsk *xdp.Socket, descs []xdp.Desc) ([]int, error) {
	priorities := make([]int, len(descs))

	for i, desc := range descs {
		frame := xsk.GetFrame(desc)
		if isVLAN(frame) {
			vlanID, err := getVLANID(frame)
			if err != nil {
				return nil, err
			}
			priorities[i] = vlanID
		} else {
			// Asignar una prioridad por defecto a paquetes que no son VLAN
			priorities[i] = 1 // defaultPriority es un valor que debes definir
		}
	}

	return priorities, nil
}

func isVLAN(frame []byte) bool {
	// Asumiendo que la cabecera Ethernet tiene 14 bytes y los dos bytes siguientes
	// indican el tipo (Ethertype). VLAN suele tener un Ethertype de 0x8100.
	if len(frame) >= 16 {
		ethertype := (uint16(frame[12]) << 8) | uint16(frame[13])
		return ethertype == 0x8100
	}
	return false
}

func getVLANID(frame []byte) (int, error) {
	// Asumiendo que la ID de VLAN está en los 4 bytes después de la cabecera Ethernet,
	// y ocupa los 12 bits menos significativos.
	if len(frame) < 18 {
		return 0, fmt.Errorf("frame demasiado corto para ser un paquete VLAN")
	}
	vlanID := (int(frame[14])<<8 | int(frame[15])) & 0x0FFF
	return vlanID, nil
}
