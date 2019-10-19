# Learning Assembly x86_64 in Linux
### Tutorials
I started out with the following youtube series on programming assembly on Linux x86_64:
- [x86_64 Linux Assembly](https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn)

Most of the code here comes from there, so it's a good place to start if you have a Linux x86_64 machine/vm.
As I learn more, I'll get info from other sources too.

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

---

# Registers
[![registers](registers2.png)](https://www.classes.cs.uchicago.edu/archive/2009/spring/22620-1/docs/handout-03.pdf)
![registers](registers.png)
