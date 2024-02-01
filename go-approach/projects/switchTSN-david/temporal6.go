package main

import (
	"bufio"
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"sync"
	"time"

	"github.com/asavie/xdp"
	"github.com/vishvananda/netlink"
	"golang.org/x/sys/unix"
)

var globalVariable int
var lock sync.Mutex

//	__________________________________________  COLAS  __________________________________________

type PacketQueue struct {
	Queues [][][]byte // A slice of slices, where each inner slice is a queue of frames
}

func Createqueues(numberOfQueues int) *PacketQueue {
	packetQueue := &PacketQueue{
		Queues: make([][][]byte, numberOfQueues),
	}

	// Initialize each queue
	for i := range packetQueue.Queues {
		packetQueue.Queues[i] = make([][]byte, 0)
	}

	return packetQueue
}

func (pq *PacketQueue) AddPacket(queueIndex int, frame []byte) {
	// Ensure that queueIndex is within bounds
	if queueIndex < 0 || queueIndex >= len(pq.Queues) {
		// Handle the error or ignore the addition
		return
	}
	pq.Queues[queueIndex] = append(pq.Queues[queueIndex], frame)
}

func (pq *PacketQueue) GetPackets(queueIndex int) [][]byte {
	// Ensure that queueIndex is within bounds
	if queueIndex < 0 || queueIndex >= len(pq.Queues) {
		// Return an empty list or handle the error
		return [][]byte{}
	}
	return pq.Queues[queueIndex]
}

//	__________________________________________  MAIN  __________________________________________

func main() {
	var queues int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -queues <number of queues>\n", os.Args[0])
		flag.PrintDefaults()
	}

	// Assuming these are the other flags you still want to use
	flag.IntVar(&queues, "queues", 0, "Number of queues (between 1 and 6).")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	// Read interfaces from CSV file
	fileName := "interfaces.csv" // Replace with your file name
	file, err := os.Open(fileName)
	if err != nil {
		log.Fatalf("failed to open file %s: %v", fileName, err)
	}
	defer file.Close()

	reader := csv.NewReader(bufio.NewReader(file))
	var interfaces []netlink.Link
	var queueIDs []int

	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		if len(record) != 2 {
			log.Fatalf("invalid record format: %v", record)
		}

		ifaceName := record[0]
		iface, err := netlink.LinkByName(ifaceName)
		if err != nil {
			log.Fatalf("failed to fetch info about interface %s: %v", ifaceName, err)
		}
		interfaces = append(interfaces, iface)

		queueID, err := strconv.Atoi(record[1])
		if err != nil {
			log.Fatalf("invalid queue ID: %s", record[1])
		}
		queueIDs = append(queueIDs, queueID)
	}

	// Validate the number of queues
	if queues < 1 || queues > 6 {
		fmt.Println("Error: The 'queues' flag must be between 1 and 6.")
		os.Exit(1)
	}

	globalVariable = 1
	go updateGlobalVariable(queues)

	launchswitch(verbose, interfaces, queueIDs, queues)

}

func updateGlobalVariable(queues int) {
	ticker := time.NewTicker(10 * time.Second)
	for {
		select {
		case <-ticker.C:
			lock.Lock()
			if globalVariable >= queues {
				globalVariable = 1
			} else {
				globalVariable++ // Update the global variable
			}
			log.Printf("Timer updated to %d", globalVariable)
			lock.Unlock()
		}
	}
}

func launchswitch(verbose bool, interfaces []netlink.Link, queueIDs []int, queues int) {
	if len(interfaces) != len(queueIDs) {
		log.Fatalf("Number of interfaces and queue IDs do not match")
	}

	var xsks []*xdp.Socket

	for i, iface := range interfaces {
		queueID := queueIDs[i]

		log.Printf("attaching XDP program for %s...", iface.Attrs().Name)
		prog, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
		if err != nil {
			log.Fatalf("failed to load xdp program: %v\n", err)
		}

		if err := prog.Attach(iface.Attrs().Index); err != nil {
			log.Fatalf("failed to attach xdp program to interface: %v\n", err)
		}
		defer prog.Detach(iface.Attrs().Index)

		log.Printf("opening XDP socket for %s...", iface.Attrs().Name)
		xsk, err := xdp.NewSocket(iface.Attrs().Index, queueID, nil)
		if err != nil {
			log.Fatalf("failed to open XDP socket for interface %s: %v", iface.Attrs().Name, err)
		}

		xsks = append(xsks, xsk)

		log.Printf("registering XDP socket for %s...", iface.Attrs().Name)
		if err := prog.Register(queueID, xsks[i].FD()); err != nil {
			fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
			return
		}
		defer prog.Unregister(queueID)
	}

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

	fds := make([]unix.PollFd, len(xsks))

	for i, xsk := range xsks {
		if xsk != nil {
			fds[i].Fd = int32(xsk.FD())
		}
	}

	var wg sync.WaitGroup

	for idx, xsk := range xsks {
		wg.Add(2) // Two goroutines per socket

		// Goroutine for handling incoming packets
		go handleIncoming(&wg, idx, xsk, xsks, &numBytesTotal, &numFramesTotal, packetQueues)

		// Goroutine for handling outgoing packets
		go handleOutgoing(&wg, idx, xsk, xsks)
	}

	wg.Wait() // Wait for all goroutines to complete

}

