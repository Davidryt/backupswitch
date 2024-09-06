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

/*
func main() {
	var iface1Name string
	var iface1QueueID int
	var iface2Name string
	var iface2QueueID int
	var iface3Name string
	var iface3QueueID int
	var queues int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -iface1 <network link name> -iface2 <network link name> -queues <number of queues>\n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&iface1Name, "iface1", "", "Input network link name.")
	flag.IntVar(&iface1QueueID, "iface1queue", 0, "The queue ID to attach to on input link.")
	flag.StringVar(&iface2Name, "iface2", "", "Output network link name.")
	flag.IntVar(&iface2QueueID, "iface2queue", 0, "The queue ID to attach to on output link.")
	flag.StringVar(&iface3Name, "iface3", "", "Output network link name.")
	flag.IntVar(&iface3QueueID, "iface3queue", 0, "The queue ID to attach to on output link.")
	flag.IntVar(&queues, "queues", 0, "Number of queues (between 1 and 6).")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if iface1Name == "" || iface2Name == "" || iface3Name == "" || queues == 0 {
		flag.Usage()
		os.Exit(1)
	}

	iface1, err := netlink.LinkByName(iface1Name)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", iface1Name, err)
	}

	iface2, err := netlink.LinkByName(iface2Name)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", iface2Name, err)
	}

	iface3, err := netlink.LinkByName(iface3Name)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", iface3Name, err)
	}

	if queues < 1 || queues > 6 {
		fmt.Println("Error: The 'queues' flag must be between 1 and 6.")
		os.Exit(1)
	}

	globalVariable = 1
	go updateGlobalVariable(queues)

	launchswitch(verbose, iface1, iface1QueueID, iface2, iface2QueueID, iface3, iface3QueueID, queues)
}*/

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

	//var wg sync.WaitGroup

	for idx := 0; idx < len(xsks)-1; idx++ {
		//wg.Add(1) // Add to the WaitGroup before starting the goroutine
		go func(idx int, xsks []*xdp.Socket) {
			//defer wg.Done() // Call Done when the goroutine completes
			for {
				xsks[idx].Fill(xsks[idx].GetDescs(xsks[idx].NumFreeFillSlots(), true))

				fds[idx].Events = unix.POLLIN

				if xsks[idx].NumTransmitted() > 0 {
					fds[idx].Events |= unix.POLLOUT
				}
				fds[idx].Revents = 0

				_, err := unix.Poll(fds[:], -1)
				if err == syscall.EINTR {
					// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
					continue
				} else if err != nil {
					fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
					os.Exit(1)
				}

				if (fds[idx].Revents & unix.POLLIN) != 0 {
					//storepackets(xsks[idx], packetQueues)
					//numBytes, numFrames := forwardFrames(xsks[idx], outxsks[idx])
					numBytes, numFrames := forwardFrames4(xsks[0], xsks[1], packetQueues)
					//numBytes, numFrames := forwardFrames5(xsks[idx], xsks, idx, packetQueues)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				}
				if (fds[0].Revents & unix.POLLOUT) != 0 {
					xsks[idx].Complete(xsks[idx].NumCompleted())
				}
			}
		}(idx, xsks)
	}

	if len(xsks) > 0 {
		lastIdx := len(xsks) - 1
		for {
			xsks[lastIdx].Fill(xsks[lastIdx].GetDescs(xsks[lastIdx].NumFreeFillSlots(), true))

			fds[lastIdx].Events = unix.POLLIN

			if xsks[lastIdx].NumTransmitted() > 0 {
				fds[lastIdx].Events |= unix.POLLOUT
			}
			fds[lastIdx].Revents = 0

			_, err := unix.Poll(fds[:], -1)
			if err == syscall.EINTR {
				// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
				continue
			} else if err != nil {
				fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
				os.Exit(1)
			}

			if (fds[lastIdx].Revents & unix.POLLIN) != 0 {
				//storepackets(xsks[lastIdx], packetQueues)
				//numBytes, numFrames := forwardFrames(xsks[lastIdx], outxsks[lastIdx])
				numBytes, numFrames := forwardFrames4(xsks[1], xsks[0], packetQueues)
				//numBytes, numFrames := forwardFrames5(xsks[lastIdx], xsks, idx, packetQueues)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}
			if (fds[lastIdx].Revents & unix.POLLOUT) != 0 {
				xsks[lastIdx].Complete(xsks[lastIdx].NumCompleted())
			}
		}
	}

	//wg.Wait() // Wait for all goroutines to complete

	/*

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
					//storepackets(inXsk, packetQueues)
					//numBytes, numFrames := forwardFrames(inXsk, outXsk)
					//numBytes, numFrames := forwardFrames4(inXsk, outXsk, packetQueues)
					numBytes, numFrames := forwardFrames5(inXsk, outXsk, outXsk2, packetQueues)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				}
				if (fds[0].Revents & unix.POLLOUT) != 0 {
					inXsk.Complete(inXsk.NumCompleted())
				}
			}
		}()

		go func() {
			for {
				outXsk2.Fill(outXsk2.GetDescs(outXsk2.NumFreeFillSlots(), true))

				fds[2].Events = unix.POLLIN
				if outXsk2.NumTransmitted() > 0 {
					fds[2].Events |= unix.POLLOUT
				}

				fds[2].Revents = 0

				_, err := unix.Poll(fds[:], -1)
				if err == syscall.EINTR {
					// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
					continue
				} else if err != nil {
					fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
					os.Exit(1)
				}

				if (fds[2].Revents & unix.POLLIN) != 0 {
					//storepackets(outXsk, packetQueues)
					//numBytes, numFrames := forwardFrames(outXsk, inXsk)
					//numBytes, numFrames := forwardFrames4(outXsk2, inXsk, packetQueues)
					numBytes, numFrames := forwardFrames5(outXsk2, inXsk, outXsk, packetQueues)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				}
				if (fds[2].Revents & unix.POLLOUT) != 0 {
					outXsk2.Complete(outXsk2.NumCompleted())
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
				//storepackets(outXsk, packetQueues)
				//numBytes, numFrames := forwardFrames(outXsk, inXsk)
				//numBytes, numFrames := forwardFrames4(outXsk, inXsk, packetQueues)
				numBytes, numFrames := forwardFrames5(outXsk, inXsk, outXsk2, packetQueues)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}
			if (fds[1].Revents & unix.POLLOUT) != 0 {
				outXsk.Complete(outXsk.NumCompleted())
			}
		}*/

}

/*
func launchswitch(verbose bool, iface1 netlink.Link, iface1QueueID int, iface2 netlink.Link, iface2QueueID int, iface3 netlink.Link, iface3QueueID int, queues int) {
	//HERE WE DO INTERFACE 1

	log.Printf("attaching XDP program for %s...", iface1.Attrs().Name)
	inProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load xdp program: %v\n", err)
	}

	if err := inProg.Attach(iface1.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer inProg.Detach(iface1.Attrs().Index)
	log.Printf("opening XDP socket for %s...", iface1.Attrs().Name)
	inXsk, err := xdp.NewSocket(iface1.Attrs().Index, iface1QueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", iface1.Attrs().Name, err)
	}
	log.Printf("registering XDP socket for %s...", iface1.Attrs().Name)
	if err := inProg.Register(iface1QueueID, inXsk.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer inProg.Unregister(iface1QueueID)

	//HERE WE DO INTERFACE 2

	log.Printf("attaching XDP program for %s...", iface2.Attrs().Name)
	outProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load xdp program: %v\n", err)
	}

	if err := outProg.Attach(iface2.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer outProg.Detach(iface2.Attrs().Index)

	log.Printf("opening XDP socket for %s...", iface2.Attrs().Name)
	outXsk, err := xdp.NewSocket(iface2.Attrs().Index, iface2QueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", iface2.Attrs().Name, err)
	}

	if err := outProg.Register(iface2QueueID, outXsk.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer outProg.Unregister(iface2QueueID)

	//HERE WE DO INTERFACE 3-----------------------------------------------------------------

	log.Printf("attaching XDP program for %s...", iface3.Attrs().Name)
	outProg2, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load xdp program: %v\n", err)
	}

	if err := outProg2.Attach(iface3.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer outProg2.Detach(iface3.Attrs().Index)

	log.Printf("opening XDP socket for %s...", iface3.Attrs().Name)
	outXsk2, err := xdp.NewSocket(iface3.Attrs().Index, iface3QueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", iface3.Attrs().Name, err)
	}

	if err := outProg2.Register(iface3QueueID, outXsk2.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer outProg2.Unregister(iface3QueueID)

	//-----------------------------------------------------------------

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

	var fds [3]unix.PollFd
	fds[0].Fd = int32(inXsk.FD())
	fds[1].Fd = int32(outXsk.FD())
	fds[2].Fd = int32(outXsk2.FD())
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
				//storepackets(inXsk, packetQueues)
				//numBytes, numFrames := forwardFrames(inXsk, outXsk)
				//numBytes, numFrames := forwardFrames4(inXsk, outXsk, packetQueues)
				numBytes, numFrames := forwardFrames5(inXsk, outXsk, outXsk2, packetQueues)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}
			if (fds[0].Revents & unix.POLLOUT) != 0 {
				inXsk.Complete(inXsk.NumCompleted())
			}
		}
	}()

	go func() {
		for {
			outXsk2.Fill(outXsk2.GetDescs(outXsk2.NumFreeFillSlots(), true))

			fds[2].Events = unix.POLLIN
			if outXsk2.NumTransmitted() > 0 {
				fds[2].Events |= unix.POLLOUT
			}

			fds[2].Revents = 0

			_, err := unix.Poll(fds[:], -1)
			if err == syscall.EINTR {
				// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
				continue
			} else if err != nil {
				fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
				os.Exit(1)
			}

			if (fds[2].Revents & unix.POLLIN) != 0 {
				//storepackets(outXsk, packetQueues)
				//numBytes, numFrames := forwardFrames(outXsk, inXsk)
				//numBytes, numFrames := forwardFrames4(outXsk2, inXsk, packetQueues)
				numBytes, numFrames := forwardFrames5(outXsk2, inXsk, outXsk, packetQueues)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}
			if (fds[2].Revents & unix.POLLOUT) != 0 {
				outXsk2.Complete(outXsk2.NumCompleted())
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
			//storepackets(outXsk, packetQueues)
			//numBytes, numFrames := forwardFrames(outXsk, inXsk)
			//numBytes, numFrames := forwardFrames4(outXsk, inXsk, packetQueues)
			numBytes, numFrames := forwardFrames5(outXsk, inXsk, outXsk2, packetQueues)
			numBytesTotal += numBytes
			numFramesTotal += numFrames
		}
		if (fds[1].Revents & unix.POLLOUT) != 0 {
			outXsk.Complete(outXsk.NumCompleted())
		}
	}

}
*/

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
}

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
}*/

