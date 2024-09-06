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
#include <linux/if_vlan.h> // Include VLAN header definitions

#define MAX_SOCKS 64

struct bpf_map_def SEC("maps") xsks_map = {
    .type = BPF_MAP_TYPE_XSKMAP,
    .key_size = sizeof(int),
    .value_size = sizeof(int),
    .max_entries = MAX_SOCKS,  
};

struct bpf_map_def SEC("maps") qidconf_map = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(int),
    .value_size = sizeof(int),
    .max_entries = MAX_SOCKS,
};

SEC("xdp_sock") 
int xdp_redirect(struct xdp_md *ctx) 
{ 
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    int *qidconf, index = ctx->rx_queue_index;

    // Ensure the Ethernet header is within the packet
    if ((void *)(eth + 1) > data_end)
        return XDP_DROP;

    // Check for VLAN-tagged packet (single or double tagging)
    __u16 h_proto = eth->h_proto;
    if (h_proto == bpf_htons(ETH_P_8021Q) || h_proto == bpf_htons(ETH_P_8021AD)) {
        // Lookup the queue configuration
        qidconf = bpf_map_lookup_elem(&qidconf_map, &index);
        if (qidconf) {
            // Redirect if this is a VLAN-tagged packet
            return bpf_redirect_map(&xsks_map, index, 0);
        }
    }
    
    // Drop the packet if not VLAN-tagged
    return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
