	# Edit note: I've added the stack after each operation that influences it, so that
	# you can track how it changes and where all the data is.

	# PURPOSE:  Program to illustrate how functions work
	#          This program will compute the value of
	#          2^3
	# 

	# Everything in the main program is stored in registers,
	# so the data section doesn't have anything.
	.section .data 

	.section .text

	.globl _start
_start:

	# stack:
	# %esp: 104 
	# 100-96: [empty]

	# Given that 100 is the highest memory location possible for the stack. Notice it points
	# to a non-existent location, the push command will increment %esp by four and then write to 
	# the new location (100)

	pushl $3                  # push second argument
	pushl $2                  # push first argument

	# stack:
	# 100-96: $3
	# 96-92:  $2 ; %esp: 96

	call  power               # call the function (this will put the return address on the stack)

	# stack (as returned from power() ):
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument);  %esp: 96; %ebp = old %ebp
	# 92-88: return address; [DEAD SPACE]          
	# 88-84: stack reference (%ebp) [DEAD SPACE]	
	# 84-80: $8 (result) [DEAD SPACE]		

	addl  $8, %esp            # move the stack pointer back
	# stack:
	# %esp: 104
	# 100-96: $3 (second argument) [DEAD SPACE]   
	# 96-92:  $2 (first argument) [DEAD SPACE]     
	# 92-88: return address; [DEAD SPACE]          
	# 88-84: stack reference (%ebp) [DEAD SPACE]	
	# 84-80: $8 (result) [DEAD SPACE]

	movl %eax, %ebx			  # put result of the power function in %ebp 
							  # this should be 2^3 = 8
	movl  $1, %eax            # exit (%ebx is returned)
	int   $0x80

	# PURPOSE:  This function is used to compute
	#          the value of a number raised to
	#          a power.
	# 
	# INPUT:    First argument - the base number
	#          Second argument - the power to 
	#                            raise it to
	# 
	# OUTPUT:   Will give the result as a return value in %eax
	# 
	# NOTES:    The power must be 1 or greater
	# 
	# VARIABLES: 
	#          %ebx - holds the base number
	#          %ecx - holds the power
	# 
	#          -4(%ebp) - holds the current result
	# 
	#          %eax is used for temporary storage
	# 
	.type power, @function
power:
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address; %esp: 92
	
	pushl %ebp           # save old base pointer
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address
	# 88-84: stack reference (%ebp); %esp: 88	
	
	movl  %esp, %ebp     # make stack pointer the base pointer
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address
	# 88-84: stack reference (old %ebp); %esp: 88; %ebp: 88	
	
	subl  $4, %esp       # get room for our local storage
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address
	# 88-84: stack reference (%ebp)
	# 84-80: [empty] (result); %esp: 84; %ebp: 88		
	
	movl  8(%ebp), %ebx  # %ebp+8 = 96 --> %ebx = $2 (first argument)
	movl  12(%ebp), %ecx # %ebp+12 = 100 --> %ebx = $3 (second argument)

	movl  %ebx, -4(%ebp) # $ebp-4 = 84 --> [84] = $2
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address
	# 88-84: stack reference (%ebp)
	# 84-80: $2 (result);  %esp: 84; %ebp: 88	
	
power_loop_start:
	cmpl  $1, %ecx       # if the power is 1, we are done
						 # %ecx will go from $3 to $2 to $1
	je    end_power
	movl  -4(%ebp), %eax # -4(%ebp) will go from $2 to $4 to $8
	imull %ebx, %eax     # multiply the current result by
	                     # the base number
	movl  %eax, -4(%ebp) # store the current result 

	decl  %ecx           # decrease the power
	jmp   power_loop_start # run for the next power

end_power:
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address
	# 88-84: stack reference (%ebp)
	# 84-80: $8 (result);  %esp: 84; %ebp: 88
	
	movl -4(%ebp), %eax  # return value goes in %eax (= $8)
	movl %ebp, %esp      # restore the stack pointer
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address
	# 88-84: stack reference (%ebp);  %esp: 88; %ebp: 88	
	# 84-80: $8 (result) [DEAD SPACE]
	
	popl %ebp            # restore the base pointer
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument)
	# 92-88: return address;          %esp: 92; %ebp = old %ebp
	# 88-84: stack reference (%ebp) [DEAD SPACE]	
	# 84-80: $8 (result) [DEAD SPACE]	
	
	ret
	
	# stack:
	# 100-96: $3 (second argument)
	# 96-92:  $2 (first argument);  %esp: 96; %ebp = old %ebp
	# 92-88: return address; [DEAD SPACE]          
	# 88-84: stack reference (%ebp) [DEAD SPACE]	
	# 84-80: $8 (result) [DEAD SPACE]		
