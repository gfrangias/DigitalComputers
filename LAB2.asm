.data
	
	firstIntMsg: .asciiz "Enter 1st integer: "     
	opCharMsg: .asciiz "Enter operation symbol: "   
    	secondIntMsg: .asciiz "\nEnter 2nd integer: "
    	wrongChar: .asciiz "You have entered an inappropriate operation character!"
    	resultMsg: .asciiz "The result is: "
   	
    	firstInt: .word 0
    	opChar: .asciiz ""
    	secondInt: .word 0
    	result: .word 0
    
.text

main:
		la $a0, firstIntMsg			#Load and print string asking for the first integer
		li $v0, 4
		syscall
	
		li $v0, 5				#Take user input for the first integer
		syscall
		sw $v0, firstInt
	
		la $a0, opCharMsg			#Load and print string asking for the operation character
		li $v0, 4
		syscall
	
		li $v0,12				#Take user input for the operation character
		syscall
		sw $v0, opChar
	
		la $a0, secondIntMsg			#Load and print string asking for the second integer
		li $v0, 4
		syscall
	
		li $v0, 5				#Take user input for the second integer
		syscall
		sw $v0, secondInt
		
		lb $s1, firstInt			#Load the first integer in s1
		lb $s0, opChar				#Load the operation character in s0
		lb $s2, secondInt			#Load the second integer in s2

		beq $s0, 0x0000002b, addition		#+	#If the given character belongs to an operation...
		beq $s0, 0x0000002d, subtraction	#-	#...branch to that operation 
		beq $s0, 0x0000002a, multiplication	#*
		beq $s0, 0x0000002f, division		#/

		la $a0, wrongChar			#Load and print string for wrong operation character
		li $v0, 4
		syscall	
		j exit	
	
addition:	add $s1, $s1, $s2			#Adding the two integers
		j print
		
subtraction:	sub $s1, $s1, $s2			#Subtracting the two integers
		j print
		
multiplication: mul $s1, $s1, $s2			#Multipling the two integers
		j print
		
division: 	div $s1, $s1, $s2			#Dividing the two integers
		j print
	
print:		la $a0, resultMsg			#Load and print string "The result is: "
		li $v0, 4
		syscall
		li $v0, 1				#Print the integer result 
		move $a0,$s1
		syscall
	
exit: 		li $v0, 10				#End program 
		syscall
	
