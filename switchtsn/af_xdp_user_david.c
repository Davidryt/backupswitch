
/**
 * @mainpage AF_XDP Switch
 * @section Introduction
 * The objective is to build a network switch that is able to transfer all the incoming packages from network A to B, and viceversa, in the fastest way possible
 * @section About
 * We based the current code on the available documentation on the XDP-tutorial in <https://github.com/xdp-project/xdp-tutorial/>
 * 
 * @author      David Rico <david.r.menendez@alumnos.uc3m.es>
 */

#include <assert.h>
#include <errno.h>
#include <getopt.h>
#include <locale.h>
#include <poll.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <sys/resource.h>

#include <bpf/bpf.h>
#include <bpf/xsk.h>

#include <arpa/inet.h>
#include <net/if.h>
#include <linux/if_link.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <linux/icmpv6.h>


#include "../common/common_params.h"
#include "../common/common_user_bpf_xdp.h"
#include "../common/common_libbpf.h"


#define NUM_FRAMES         4096
#define FRAME_SIZE         XSK_UMEM__DEFAULT_FRAME_SIZE
#define RX_BATCH_SIZE      64
#define INVALID_UMEM_FRAME UINT64_MAX

/**
 * xsk_umem_info: (STRUCTURE UMEMORY)
 * User Mode Memory, which is a memory region that is managed by user space applications rather than the kernel. Allows to manage/store stuff from kernel and access from user.
 *
 */

struct xsk_umem_info {
	struct xsk_ring_prod fq;	/** producer ring  */
	struct xsk_ring_cons cq;	/** consumer ring  */
	struct xsk_umem *umem;		/** umem pointer to locate  */
	void *buffer;			/** buffer for storage before sent to umem  */
};

/**
 * stats_record: (Example structure to store recors of status of the AF_XDP (SENT/RECEIVED)
 *
 */

struct stats_record {
	uint64_t timestamp;
	uint64_t rx_packets;	/** packets received */
	uint64_t rx_bytes;	/** bytes received  */
	uint64_t tx_packets;	/** packets sent */
	uint64_t tx_bytes;	/** bytes sent */
};

/**
 * xsk_socket_info: (STRUCTURE to store the actual data and conf of the socket itself)
 * This is NOT the actual socket (xsk_socket() is), but it relations directly to the umem and the socket. its optional but recomended to also store records 
 *
 */

struct xsk_socket_info {
	struct xsk_ring_cons rx;	/** consumer ring (for rx)  */
	struct xsk_ring_prod tx;	/** producer ring (fot tx) */
	struct xsk_umem_info *umem;	/** pointer to umem_info  */
	struct xsk_socket *xsk;		/** pointer to socket (used to call actions)  */

	uint64_t umem_frame_addr[NUM_FRAMES];	/** list of addr  */
	uint32_t umem_frame_free;		/** free frames  */

	uint32_t outstanding_tx;		/** ?  */

	struct stats_record stats;		/** actual stats (this iteration)  */
	struct stats_record prev_stats;		/** producer previous stats */

};

 /**
  * xsk_ring_prod__free(). It takes a pointer to a struct xsk_ring_prod as its argument and returns an unsigned 32-bit integer (__u32). 
  * @param xsk_ring_prod (producer ring)
  * It sets the cached_cons field of the xsk_ring_prod structure to the value of the consumer field plus the size field of the same structure.
  * this function calculates the number of free slots in a producer ring buffer by subtracting the producer index from the consumer index.
  * @return The difference between the cached_cons and cached_prod fields of the xsk_ring_prod structure.
  */

static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
{
	r->cached_cons = *r->consumer + r->size;
	return r->cached_cons - r->cached_prod;
}

static const char *__doc__ = "AF_XDP kernel bypass example\n";

