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

### Functions
> I've skipped some steps between hello world and this example. Most importantly the usage of labels, `cmp`,
and conditional jumps. I might add these steps in later, but most introductionary tutorials on assembly will cover these.
Se my [x86_64 tutorial](https://github.com/dwrolvink/Linux/tree/master/assembly_x86_64) for more low-level examples (in 64 bit), or read the first few chapters of the book listed above to stay in the 32 bit mindset.

In this example I show how to use a function, and pass the arguments using the stack. The function will compute y = $1 ^ $2 (raise int1 by the power of int2). The answer is stored in %eax. For a simple function like this, you could just put int1 into %eax and int2 into $ebx, but then we wouldn't learn anything =]

At this point, go and read the example: [power.s](https://github.com/dwrolvink/Linux/blob/master/assembly_x86_ATT/examples/functions.s), and try to follow what happens to the stack and what use the 
base pointer has; how the arguments are passed, and how they are cleaned up afterwards. That will make the next part easier to follow.

To use the stack effectively, we make use of the **base pointer**. This allows us to have an anchor to point in the stack,
without having it move around as we do push and pop, like the stack pointer does (yes, you read that right, the record doesn't have to be on the top of the stack to be able to read it, everyone lied to you). 

We *could* use the stack pointer, if we do some math, but then if we change any code we'll have to redo all that math all over again.

Notice how we save the old base pointer before overwriting it. This is so that at the end of the function, everything will be as we left it before calling the function (except for the standard registers %eax, %ebx, etc). 

