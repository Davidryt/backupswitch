package main

import (
	"fmt"
	"os"
	"sync"
	"syscall"
	"xdp" // Assuming this is your package for working with xdp sockets
)

func main() {
	xsks := []*xdp.Socket{ /* initialize your sockets here */ }
	fds := make([]syscall.FdSet, len(xsks))
	var tv syscall.Timeval

	var wg sync.WaitGroup

	for i, xsk := range xsks {
		if xsk != nil {
			syscall.FD_SET(xsk.FD(), &fds[i])
		}
	}

	for idx, xsk := range xsks {
		wg.Add(1)
		go func(idx int, xsk *xdp.Socket) {
			defer wg.Done()
			for {
				xsk.Fill(xsk.GetDescs(xsk.NumFreeFillSlots(), true))

				// Set timeout to zero for non-blocking operation
				tv.Sec = 0
				tv.Usec = 0

				// Monitor the socket for read and write availability
				readFDs := fds[idx]
				writeFDs := fds[idx]
				if xsk.NumTransmitted() > 0 {
					syscall.FD_SET(xsk.FD(), &writeFDs)
				} else {
					syscall.FD_ZERO(&writeFDs)
				}

				_, err := syscall.Select(xsk.FD()+1, &readFDs, &writeFDs, nil, &tv)
				if err != nil {
					if err == syscall.EINTR {
						continue // Handle interrupted system calls
					}
					fmt.Fprintf(os.Stderr, "select failed: %v\n", err)
					os.Exit(1)
				}

				// Check if the socket is ready for reading
				if syscall.FD_ISSET(xsk.FD(), &readFDs) {
					numBytes, numFrames := forwardFrames5(xsk, xsks, idx, packetQueues)
					numBytesTotal += numBytes
					numFramesTotal += numFrames
				}

				// Check if the socket is ready for writing
				if syscall.FD_ISSET(xsk.FD(), &writeFDs) {
					xsk.Complete(xsk.NumCompleted())
				}
			}
		}(idx, xsk)
	}

	wg.Wait()
}
