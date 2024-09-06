package main

import (
	"os"
	"os/signal"
	"syscall"
	"fmt"

	"github.com/asavie/xdp"
	"github.com/vishvananda/netlink"
)

func main() {
	const LinkName = "enp2s0"
	const QueueID = 0

	link, err := netlink.LinkByName(LinkName)
	if err != nil {
		panic(err)
	}

	program, err := xdp.NewProgram(QueueID + 1)
	if err != nil {
		panic(err)
	}
	if err := program.Attach(link.Attrs().Index); err != nil {
		panic(err)
	}

	xsk, err := xdp.NewSocket(link.Attrs().Index, QueueID, nil)
	if err != nil {
		panic(err)
	}

	if err := program.Register(QueueID, xsk.FD()); err != nil {
		panic(err)
	}

	// Remove the XDP BPF program on interrupt.
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		program.Detach(link.Attrs().Index)
		os.Exit(1)
	}()

	for {
		stats,err:=xsk.Stats()
		if err != nil {
			panic(err)
		}
		fmt.Printf("Stats:\n Filled: %d\n Received: %d\n Transmited: %d\n Completed : %d\n", stats.Filled, stats.Received, stats.Transmitted, stats.Completed)
		xsk.Fill(xsk.GetDescs(xsk.NumFreeFillSlots(),true))
		numRx, _, err := xsk.Poll(-1)
		if err != nil {
			panic(err)
		}
		rxDescs := xsk.Receive(numRx)
		for i := 0; i < len(rxDescs); i++ {
			// Set destination MAC address to
			// ff:ff:ff:ff:ff:ff
			frame := xsk.GetFrame(rxDescs[i])
			fmt.Printf("Frame %d\n", frame)
			for i := 0; i < 6; i++ {
				frame[i] = byte(0xff)
			}
		}
		xsk.Transmit(rxDescs)
	}
}