static const struct option_wrapper long_options[] = {

	{{"help",	 no_argument,		NULL, 'h' },
	 "Show help", false},

	{{"dev",	 required_argument,	NULL, 'd' },
	 "Operate on device <ifname>", "<ifname>", true},

	{{"skb-mode",	 no_argument,		NULL, 'S' },
	 "Install XDP program in SKB (AKA generic) mode"},

	{{"native-mode", no_argument,		NULL, 'N' },
	 "Install XDP program in native mode"},

	{{"auto-mode",	 no_argument,		NULL, 'A' },
	 "Auto-detect SKB or native mode"},

	{{"force",	 no_argument,		NULL, 'F' },
	 "Force install, replacing existing program on interface"},

	{{"copy",        no_argument,		NULL, 'c' },
	 "Force copy mode"},

	{{"zero-copy",	 no_argument,		NULL, 'z' },
	 "Force zero-copy mode"},

	{{"queue",	 required_argument,	NULL, 'Q' },
	 "Configure interface receive queue for AF_XDP, default=0"},

	{{"poll-mode",	 no_argument,		NULL, 'p' },
	 "Use the poll() API waiting for packets to arrive"},

	{{"unload",      no_argument,		NULL, 'U' },
	 "Unload XDP program instead of loading"},

	{{"quiet",	 no_argument,		NULL, 'q' },
	 "Quiet mode (no output)"},

	{{"filename",    required_argument,	NULL,  1  },
	 "Load program from <file>", "<file>"},

	{{"progsec",	 required_argument,	NULL,  2  },
	 "Load program in <section> of the ELF file", "<section>"},

	{{0, 0, NULL,  0 }, NULL, false}
};

static bool global_exit;

/**
 * Function configure_xsk_umem(). This function takes a pointer to a buffer and its size as its arguments and returns a pointer to a struct xsk_umem_info
 * It allocates memory for a struct xsk_umem_info using the calloc() function. This structure is used to store information about a user-mode memory (UMEM) region.
 * It calls the xsk_umem__create() function to create a UMEM region using the buffer and size provided as arguments, and to initialize the corresponding fill queue (fq) and completion queue 
 * (cq) structures in the xsk_umem_info structure. If xsk_umem__create() returns a non-zero value, indicating an error, the function sets errno to the negated error code and returns NULL.
 * The function sets the buffer field of the xsk_umem_info structure to the buffer provided as an argument.
 * The function returns a pointer to the xsk_umem_info structure.
 * In summary, this function creates and initializes a UMEM region, and returns a pointer to a structure containing information about the UMEM region.
 *
 */

static struct xsk_umem_info *configure_xsk_umem(void *buffer, uint64_t size)
{
	struct xsk_umem_info *umem;
	int ret;

	umem = calloc(1, sizeof(*umem));
	if (!umem)
		return NULL;

	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
			       NULL);
	if (ret) {
		errno = -ret;
		return NULL;
	}

	umem->buffer = buffer;
	return umem;
}

/**
 * The xsk_alloc_umem_frame function is used to allocate a frame from the UMEM. 
 * It does this by checking if there are any free frames available in the UMEM. 
 * If there are no free frames, the function returns an error code (INVALID_UMEM_FRAME). 
 * If there are free frames, the function takes the address of the last available frame, decrements the number of free frames, marks the frame as used, 
 * and returns the address of the allocated frame.
 */

static uint64_t xsk_alloc_umem_frame(struct xsk_socket_info *xsk)
{
	uint64_t frame;
	if (xsk->umem_frame_free == 0)
		return INVALID_UMEM_FRAME;

	frame = xsk->umem_frame_addr[--xsk->umem_frame_free];
	xsk->umem_frame_addr[xsk->umem_frame_free] = INVALID_UMEM_FRAME;
	return frame;
}

/**
 * The xsk_free_umem_frame function is used to free a frame that was previously allocated. 
 * It does this by marking the frame as free in the UMEM and incrementing the number of free frames.
 */

static void xsk_free_umem_frame(struct xsk_socket_info *xsk, uint64_t frame)
{
	assert(xsk->umem_frame_free < NUM_FRAMES);

	xsk->umem_frame_addr[xsk->umem_frame_free++] = frame;
}

