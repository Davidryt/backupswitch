/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
#include <linux/if_ether.h> 
#include <linux/ip.h> 
#include <linux/udp.h> 
#include <linux/in.h> 
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#define MAX_SOCKS 64

struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = MAX_SOCKS,  
};

struct bpf_map_def SEC("maps") qidconf_map = {
	.type        = BPF_MAP_TYPE_ARRAY,
	.key_size    = sizeof(int),
	.value_size  = sizeof(int),
	.max_entries = MAX_SOCKS,
};

SEC("xdp_sock") 
int xdp_redirect(struct xdp_md *ctx) 
{ 
	int *qidconf, index = ctx->rx_queue_index; 
	
	// A set entry here means that the correspnding queue_id has an active AF_XDP socket bound to it. 
	qidconf = bpf_map_lookup_elem(&qidconf_map, &index); 
	//qidconf=false;
	if (qidconf) 
	{ 
		//void *data = (void*)(long)ctx->data; 
		//void *data_end = (void*)(long)ctx->data_end; 
		
		//struct ethhdr *eth = data;
		//__u16 h_proto = eth->h_proto; 
		//if ((void*)eth + sizeof(*eth) <= data_end) { 
			//if (h_proto == bpf_htons(ETH_P_IP)){ 
				//struct iphdr *ip = data + sizeof(*eth); 
				//if ((void*)ip + sizeof(*ip) <= data_end) { 
					//if (ip->protocol == IPPROTO_UDP){ 
						//struct udphdr *udp = data + sizeof(*eth) + sizeof(*ip); 
						//if ((void*)udp + sizeof(*udp) <= data_end){ 
						//	if (udp->dest == bpf_htons(8472)){ 
								return bpf_redirect_map(&xsks_map, index, 0); 
				
						//	}
						//}
					//}
				//}
			//}
		//}
	}			
	return XDP_DROP; 			
}

char _license[] SEC("license") = "GPL";


