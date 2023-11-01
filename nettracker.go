package main

import (
	"flag"
	"fmt"
	"io"
	"net"
	"os"
	"os/exec"
	"time"
)

var (
    versionNumber string
)

// Function to handle proxying the data between two connections
func proxyData(src, dest net.Conn) {
	defer src.Close()
	defer dest.Close()

	// Copy data from src to dest
	io.Copy(src, dest)
}

func handleConnection(conn net.Conn, cmdStr string, tunnelPort string) {
	// Connect to the tunnel port
	tunnelConn, err := net.Dial("tcp", "localhost:"+tunnelPort)
	if err != nil {
		tunnelConn, err = establishConnection(conn, cmdStr, tunnelPort)
		if err != nil {
			fmt.Println("Error connecting to tunnel:", err)
			data := []byte("ENCON: database connection failed (tunnel not available).\n")
			conn.Write(data)
			conn.Close()
			return
		}
	}

	// Start proxying data
	go proxyData(conn, tunnelConn)
	go proxyData(tunnelConn, conn)
}

func establishConnection(conn net.Conn, cmdStr string, tunnelPort string) (net.Conn, error) {
	// Run the bash command if the tunnel is not yet established
	cmd := exec.Command("bash", "-c", cmdStr)
	err := cmd.Start() // Start instead of Run to not block the main routine
	if err != nil {
		fmt.Println("Error executing command:", err)
		return nil, err
	}

	// Wait for the tunnel to be ready (this can be adjusted as needed)
	// In a real-world application, a more robust mechanism would be used
	// to determine when the tunnel is ready.
	time.Sleep(2 * time.Second)

	return net.Dial("tcp", "localhost:"+tunnelPort)
}

func main() {
	tunnelPort := flag.String("tunnelPort", "", "Local port with tunnel connection")
	host := flag.String("host", "localhost", "Netsucket host")
	port := flag.String("port", "6000", "Netsucket port")
	cmdStr := flag.String("cmdStr", "", "Bash command to establish tunnel connection")
	version := flag.Bool("version", false, "Show netsucket version information")

	// Parse the command-line arguments
	flag.Parse()

	if (*version == true) {
		fmt.Println(versionNumber)
		return
	}

	if (*tunnelPort == "" || *cmdStr == "") {
		fmt.Printf("Usage of %s:\n", os.Args[0])
		flag.PrintDefaults()
		return
	}

	// Set up the listener
	netsucket := fmt.Sprintf("%s:%s", *host, *port)
	listener, err := net.Listen("tcp", netsucket)
	if err != nil {
		fmt.Println("Error setting up listener:", err)
		return
	}
	defer listener.Close()

	fmt.Println("Monitoring", netsucket, "for connection attempts...")

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Println("Error accepting connection:", err)
			continue
		}

		fmt.Println("Connection attempt detected from", conn.RemoteAddr().String())
		go handleConnection(conn, *cmdStr, *tunnelPort)
	}
}
