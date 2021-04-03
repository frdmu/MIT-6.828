# Problem:
- :point_right:For GCC 7 or later, after switching to lab3 branch an error like ```kernel panic at kern/pmap.c:147: PADDR called with invalid kva 00000000``` will occur.
  This is a bug caused by the linker script, modify kern/kernel.ld as follow will fix it.
  https://github.com/frdmu/MIT-6.828/commit/56516630e75f93acaa93424b6c4e3821e5fafeed
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
- one terminal$ ```make qemu-gdb``` 
- another terminal$ ```make gdb```
# Refer: 
1. https://github.com/clann24/jos  
2. https://github.com/SmallPond/MIT6.828_OS
3. https://github.com/hehao98/MIT6.828Labs-JOS
4. https://123xzy.github.io/2019/03/08/MIT-6-828-Operating-System-Engineering

# Undone:
- lab2 challenge
- HW5 Optional challenges
- lab3 challenge1(assembly macros)
- lab3 exercise 7: ```testbss``` can not pass ```make grade```
- lab3 challenge3

