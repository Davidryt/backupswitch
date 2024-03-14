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

func main() {
	var inLinkName string
	var inLinkQueueID int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -inlink <network link name> -outlink <network link name>\n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&inLinkName, "inlink", "", "Input network link name.")
	flag.IntVar(&inLinkQueueID, "inlinkqueue", 0, "The queue ID to attach to on input link.")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if inLinkName == "" { 
		flag.Usage()
		os.Exit(1)
	}


	inLink, err := netlink.LinkByName(inLinkName)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", inLinkName, err)
	}



	forwardL2(verbose, inLink, inLinkQueueID) 
}

func forwardL2(verbose bool, inLink netlink.Link, inLinkQueueID int) { 
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


	log.Printf("starting Detnet forwarder...")

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

	fdsock, err := syscall.Socket(syscall.AF_UNIX, syscall.SOCK_RAW, 0)
	if err != nil {
		log.Fatalf("failed to create socket: %v", err)
	}
	packets:=uint64(0)
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
			numBytes, numFrames := forwardFrames(inXsk, fdsock)
			numBytesTotal += numBytes
			numFramesTotal += numFrames
			packets+=numFrames
			log.Printf("paquetes %d", packets)
		}
		if (fds[0].Revents & unix.POLLOUT) != 0 {
			inXsk.Complete(inXsk.NumCompleted())
		}

	}
}

func forwardFrames(input *xdp.Socket, fdsock int) (numBytes uint64, numFrames uint64) {
	inDescs := input.Receive(input.NumReceived())

	numFrames = uint64(len(inDescs))
	addr := &syscall.SockaddrUnix{Name: "/home/netcom/detnet-socket/det-r.socket"}
	for i := 0; i < len(inDescs); i++ {
		inFrame := input.GetFrame(inDescs[i])
		numBytes += uint64(len(inFrame))
		//log.Printf("inframe: %d", inFrame)
		log.Printf("\n\nPacket received with lenght: %d", len(inFrame))
		if err := syscall.Sendto(fdsock, inFrame, 0, addr); err != nil {
			log.Printf("sendto failed: %v", err)
			// Handle error or continue based on your error handling policy.
		}

	}


	return 
}



func forwardPacket(xsk *xdp.Socket, packet []byte, all int) (int, error) {

	if xsk.NumFreeTxSlots() == 0 {
		return -1, fmt.Errorf("no free TX slots available")
	}

	// Allocate a descriptor for the packet.
	descs := xsk.GetDescs(1, false) // Assuming a method to get one TX descriptor.
	if len(descs) == 0 {
		return -1, fmt.Errorf("failed to allocate a descriptor for the packet")
	}
	desc := descs[0]

	// Copy the packet data into the XDP socket's UMEM frame.
	frame := xsk.GetFrame(desc)
	copy(frame, packet)
	desc.Len = uint32(len(packet))

	// Log packet transmission details if verbose is enabled.
	
	log.Printf("Sending packet: %d bytes\n", len(packet))
	

	// Enqueue the packet for transmission.
	/*if err :=*/ 
	xsk.Transmit(descs); 
	/*err != 0 {
		return fmt.Errorf("failed to enqueue packet for transmission: %v", err)
	}*/

	// Optionally, you can immediately attempt to complete pending transmissions.
	// This step may be moved outside of this function for batch processing.
	log.Printf("Free TX slots after transmission attempt: %d\n", xsk.NumFreeTxSlots())
	
    	completed := xsk.NumCompleted()
    	all = all+1
    	log.Printf("Packets completed: %d\nTotal sent %d\n", completed,all)
    	xsk.Complete(completed)

	return all, nil
}