/**
 * The xsk_umem_free_frames function simply returns the number of free frames that are currently available in the UMEM.
 */

static uint64_t xsk_umem_free_frames(struct xsk_socket_info *xsk)
{
	return xsk->umem_frame_free;
}

/**
 * Function xsk_configure_socket that configures the XDP socket used to send and receive packets.
 * This function is key for the socket config so we will go in detail on the steps performed_
 * 
 */


static struct xsk_socket_info *xsk_configure_socket(struct config *cfg,
						    struct xsk_umem_info *umem)
{
	struct xsk_socket_config xsk_cfg;
	struct xsk_socket_info *xsk_info;
	uint32_t idx;
	uint32_t prog_id = 0;
	int i;
	int ret;

	xsk_info = calloc(1, sizeof(*xsk_info));				/**6	 Allocates memory for the xsk_socket_info struct. */
	if (!xsk_info)
		return NULL;

	xsk_info->umem = umem;							/** Sets the umem field of the xsk_socket_info struct to point to the previously configured UMEM. */
	xsk_cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;			/** Initializes a xsk_socket_config struct with default values for the number  of descriptors for the receive and transmit rings, as well as the XDP and bind flags. */
	xsk_cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;			
	xsk_cfg.libbpf_flags = 0;
	xsk_cfg.xdp_flags = cfg->xdp_flags;
	xsk_cfg.bind_flags = cfg->xsk_bind_flags;
	ret = xsk_socket__create(&xsk_info->xsk, cfg->ifname,cfg->xsk_if_queue, umem->umem, &xsk_info->rx,&xsk_info->tx, &xsk_cfg); /** Calls the xsk_socket__create function to create the XDP socket, passing in the ifname, xsk_if_queue, UMEM, and the rx and tx ring buffers from the xsk_socket_info struct, as well as the xsk_socket_config struct created in the previous step. */
				 

	if (ret)
		goto error_exit;						/** Check errors */

	ret = bpf_get_link_xdp_id(cfg->ifindex, &prog_id, cfg->xdp_flags);	/** Calls bpf_get_link_xdp_id to retrieve the XDP program ID associated with the interface specified in cfg->ifname and the XDP flags specified in cfg->xdp_flags. */
	if (ret)
		goto error_exit;						/** Check errors */


	for (i = 0; i < NUM_FRAMES; i++)					/** Initializes the UMEM frame allocation by filling the umem_frame_addr array in the xsk_socket_info struct with the addresses of the frames. The number of frames and the size of each frame are defined as constants in the program. */
		xsk_info->umem_frame_addr[i] = i * FRAME_SIZE;

	xsk_info->umem_frame_free = NUM_FRAMES;

	
	ret = xsk_ring_prod__reserve(&xsk_info->umem->fq,			/** Reserves space in the UMEM fill queue (fq) for the number of descriptors defined as XSK_RING_PROD__DEFAULT_NUM_DESCS (also a constant). */
				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
				     &idx);

	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)				/** Check errors */
		goto error_exit;

	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i ++)			/** Fills the space in the fq with frames by calling xsk_alloc_umem_frame to get the address of a free frame and writing it to the fill queue. */
		*xsk_ring_prod__fill_addr(&xsk_info->umem->fq, idx++) =
			xsk_alloc_umem_frame(xsk_info);

	xsk_ring_prod__submit(&xsk_info->umem->fq,				/** Submits the filled descriptors to the fq. */
			      XSK_RING_PROD__DEFAULT_NUM_DESCS);

	return xsk_info;

error_exit:
	errno = -ret;
	return NULL;
}

/**
 * This function complete_tx is responsible for completing the outstanding transmission (TX) operations on the socket. 
 * Overall, this function ensures that any outstanding TX operations are completed and their associated memory is freed.
 * 
 */

