# Some bugs:
- :point_right:For GCC 7 or later, after switching to lab3 branch an error like ```kernel panic at kern/pmap.c:147: PADDR called with invalid kva 00000000``` will occur.
  This is a bug caused by the linker script, modify kern/kernel.ld as follow will fix it.
>>https://github.com/frdmu/MIT-6.828/commit/56516630e75f93acaa93424b6c4e3821e5fafeed
  
- :point_right:Before I plan to do HW8, I start the xv6 by typing ```make qemu``` firstly, but the results show that:
```
  alarmtest.o: In function `main':
  MIT-6.828/HW3:xv6_system_calls/xv6/alarmtest.c:12: undefined reference to `alarm'
  Makefile:149: recipe for target '_alarmtest' failed
  make: **** [_alarmtest] Error 1
```
>>Solution: open alarmtest.c, user.h, syscall.h, usys.S respectively and then just save them once again, after doing this, the problem is solved.
 
# Website: 
1. https://www.cs.hmc.edu/~rhodes/courses/cs134/sp19/schedule.html  
2. https://pdos.csail.mit.edu/6.828/2011/schedule.html
# Command:
1. grade
- $ ```make grade```
3. build JOS
- $ ```make```
4. start virtual machine
- $ ```make qemu```
5. debug:
- one terminal $ ```make qemu-gdb``` 
- another terminal $ ```make gdb```
# Refer: 
1. https://github.com/clann24/jos  
2. https://github.com/SmallPond/MIT6.828_OS
3. https://github.com/hehao98/MIT6.828Labs-JOS
4. https://123xzy.github.io/2019/03/08/MIT-6-828-Operating-System-Engineering

# Undone:
- lab2 challenge
- HW5 Optional challenges
- lab3 challenge1(assembly macros)
- lab3 challenge3

