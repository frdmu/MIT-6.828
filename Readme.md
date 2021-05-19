# Some bugs:
- :point_right:For GCC 7 or later, after switching to lab3 branch an error like ```kernel panic at kern/pmap.c:147: PADDR called with invalid kva 00000000``` will occur.
  This is a bug caused by the linker script, modify kern/kernel.ld as follow will fix it.
>>https://github.com/frdmu/MIT-6.828/commit/56516630e75f93acaa93424b6c4e3821e5fafeed
  
- :point_right:If you have any problem when ```make```, maybe you can try ```make clean``` first!
 
# Website: 
1. https://www.cs.hmc.edu/~rhodes/courses/cs134/sp19/schedule.html  
2. https://pdos.csail.mit.edu/6.828/2011/schedule.html
# Directory structure description：
- JOS source code in ```code``` directory
- xv6 source code in ```HW3:xv6_system_calls``` directory
# Command:
1. grading your answer
- $ ```make grade```
3. build JOS/xv6
- $ ```make clean```
- $ ```make```
5. start virtual machine
- $ ```make qemu```
6. debug:
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
- HW8 Optional challenges
- lab4 challenge