static void complete_tx(struct xsk_socket_info *xsk)
{
	unsigned int completed;
	uint32_t idx_cq;

	if (!xsk->outstanding_tx)						/** Check if there are any outstanding TX operations. If there are none, return.*/
		return;

	sendto(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, 0);	/** Call sendto with a NULL buffer and 0 size to force the underlying transport layer to attempt to transmit any pending data immediately.*/


	completed = xsk_ring_cons__peek(&xsk->umem->cq,				/** Collect and free the completed TX buffers. It does this by calling xsk_ring_cons__peek to get the number of completed TX operations, and then iterates over the completed TX descriptors, freeing their associated memory using xsk_free_umem_frame.*/
					XSK_RING_CONS__DEFAULT_NUM_DESCS,
					&idx_cq);

	if (completed > 0) {				
		for (int i = 0; i < completed; i++)
			xsk_free_umem_frame(xsk,
					    *xsk_ring_cons__comp_addr(&xsk->umem->cq,
								      idx_cq++));

		xsk_ring_cons__release(&xsk->umem->cq, completed);		/** Release the completed TX buffers from the completion queue using xsk_ring_cons__release.*/
		xsk->outstanding_tx -= completed < xsk->outstanding_tx ?	/** Update the outstanding_tx counter to reflect the number of completed TX operations.*/
			completed : xsk->outstanding_tx;
	}
}

/**
 * csum16_add() takes a 16-bit checksum and a 16-bit value to be added to it, and returns the updated 16-bit checksum. The calculation is done by adding the two values, 
 * taking the result as a 32-bit value, and adding the carry (if any) back to the lower 16 bits.
 * 
 */

static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
{
	uint16_t res = (uint16_t)csum;

	res += (__u16)addend;
	return (__sum16)(res + (res < (__u16)addend));
}

/**
 * csum16_sub() is similar to csum16_add(), but it subtracts the second argument from the first one, and takes care of the borrow.
 * 
 */

static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
{
	return csum16_add(csum, ~addend);
}

/**
 * csum_replace2 replaces a 16-bit value in the checksum with a new value. 
 * @param a pointer to the checksum
 * @param the old 16-bit value
 * @param the new 16-bit value
 * It first subtracts the old value from the checksum (taking care of the borrow), then adds the new value, and finally takes the one's complement to get the new checksum.
 * 
 */

static inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
{
	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);   //wtf
}

/**
 *	Function process_packet
 * @param a pointer to a struct xsk_socket_info that holds information about the XDP socket
 * @param the address and length of a packet to be processed
 *
 *	I have implemented a logic to answer to echo replies when echo request received for testing purpose, but its commented since for the moment we dont want to process nothing for a switch
 *	Im retutning false for the moment
 */

static bool process_packet(struct xsk_socket_info *xsk,
			   uint64_t addr, uint32_t len)
{
	//uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);

       

	/*	//ICMP STUFF GOING ON BUT USELESS FOR SWITCH
		int ret;
		uint32_t tx_idx = 0;
		uint8_t tmp_mac[ETH_ALEN];
		struct in6_addr tmp_ip;
		struct ethhdr *eth = (struct ethhdr *) pkt;
		struct ipv6hdr *ipv6 = (struct ipv6hdr *) (eth + 1);
		struct icmp6hdr *icmp = (struct icmp6hdr *) (ipv6 + 1);

		if (ntohs(eth->h_proto) != ETH_P_IPV6 ||
		    len < (sizeof(*eth) + sizeof(*ipv6) + sizeof(*icmp)) ||
		    ipv6->nexthdr != IPPROTO_ICMPV6 ||
		    icmp->icmp6_type != ICMPV6_ECHO_REQUEST)
			return false;

		memcpy(tmp_mac, eth->h_dest, ETH_ALEN);
		memcpy(eth->h_dest, eth->h_source, ETH_ALEN);
		memcpy(eth->h_source, tmp_mac, ETH_ALEN);

		memcpy(&tmp_ip, &ipv6->saddr, sizeof(tmp_ip));
		memcpy(&ipv6->saddr, &ipv6->daddr, sizeof(tmp_ip));
		memcpy(&ipv6->daddr, &tmp_ip, sizeof(tmp_ip));

		icmp->icmp6_type = ICMPV6_ECHO_REPLY;

		csum_replace2(&icmp->icmp6_cksum,
			      htons(ICMPV6_ECHO_REQUEST << 8),
			      htons(ICMPV6_ECHO_REPLY << 8));

		ret = xsk_ring_prod__reserve(&xsk->tx, 1, &tx_idx);
		if (ret != 1) {
			return false;
		}

		xsk_ring_prod__tx_desc(&xsk->tx, tx_idx)->addr = addr;
		xsk_ring_prod__tx_desc(&xsk->tx, tx_idx)->len = len;
		xsk_ring_prod__submit(&xsk->tx, 1);
		xsk->outstanding_tx++;

		xsk->stats.tx_bytes += len;
		xsk->stats.tx_packets++;
		return true;
	*/

	return false;
}

