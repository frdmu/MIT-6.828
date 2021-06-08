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
        e1000_tx_desc_array[i].status = E1000_TXD_STAT_DD;
    }
    
    e1000[LOCATION(E1000_TDBAL)] = PADDR(e1000_tx_desc_array);
    e1000[LOCATION(E1000_TDLEN)] = sizeof(struct e1000_tx_desc) * E1000_TX_DESC_ARRAY_SIZE;
    e1000[LOCATION(E1000_TDH)] = 0;
    e1000[LOCATION(E1000_TDT)] = 0;
    e1000[LOCATION(E1000_TCTL)] = E1000_TCTL_EN | E1000_TCTL_PSP | (E1000_TCTL_CT & (0x10 << 4)) | (E1000_TCTL_COLD & (0x40 << 12));
    e1000[LOCATION(E1000_TIPG)] = 10 | (4 << 10) | (6 << 20);
}
int 
pci_e1000_attach(struct pci_func *pcif) {
    pci_func_enable(pcif);
    e1000 = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]); 
    cprintf("device status:[%08x]\n", e1000[LOCATION(E1000_STATUS)]); 
    e1000_transmit_init();
    return 0;
}
