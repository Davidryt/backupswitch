/*
l2fwd is a primitive layer 2 frame forwarder, it attaches to two given network
links and transmits any frames received on any of them on the other network
link with the given destination MAC address.
*/
package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"syscall"
	"time"

	"github.com/asavie/xdp"
	"github.com/vishvananda/netlink"
	"golang.org/x/sys/unix"
)

func main() {
	var inLinkName string
	var inLinkDstStr string
	var inLinkQueueID int
	var outLinkName string
	var outLinkDstStr string
	var outLinkQueueID int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -inlink <network link name> -outlink <network link name>\n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&inLinkName, "inlink", "", "Input network link name.")
	flag.IntVar(&inLinkQueueID, "inlinkqueue", 0, "The queue ID to attach to on input link.")
	flag.StringVar(&inLinkDstStr, "inlinkdst", "8e:67:5c:7d:4d:6d", "Destination MAC address to forward frames to from 'in' interface.")
	flag.StringVar(&outLinkName, "outlink", "", "Output network link name.")
	flag.IntVar(&outLinkQueueID, "outlinkqueue", 0, "The queue ID to attach to on output link.")
	flag.StringVar(&outLinkDstStr, "outlinkdst", "7e:f4:31:9b:dc:aa", "Destination MAC address to forward frames to from 'out' interface.")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if inLinkName == "" || outLinkName == "" {
		flag.Usage()
		os.Exit(1)
	}

	inLinkDst, err := net.ParseMAC(inLinkDstStr)
	if err != nil {
		flag.Usage()
		os.Exit(1)
	}

	outLinkDst, err := net.ParseMAC(outLinkDstStr)
	if err != nil {
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

	launchswitch(verbose, inLink, inLinkQueueID, inLinkDst, outLink, outLinkQueueID, outLinkDst)
}

func launchswitch(verbose bool, inLink netlink.Link, inLinkQueueID int, inLinkDst net.HardwareAddr, outLink netlink.Link, outLinkQueueID int, outLinkDst net.HardwareAddr) {
	//HERE WE DO INTERFACE 1

	/*log.Printf("attaching XDP program for %s...", inLink.Attrs().Name)
	inProg, err := xdp.NewProgram(inLinkQueueID + 1)
	if err != nil {
		log.Fatalf("failed to create xdp program: %v\n", err)
	}*/

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

	/*log.Printf("attaching XDP program for %s...", outLink.Attrs().Name)
	outProg, err := xdp.NewProgram(outLinkQueueID + 1)
	if err != nil {
		log.Fatalf("failed to create xdp program: %v\n", err)
	}*/
	log.Printf("attaching XDP program for %s...", outLink.Attrs().Name)
	outProg, err := xdp.LoadProgram("ebpf.o", "xdp_redirect", "qidconf_map", "xsks_map")
	if err != nil {
		log.Fatalf("failed to load xdp program: %v\n", err)
	}

	if err := outProg.Attach(outLink.Attrs().Index); err != nil {
		log.Fatalf("failed to attach xdp program to interface: %v\n", err)
	}
	defer outProg.Detach(outLink.Attrs().Index)
	//*******************legacy*************************************
	log.Printf("opening XDP socket for %s...", outLink.Attrs().Name)
	outXsk, err := xdp.NewSocket(outLink.Attrs().Index, outLinkQueueID, nil)
	if err != nil {
		log.Fatalf("failed to open XDP socket for link %s: %v", outLink.Attrs().Name, err)
	}
	//*******************legacy*******************************
	if err := outProg.Register(outLinkQueueID, outXsk.FD()); err != nil {
		fmt.Printf("error: failed to register socket in BPF map: %v\n", err)
		return
	}
	defer outProg.Unregister(outLinkQueueID)

	log.Printf("starting TSN Switch...")

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
	
	go func() {
   		for {
      			inXsk.Fill(inXsk.GetDescs(inXsk.NumFreeFillSlots(), true))
      			outXsk.Fill(outXsk.GetDescs(outXsk.NumFreeFillSlots(), true))
   		}
	}()
	
	for {
		fds[0].Fd = int32(inXsk.FD())
		fds[1].Fd = int32(outXsk.FD())
	
	   	fds[0].Events = unix.POLLIN
	   	if inXsk.NumTransmitted() > 0 {
	   		fds[0].Events |= unix.POLLOUT
	   	}

	   	fds[1].Events = unix.POLLIN
	   	if outXsk.NumTransmitted() > 0 {
	   		fds[1].Events |= unix.POLLOUT
	   	}
	
	   	fds[0].Revents = 0
	   	fds[1].Revents = 0

 	  	_, err := unix.Poll(fds[:], -1)
		if err == syscall.EINTR {
			// EINTR is a non-fatal error that may occur due to ongoing syscalls that interrupt our poll
			continue
		} else if err != nil {
			fmt.Fprintf(os.Stderr, "poll failed: %v\n", err)
			os.Exit(1)
		}

		if (fds[0].Revents & unix.POLLIN) != 0 {
			numBytes, numFrames := forwardFrames(inXsk, outXsk, outLinkDst)
			numBytesTotal += numBytes
			numFramesTotal += numFrames
		}
		if (fds[0].Revents & unix.POLLOUT) != 0 {
			inXsk.Complete(inXsk.NumCompleted())
		}
		if (fds[1].Revents & unix.POLLIN) != 0 {
			numBytes, numFrames := forwardFrames(outXsk, inXsk, inLinkDst)
			numBytesTotal += numBytes
			numFramesTotal += numFrames
		}
		if (fds[1].Revents & unix.POLLOUT) != 0 {
			outXsk.Complete(outXsk.NumCompleted())
		}
	}
}

func forwardFrames(input *xdp.Socket, output *xdp.Socket, dstMac net.HardwareAddr) (numBytes uint64, numFrames uint64) {
	inDescs := input.Receive(input.NumReceived())
	//replaceDstMac(input, inDescs, dstMac)

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

func replaceDstMac(xsk *xdp.Socket, descs []xdp.Desc, dstMac net.HardwareAddr) {
	for _, d := range descs {
		frame := xsk.GetFrame(d)
		copy(frame, dstMac)
	}
}