/**
 * Handles the received packets from the XDP socket. 
 * It first checks if any packets have been received, and if not, it returns. 
 * If there are packets, it checks how many free frames are available in the frame queue of the shared UMEM. 
 * If there are free frames available, it reserves as many frames as possible from the frame queue, and fills the reserved frames with new frame descriptors from the UMEM. 
 * These frame descriptors are then submitted to the frame queue.
 * The function then processes the received packets one by one, by calling the process_packet() function. 
 * If process_packet() returns false, it means the packet could not be processed, and the frame is freed using xsk_free_umem_frame(). 
 * The number of bytes and packets received are added to the statistics of the socket.
 * Finally, the function checks if any packets are ready to be transmitted, by calling the complete_tx() function. If so, it will wake up the kernel for transmission.
 *
 */

static void handle_receive_packets(struct xsk_socket_info *xsk)
{
	unsigned int rcvd, stock_frames, i;
	uint32_t idx_rx = 0, idx_fq = 0;
	int ret;

	rcvd = xsk_ring_cons__peek(&xsk->rx, RX_BATCH_SIZE, &idx_rx);	/** Did we receive a pack? if not, return */
	if (!rcvd)
		return;

	
	stock_frames = xsk_prod_nb_free(&xsk->umem->fq,			/** How many frames do we have free ( we want to fill as many? */
					xsk_umem_free_frames(xsk));

	if (stock_frames > 0) {

		ret = xsk_ring_prod__reserve(&xsk->umem->fq, stock_frames,	/** We reserve those frames then */
					     &idx_fq);

										
		while (ret != stock_frames)					/** Por si falla? Lo mismo no hace ni falta esto */
			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
						     &idx_fq);

		for (i = 0; i < stock_frames; i++)				/** We fill the reseved frames with the new frame descriptors */
			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
				xsk_alloc_umem_frame(xsk);

		xsk_ring_prod__submit(&xsk->umem->fq, stock_frames);		/** submit those descriptors to the queue!! */
	}

	/* Here we use to send the packages to process. Now we should do this? we just want to store them and let the af_xdp in output interface sent it. */
	/*for (i = 0; i < rcvd; i++) {
		uint64_t addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
		uint32_t len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;

		if (!process_packet(xsk, addr, len))
			xsk_free_umem_frame(xsk, addr);

		xsk->stats.rx_bytes += len;
	}*/

	xsk_ring_cons__release(&xsk->rx, rcvd);					/** The number of bytes and packets received are added to the statistics of the socket.*/
	xsk->stats.rx_packets += rcvd;

	
	complete_tx(xsk);							/** Wake up kernel call for transmission of the remaining packages */
  }

static void rx_and_process(struct config *cfg,
			   struct xsk_socket_info *xsk_socket)
{
	struct pollfd fds[2];
	int ret, nfds = 1;

	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
	fds[0].events = POLLIN;

	while(!global_exit) {
		if (cfg->xsk_poll_mode) {
			ret = poll(fds, nfds, -1);
			if (ret <= 0 || ret > 1)
				continue;
		}
		handle_receive_packets(xsk_socket);
	}
}

