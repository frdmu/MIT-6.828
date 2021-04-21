## There are three things most important in process:
- address space
- context
- program

## How user process implement system calls in JOS?
- ```lib/syscall.c``` through ```int $30``` trap into kernel
- get interrupt descriptor gate in ```kern/trap.c: trap_init()``` 
- get trapframe:tf in ```kern/trapentry.S ``` and then call ```kern/trap.c: trap(tf)```
- call ```kern/trap.c: trap_dispatch(tf)```
- in ```trap_dispatch(tf)```, call ```syscall()```
- after ```syscall()``` return, ```env_run(curenv)``` or ```sched_yield()``` return from kernel to user process
- done 

## How user process deal with page fault in JOS?
- user process ```lib/pgfault.c: set_pgfault_handler(handler)```, just like ```user/faultdie.c``` has done. 
- when page fault occurs, user process traps into kernel through page fault interrupt, we also get interrupt descriptor gate in ```kern/trap.c: trap_init()``` 
- get trapframe:tf in ```kern/trapentry.S ``` and then call ```kern/trap.c: trap(tf)```
- call ```kern/trap.c: trap_dispatch(tf)```
- in ```trap_dispatch(tf)```, call ```page_fault_handler(tf)```
- then ```lib/pfentry.S: _pgfault_upcall``` and run ```_pgfault_handler```
- done
