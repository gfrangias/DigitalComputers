.data

	operationMsg: .asciiz "\nPlease enter N to enter a number, or Q to quit: \n"
	numberMsg: .asciiz "\nPlease enter a number in the range 0-24: \n"
	resultMsg: .asciiz "\nThe Fibonacci number F   is "
	.align 2
	operationInput: .word 1
	.align 2

.text 

main:	
		jal UserOperation
		move $s0, $v0
		beq $s0, 'N', UserNumber
		beq $s0, 'Q', Exit
		j main
	
	UserOperation:	
			la $a0, operationMsg	
			li $v0, 4			
			syscall
			li $v0, 12			
			syscall
			jr $ra
	
	UserNumber:
			la $a0, numberMsg	
			li $v0, 4			
			syscall
			li $v0, 5			
			syscall
			move $t0, $v0
			blt $t0, 0, UserNumber
			bgt $t0, 24, UserNumber
			move $v0, $t0
			jal FiboStart
			j main
			
	FiboStart:	
			li $t3, 0
			move $t0, $v0
			move $t2, $v0
			ble $t0, 1, FirstTerms
			subi $t0, $t0, 1
			li $t1, 12
			mul $t0, $t0, $t1
			sub $sp, $sp, $t0
			sw $ra, 0($sp)
			li $t1, 0
			sw $t1, 4($sp)
			li $t1, 1
			sw $t1, 8($sp)
			subi $t2, $t2, 2
			
	Fibo:		beq $t3, $t2, FiboEnd
			lw $ra, 0($sp)
			sw $ra, 12($sp)
			lw $t0, 4($sp)
			lw $t1, 8($sp)
			sw $t1, 16($sp)
			add $t0, $t0, $t1
			sw $t0, 20($sp)
			addi $sp, $sp, 12
			addi $t3, $t3, 1
			jal Fibo
			
	FiboEnd:
			lw $ra, 0($sp)
			lw $t0, 4($sp)
			lw $t1, 8($sp)
			addi $sp, $sp, 12
			add $t0, $t0, $t1
			addi $t2, $t2, 2
	FirstTerms:	la $t3, resultMsg
			bge $t2, 20, twenties
			bge $t2, 10, tenties
			addi $t2, $t2, 48
			sb $t2, 23($t3)			
			la $a0, resultMsg
			li $v0, 4
			syscall
			li $v0, 1
			move $a0, $t0
			syscall
			li $t1, 0x00000000
			sb $t1, 23($t3)
			jr $ra	
				
			twenties: 
					li $t1, 0x00000032
					sb $t1, 23($t3)
					addi $t2, $t2, 28
					sb $t2, 24($t3)
					j print1
					
			tenties: 
					li $t1, 0x00000031
					sb $t1, 23($t3)
					addi $t2, $t2, 38
					sb $t2, 24($t3)
					j print1
			
			print1:		
					la $a0, resultMsg
					li $v0, 4
					syscall
					li $v0, 1
					move $a0, $t0
					syscall
					li $t1, 0
					sb $t1, 23($t3)
					sb $t1, 24($t3)
					jr $ra
								
Exit:		
	li $v0, 10	#exit program	
	syscall
		
