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
#define E1000_RA       0x05400  /* Receive Address - RW Array */
#define E1000_RDBAL    0x02800  /* RX Descriptor Base Address Low - RW */
#define E1000_RDLEN    0x02808  /* RX Descriptor Length - RW */
#define E1000_RDH      0x02810  /* RX Descriptor Head - RW */
#define E1000_RDT      0x02818  /* RX Descriptor Tail - RW */
#define E1000_RCTL     0x00100  /* RX Control - RW */

/* Transmit Control bit definitions */
#define E1000_TCTL_EN     0x00000002    /* enable tx */
#define E1000_TCTL_PSP    0x00000008    /* pad short packets */
#define E1000_TCTL_CT     0x00000ff0    /* collision threshold */
#define E1000_TCTL_COLD   0x003ff000    /* collision distance */
/* Transmit Descriptor*/
struct e1000_tx_desc
{
	uint64_t addr;   /* Address of packet buffer*/
	uint16_t length; /* Packet buffer length */
	uint8_t cso;     /* Checksum offset */
	uint8_t cmd;     /* Descriptor control */
	uint8_t status;  /* Descriptor status */
	uint8_t css;     /* Checksum start */
	uint16_t special;
}__attribute__((packed));
/* Transmit Descriptor bit definitions */
#define E1000_TXD_STAT_DD    0x00000001 /* Descriptor Done */
#define E1000_TXD_CMD_RS     0x08 /* Report Status */
#define E1000_TXD_CMD_EOP    0x01 /* End of Packet */
/* Reserve memory for the transmit descriptor array and the packet buffers pointed to by the transmit descriptors */
#define E1000_TX_DESC_ARRAY_SIZE 64 /* Size of transmit descriptor queue */
#define E1000_TX_DESC_BUF_MTU 1518  /* The maximum size of an Ethernet packet */
struct e1000_tx_desc e1000_tx_desc_array[E1000_TX_DESC_ARRAY_SIZE] __attribute__((aligned(PGSIZE))); 
char e1000_tx_packet_buf[E1000_TX_DESC_ARRAY_SIZE][E1000_TX_DESC_BUF_MTU] __attribute__((aligned(PGSIZE))); 

/* Receive Control bit definitions */
#define E1000_RCTL_EN             0x00000002    /* enable */
#define E1000_RCTL_BAM            0x00008000    /* broadcast enable */
#define E1000_RCTL_SECRC          0x04000000    /* Strip Ethernet CRC */
/* Receive Address */
#define E1000_RAH_AV  0x80000000        /* Receive descriptor valid */
/* Receive Descriptor */
struct e1000_rx_desc {
    uint64_t buffer_addr; /* Address of the descriptor's data buffer */
    uint16_t length;     /* Length of data DMAed into data buffer */
    uint16_t csum;       /* Packet checksum */
    uint8_t status;      /* Descriptor status */
    uint8_t errors;      /* Descriptor Errors */
    uint16_t special;
}__attribute__((packed));
/* Receive Descriptor bit definitions */
#define E1000_RXD_STAT_DD       0x01    /* Descriptor Done */
/* Reserve memory for the receive descriptor array and the packet buffers pointed to by the receive descriptors */
#define E1000_RX_DESC_ARRAY_SIZE 128 /* Size of receive descriptor queue */
#define E1000_RX_DESC_BUF_MTU 1518  /* The maximum size of an packet */
struct e1000_rx_desc e1000_rx_desc_array[E1000_RX_DESC_ARRAY_SIZE] __attribute__((aligned(PGSIZE))); 
char e1000_rx_packet_buf[E1000_RX_DESC_ARRAY_SIZE][E1000_RX_DESC_BUF_MTU] __attribute__((aligned(PGSIZE))); 

/* Func */
void e1000_transmit_init(); 
int e1000_transmit(void* addr, int len);
void e1000_receive_init();
int e1000_receive(void* addr, int* len);
#define JOS_KERN_E1000_H
#endif  // SOL >= 6
