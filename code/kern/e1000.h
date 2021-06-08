#ifndef JOS_KERN_E1000_H
#include <inc/types.h>
#include <inc/mmu.h>

#define PCI_E1000_VENDOR_ID 0x8086
#define PCI_E1000_DEVICE_ID 0x100e
#define LOCATION(offset) (offset >> 2)
volatile uint32_t * e1000;

/* Register Set */
#define E1000_STATUS   0x00008  /* Device Status - RO */
#define E1000_TDBAL    0x03800  /* TX Descriptor Base Address Low - RW */
#define E1000_TDLEN    0x03808  /* TX Descriptor Length - RW */
#define E1000_TDH      0x03810  /* TX Descriptor Head - RW */
#define E1000_TDT      0x03818  /* TX Descripotr Tail - RW */
#define E1000_TCTL     0x00400  /* TX Control - RW */
#define E1000_TIPG     0x00410  /* TX Inter-packet gap -RW */

/* Transmit Control bit definitions */
#define E1000_TCTL_EN     0x00000002    /* enable tx */
#define E1000_TCTL_PSP    0x00000008    /* pad short packets */
#define E1000_TCTL_CT     0x00000ff0    /* collision threshold */
#define E1000_TCTL_COLD   0x003ff000    /* collision distance */

/* Transmit Descriptor*/
struct e1000_tx_desc
{
	uint64_t addr;   /* Address of packet buffer*/
	uint16_t length; /* Data buffer length */
	uint8_t cso;     /* Checksum offset */
	uint8_t cmd;     /* Descriptor control */
	uint8_t status;  /* Descriptor status */
	uint8_t css;     /* Checksum start */
	uint16_t special;
}__attribute__((packed));
/* Transmit Descriptor bit definitions */
#define E1000_TXD_STAT_DD    0x00000001 /* Descriptor Done */

/* Reserve memory for the transmit descriptor array and the packet buffers pointed to by the transmit descriptors */
#define E1000_TX_DESC_ARRAY_SIZE 64 /* Size of transmit descriptor queue */
#define E1000_TX_DESC_BUF_MTU 1518  /* The maximum size of an Ethernet packet */
struct e1000_tx_desc e1000_tx_desc_array[E1000_TX_DESC_ARRAY_SIZE] __attribute__((aligned(PGSIZE))); 
char e1000_tx_packet_buf[E1000_TX_DESC_ARRAY_SIZE][E1000_TX_DESC_BUF_MTU] __attribute__((aligned(PGSIZE))); 

/* Func */
void e1000_transmit_init(); 

#define JOS_KERN_E1000_H
#endif  // SOL >= 6
