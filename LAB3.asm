##############################################################
# ---Program for the third labratory of Digital Computers---
#
#Operarion:
# The program takes a string of max 100 bytes from user input.
# User input ends with a new line (\n).
# The given string is processed so that:
# 1)uppercase letters are turned to lowercase
# 2)any none alphanumeric characters are deleted
# 3)multiple space characters turn to a single one
# The new processed string is printed on the console.
#
#Developed by:
#George Ramiotis
#George Frangias
#
#Version 1.3
##############################################################

.data
	inputMsg: .asciiz "Please Enter your String: "
	outputMsg: .asciiz "The Processed String is: "
	.align 2
	userString: .space 100
	.align 2
	processedString: .space 100
	
.text

main:
		jal Get_Input
		jal Process
		jal Print_Output
		j Exit

############################################################
#		---Subroutine Get_Input---
#
#Operation:
# Prints on console the message:"Please Enter your String: "
# Loads byte space in adress and saves the user input in $a2
############################################################

Get_Input:	la $a0, inputMsg
		li $v0, 4
		syscall
		
		li $v0, 8      
   		la $a0, userString 
    		li $a1, 100
    		
    		move $s0, $a0
    		la $t0, ($s0)
    		syscall
		
    		jr $ra
    		
##################################################################
#		---Subroutine Process---
#
#Operation:
#see the whole program's operation on line 4
#Registers in use:
#$t0= Input string is stored
#$t1= The words of the input string are strored in it one-by-one
#$t2= The first byte of every word is stored in it one-by-one 
#$t3= Memory address pointer for in-word bytes 
#$t4= Checks if the last byte was a non-alphanumerical character
##################################################################   		
Process:
    			la $s1, processedString
	newWord:	
    			lw $t1, 0($t0)
    			j loop
    	loop:		andi $t2,$t1, 0x000000ff
    			beq $t2, 0x0000000a, exitProcess
    			blt $t2, 0x00000041, saveNumbers
    			bgt $t2, 0x0000005a, saveLetters
    			addi $t2, $t2, 32
    			j saveByte
    	wordCount:	addi $t0, $t0, 4
    			li $t3, 0
    			j newWord
    	saveNumbers:  	blt $t2, 0x00000030,nonAlphanumeric
    			bgt $t2, 0x00000039,nonAlphanumeric
    			j saveByte
    	saveLetters:  	blt $t2,0x00000061,nonAlphanumeric
    			bgt $t2,0x0000007a,nonAlphanumeric
    			j saveByte
    	nonAlphanumeric:beq $t4, 1, saveSpaceChar
    			li $t2, 0x00000020
    			sb $t2, 0($s1)
    			srl $t1,$t1, 8 
    			beq $t3, 4 , wordCount 
    			addi $t3, $t3, 1
    			addi $s1, $s1, 1
    			li $t4, 1
    			j loop
	saveSpaceChar:	srl $t1,$t1, 8 
    			beq $t3, 4 , wordCount 
    			addi $t3, $t3, 1
    			j loop
	saveByte:	sb $t2, 0($s1)
    			srl $t1,$t1, 8
			beq $t3, 4 , wordCount
    			addi $t3, $t3, 1
    			addi $s1, $s1, 1
    			li $t4, 0
    			j loop
    	exitProcess:	jr $ra
    	
#############################################################
#	      ---Subroutine Print_Output---
#
#Operation:
# Prints on console the message:"The Processed String is: "
# Points on $a3 where the processed string is stored with
# using the primmary $a0
# Prints the processed string
#############################################################
    		    		
Print_Output:	la $a0, outputMsg
		li $v0, 4
		syscall
		
		la $a0, processedString
		li $v0, 4
		syscall
		jr $ra
		
Exit:		li $v0, 10
		syscall