func forwardFrames4(input *xdp.Socket, output *xdp.Socket, packetQueues *PacketQueue) (numBytes uint64, numFrames uint64) {
	inDescs := input.Receive(input.NumReceived())
	outDescs := output.GetDescs(output.NumFreeTxSlots(), false)
	for i := 0; i < len(inDescs); i++ {
		inFrame := input.GetFrame(inDescs[i])
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

func forwardFrames5(input *xdp.Socket, xsks []*xdp.Socket, idx int, packetQueues *PacketQueue) (numBytes uint64, numFrames uint64) {
	inDescs := input.Receive(input.NumReceived())
	var output *xdp.Socket
	for i, xsk := range xsks {
		if i != idx {
			output = xsk
		}
	}
	outDescs := output.GetDescs(output.NumFreeTxSlots(), false)
	for i := 0; i < len(inDescs); i++ {
		inFrame := input.GetFrame(inDescs[i])
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

/*func clearqueues(packetQueues *PacketQueue, sentFrames [][]byte) {
	if len(sentFrames) == 0 {
		return // No frames sent, nothing to clear
	}

	queueIndex := 0 //temporal

	// Check if queueIndex is valid
	if queueIndex < 0 || queueIndex >= len(packetQueues.Queues) {
		return // Invalid index, nothing to clear
	}

	// Remove sent frames from the queue
	packetQueues.Queues[queueIndex] = packetQueues.Queues[queueIndex][len(sentFrames):]
}*/

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
		priority = vlanID
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

/*func min(a, b int) int {
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
}*/
