package main

import (
	"flag"
	"fmt"
	"log"
	//"net"
	"os"
	"syscall"
	"time"

	"github.com/asavie/xdp"
	"github.com/vishvananda/netlink"
	"golang.org/x/sys/unix"
)

func main() {
	var interfaceName string
	var interfaceDstStr string
	var interfaceQueueID int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -iface <network link name> \n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&interfaceName, "iface", "", "Input network link name.")
	flag.IntVar(&interfaceQueueID, "interfacequeue", 0, "The queue ID to attach to on input link.")
	flag.StringVar(&interfaceDstStr, "interfaceDst", "ff:ff:ff:ff:ff:ff", "Destination MAC address to forward frames to from 'in' interface.")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if interfaceName == "" {
		flag.Usage()
		os.Exit(1)
	}

	iface, err := netlink.LinkByName(interfaceName)
	if err != nil {
		log.Fatalf("failed to fetch info about link %s: %v", interfaceName, err)
	}

	forward(verbose, iface, interfaceQueueID)
}

func forward(verbose bool, iface netlink.Link, interfaceQueueID int) {
	log.Printf("attaching XDP program for %s...", iface.Attrs().Name)
	inProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to create xdp program: %v\n", err)
	}
	if err := inProg.Attach(iface.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer inProg.Detach(iface.Attrs().Index)
	log.Printf("opening XDP socket for %s...", iface.Attrs().Name)
	inXsk, err := xdp.NewSocket(iface.Attrs().Index, interfaceQueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", iface.Attrs().Name, err)
	}
	log.Printf("registering XDP socket for %s...", iface.Attrs().Name)
	if err := inProg.Register(interfaceQueueID, inXsk.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer inProg.Unregister(interfaceQueueID)

	log.Printf("XDP deployed...")
	detnet_init(detnetConf_path, newFlows_path)
	log.Printf("Detnet deployed...")
	log.Printf("Starting switch...")



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

	var fds [1]unix.PollFd
	fds[0].Fd = int32(inXsk.FD())

	for {
    	inXsk.Fill(inXsk.GetDescs(inXsk.NumFreeFillSlots(), true))
    	fds[0].Events = unix.POLLIN
    	if inXsk.NumTransmitted() > 0 {
    	    fds[0].Events |= unix.POLLOUT
    	}

    	fds[0].Revents = 0
    	_, err := unix.Poll(fds[:], -1)
    	if err == syscall.EINTR {
        	continue
    	} else if err != nil {
    	    fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
    	    os.Exit(1)
    	}

    	if fds[0].Revents&unix.POLLIN != 0 {
        	numBytes, numFrames := forwardFrames(inXsk, inXsk)
        	numBytesTotal += numBytes
        	numFramesTotal += numFrames
   		}
    	if fds[0].Revents&unix.POLLOUT != 0 {
    	    inXsk.Complete(inXsk.NumCompleted())
    	}
	}
}

func forwardFrames(input *xdp.Socket, output *xdp.Socket) (numBytes uint64, numFrames uint64) {
	log.Printf("Forwarding")
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
		
		outFrame := output.GetFrame(outDescs[i])
		numBytes += uint64(len(inFrame))
		outDescs[i].Len = uint32(copy(outFrame, inFrame))
	}
	outDescs = outDescs[:len(inDescs)]
	//log.Printf("Sending %d frames", numFrames)

	output.Transmit(outDescs)

	return
}

