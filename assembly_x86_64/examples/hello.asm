; Code written for: Linux x86_64
; Tutorial: https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn

section .data
    text1 db "Hello World",10  ; ,10 = \n

section .text
    global _start
  
_start:
    CALL _print_hello

    ; exit program
    MOV RAX, 60
    MOV RDI, 0
    syscall
  
_print_hello:
    MOV RAX, 1      ; sys_write
    MOV RDI, 1      ; standard_output
    MOV RSI, text1  ; stored string
    MOV RDX, 12     ; length of string
    RET
