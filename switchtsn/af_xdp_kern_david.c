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

/*
// The parsing helper functions from the packet01 lesson have moved here
#include "../common/parsing_helpers.h"
#include "../common/rewrite_helpers.h"

//Defines xdp_stats_map 
#include "../common/xdp_stats_kern_user.h"
#include "../common/xdp_stats_kern.h"

#ifndef memcpy
#define memcpy(dest, src, n) __builtin_memcpy((dest), (src), (n))
#endif
*/

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

/*struct bpf_map_def SEC("maps") redirect_params = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = ETH_ALEN,
	.value_size = ETH_ALEN,
	.max_entries = 1,
};*/

SEC("xdp_sock") 
int xdp_vxlan_redirect(struct xdp_md *ctx) 
{ 
	int *qidconf, index = ctx->rx_queue_index; 
	
	// A set entry here means that the correspnding queue_id has an active AF_XDP socket bound to it. 
	qidconf = bpf_map_lookup_elem(&qidconf_map, &index); 
	//qidconf=false;
	if (qidconf) 
	{ 
		void *data = (void*)(long)ctx->data; 
		void *data_end = (void*)(long)ctx->data_end; 
		
		struct ethhdr *eth = data;
		__u16 h_proto = eth->h_proto; 
		if ((void*)eth + sizeof(*eth) <= data_end) { 
			if (h_proto == bpf_htons(ETH_P_IP)){ 
				/*struct iphdr *ip = data + sizeof(*eth); 
				if ((void*)ip + sizeof(*ip) <= data_end) { 
					if (ip->protocol == IPPROTO_UDP){ 
						struct udphdr *udp = data + sizeof(*eth) + sizeof(*ip); 
						if ((void*)udp + sizeof(*udp) <= data_end){ 
							if (udp->dest == bpf_htons(8472)){ */
								return bpf_redirect_map(&xsks_map, 11, 0); 
				
							/*}
						}
					}
				}*/
			}
		}
	}			
	return XDP_DROP; 			
} 
/*
SEC("xdp_sock")
int xdp_sock_prog(struct xdp_md *ctx)
{
    int index = ctx->rx_queue_index;
    __u32 *pkt_count;

    pkt_count = bpf_map_lookup_elem(&xdp_stats_map, &index);
    if (pkt_count) {

        // We pass every other packet 
        if ((*pkt_count)++ & 1)
            return bpf_redirect(9, 0);
    }

    //A set entry here means that the correspnding queue_id
    //has an active AF_XDP socket bound to it. 
    if (bpf_map_lookup_elem(&xsks_map, &index))
        return bpf_redirect_map(&xsks_map, index, 0);

    return XDP_PASS;
}
*/

/*SEC("xdp_sock")
int xdp_redirect_func(struct xdp_md *ctx)
{
	int index = ctx->rx_queue_index;
	//Assignment 2: fill in with the ifindex of the left interface 
	unsigned ifindex = 9  ; 
	__u32 *pkt_count;

    	pkt_count = bpf_map_lookup_elem(&xdp_stats_map, &index);
    	if (pkt_count) {
    		if ((*pkt_count)++ & 1){
            		return XDP_PASS;
    		}    
    	}
	
	if (bpf_map_lookup_elem(&xsks_map, &index))
		//return bpf_redirect_map(&xsks_map, index, 0);
        	return bpf_redirect(ifindex, 0);

	return XDP_PASS;
	 
}*/


/*SEC("afxdp_red")
int redirect_xdp_prog(struct xdp_md *ctx)
{
    // Get the incoming interface index
    uint32_t in_ifindex = ctx->ingress_ifindex;

    // Look up the destination interface index in the map
    uint32_t *out_ifindex = bpf_map_lookup_elem(&redirect_params, &in_ifindex);
    if (out_ifindex == NULL) {
        // If the destination interface is not found, drop the packet
        return XDP_DROP;
    }

    // Redirect the packet to the destination interface
    int ret = bpf_redirect_map(&redirect_params, &in_ifindex, XDP_DROP);
    // Return whatever redirect returns (redirect or drop)
    return ret;
}
*/
/*
SEC("xdp_redirect_map")
int xdp_redirect_map_func(struct xdp_md *ctx)
{
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct hdr_cursor nh;
	struct ethhdr *eth;
	int eth_type;
	int action = XDP_PASS;
	unsigned char *dst;

	//These keep track of the next header type and iterator pointer 
	nh.pos = data;

	//Parse Ethernet and IP/IPv6 headers
	eth_type = parse_ethhdr(&nh, data_end, &eth);
	if (eth_type == -1)
		goto out;

	//Do we know where to redirect this packet? 
	dst = bpf_map_lookup_elem(&redirect_params, eth->h_source);
	if (!dst)
		goto out;

	// Set a proper destination address 
	memcpy(eth->h_dest, dst, ETH_ALEN);
	action = bpf_redirect_map(&xsks_map, 0, 0);

out:
	return action;
}
*/


char _license[] SEC("license") = "GPL";
