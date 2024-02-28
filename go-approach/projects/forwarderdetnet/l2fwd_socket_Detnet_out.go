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
	fd, err := syscall.Socket(syscall.AF_UNIX, syscall.SOCK_RAW, 0)
	if err != nil {
		log.Fatalf("failed to create Unix domain socket: %v", err)
	}
	defer syscall.Close(fd)

	addr := &syscall.SockaddrUnix{Name: unixSocketPath}
	syscall.Bind(fd, addr) // Note: Check for errors in real code

	// Load the XDP program and create an XDP socket
	/*log.Printf("Attaching XDP program to %s...\n", outLink.Attrs().Name)
	xdpProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load XDP program: %v", err)
	}
	defer xdpProg.Detach(outLink.Attrs().Index)
	
	if err := xdpProg.Attach(outLink.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}*/
	
	xsk, err := xdp.NewSocket(outLink.Attrs().Index, outLinkQueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket: %v", err)
	}
	defer xsk.Close()

	log.Println("Listening for packets to forward...")
	all:=0
	for {
		buf := make([]byte, 9000)
		n, _, err := syscall.Recvfrom(fd, buf, 0)
		if err != nil {
			log.Printf("error receiving from Unix socket: %v", err)
			continue
		}

		// Forward the packet via XDP
		alltemp, err := forwardPacket(xsk, buf[:n],all)
		all=alltemp
		if err != nil {
			log.Printf("error forwarding packet: %v", err)
		}
	}
}

func forwardPacket(xsk *xdp.Socket, packet []byte, all int) (int, error) {

	if xsk.NumFreeTxSlots() == 0 {
		log.Println("No free TX slots available, waiting for slot.")
		// Optionally wait or handle this scenario appropriately
		return all, fmt.Errorf("no free TX slots available")
	}

	// Allocate a descriptor for the packet.
	descs := xsk.GetDescs(1, false)
	if len(descs) == 0 {
		return all, fmt.Errorf("failed to allocate a descriptor for the packet")
	}
	desc := descs[0]

	// Copy the packet data into the XDP socket's UMEM frame.
	frame := xsk.GetFrame(desc)
	copy(frame, packet)
	desc.Len = uint32(len(packet))

	// Log packet transmission details if verbose is enabled.
	
	log.Printf("Sending packet: %d bytes\n", desc.Len)
	log.Printf("Packet: %d \n", packet)

	// Enqueue the packet for transmission.
	tran := xsk.Transmit(descs)
	if tran < 1 {
	        log.Printf("Failed to enqueue packet for transmission, tran: %d\n", tran)
	}
	
	
    	completed := xsk.NumCompleted()
    	all = all+1
    	
    	xsk.Complete(completed)
    	log.Printf("Packets completed: %d --- Total sent %d\n", completed,all)
    	log.Printf("Free TX slots after transmission attempt: %d\n", xsk.NumFreeTxSlots())

	return all, nil
}
