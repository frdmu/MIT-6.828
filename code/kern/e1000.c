#include <kern/e1000.h>
#include <kern/pmap.h>
#include <kern/pci.h>
// LAB 6: Your driver code here
int 
pci_e1000_attach(struct pci_func *pcif) {
    pci_func_enable(pcif);
    e1000 = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]); 
    cprintf("device status:[%08x]\n", e1000[2]); 
    return 0;
}
