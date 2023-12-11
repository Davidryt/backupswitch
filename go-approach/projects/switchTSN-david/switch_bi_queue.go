/*
 */
package main

import (
	"bytes"
	"flag"
	"fmt"
	"log"
	"os"
	"syscall"
	"time"

	"github.com/asavie/xdp"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/vishvananda/netlink"
	"golang.org/x/sys/unix"
)

const (
	PriorityHigh   int = iota // 0
	PriorityNormal            // 1
	PriorityLow               // 2
)

type packetQueue struct {
	packets [][]byte
}

func main() {
	var inLinkName string
	var inLinkQueueID int
	var outLinkName string
	var outLinkQueueID int
	var verbose bool

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "usage: %s -inlink <network link name> -outlink <network link name>\n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&inLinkName, "inlink", "", "Input network link name.")
	flag.IntVar(&inLinkQueueID, "inlinkqueue", 0, "The queue ID to attach to on input link.")
	flag.StringVar(&outLinkName, "outlink", "", "Output network link name.")
	flag.IntVar(&outLinkQueueID, "outlinkqueue", 0, "The queue ID to attach to on output link.")
	flag.BoolVar(&verbose, "verbose", false, "Output forwarding statistics.")
	flag.Parse()

	if inLinkName == "" || outLinkName == "" {
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

	launchswitch(verbose, inLink, inLinkQueueID, outLink, outLinkQueueID)
}

func launchswitch(verbose bool, inLink netlink.Link, inLinkQueueID int, outLink netlink.Link, outLinkQueueID int) {
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
	//Two queues to store descriptors
	priorityQueue := packetQueue{}
	normalQueue := packetQueue{}

	log.Printf("Queues created...")

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
	//two struct of queues where I store FDs from in and out interfaces
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

			// Process each descriptor and enqueue packets based on their priority.
			for _, desc := range descs {
				packet := desc[:desc.Len]
				priority := getPacketPriority(packet)

				// Enqueue the packet into the appropriate queue based on priority.
				if priority == PriorityHigh {
					priorityQueue.packets = append(priorityQueue.packets, packet)
				} else {
					normalQueue.packets = append(normalQueue.packets, packet)
				}
			}

			if (fds[0].Revents & unix.POLLIN) != 0 {
				//prio
				if len(priorityQueue.packets) > 0 {
					packet := priorityQueue.packets[0]
					priorityQueue.packets = priorityQueue.packets[1:]
					numBytes, numFrames = forwardPacket(packet, inXsk, outXsk)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				} else if len(normalQueue.packets) > 0 {
					packet := normalQueue.packets[0]
					normalQueue.packets = normalQueue.packets[1:]
					numBytes, numFrames = forwardPacket(packet, inXsk, outXsk)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				}
				/*old
				numBytes, numFrames := forwardFrames(inXsk, outXsk)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
				*/
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

		// Process each descriptor and enqueue packets based on their priority.
		for _, desc := range descs {
			packet := desc[:desc.Len]
			priority := getPacketPriority(packet)

			// Enqueue the packet into the appropriate queue based on priority.
			if priority == PriorityHigh {
				priorityQueue.packets = append(priorityQueue.packets, packet)
			} else {
				normalQueue.packets = append(normalQueue.packets, packet)
			}
		}

		if (fds[1].Revents & unix.POLLIN) != 0 {

			//prio
			if len(priorityQueue.packets) > 0 {
				packet := priorityQueue.packets[0]
				priorityQueue.packets = priorityQueue.packets[1:]
				numBytes, numFrames = forwardPacket(packet, outXsk, inXsk)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			} else if len(normalQueue.packets) > 0 {
				packet := normalQueue.packets[0]
				normalQueue.packets = normalQueue.packets[1:]
				numBytes, numFrames = forwardPacket(packet, outXsk, inXsk)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}

			/*numBytes, numFrames := forwardFrames(outXsk, inXsk)
			numBytesTotal += numBytes
			numFramesTotal += numFrames*/
		}
		if (fds[1].Revents & unix.POLLOUT) != 0 {
			outXsk.Complete(outXsk.NumCompleted())
		}
	}

}

func forwardPacket(descriptor []byte, input *xdp.Socket, output *xdp.Socket) (numBytes uint64, numFrames uint64) {
	// First, we need to find the packet that matches the provided descriptor.
	var matchingPacket []byte
	inDescs := input.Receive(input.NumReceived())

	for _, desc := range inDescs {
		// Assuming the descriptor is some form of identifier you can use to match packets.
		if bytes.Equal(desc, descriptor) {
			matchingPacket = input.GetFrame(desc)
			break
		}
	}

	if matchingPacket == nil {
		// No matching packet was found, handle this case.
		return 0, 0
	}

	// Prepare to send the packet.
	outDescs := output.GetDescs(1, false)
	if len(outDescs) == 0 {
		// Handle the case where no descriptors are available.
		return 0, 0
	}

	outFrame := output.GetFrame(outDescs[0])

	// Copy the matching packet data to the output frame.
	numBytes = uint64(len(matchingPacket))
	copiedBytes := copy(outFrame, matchingPacket)
	if copiedBytes != len(matchingPacket) {
		// If we couldn't copy all the bytes, handle this case.
		return 0, 0
	}

	// Update the descriptor with the number of bytes we're sending.
	outDescs[0].Len = uint32(copiedBytes)

	// Now, actually send the packet.
	err := output.Transmit(outDescs[:1])
	if err != nil {
		// Handle the error accordingly.
		return 0, 0
	}

	// If everything was successful, return the number of bytes and frames sent.
	return numBytes, 1 // We've sent one frame.
}

/*
func forwardFrames(input *xdp.Socket, output *xdp.Socket) (numBytes uint64, numFrames uint64) {
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
}*/

func getPacketPriority(descriptor []byte, queue *xdp.Socket) int {
	// Retrieve the actual packet using the descriptor.
	packetData := GetPacket(descriptor, queue)
	if packetData == nil {
		// Handle the case where the packet is not found.
		return PriorityNormal
	}

	// Create a new packet from the raw bytes.
	packet := gopacket.NewPacket(packetData, layers.LayerTypeEthernet, gopacket.Default)

	// Check if the packet has a VLAN layer.
	vlanLayer := packet.Layer(layers.LayerTypeDot1Q)
	if vlanLayer != nil {
		// Type assert the layer to the Dot1Q type to access its fields.
		vlan, _ := vlanLayer.(*layers.Dot1Q)

		// Check the VLAN ID.
		if vlan.VLANIdentifier == 10 {
			return PriorityHigh
		}
	}

	// Default priority if no VLAN or VLAN ID is not 10.
	return PriorityNormal
}
