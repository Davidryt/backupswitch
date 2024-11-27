package main

import (
	"encoding/binary"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"os"
	"log"
	"strconv"
	"strings"
)

const L2_size = 18
const L3_size = 20
const L4_size = 8
const MPLS_size = 8

const nxheadL2_offset_1 int = 12
const nxheadL2_offset_2 int = 13
const slabel_offset int = L2_size + L3_size + L4_size
const vlan_offset int = L2_size - 4
const iplen_offset_1 int = L2_size + 2
const iplen_offset_2 int = L2_size + 3
const ipChkSm_offset_1 int = L2_size + 10
const ipChkSm_offset_2 int = L2_size + 11
const udplen_offset_1 int = L2_size + L3_size + 4
const udplen_offset_2 int = L2_size + L3_size + 5
const header_len = L2_size + L3_size + L4_size + MPLS_size

type L2_info struct {
	Src  string `json:"src_mac,omitempty"`
	Dst  string `json:"dst_mac,omitempty"`
	Vid  uint16 `json:"flow_id"`
	Pcp  uint8  `json:"pcp"`
	Vlan string `json:"vlan,omitempty"`
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
	maxRep int     `json:"maxRep,omitempty"`
}

func L2_header(data L2_info) []byte {
	a, _ := strconv.ParseInt(strconv.FormatInt(int64(data.Pcp), 2) + strconv.FormatInt(int64(data.Vid), 2), 2, 16)
	log.Printf("a: %d", a)
	log.Printf("a1: %d", strconv.FormatInt(int64(data.Vid), 2))
	log.Printf("a2: %d", strconv.FormatInt(int64(data.Pcp), 2))
	src, _ := hex.DecodeString(data.Src)
	dst, _ := hex.DecodeString(data.Dst)
	b := make([]byte, 2)
	binary.BigEndian.PutUint16(b, uint16(a))
	if data.Vlan == "true" {
		return append(dst, append(src, append([]byte{0x81, 0x00},
			append(b, []byte{0x08, 0x00}...)...)...)...)
	} else {
		return append(dst, append(src, []byte{0x08, 0x00}...)...)
	}
}
func L3_header(data L3_info, tos uint8) []byte {
	//a, _ := strconv.ParseInt(strconv.FormatInt(int64(data.tos), 2)+
	//        strconv.FormatInt(int64(data.Pcp), 2), 2, 16)
	//bin_tos := make([]byte, 1)
	return append([]byte{0x45, tos, 0x00, 0x00,
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

func calculateChecksum(data []byte) uint16 {
	var sum uint32
	// Sum up 16-bit words
	for i := 0; i < len(data); i += 2 {
		if i+1 < len(data) {
			sum += uint32(data[i])<<8 + uint32(data[i+1])
		} else {
			sum += uint32(data[i]) << 8 // In case of odd length
		}
	}
	// Add the carries
	for (sum >> 16) > 0 {
		sum = (sum & 0xFFFF) + (sum >> 16)
	}
	// Return the one's complement of sum
	return uint16(^sum)
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
var rHeaders = make(map[[2]byte]map[int][]byte)
var maxRep = make(map[[2]byte]int)
var frstCopy = make(map[[2]byte]map[[4]byte]int)
var actions = make(map[[2]byte]string)
var newFlows = make(map[[2]byte][2]byte)

func detnet(packet []byte) []byte {
	var slabel [2]byte
	var pOff int
	var hOff int
	if packet[nxheadL2_offset_1] == 0x81 && packet[nxheadL2_offset_2] == 0x00 {
		copy(slabel[:], packet[slabel_offset:slabel_offset+2])
		pOff = 0
	} else {
		copy(slabel[:], packet[slabel_offset-4:slabel_offset-2])
		pOff = 4
	}

	switch actions[slabel] {
	case "forward":
		if len(headers[slabel]) == header_len {
			hOff = 0
		} else {
			hOff = 4
		}
		headers[slabel][iplen_offset_1-hOff] = packet[iplen_offset_1-pOff]
		headers[slabel][iplen_offset_2-hOff] = packet[iplen_offset_2-pOff]
		return append(headers[slabel][:slabel_offset-hOff], packet[slabel_offset-pOff:]...)

	case "pop":
		if len(headers[slabel]) == L2_size {
			hOff = 0
		} else {
			hOff = 4
		}
		return append(headers[slabel], packet[header_len-hOff:]...)

	case "replicate":
		if len(headers[slabel]) == header_len {
			hOff = 0
		} else {
			hOff = 4
		}
		var out [][]byte
		for _, v := range rHeaders[slabel] {
			v[iplen_offset_1-hOff] = packet[iplen_offset_1-pOff]
			v[iplen_offset_2-hOff] = packet[iplen_offset_2-pOff]
			out = append(out, append(v[:slabel_offset-hOff], packet[slabel_offset-pOff:]...))
		}
		return out[0]

	case "eliminate":
		if len(headers[slabel]) == header_len {
			hOff = 0
		} else {
			hOff = 4
		}
		var cdword [4]byte
		copy(cdword[:], packet[header_len-4-pOff:header_len-pOff])
		times, ok := frstCopy[slabel][cdword]
		if ok {
			if times >= maxRep[slabel]-1 {
				delete(frstCopy[slabel], cdword)
			} else {
				frstCopy[slabel][cdword]++
			}
			return nil
		} else {
			frstCopy[slabel][cdword] = 1
			headers[slabel][iplen_offset_1-hOff] = packet[iplen_offset_1-pOff]
			headers[slabel][iplen_offset_2-hOff] = packet[iplen_offset_2-pOff]
			return append(headers[slabel][:slabel_offset-hOff], packet[slabel_offset-pOff:]...)
		}

	default:
		var flow [2]byte
		copy(flow[:], packet[vlan_offset:vlan_offset+2])
		slabel, ok := newFlows[flow]
		//log.Printf("label: %d", flow)
		if ok {
			if len(headers[slabel]) == header_len {
				ip_length := uint16(L3_size + L4_size + MPLS_size + len(packet[L2_size:]))
				bin_ip_length := make([]byte, 2)
				binary.BigEndian.PutUint16(bin_ip_length, ip_length)
				udp_length := uint16(L4_size + MPLS_size + len(packet[L2_size:]))
				bin_udp_length := make([]byte, 2)
				binary.BigEndian.PutUint16(bin_udp_length, udp_length)
				out := append(headers[slabel][:slabel_offset+4], append(MPLS_seqnum(), packet[L2_size:]...)...)
				out[iplen_offset_1] = bin_ip_length[0]
				out[iplen_offset_2] = bin_ip_length[1]
				out[udplen_offset_1] = bin_udp_length[0]
				out[udplen_offset_2] = bin_udp_length[1]
				//out := append(headers[slabel][:udplen_offset_1], append(bin_udp_length, append(headers[slabel][udplen_offset_2+1:],
				//	packet[L2_size:]...)...)...)
				chkSm := calculateChecksum(out[L2_size:])
				bin_chkSm := make([]byte, 2)
				binary.BigEndian.PutUint16(bin_chkSm, chkSm)
				out[ipChkSm_offset_1] = bin_chkSm[0]
				out[ipChkSm_offset_2] = bin_chkSm[1]
				//out = append(out[:ipChkSm_offset_1], append(bin_chkSm, out[ipChkSm_offset_2+1:]...)...)
				return out // Hay que añadir el seq num
			} else {
				ip_length := uint16(L3_size + L4_size + MPLS_size + len(packet[L2_size:]))
				bin_ip_length := make([]byte, 2)
				binary.BigEndian.PutUint16(bin_ip_length, ip_length)
				udp_length := uint16(L4_size + MPLS_size + len(packet[L2_size:]))
				bin_udp_length := make([]byte, 2)
				binary.BigEndian.PutUint16(bin_udp_length, udp_length)
				out := append(headers[slabel][:slabel_offset], append(MPLS_seqnum(), packet[L2_size-4:]...)...)
				out[iplen_offset_1-4] = bin_ip_length[0]
				out[iplen_offset_2-4] = bin_ip_length[1]
				out[udplen_offset_1-4] = bin_udp_length[0]
				out[udplen_offset_2-4] = bin_udp_length[1]
				//out := append(headers[slabel][:udplen_offset_1-4], append(bin_udp_length, append(headers[slabel][udplen_offset_2-3:],
				//	packet[L2_size:]...)...)...)
				chkSm := calculateChecksum(out[L2_size-4 : L2_size+L3_size-4])
				bin_chkSm := make([]byte, 2) //[2]byte{0x24, 0x75} //make([]byte, 2)
				binary.BigEndian.PutUint16(bin_chkSm, chkSm)
				out[ipChkSm_offset_1-4] = bin_chkSm[0]
				out[ipChkSm_offset_2-4] = bin_chkSm[1]
				//out = append(out[:ipChkSm_offset_1-4], append(bin_chkSm, out[ipChkSm_offset_2-3:]...)...)
				return out
			}
		}
	}
	return packet
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
		switch v.Action {
		case "encapsulate":
			var b [2]byte
			c, _ := strconv.Atoi(k)
			binary.BigEndian.PutUint16(b[:], uint16(c))
			log.Printf("DETNET? %d ", L2_header(v.L2))
			headers[[2]byte(b)] = append(L2_header(v.L2), append(L3_header(v.L3, v.L2.Pcp),
				append(L4_header(v.L4), append(MPLS_slabel(uint16(c)), []byte{0, 0, 0, 0}...)...)...)...)
		case "replicate":
			var b [2]byte
			res := strings.Split(k, "_")
			c, _ := strconv.Atoi(res[0])
			binary.BigEndian.PutUint16(b[:], uint16(c))
			actions[[2]byte(b)] = "replicate"
			repNumber, _ := strconv.Atoi(res[1])
			rHeaders[[2]byte(b)][repNumber] = append(L2_header(v.L2), append(L3_header(v.L3, v.L2.Pcp),
				append(L4_header(v.L4), append(MPLS_slabel(uint16(c)), []byte{0, 0, 0, 0}...)...)...)...)
		case "eliminate":
			var b [2]byte
			c, _ := strconv.Atoi(k)
			binary.BigEndian.PutUint16(b[:], uint16(c))
			maxRep[[2]byte(b)] = v.maxRep
			var m = make(map[[4]byte]int)
			frstCopy[[2]byte(b)] = m
			actions[[2]byte(b)] = "eliminate"
			headers[[2]byte(b)] = append(L2_header(v.L2), append(L3_header(v.L3, v.L2.Pcp),
				append(L4_header(v.L4), append(MPLS_slabel(uint16(c)), []byte{0, 0, 0, 0}...)...)...)...)
		case "forward":
			var b [2]byte
			c, _ := strconv.Atoi(k)
			binary.BigEndian.PutUint16(b[:], uint16(c))
			actions[[2]byte(b)] = "forward"
			headers[[2]byte(b)] = append(L2_header(v.L2), append(L3_header(v.L3, v.L2.Pcp),
				append(L4_header(v.L4), append(MPLS_slabel(uint16(c)), []byte{0, 0, 0, 0}...)...)...)...)
		case "pop":
			var b [2]byte
			c, _ := strconv.Atoi(k)
			binary.BigEndian.PutUint16(b[:], uint16(c))
			actions[[2]byte(b)] = "pop"
			headers[[2]byte(b)] = L2_header(v.L2)
		}
	}
	flows_file, _ := os.ReadFile(newFlows_path)
	flows := make(map[string]string)
	fmt.Println("Successfully Opened " + detnetConf_path)
	json.Unmarshal(flows_file, &flows)
	for k, v := range flows {
		var flow [2]byte
		f, _ := strconv.Atoi(k)
		binary.BigEndian.PutUint16(flow[:], uint16(f))
		var slabel [2]byte
		s, _ := strconv.Atoi(v)
		binary.BigEndian.PutUint16(slabel[:], uint16(s))
		newFlows[flow] = slabel
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
