package main

import (
	"encoding/binary"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const L2_size = 18
const L3_size = 20
const L4_size = 8
const MPLS_size = 8

const slabel_offset int = L2_size + L3_size + L4_size
const vlan_offset int = L2_size - 4
const iplen_offset_1 int = L2_size + 2
const iplen_offset_2 int = L2_size + 3
const header_len = L2_size + L3_size + L4_size + MPLS_size

type L2_info struct {
	Src string `json:"src_mac,omitempty"`
	Dst string `json:"dst_mac,omitempty"`
	Vid uint16 `json:"flow_id"`
	Pcp uint8  `json:"pcp"`
}
type L3_info struct {
	Src string `json:"src_ip"`
	Dst string `json:"dst_ip"`
}
type L4_info struct {
	Src uint16 `json:"src_port"`
	Dst uint16 `json:"dst_port"`
}
type Service struct {
	Action string  `json:"action"`
	L2     L2_info `json:"L2,omitempty"`
	L3     L3_info `json:"L3,omitempty"`
	L4     L4_info `json:"L4,omitempty"`
}

func L2_header(data L2_info) []byte {
	a, _ := strconv.ParseInt(strconv.FormatInt(int64(data.Vid), 2)+
		strconv.FormatInt(int64(data.Pcp), 2), 2, 16)
	src, _ := hex.DecodeString(data.Src)
	dst, _ := hex.DecodeString(data.Dst)
	b := make([]byte, 2)
	binary.BigEndian.PutUint16(b, uint16(a))
	return append(src, append(dst, append([]byte{0x81, 0x00},
		append(b, []byte{0x08, 0x00}...)...)...)...)
}
func L3_header(data L3_info) []byte {
	return append([]byte{0x45, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x40, 0x00,
		0x40, 0x11, 0x00, 0x00},
		append(parseIPv4addr(data.Src),
			parseIPv4addr(data.Dst)...)...)
}
func L4_header(data L4_info) []byte {
	src, dst := make([]byte, 2), make([]byte, 2)
	binary.BigEndian.PutUint16(src, data.Src)
	binary.BigEndian.PutUint16(dst, data.Dst)
	return append(src, append(dst, []byte{0, 0, 0, 0}...)...)
}
func MPLS_slabel(slabel uint16) []byte {
	lab := make([]byte, 2)
	binary.BigEndian.PutUint16(lab, slabel)
	return append(lab, []byte{0, 255}...)
}
func MPLS_seqnum() []byte {
	if seqNum == 0xFFFFFFF {
		seqNum = 0
	} else {
		seqNum++
	}
	b := make([]byte, 4)
	binary.BigEndian.PutUint32(b, seqNum)
	return b
}

func parseIPv4addr(addr string) []byte {
	a := strings.Split(addr, ".")
	b := make([]byte, 4)
	for i := 0; i < 4; i++ {
		c, _ := strconv.Atoi(a[i])
		b[i] = byte(c)
	}
	return b
}

var seqNum uint32 = 0
var headers = make(map[[2]byte][]byte)
var actions = make(map[[2]byte]string)
var newFlows = make(map[[2]byte][2]byte)

func detnet(packet []byte) []byte {
	fmt.Println("Received packet by Detnet.")
	var slabel [2]byte
	copy(slabel[:], packet[slabel_offset : slabel_offset+2])
	switch actions[slabel] {
	case "forward":
		headers[slabel][iplen_offset_1] = packet[iplen_offset_1]
		headers[slabel][iplen_offset_2] = packet[iplen_offset_2]
		return append(headers[slabel][:slabel_offset], packet[slabel_offset:]...)
	case "pop":
		return append(headers[slabel], packet[header_len:]...)
	default:
		var vlan [2]byte
		copy(vlan[:], packet[vlan_offset : vlan_offset+2])
		slabel, ok := newFlows[vlan]
		if ok {
			return append(headers[slabel], packet[L2_size:]...)
		}
	}
	fmt.Println("Not identified.")
	return nil
}

func detnet_init(detnetConf_path string, newFlows_path string) bool {
	detnetConf_file, err := os.ReadFile(detnetConf_path)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Opened " + detnetConf_path)
	var services = make(map[string]Service)
	json.Unmarshal(detnetConf_file, &services)
	fmt.Println(services)
	for k, v := range services {
		b := make([]byte, 2)
		var d [2]byte
		c, _ := strconv.Atoi(k)
		binary.BigEndian.PutUint16(b, uint16(c))
		copy(d[:],b) // *(*[2]byte)(b)
		switch v.Action {
		case "encapsulate":
			headers[d] = append(L2_header(v.L2), append(L3_header(v.L3),
				append(L4_header(v.L4), append(MPLS_slabel(uint16(c)), []byte{0, 0, 0, 0}...)...)...)...)
		case "forward":
			actions[d] = "forward"
			headers[d] = append(L2_header(v.L2), append(L3_header(v.L3),
				append(L4_header(v.L4), append(MPLS_slabel(uint16(c)), []byte{0, 0, 0, 0}...)...)...)...)
		case "pop":
			actions[d] = "pop"
			headers[d] = L2_header(v.L2)
		}
	}
	flows_file, _ := os.ReadFile(newFlows_path)
	flows := make(map[string]string)
	fmt.Println("Successfully Opened " + detnetConf_path)
	json.Unmarshal(flows_file, &flows)
	for k, v := range flows {
		flow := make([]byte, 2)
		f, _ := strconv.Atoi(k)
		binary.BigEndian.PutUint16(flow, uint16(f))
		slabel := make([]byte, 2)
		s, _ := strconv.Atoi(v)
		binary.BigEndian.PutUint16(slabel, uint16(s))
		var b [2]byte
		var d [2]byte
		copy(b[:],flow)
		copy(d[:],slabel)
		newFlows[b] = d
	}

	fmt.Println(headers)
	fmt.Println(actions)
	fmt.Println(newFlows)
	return true
}

//func main() {
//	fmt.Println("Hola")
//	detnet_init("./detnetData.json", "./newFlows.json")
//}
