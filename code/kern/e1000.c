#include <kern/e1000.h>
#include <kern/pmap.h>
#include <kern/pci.h>
#include <inc/string.h>
// LAB 6: Your driver code here
void e1000_transmit_init() {
    int i; 
    // Initialize transmit Descriptor list entries to 0 
    memset(e1000_tx_desc_array, 0, sizeof(struct e1000_tx_desc) * E1000_TX_DESC_ARRAY_SIZE);
    for (i = 0; i < E1000_TX_DESC_ARRAY_SIZE; i++) {
        e1000_tx_desc_array[i].addr = PADDR(e1000_tx_packet_buf[i]);
        e1000_tx_desc_array[i].status = E1000_TXD_STAT_DD; // free
        e1000_tx_desc_array[i].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP; 
    }
    
    e1000[LOCATION(E1000_TDBAL)] = PADDR(e1000_tx_desc_array);
    e1000[LOCATION(E1000_TDLEN)] = sizeof(struct e1000_tx_desc) * E1000_TX_DESC_ARRAY_SIZE;
    e1000[LOCATION(E1000_TDH)] = 0;
    e1000[LOCATION(E1000_TDT)] = 0;
    e1000[LOCATION(E1000_TCTL)] = E1000_TCTL_EN | E1000_TCTL_PSP | (E1000_TCTL_CT & (0x10 << 4)) | (E1000_TCTL_COLD & (0x40 << 12));
    e1000[LOCATION(E1000_TIPG)] = 10 | (4 << 10) | (6 << 20);
}
int e1000_transmit(void* addr, int len) {
    int e1000_tdt = e1000[LOCATION(E1000_TDT)];
    struct e1000_tx_desc* e1000_tx_desc_ptr = &e1000_tx_desc_array[e1000_tdt];
    if (!(e1000_tx_desc_ptr->status & E1000_TXD_STAT_DD))
        return -1; // transmit queue is full

    memmove(e1000_tx_packet_buf[e1000_tdt], addr, len);
    e1000_tx_desc_ptr->status &= ~E1000_TXD_STAT_DD;
    e1000_tx_desc_ptr->length = (uint16_t)len;

    e1000[LOCATION(E1000_TDT)] = (e1000_tdt + 1) % E1000_TX_DESC_ARRAY_SIZE;

    return 0;
}
void e1000_receive_init() {
    int i; 
    
    e1000[LOCATION(E1000_RA)] = 0x12005452;
    e1000[LOCATION(E1000_RA)+1] = 0x00005634 | E1000_RAH_AV;
    
    memset(e1000_rx_desc_array, 0, sizeof(struct e1000_rx_desc) * E1000_RX_DESC_ARRAY_SIZE); 
    for (i = 0; i < E1000_RX_DESC_ARRAY_SIZE; i++) {
        e1000_rx_desc_array[i].buffer_addr = PADDR(e1000_rx_packet_buf[i]);
    }

    e1000[LOCATION(E1000_RDBAL)] = PADDR(e1000_rx_desc_array);
    e1000[LOCATION(E1000_RDLEN)] = sizeof(struct e1000_rx_desc) * E1000_RX_DESC_ARRAY_SIZE;
    e1000[LOCATION(E1000_RDH)] = 0;
    e1000[LOCATION(E1000_RDT)] = E1000_RX_DESC_ARRAY_SIZE - 1;

    e1000[LOCATION(E1000_RCTL)] = E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SECRC;
}
int e1000_receive(void *addr, int *len) {
    static int next = 0;
    int tail = e1000[LOCATION(E1000_RDT)];
    if (!(e1000_rx_desc_array[next].status & E1000_RXD_STAT_DD))
        return -1; // no packet received
    
    *len = e1000_rx_desc_array[next].length;
    memcpy(addr, e1000_rx_packet_buf[next], *len);

    e1000_rx_desc_array[next].status &= ~E1000_RXD_STAT_DD;
    next = (next + 1) % E1000_RX_DESC_ARRAY_SIZE;
    e1000[LOCATION(E1000_RDT)] = (tail + 1) % E1000_RX_DESC_ARRAY_SIZE;
    return 0;
}
int pci_e1000_attach(struct pci_func *pcif) {
    pci_func_enable(pcif);
    e1000 = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]); 
    cprintf("device status:[%08x]\n", e1000[LOCATION(E1000_STATUS)]); 
    e1000_transmit_init();
    e1000_receive_init();
    return 0;
}
