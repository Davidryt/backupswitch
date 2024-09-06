package main

import (
	"fmt"
	"os"
	"syscall"
)

func main() {
	var fds syscall.FdSet
	var tv syscall.Timeval

	var fds [2]syscall.FdSet
	fds[0].Fd = int32(inXsk.FD())
	fds[1].Fd = int32(outXsk.FD())
	go func() {
		for {

			inXsk.Fill(inXsk.GetDescs(inXsk.NumFreeFillSlots(), true))

			// Initialize the file descriptor set and timeout each iteration
			syscall.FD_ZERO(&fds)
			syscall.FD_SET(fds[0].Fd, &fds)

			// Set timeout to zero for non-blocking operation
			tv.Sec = 0
			tv.Usec = 0

			// Check for read readiness (POLLIN) and optionally write readiness (POLLOUT)
			readFds := fds
			var writeFds *syscall.FdSet
			if outXsk.NumTransmitted() > 0 {
				writeFds = &fds
			}

			_, err := syscall.Select(fds[0].Fd+1, &readFds, writeFds, nil, &tv)
			if err != nil {
				if err == syscall.EINTR {
					continue // Handle EINTR (interrupted system call)
				}
				fmt.Fprintf(os.Stderr, "select failed: %v\n", err)
				os.Exit(1)
			}

			if syscall.FD_ISSET(fds[0].Fd, &readFds) {
				numBytes, numFrames := forwardFrames4(outXsk, inXsk, packetQueues)
				numBytesTotal += numBytes
				numFramesTotal += numFrames
			}

			if writeFds != nil && syscall.FD_ISSET(fds[0].Fd, writeFds) {
				outXsk.Complete(outXsk.NumCompleted())
			}
		}
	}()

	for {
		outXsk.Fill(outXsk.GetDescs(outXsk.NumFreeFillSlots(), true))

		// Initialize the file descriptor set and timeout each iteration
		syscall.FD_ZERO(&fds)
		syscall.FD_SET(fds[1].Fd, &fds)

		// Set timeout to zero for non-blocking operation
		tv.Sec = 0
		tv.Usec = 0

		// Check for read readiness (POLLIN) and optionally write readiness (POLLOUT)
		readFds := fds
		var writeFds *syscall.FdSet
		if outXsk.NumTransmitted() > 0 {
			writeFds = &fds
		}

		_, err := syscall.Select(fds[1].Fd+1, &readFds, writeFds, nil, &tv)
		if err != nil {
			if err == syscall.EINTR {
				continue // Handle EINTR (interrupted system call)
			}
			fmt.Fprintf(os.Stderr, "select failed: %v\n", err)
			os.Exit(1)
		}

		if syscall.FD_ISSET(fds[1].Fd, &readFds) {
			numBytes, numFrames := forwardFrames4(outXsk, inXsk, packetQueues)
			numBytesTotal += numBytes
			numFramesTotal += numFrames
		}

		if writeFds != nil && syscall.FD_ISSET(fds[1].Fd, writeFds) {
			outXsk.Complete(outXsk.NumCompleted())
		}
	}
}
