# Learning Assembly x86_64 (NASM) in Linux
### Tutorials
I started out with the following youtube series on programming assembly on Linux x86_64:
- [x86_64 Linux Assembly](https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn)

Most of the code here comes from there, so it's a good place to start if you have a Linux x86_64 machine/vm.
As I learn more, I'll get info from other sources too.

All the code here is written in the Intel dialect, and has NASM specific code, so it has to be compiled using NASM.

# System calls
[System calls](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)

| action | rax | rdi | rsi | rdx | r10 | r8 | r9 |
| :----- | :-- | :-- | :-- | :-- | :-- | :- | :- |
| echo     | `sys_write` 1  | `standard_output` 1  | `buffer` ADDR | `str length` (int) | | | | |
| readline | `sys_read` 0   | `standard_input` 0   | | |  | | | |
| exit     | `sys_exit` 60  | `error_code` 0       | | |  | | | |



# Examples
### Run asm code
Create a file so that we can easily run programs from a given .asm file input by doing `./run programname`. 
[Create assembly compile script](code/run.md)

### Hello World
Write "Hello World" to the console. [hello.asm](examples/hello.asm)

### Echo
Get string from standard input using sys_read, then output it using sys_write: [echo.asm](examples/echo.asm)

### A better Echo
Using more advanced techniques, we can create standard subroutines to simplify our work: [echo_v2.asm](examples/echo_v2.asm)

### A cleaner Echo
At this point, we've written a lot of code that we might want to reuse in a different project. Using the `%include` statement and macros, we put all the code that we want to reuse in a different file, `lib/linux64.inc`. All the variables that we want to reuse are put into `lib/std_data.inc`.

The following part of kupala's tutorial explains the use of macros/include: [Macros & Include](https://www.youtube.com/watch?v=mRTax0MLaok&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn&index=8&t=0s)

Our code can be found here: [Include & Macro example](examples/include)

# Sections
The data segment is read-write, since the values of variables can be altered at run time. This is in contrast to the read-only data segment (rodata segment or .rodata), which contains static constants rather than variables; it also contrasts to the code segment, also known as the text segment, which is read-only on many architectures. Uninitialized data, both variables and constants, is instead in the BSS segment. [source](https://en.wikipedia.org/wiki/Data_segment)


---

# Registers
[![registers](registers2.png)](https://www.classes.cs.uchicago.edu/archive/2009/spring/22620-1/docs/handout-03.pdf)
![registers](registers.png)
