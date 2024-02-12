package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"syscall"

	"github.com/asavie/xdp"
	"github.com/vishvananda/netlink"
)

func main() {
	var unixSocketPath string
	var outLinkName string
	var outLinkQueueID int
	var verbose bool

	flag.StringVar(&unixSocketPath, "unixsocket", "", "Path to the Unix domain socket.")
	flag.StringVar(&outLinkName, "outlink", "", "Output network link name.")
	flag.IntVar(&outLinkQueueID, "outlinkqueue", 0, "The queue ID to attach to on output link.")
	flag.BoolVar(&verbose, "verbose", false, "Output more information.")
	flag.Parse()

	if unixSocketPath == "" || outLinkName == "" {
		fmt.Println("Required arguments are missing.")
		flag.Usage()
		os.Exit(1)
	}

	outLink, err := netlink.LinkByName(outLinkName)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", outLinkName, err)
	}

	receiveAndForward(unixSocketPath, outLink, outLinkQueueID, verbose)
}

func receiveAndForward(unixSocketPath string, outLink netlink.Link, outLinkQueueID int, verbose bool) {
	// Create and bind the Unix domain socket
	fd, err := syscall.Socket(syscall.AF_UNIX, syscall.SOCK_DGRAM, 0)
	if err != nil {
		log.Fatalf("failed to create Unix domain socket: %v", err)
	}
	defer syscall.Close(fd)

	addr := &syscall.SockaddrUnix{Name: unixSocketPath}
	syscall.Bind(fd, addr) // Note: Check for errors in real code

	// Load the XDP program and create an XDP socket
	log.Printf("Attaching XDP program to %s...\n", outLink.Attrs().Name)
	xdpProg, err := xdp.LoadProgram("ebpf.o", "xdp_pass", "", "")
	if err != nil {
		log.Fatalf("failed to load XDP program: %v", err)
	}
	defer xdpProg.Detach(outLink.Attrs().Index)

	xsk, err := xdp.NewSocket(outLink.Attrs().Index, outLinkQueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket: %v", err)
	}
	defer xsk.Close()

	log.Println("Listening for packets to forward...")
	for {
		buf := make([]byte, 2048)
		n, _, err := syscall.Recvfrom(fd, buf, 0)
		if err != nil {
			log.Printf("error receiving from Unix socket: %v", err)
			continue
		}

		// Forward the packet via XDP
		if err := forwardPacket(xsk, buf[:n]); err != nil {
			log.Printf("error forwarding packet: %v", err)
		}
	}
}

func forwardPacket(xsk *xdp.Socket, packet []byte) error {

	if xsk.NumFreeTxSlots() == 0 {
		return fmt.Errorf("no free TX slots available")
	}

	// Allocate a descriptor for the packet.
	descs := xsk.GetDescs(1, false) // Assuming a method to get one TX descriptor.
	if len(descs) == 0 {
		return fmt.Errorf("failed to allocate a descriptor for the packet")
	}
	desc := descs[0]

	// Copy the packet data into the XDP socket's UMEM frame.
	frame := xsk.GetFrame(desc)
	copy(frame, packet)
	desc.Len = uint32(len(packet))

	// Log packet transmission details if verbose is enabled.
	if verbose {
		log.Printf("Sending packet: %d bytes\n", len(packet))
	}

	// Enqueue the packet for transmission.
	if err := xsk.Transmit(descs); err != nil {
		return fmt.Errorf("failed to enqueue packet for transmission: %v", err)
	}

	// Optionally, you can immediately attempt to complete pending transmissions.
	// This step may be moved outside of this function for batch processing.
	xsk.Complete(xsk.NumCompleted())

	return nil
}
