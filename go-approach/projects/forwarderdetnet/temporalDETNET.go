package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"sync"
	"syscall"
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

//	__________________________________________  IFACE  __________________________________________

func restartNetworkInterface(iface string) error {
	// Apagar la interfaz de red
	downCmd := exec.Command("sudo", "ip", "link", "set", iface, "down")
	err := downCmd.Run()
	if err != nil {
		return fmt.Errorf("error al apagar la interfaz %s: %v", iface, err)
	}
	time.Sleep(time.Duration(1) * time.Second)
	// Encender la interfaz de red
	upCmd := exec.Command("sudo", "ip", "link", "set", iface, "up")
	err = upCmd.Run()
	if err != nil {
		return fmt.Errorf("error al encender la interfaz %s: %v", iface, err)
	}
	time.Sleep(time.Duration(1) * time.Second)
	log.Printf("Interface %s restarted", iface)
	// Poner vlnas offload
	vlanoffload := exec.Command("sudo","ethtool", "-K", iface, "rx-vlan-offload", "off", "tx-vlan-offload",  "off")
	err = vlanoffload.Run()
	if err != nil {
		return fmt.Errorf("error al desactivar hardware offloading en la interfaz %s: %v", iface, err)
	}
	time.Sleep(time.Duration(1) * time.Second)	
	return nil
}

//	__________________________________________  CONFIG FILE READER  __________________________________________

func readInterfacesFromFile(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("error opening file: %v", err)
	}
	defer file.Close()

	var interfaces []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		interfaces = append(interfaces, line)
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading file: %v", err)
	}

	return interfaces, nil
}

//      __________________________________________  MAIN  __________________________________________

func main() {
	var queues int
	var verbose bool

	flag.IntVar(&queues, "queues", 0, "Number of queues (between 1 and 6).")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if queues == 0 {

		log.Fatalf("Error: The 'queues' flag must be between 1 and 6.")
	}

	interfaces, err := readInterfacesFromFile("ifaces")
	if err != nil {
		log.Fatalf("failed to read interfaces from file: %v", err)
	}

	if len(interfaces) < 0 {
		log.Fatalf("Error: The file must contain at least 2 interfaces, found %d", len(interfaces))
	}

	
	var links []netlink.Link

	for _, ifaceName := range interfaces {
		link, err := netlink.LinkByName(ifaceName)
		if err != nil {
			log.Fatalf("failed to fetch info about link %s: %v", ifaceName, err)
		}

		links = append(links, link)

		log.Printf("Restarting interface %s...", ifaceName)
		err = restartNetworkInterface(ifaceName)
		if err != nil {
			log.Fatalf("Error restarting the interface %s: %v", ifaceName, err)
		}
	}
	
	globalVariable = 1
	go updateGlobalVariable(queues)

	//launchswitch(verbose, links[0], 0, links[1], 0, queues)
	launchswitch(verbose, links, queues)
}

/*func updateGlobalVariable(queues int) {
	ticker := time.NewTicker(500 * time.Nanosecond)
	for {
		select {
		case <-ticker.C:
			lock.Lock()
			if globalVariable >= queues {
				globalVariable = 1
			} else {
				globalVariable++ // Update the global variable
			}
			lock.Unlock()
		}
	}
}*/

func updateGlobalVariable(queues int) {
    ticker := time.NewTicker(10 * time.Millisecond)
    for {
        select {
        case <-ticker.C:
            lock.Lock()

            // Usa el tiempo del sistema para calcular en qué ciclo debería estar
            currentTime := time.Now().UnixNano() / int64(time.Millisecond)
            cycleDuration := int64(10) // Duración del ciclo en milisegundos
            currentCycle := (currentTime / cycleDuration) % int64(queues)
            globalVariable = int(currentCycle) + 1 // +1 para que comience en 1
            lock.Unlock()
        }
    }
}


