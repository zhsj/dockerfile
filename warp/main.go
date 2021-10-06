package main

import (
	"encoding/base64"
	"encoding/hex"
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"

	"golang.zx2c4.com/wireguard/conn"
	"golang.zx2c4.com/wireguard/device"
	"golang.zx2c4.com/wireguard/tun/netstack"
)

func main() {
	listen := flag.String("listen", ":8080", "")
	flag.Parse()
	conf := getConf()
	tnet := setupNet(conf)
	runProxy(*listen, tnet)
}

func getConf() string {
	peerEndpoint := os.Getenv("PEER_ENDPOINT")

	if peerEndpoint == "" {
		ip, err := net.LookupIP("engage.cloudflareclient.com")
		if err != nil {
			log.Fatal(err)
		}
		if len(ip) == 0 {
			log.Fatal("No available IP for engage.cloudflareclient.com")
		}
		peerEndpoint = ip[0].String() + ":2408"
	}

	privateKey, err := base64.StdEncoding.DecodeString(os.Getenv("PRIVATE_KEY"))
	if err != nil {
		log.Fatalf("Parse PRIVATE_KEY env: %v", err)
	}
	peerKey, err := base64.StdEncoding.DecodeString(os.Getenv("PEER_KEY"))
	if err != nil {
		log.Fatalf("Parse PEER_KEY env: %v", err)
	}
	if len(privateKey) == 0 || len(peerKey) == 0 {
		log.Fatal("Miss PRIVATE_KEY or PEER_KEY env")
	}

	conf := fmt.Sprintf(
		`private_key=%s
public_key=%s
endpoint=%s
allowed_ip=0.0.0.0/0
`,
		hex.EncodeToString(privateKey),
		hex.EncodeToString(peerKey),
		peerEndpoint,
	)
	return conf
}

func setupNet(conf string) *netstack.Net {
	tun, tnet, err := netstack.CreateNetTUN(
		[]net.IP{net.ParseIP("172.16.0.2")},
		[]net.IP{net.ParseIP("1.0.0.1")}, 1280,
	)
	if err != nil {
		log.Fatal(err)
	}
	dev := device.NewDevice(tun, conn.NewDefaultBind(), device.NewLogger(device.LogLevelError, ""))
	if err := dev.IpcSet(conf); err != nil {
		log.Fatal(err)
	}
	if err := dev.Up(); err != nil {
		log.Fatal(err)
	}
	return tnet
}

func runProxy(local string, remoteNet *netstack.Net) {
	ln, err := net.Listen("tcp", local)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Listening on %s", local)

	s := &http.Server{Handler: httpProxyHandler(remoteNet.DialContext)}
	if err := s.Serve(ln); err != nil {
		log.Fatal(err)
	}
}