func handleIncoming(wg *sync.WaitGroup, idx int, xsk *xdp.Socket, xsks []*xdp.Socket, numBytesTotal *uint64, numFramesTotal *uint64, packetQueues *PacketQueue) {
	defer wg.Done()

	// Setup for polling incoming packets
	fds := []unix.PollFd{{Fd: int32(xsk.FD()), Events: unix.POLLIN}}

	for {

		xsk.Fill(xsk.GetDescs(xsk.NumFreeFillSlots(), true))

		// Poll the socket for incoming packets
		_, err := unix.Poll(fds, -1)
		if err != nil {
			fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
			return
		}

		if fds[0].Revents&unix.POLLIN != 0 {
			// Original logic for handling incoming packets
			numBytes, numFrames := forwardFrames5(xsk, xsks, idx, packetQueues)
			*numBytesTotal += numBytes
			*numFramesTotal += numFrames
		}
	}
}

func handleOutgoing(wg *sync.WaitGroup, idx int, xsk *xdp.Socket, xsks []*xdp.Socket) {
	defer wg.Done()

	// Setup for polling outgoing packets
	fds := []unix.PollFd{{Fd: int32(xsk.FD()), Events: unix.POLLOUT}}

	for {
		// Poll the socket for readiness to transmit packets
		_, err := unix.Poll(fds, -1)
		if err != nil {
			fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
			return
		}

		if fds[0].Revents&unix.POLLOUT != 0 {
			if xsk.NumTransmitted() > 0 {
				xsk.Complete(xsk.NumCompleted())
				// Additional logic for handling outgoing packets
				xsk.Complete(xsk.NumCompleted())
			}
		}
	}
}

func forwardFrames5(input *xdp.Socket, xsks []*xdp.Socket, idx int, packetQueues *PacketQueue) (numBytes uint64, numFrames uint64) {
	inDescs := input.Receive(input.NumReceived())
	//change
	var output *xdp.Socket
	for i, xsk := range xsks {
		if i != idx {
			output = xsk
		}
	}

	outDescs := output.GetDescs(output.NumFreeTxSlots(), false)
	for i := 0; i < len(inDescs); i++ {
		inFrame := input.GetFrame(inDescs[i])
		//need work on vlan
		enqueueframe(inFrame, packetQueues)
	}

	sendFrames, prio := getFrames2Send(packetQueues, len(outDescs))

	numFrames = uint64(len(sendFrames))

	for i := 0; i < len(sendFrames); i++ {
		outFrame := output.GetFrame(outDescs[i])
		inFrame := sendFrames[i]
		numBytes += uint64(len(inFrame))
		outDescs[i].Len = uint32(copy(outFrame, inFrame))
	}
	outDescs = outDescs[:len(sendFrames)]

	output.Transmit(outDescs)

	clearqueues(packetQueues, sendFrames, prio)

	return
}

func getFrames2Send(packetQueues *PacketQueue, length int) ([][]byte, int) {
	lock.Lock()
	priority := globalVariable
	lock.Unlock()
	toSend := packetQueues.Queues[priority-1]
	if len(toSend) > length {
		toSend = toSend[:length]
	}
	return toSend, priority
}

func enqueueframe(frame []byte, packetQueues *PacketQueue) error {

	// Obtiene las prioridades de los descriptores
	priority, err := getPriority(frame)
	//log.Printf("prio: %d", priority)
	if err != nil {
		return fmt.Errorf("error obteniendo prioridad: %w", err)
	}

	queueIndex := priority - 1 // Ajusta el índice de la cola si es necesario
	// Verifica que la prioridad sea válida y que la cola exista
	if queueIndex >= 0 && queueIndex < len(packetQueues.Queues) {
		//log.Printf("Almacenando")
		packetQueues.AddPacket(queueIndex, frame)
		//log.Printf("Array: %d", packetQueues.GetPackets(queueIndex))
	}

	return nil
}

func clearqueues(packetQueues *PacketQueue, sentFrames [][]byte, prio int) {
	queueIndex := prio - 1 // Assuming frames are sent from the first queue

	// Check if queueIndex is valid
	if queueIndex < 0 || queueIndex >= len(packetQueues.Queues) {
		return // Invalid index, nothing to clear
	}

	// Get the current queue
	currentQueue := packetQueues.Queues[queueIndex]

	// Ensure we do not slice beyond the queue's length
	numSentFrames := len(sentFrames)
	if numSentFrames > len(currentQueue) {
		numSentFrames = len(currentQueue)
	}

	// Remove sent frames from the queue
	packetQueues.Queues[queueIndex] = currentQueue[numSentFrames:]
}

func getPriority(frame []byte) (int, error) {
	/*priority := -1
	if isVLAN(frame) {
		vlanID, err := getVLANID(frame)
		if err != nil {
			return -1, err
		}
		priority = vlanID
	} else {*/
	// Asignar una prioridad por defecto a paquetes que no son VLAN
	priority := 1 // defaultPriority es un valor que debes definir
	/*}*/
	return priority, nil
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
