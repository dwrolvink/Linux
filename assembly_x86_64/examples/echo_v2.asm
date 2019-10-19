; Code written for: Linux x86_64
; Tutorial: https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn

section .bss
    name resb 16  ; reserve 16 bytes for $name
    
section .data
	; script data
	text_query db "What is your name?: ",0
	text_hello db "Hello ",0

	; lib data
	ClearTerm db   27,"[H",27,"[2J",0    ; <ESC> [H <ESC> [2J ; needed for cls()
    
section .text
	global _start
    
_start:
	call cls				; clearscreen
	mov rax, text_query 	; ask for name
	call print

	call _getName			; readln
	call cls				; clearscreen
	
	mov rax, text_hello		; print hello
	call print
	mov rax, name			; print name
	call print

	call exit				; exit program

; script subroutines 
; ----------------------------------------------
_getName:
	mov rsi, name   ; store input into $name
	mov rdx, 16     ; number of bytes to read in
	call _read
	ret

; standard subroutines
; ----------------------------------------------

; exit program
exit:
	MOV RAX, 60
	MOV RDI, 0
	syscall    

; sys_read
; call by: - put .bss buffer into rsi; - put length into rdx
_read:
	mov rax, 0      ; sys_read
	mov rdi, 0      ; standard_input
	syscall
	ret

; prints string to standard_output
; call by putting a string into rax
print:
	push rax 			; push string ref to the stack
	mov rbx, 0			; $count = 0
__print_loop:
	inc rax				; $i++, $i-> $string[$i]
	inc rbx				; $count++
	mov cl, [rax]   	; move 8 bit (one ASCII char) into cl
	cmp cl, 0			; (char == $null)
	jne __print_loop 	; else

	mov rax, 1     	 	; sys_write
    mov rdi, 1      	; standard_output
	pop rsi 			; pop string ref to rsi
    mov rdx, rbx		; put count in place for syscall
	syscall
	ret

; Clear screen
cls:
	mov rax, ClearTerm
	call print
	ret




