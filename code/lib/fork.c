// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

extern void _pgfault_upcall(void);
// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;
	envid_t envid = sys_getenvid();

	// Check that 
	// (1) the fault is a write(check for FEC_WR in the error code)
	// (2) the PTE for the page is marked PTE_COW
	// If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
		panic("Fault is not a write or the PTE for page is not marked PTE_COW");

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, (void*)PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_alloc: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, addr, PGSIZE);
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_map: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
	// panic("pgfault not implemented");
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	// LAB 4: Your code here.
	uintptr_t va = pn * PGSIZE;	
    if (uvpt[pn] & PTE_SHARE) {
		if ((r = sys_page_map(thisenv->env_id, (void*)va, envid, (void*)va, uvpt[pn]&PTE_SYSCALL)) < 0)
			return r;
    }	
	// if the page is writable or copy-on-write
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
		// child
		if ((r = sys_page_map(thisenv->env_id, (void*)va, envid, (void*)va, PTE_P|PTE_U|PTE_COW)) < 0)
			return r;
		// parent
		if ((r = sys_page_map(thisenv->env_id, (void*)va, thisenv->env_id, (void*)va, PTE_P|PTE_U|PTE_COW)) < 0)
			return r;
	} else {
	
		if ((r = sys_page_map(thisenv->env_id, (void*)va, envid, (void*)va, PTE_P|PTE_U)) < 0)
			return r;
	}
	
	//panic("duppage not implemented");
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t pn;	
	int r;

	// set up our page fault handler appropriately
	set_pgfault_handler(pgfault);	

	// create a child
	envid = sys_exofork();
	if (envid == 0) { 
		// child
		thisenv = &envs[ENVX(sys_getenvid())];	
		return 0;
	}
	// parent
	// copy parent's user address space to the child
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); pn++) {
		// pn = i * 1024 + j, i(0~1024): PDX, j(0~1024): PTX
		// so pn >> 10 equals to i	
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P)) {
			// page table entrys <---> virtual address space pages
			if ((r = duppage(envid, pn)) < 0)	
				return r;
		}	
	}

	// allocate a new page for the child's user exception stack
	if ((r = sys_page_alloc(envid, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P)) < 0)	
		return r;
	// set page fault handler to the child
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)	
		return r;	
	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
		return r;
	
	return envid;
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
