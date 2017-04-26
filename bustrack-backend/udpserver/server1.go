package udp

import (
	"fmt"
	"log"
	"net"
	"os"
)

func handleUDPConnection(conn *net.UDPConn) {

	// here is where you want to do stuff like read or write to client

	buffer := make([]byte, 1024)

	n, addr, err := conn.ReadFromUDP(buffer)

	fmt.Println("UDP client : ", addr)
	fmt.Println("Received from UDP client :  ", string(buffer[:n]))

	if err != nil {
		log.Fatal(err)
	}

	// NOTE : Need to specify client address in WriteToUDP() function
	//        otherwise, you will get this error message
	//        write udp : write: destination address required if you use Write() function instead of WriteToUDP()

	// write message back to client
	message := []byte("Hello UDP client!")
	_, err = conn.WriteToUDP(message, addr)

	if err != nil {
		log.Println(err)
	}

}

func main() {
	hostName := getCurretIP()
	portNum := "8085"
	service := hostName + ":" + portNum

	udpAddr, err := net.ResolveUDPAddr("udp4", service)
	fmt.Println(udpAddr)
	if err != nil {
		log.Fatal(err)
	}

	// setup listener for incoming UDP connection
	ln, err := net.ListenUDP("udp", udpAddr)

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("UDP server up and listening on port 8085")

	defer ln.Close()

	for {
		// wait for UDP client to connect
		handleUDPConnection(ln)
	}

}

func getCurretIP() string {
	addrs, err := net.InterfaceAddrs()
	var currentIp string = "0.0.0.0"
	if err != nil {
		os.Stderr.WriteString("Oops: " + err.Error() + "\n")
		os.Exit(1)
	}

	for _, a := range addrs {
		if ipnet, ok := a.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				currentIp = ipnet.IP.String()
			}
		}
	}
	return currentIp
}