#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
static uint64_t gettime(void)
{
	struct timespec t;
	int res;

	res = clock_gettime(CLOCK_MONOTONIC, &t);
	if (res < 0) {
		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
		exit(EXIT_FAIL);
	}
	return (uint64_t) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
}

static double calc_period(struct stats_record *r, struct stats_record *p)
{
	double period_ = 0;
	__u64 period = 0;

	period = r->timestamp - p->timestamp;
	if (period > 0)
		period_ = ((double) period / NANOSEC_PER_SEC);

	return period_;
}

static void stats_print(struct stats_record *stats_rec,
			struct stats_record *stats_prev)
{
	uint64_t packets, bytes;
	double period;
	double pps; /* packets per sec */
	double bps; /* bits per sec */

	char *fmt = "%-12s %'11lld pkts (%'10.0f pps)"
		" %'11lld Kbytes (%'6.0f Mbits/s)"
		" period:%f\n";

	period = calc_period(stats_rec, stats_prev);
	if (period == 0)
		period = 1;

	packets = stats_rec->rx_packets - stats_prev->rx_packets;
	pps     = packets / period;

	bytes   = stats_rec->rx_bytes   - stats_prev->rx_bytes;
	bps     = (bytes * 8) / period / 1000000;

	printf(fmt, "AF_XDP RX:", stats_rec->rx_packets, pps,
	       stats_rec->rx_bytes / 1000 , bps,
	       period);

	packets = stats_rec->tx_packets - stats_prev->tx_packets;
	pps     = packets / period;

	bytes   = stats_rec->tx_bytes   - stats_prev->tx_bytes;
	bps     = (bytes * 8) / period / 1000000;

	printf(fmt, "       TX:", stats_rec->tx_packets, pps,
	       stats_rec->tx_bytes / 1000 , bps,
	       period);

	printf("\n");
}

static void *stats_poll(void *arg)
{
	unsigned int interval = 2;
	struct xsk_socket_info *xsk = arg;
	static struct stats_record previous_stats = { 0 };

	previous_stats.timestamp = gettime();

	/**2 Trick to pretty printf with thousands separators use %' */
	setlocale(LC_NUMERIC, "en_US");

	while (!global_exit) {
		sleep(interval);
		xsk->stats.timestamp = gettime();
		stats_print(&xsk->stats, &previous_stats);
		previous_stats = xsk->stats;
	}
	return NULL;
}

static void exit_application(int signal)
{
	signal = signal;
	global_exit = true;
}

 /**
  * Loop principal de nuestro algoritmo (MAIN).
  * @param argc Integer que nos indica el numero de argumentos recibidos + 1.
  * @param argv Array que contiene dichos argumentos.
  * @return 1 en caso de Éxito
  * @return -1 en caso de Error de ejecución
  */
  