//func launchswitch(verbose bool, inLink netlink.Link, inLinkQueueID int, outLink netlink.Link, outLinkQueueID int, queues int) {
func launchswitch(verbose bool, links []netlink.Link, queues int) {
	var Xsks []*xdp.Socket
	for _, link := range links {
	
		log.Printf("attaching XDP program for %s...", link.Attrs().Name)
		Prog, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
		if err != nil {
			log.Fatalf("failed to load xdp program: %v\n", err)
		}

		if err := Prog.Attach(link.Attrs().Index); err != nil {
			log.Fatalf("failed to attach xdp program to interface: %v\n", err)
		}
		defer Prog.Detach(link.Attrs().Index)
		log.Printf("opening XDP socket for %s...", link.Attrs().Name)
		Xsk, err := xdp.NewSocket(link.Attrs().Index, 0, nil)
		if err != nil {
			log.Fatalf("failed to open XDP socket for link %s: %v", link.Attrs().Name, err)
		}
		log.Printf("registering XDP socket for %s...", link.Attrs().Name)
		if err := Prog.Register(0, Xsk.FD()); err != nil {
			fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
			return
		}
		defer Prog.Unregister(0)
		Xsks = append(Xsks, Xsk)
	}
	
	log.Printf("XDP deployed...")
	detnet_init("./config/detnetData.json", "./config/newFlows.json")
	log.Printf("Detnet deployed...")
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

	size := len(Xsks)
	fds := make([]unix.PollFd, size) // Create a slice instead of an array
	q := 0
	for _, Xsk := range Xsks {
		fds[q].Fd = int32(Xsk.FD())
		q++
	}
	
	//inXsk:=Xsks[0]
	//outXsk:=Xsks[1]
	for i, Xsk := range Xsks {
		if i < size-1 {
			go func(xsk *xdp.Socket, idx int) {
				for {
					xsk.Fill(xsk.GetDescs(xsk.NumFreeFillSlots(), true))

					fds[idx].Events = unix.POLLIN

					if xsk.NumTransmitted() > 0 {
						fds[idx].Events |= unix.POLLOUT
					}
					fds[idx].Revents = 0

					_, err := unix.Poll(fds[:], -1)
					if err == syscall.EINTR {
						//non-fatal error that may occur due to ongoing syscalls that interrupt poll
						continue
					} else if err != nil {
						fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
						os.Exit(1)
					}

					if (fds[idx].Revents & unix.POLLIN) != 0 {
						// Handle packet forwarding for this interface
						numBytes, numFrames := forwardFrames4(xsk, Xsks, packetQueues)
						numBytesTotal += numBytes
						numFramesTotal += numFrames
					}
					if (fds[idx].Revents & unix.POLLOUT) != 0 {
						xsk.Complete(xsk.NumCompleted())
					}
				}
			}(Xsk, i)
		} else {
			// Handle the last interface in the main loop
			for {
				Xsk.Fill(Xsk.GetDescs(Xsk.NumFreeFillSlots(), true))

				fds[i].Events = unix.POLLIN
				if Xsk.NumTransmitted() > 0 {
					fds[i].Events |= unix.POLLOUT
				}

				fds[i].Revents = 0

				_, err := unix.Poll(fds[:], -1)
				if err == syscall.EINTR {
					// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt poll
					continue
				} else if err != nil {
					fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
					os.Exit(1)
				}

				if (fds[i].Revents & unix.POLLIN) != 0 {
					// Handle packet forwarding for this interface
					numBytes, numFrames := forwardFrames4(Xsk, Xsks, packetQueues)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				}
				if (fds[i].Revents & unix.POLLOUT) != 0 {
					Xsk.Complete(Xsk.NumCompleted())
				}
			}

		}
	}

}


func forwardFrames4(input *xdp.Socket, Xsks []*xdp.Socket, packetQueues *PacketQueue) (numBytes uint64, numFrames uint64) {
	var output *xdp.Socket
	input = Xsks[0] 
	output = Xsks[0]
	
	
	
	inDescs := input.Receive(input.NumReceived())
	outDescs := output.GetDescs(output.NumFreeTxSlots(), false)
	
	
	if len(inDescs) > len(outDescs) {
		inDescs = inDescs[:len(outDescs)]
	}
	numFrames = uint64(len(inDescs))

	//send to detnet

	//log.Printf("Received %d frames", numFrames)

	for i := 0; i < len(inDescs); i++ {
		inFrame := input.GetFrame(inDescs[i])
		//getPriority(inFrame)
		Frame2send:= detnet(inFrame)
		//Frame2send:= inFrame
		//log.Printf("Sending %d frames", Frame2send)
		//getPriority(Frame2send)
		outFrame := output.GetFrame(outDescs[i])
		numBytes += uint64(len(Frame2send))
		outDescs[i].Len = uint32(copy(outFrame, Frame2send))
	}
	outDescs = outDescs[:len(inDescs)]
	//log.Printf("Sending %d frames", numFrames)
	
	output.Transmit(outDescs)


	//clearqueues(packetQueues, sendFrames, prio)

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
	//log.Printf("Almacenando en prio %d", queueIndex)
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
	priority := -1
	if isVLAN(frame) {
		vlanID, err := getVLANID(frame)
		if err != nil {
			return -1, err
		}
		log.Printf("VLAN DETECTED: %d", vlanID)
		priority = vlanID-9
	} else {
		// Asignar una prioridad por defecto a paquetes que no son VLAN
		priority = 1 // defaultPriority es un valor que debes definir
	}
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

