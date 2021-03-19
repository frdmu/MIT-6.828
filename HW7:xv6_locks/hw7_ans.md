# Don't do this
 - A: Look up accquire() function in spinlock.c, we can see that once current cpu try to hold the same lock again when the lock has been acquired, kernel will panic.

# Interrupts in ide.c
 - A: Actually, we can guess that when something happening between memory and disk, an interrupt happened, and trigger the interrupt handler ideintr(), and we can find that the first thing be done in ideintr() is acquire(&idelock). But as we know that the same lock can't be acquired twice by cpu in a unicore environment before it was released, otherwise the kernel will panic as we have seen in our experiment.

# Interrupts in file.c
 - A: Maybe there is no corresponding interrupt handler to compete for file_table_lock.

# xv6 lock implementation
 - A: Considering such a case, if thread A first clears lk->locked, and then thread B acquire this lock, and B then set lk->pcs[0] and lk->cpu, finally A clears lk->pcs[0] and lk->cpu. The result is B's setup is cleared!