int main(int argc, char **argv)
{
	int ret;
	int xsks_map_fd;
	void *packet_buffer;
	void *packet_buffer2;  //test
	uint64_t packet_buffer_size;
	uint64_t packet_buffer_size2;  //test
	struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};
	struct config cfg = {   //Temporal
		.ifindex   = -1,
		.do_unload = false,
		.filename = "",
		.progsec = "xdp_sock"
	};
	struct config left = {
		.ifindex   = 3,
		.do_unload = false,
		.filename = "",
		.progsec = "xdp_sock"
	};
	struct config right = {
		.ifindex   = 4,
		.do_unload = false,
		.filename = "",
		.progsec = "xdp_sock"
	};
	struct xsk_umem_info *umem;
	struct xsk_umem_info *umem2; //test
	struct xsk_socket_info *xsk_socket;//temporal
	struct xsk_socket_info *left_socket;
	struct xsk_socket_info *right_socket;
	struct bpf_object *bpf_obj = NULL;
	pthread_t stats_poll_thread;

	/** Global shutdown handler */
	signal(SIGINT, exit_application);

	/** Cmdline options can change progsec */
	parse_cmdline_args(argc, argv, long_options, &cfg, __doc__);
	
	/** Required option */
	if (cfg.ifindex == -1) {
		fprintf(stderr, "ERROR: Required option --dev missing\n\n");
		usage(argv[0], __doc__, long_options, (argc == 1));
		return EXIT_FAIL_OPTION;
	}
	printf("%d  interfaz", right.ifindex);
	
	/** Unload XDP program if requested */
	if (cfg.do_unload)
		return xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);

	/** Load custom program if configured */
	if (cfg.filename[0] != 0) {
		struct bpf_map *map;

		bpf_obj = load_bpf_and_xdp_attach(&cfg);
		if (!bpf_obj) {
			/** Error handling done in load_bpf_and_xdp_attach() */
			exit(EXIT_FAILURE);
		}

		/** We also need to load the xsks_map */
		map = bpf_object__find_map_by_name(bpf_obj, "xsks_map");
		xsks_map_fd = bpf_map__fd(map);
		if (xsks_map_fd < 0) {
			fprintf(stderr, "ERROR: no xsks map found: %s\n",
				strerror(xsks_map_fd));
			exit(EXIT_FAILURE);
		}
	}
	/** 
	 * @internal 
	 * Allow unlimited locking of memory, so all memory needed for packet
	 * buffers can be locked.
	 * @endinternal
	 */
	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

	/** Allocate memory for NUM_FRAMES of the default XDP frame size */
	packet_buffer_size = NUM_FRAMES * FRAME_SIZE;
	if (posix_memalign(&packet_buffer,
			   getpagesize(), /* PAGE_SIZE aligned */
			   packet_buffer_size)) {
		fprintf(stderr, "ERROR: Can't allocate buffer memory \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
	
	
	/*
	
	packet_buffer_size2 = NUM_FRAMES * FRAME_SIZE;
	if (posix_memalign(&packet_buffer2,
			   getpagesize(), 
			   packet_buffer_size2)) {
		fprintf(stderr, "ERROR: Can't allocate buffer memory \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
	
	
	*/
	
	

	/** Initialize shared packet_buffer for umem usage */
	umem = configure_xsk_umem(packet_buffer, packet_buffer_size);
	if (umem == NULL) {
		fprintf(stderr, "ERROR: Can't create umem \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
	
	/*umem2 = configure_xsk_umem(packet_buffer2, packet_buffer_size2);
	if (umem2 == NULL) {
		fprintf(stderr, "ERROR: Can't create umem2 \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}*/

	/** Open and configure the AF_XDP (xsk) socket */
	xsk_socket = xsk_configure_socket(&cfg, umem);
	if (xsk_socket == NULL) {
		fprintf(stderr, "ERROR: Can't setup AF_XDP socket input \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
	
	//left_socket = xsk_configure_socket(&left, umem);
	/*if (left_socket == NULL) {
		fprintf(stderr, "ERROR: Can't setup AF_XDP socket 1\"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}*/
	right_socket = xsk_configure_socket(&right, umem);
	if (right_socket == NULL) {
		fprintf(stderr, "ERROR: Can't setup AF_XDP socket 2 \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
	/** Start thread to do statistics display */
	if (verbose) {
		ret = pthread_create(&stats_poll_thread, NULL, stats_poll,
				     xsk_socket);  //CAMBIAR
		if (ret) {
			fprintf(stderr, "ERROR: Failed creating statistics thread "
				"\"%s\"\n", strerror(errno));
			exit(EXIT_FAILURE);
		}
	}

	/** Receive and count packets than drop them */
	rx_and_process(&cfg, xsk_socket);
	//rx_and_process(&cfg, left_socket);
	//rx_and_process(&cfg, right_socket);

	/** Cleanup */
	xsk_socket__delete(xsk_socket->xsk);
	//xsk_socket__delete(left_socket->xsk);
	//xsk_socket__delete(right_socket->xsk);
	xsk_umem__delete(umem->umem);
	//xsk_umem__delete(umem2->umem);
	xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);

	return EXIT_OK;
}
