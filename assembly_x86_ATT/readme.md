# Learning Assembly in x86 (AT&T syntax)
Like many others, I prefer the intel syntax, and I'd much rather learn x86_64 right off the bat, but I found a nice book 
that is in x86 and AT&T syntax... What're ya gonna do?

The book in question is open source, and can be found at: [https://savannah.nongnu.org/projects/pgubook/](https://savannah.nongnu.org/projects/pgubook/)

> I attempted to make an x86 vm, but I had some problems with virtualbox and afterwards, no matter what I tried, I kept getting 
an exec format error. Even though `uname -a` said i386, and the OS was in i386, and I wrote in x86 assembly... ugh. So in the end
I opted to just use emulation in the assembly step

### Running the code on a 64 bit machine
Make a file called `run`
```bash
# create assembled object file (in 32 bit mode)
as --32 ${1}.s -o ${1}.o
# link the object with i386 mode
ld -m elf_i386 -o ${1} ${1}.o
# run program
./${1}
# the book I use starts off with returning data via the exit code, 
# so print this too before executing anything else
echo "Exited with code: $?"
# clean up compiled files
rm ${1}.o ${1}
```
After creating above file, do `chmod +x run`, then make your assembly file like `print.s` (code below).
Finally, you can do `./run print` to compile and run your program (and clean it up afterwards).

### Hello world
 ```asm
.section .data    # hardcoded data section
string:
.string "Hi\n"

.section .text    # code section
.globl _start     # let linker know where to start

_start:                 # start here
  movl $4, %eax         # sys_read
  movl $1, %ebx         # std_in
  movl $string, %ecx    # point to the string to be printed
  movl $3, %edx         # print 3 characters
  int $0x80             # syscall

  movl $1, %eax         # sys_exit
  movl $0, %ebx         # exit code (0 = OK )
  int $0x80             # syscall
```

