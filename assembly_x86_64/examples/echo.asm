; Code written for: Linux x86_64
; Tutorial: https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn

section .bss
    name resb 16  ; reserve 16 bytes for $name
    
section .data
    hello db "Hello "
    query db "What is your name?: "
    
section .text
    global _start
    
_start:
    call _printQuery
    call _getName
    call _printHello
    call _printName
    
    ; exit program
    MOV RAX, 60
    MOV RDI, 0
    syscall    
    
_getName:
    mov rax, 0      ; sys_read
    mov rdi, 0      ; standard_input
    mov rsi, name   ; store input into $name
    mov rdx, 16     ; number of bytes
    syscall
    ret
_printQuery:
    mov rax, 1      ; sys_write
    mov rdi, 1      ; standard_output
    mov rsi, query  ; stored string
    mov rdx, 20     ; length of string
    syscall
    ret       
_printName:
    mov rax, 1      ; sys_write
    mov rdi, 1      ; standard_output
    mov rsi, name   ; stored string
    mov rdx, 16     ; length of string
    syscall
    ret   
_printHello:
    mov rax, 1      ; sys_write
    mov rdi, 1      ; standard_output
    mov rsi, hello  ; stored string
    mov rdx, 6      ; length of string
    syscall
    ret   
```
