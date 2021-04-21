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
 
