package main

import (
    "fmt"
    "net"
)

func main() {
    // Path to the socket
    socketPath := "/home/detnet.socket"

    // Connect to the socket
    conn, err := net.Dial("unix", socketPath)
    if err != nil {
        fmt.Println("Error connecting to socket:", err)
        return
    }
    defer conn.Close()

    // Send data
    _, err = conn.Write([]byte("Hello from client"))
    if err != nil {
        fmt.Println("Error writing to socket:", err)
        return
    }

    fmt.Println("Data sent successfully")
}

//----------------------------------------------------------


package main

import (
    "fmt"
    "net"
    "os"
)

func main() {
    // Path to the socket
    socketPath := "/home/detnet.socket"

    // Ensure the socket does not already exist
    os.Remove(socketPath)

    // Listen on the socket
    listener, err := net.Listen("unix", socketPath)
    if err != nil {
        fmt.Println("Error listening:", err)
        os.Exit(1)
    }
    defer listener.Close()

    fmt.Println("Server listening on", socketPath)
    for {
        // Accept new connections
        conn, err := listener.Accept()
        if err != nil {
            fmt.Println("Error accepting connection:", err)
            continue
        }

        // Handle each connection in a new goroutine
        go handleConnection(conn)
    }
}

func handleConnection(conn net.Conn) {
    defer conn.Close()

    buffer := make([]byte, 1024)
    n, err := conn.Read(buffer)
    if err != nil {
        fmt.Println("Error reading:", err)
        return
    }

    fmt.Println("Received:", string(buffer[:n]))
}