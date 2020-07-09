##########################################################
#        ---Program for the fourth laboratory of Digital Computers---
#-------------------------------------------------------------------------------------
#This program is a phonebook with storage for 10 entries (600 bytes)
#-------------------------------------------------------------------------------------
#
#Operarions:
#The program has 2 main operations:
#
#a. Create a new entry in the phonebook
#Every entry has a 60 bytes storage and it contains 3 fields of
#20 bytes each(last name, first name, phone number)
#
#b. Print the content of an already saved entry
#The user can enter the index of an entry and get its contents
#
#Developed by:
#George Ramiotis
#George Frangias
#
#Version 1.3
##########################################################

.data

	operationMsg: .asciiz "Please determine operation, entry(E), inquiry(I), or quit(Q): \n"
	firstNameMsg: .asciiz "Please enter first name: \n"
	lastNameMsg: .asciiz "\nPlease enter last name: \n"
	phoneNumberMsg: .asciiz "Please enter phone number: \n"
	entryMsg: .asciiz "Thank you the new entry is the following: \n"
	retrievalMsg: .asciiz "\nPlease enter the entry number you want to retrieve: \n"
	errorMsg: .asciiz "There is no such entry in the phonebook!\n"
	numberMsg: .asciiz "The number is: \n"
	.align 2
	operationInput: .word 1 
	.align 2
	phonebook: .space 600
	.align 2
	outputString1: .space 63
	.align 2
	outputString2: .space 63
	
.text

main:
	la $s0, phonebook	#set $s0 as a pointer in the start of label phonebook
	move $s1, $s0	#set $s1 as a pointer to $s0
	move $s3, $s0	#set $s3 as a pointer to $s0
	
newOperation:	
	jal Prompt_User		#jump and link in Prompt_User		
    	move $s2, $v0		#set $s1 as a pointer to $v0
	beq $s2, 'E', Get_Entry	#if user input is 'E'
	beq $s2, 'I', Print_Entry	#if user input is 'I'
	beq $s2, 'Q', Exit		#if user input is 'Q'
	
	########################################################
	#-------------------------Subroutine Prompt_User---------------------------------
	#It gets user input for the main menu
	#$v0->user input is stored in it and it is the output of the subroutine
	########################################################
	Prompt_User:
		la $a0, operationMsg	#load operation message
		li $v0, 4			#print the message
		syscall
		li $v0, 12			#store the given character in $v0
    		syscall
		jr $ra

	#########################################################
	#--------------------------Subroutine Get_Entry-----------------------------------
	#Operation:
	#It creates a new entry in phonebook
	#Registers in use:
	#$s1->it points to the start of the next new entry
	#$s3->it is used to store the given strings byte-by-byte
	#         it points to the next empty byte of phonebook
	#$s4->it counts the number of already saved entries
	#########################################################
	Get_Entry:
		beq $s4, 10, newOperation	#if there are already 10 saved entries
		jal StoreLastName		#jump and link in StoreLastName
		addi $s3, $s3, 20
		jal StoreFirstName		#jump and link in StoreFirstName
		addi $s3, $s3, 20
		jal StoreNumber		#jump and link in StoreNumber
		addi $s3, $s3, 20
		addi $s4, $s4, 1		#increase $s4 by 1
		move $s3, $s1		#$s3 points to $s1
		jal CreateString		#jump and link in CreateString
		move $s1, $s3		#$s1 points to $s3
		j newOperation		#jump in newOperation
	   	
		##############################
		#---------Subroutine StoreLastName----------
		#Operation:
		#It gets the last name string from the user
		#$a0->it stores the string in phonebook
		##############################
    		StoreLastName:
    			la $a0, lastNameMsg	#load last name message
    			li $v0, 4			#print the message
			syscall
			li $v0, 8 			#get the given string     
   			la $a0, ($s3)		#store the given string in phonebook field
  			li $a1, 20
    			syscall
    			jr $ra

    		##############################
		#---------Subroutine StoreFirstName----------
		#Operation:
		#It gets the first name string from the user
		#$a0->it stores the string in phonebook
		##############################		
    		StoreFirstName:
			la $a0, firstNameMsg	#load first name message
			li $v0, 4			#print the message
			syscall
			li $v0, 8 			#get the given string        
   			la $a0, ($s3)		#store the given string in phonebook field
    			li $a1, 20
    			move $t0, $a0		#store the string in $t0
    			syscall
			jr $ra
    	
		######################################
		#-------------Subroutine StoreNumber--------------
		#Operation:
		#It gets the phone number string from the user
		#$a0->it stores the string in phonebook
		######################################
    		StoreNumber:
    			la $a0, phoneNumberMsg	#load last name message
    			li $v0, 4			#print the message
			syscall
			li $v0, 8 			#get the given string        
   			la $a0, ($s3) 		#store the given string in phonebook field
    			li $a1, 20
    			syscall
    			jr $ra

		######################################################################
		#----------------------------------------Subroutine CreateString-------------------------------------------
		#Operation:
		#It creates and prints a string for the new entry of this format:
		#x. lastName firstName phoneNumber
		#Where x is the index of the new entry
		#It then clears the outputString1 label with clearance2:
		#Registers in use:
		#$s3->it is used to get the new entry word-by-word
		#$t2->it is used to store the new string 
		#$t3->the words of the new entry are stored in it
		#$t4->the byte produced by the mask is stored in it
		#         it is also used to store immediate "." and " " characters in the new string
		#$t5->iterator used to check if a word change is needed
		#$t6->iterator used to stop adding bytes in the new string when 60 are already stored
		######################################################################
		CreateString: 	
       			la $a0, entryMsg		#load the entry message
			li $v0, 4			#print the message
			syscall		
			li $t2, 0			#initialize $t2, $t3, $t4, $t5, $t6 to 0			
       			li $t3, 0
			li $t4, 0		
			li $t5, 0  
			li $t6, 0     			
       			la $t2, outputString1	#load  the memory address of outputString1 in $t2
       			beq $s4, 10, tenth2		#if this is the tenth entry
			addi $t4, $s4, 48		#increase $s4 by 48 to get the ascii byte of the entry number and store it in $t4
       			sb $t4, 0($t2)		#store $t4 in $t2
       			li $t4, 0x0000002e		#store "." in 1($t2)
       			sb $t4, 1($t2)		
       			li $t4, 0x00000020		#store " " in 2($t2)
       			sb $t4, 2($t2)
       			addi $t2, $t2, 3		#increase $t2 by 3
       			j newWord2
       			tenth2:
 				li $t4, 0x00000031			#store "1" in $t2
 				sb $t4, 0($t2)			
 				li $t4, 0x00000030			#store "0" in 1($t2)
 				sb $t4, 1($t2)
 				li $t4, 0x0000002e			#store "." in 2($t2)
       				sb $t4, 2($t2)
       				li $t4, 0x00000020			#store " " in 3($t2)
       				sb $t4, 3($t2)
       				addi $t2, $t2, 4			#increase $t2 by 4
       			
       			newWord2:
       				lw $t3, 0($s3)			#load word from $s3 to $t3
       			loop2:	
       				addi $t6, $t6, 1			#increase $t6 by 1
       				beq $t6, 64, printNewEntry2		#if $t6 is 64 exit
       				andi $t4, $t3, 0x000000ff 		#using a mask select the first byte of the word
       				beq $t4, 0x00000000, ifNull2		#if $t4 is null
       				beq $t4, 0x0000000a, ifNewLine2	#if $t4 is new line
       				sb $t4, 0($t2)			#store the byte from $t4 to $t2
       				srl $t3, $t3, 8			#shift $t3 right by 8 bits
       				addi $t5, $t5, 1			#increase $t5, $t2 by 1
       				addi $t2, $t2, 1
       				beq $t5, 4, wordCount2		#if $t5 is 4 change word
       				j loop2
       			wordCount2:	
       				li $t5, 0				#initialiaze $t5 to 0
       				addi $s3, $s3, 4			#increase $s3 by 4
       				j newWord2	
       			ifNull2:
       				srl $t3, $t3, 8			#shift $t3 right by 8 bits
       				addi $t5, $t5, 1			#increase $t5 by 1
       				beq $t5, 4, wordCount2		#if $t5 is 4 change word
       				j loop2
       			ifNewLine2:	
       				li $t4, 0x00000020			#store " " in $t2
       				sb $t4, 0($t2)			
       				srl $t3, $t3, 8			#shift $t3 right by 8 bits
       				addi $t5, $t5, 1			#increase $t5, $t2 by 1
       				addi $t2, $t2, 1
       				beq $t5, 4, wordCount2		#if $t5 is 4 change word
       				j loop2
       			printNewEntry2:
       				li $t4, 0x0000000a			#store new line in $t2
       				sb $t4, 0($t2)			
       				la $a0, outputString1		#load the outputString1
       				li $v0, 4				#print the string
       				syscall
       				li $t4, 0x00000000			#initialize $t4 to null
       				la $t2, outputString1		#load  the memory address of outputString1 in $t2
       				li $t6, 0
       			clearance2: 
       				beq $t6, 15, return2			#if $t6 is 15 exit
       				sw $t4, 0($t2)			#store the word in $t4 in $t2 
       				addi $t6, $t6, 1			#increase $t6 by 1
       				addi $t2, $t2, 4			#increase $t2 by 4
       				j clearance2
       			return2: 
       				jr $ra
			
######################################################################
#----------------------------------------Subroutine Print_Entry-------------------------------------------
#Operation:
#It takes an integer by the user and then it prints the contents of the 
#entry with such index in this format:
#x. lastName firstName phoneNumber
#Where x is the given integer
#It then clears the outputString2 label with clearance:
#Registers in use:
#$t1->it stores '60' for the immediate multification
#$t2->it is used to store the string 
#$t3->the words of the new entry are stored in it
#$t4->the byte produced by the mask is stored in it
#         it is also used to store immediate "." and " " characters in the new string
#$t5->iterator used to check if a word change is needed
#$t6->iterator used to stop adding bytes in the new string when 60 are already stored
#$t7->it stores the user input integer
#$t8->it is used to get the requested entry word-by-word
#$t9->it is used to store the address of the requested entry in phonebook
######################################################################
Print_Entry:
	li $t1, 0			#initialize $t1, $t7, $t8, $t9 to 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	la $a0, retrievalMsg	#load the retrieval message
	li $v0, 4			#print the message
	syscall
	li $v0, 5			#get the given integer 
	syscall			
	move $t7, $v0		#move the contents of $v0 to $t7
	blt $t7, 1, error
	bgt $t7, $s4, error
	addi $t9, $t7, -1		#subtract 1 by $t7
	li $t1, 60			#initialize $t1 to 60
	mul $t9, $t9, $t1		#multiply $t9 by 60
	move $t8, $s0		#$t8 points to $s0
	add $t8, $t8, $t9 		#increase $t8 by the contents of $t9
       	la $a0,numberMsg		#load number message
	li $v0, 4			#print the message
	syscall
	li $t2, 0			#initialize $t2, $t3, $t4, $t5, $t6 to 0
	li $t3, 0
	li $t4, 0		
	li $t5, 0  
	li $t6, 0     			
      	la $t2, outputString2	#load  the memory address of outputString2 in $t2	
      	beq $t7, 10, tenth		#if this is the tenth entry
	addi $t4, $t7, 48		#increase $t7 by 48 to get the ascii byte of the entry number and store it in $t4
       	sb $t4, 0($t2)		#store $t4 in $t2
       	li $t4, 0x0000002e		#store "." in 1($t2)
       	sb $t4, 1($t2)
       	li $t4, 0x00000020		#store " " in 2($t2)
       	sb $t4, 2($t2)
       	addi $t2, $t2, 3		#increase $t2 by 3
       	j newWord
       	tenth:
 		li $t4, 0x00000031			#store "1" in $t2		
 		sb $t4, 0($t2)
 		li $t4, 0x00000030			#store "0" in 1($t2)
 		sb $t4, 1($t2)
 		li $t4, 0x0000002e			#store "." in 2($t2)
       		sb $t4, 2($t2)
       		li $t4, 0x00000020			#store " " in 3($t2)
       		sb $t4, 3($t2)
       		addi $t2, $t2, 4			#increase $t2 by 4
       	
       	newWord:
       		lw $t3, 0($t8)			#load word from $s3 to $t3
       	loop: 	addi $t6, $t6, 1			#increase $t6 by 1
       		beq $t6, 60, printIt			#if $t6 is 60 exit
       		andi $t4, $t3, 0x000000ff 		#using a mask select the first byte of the word
       		beq $t4, 0x00000000, ifNull		#if $t4 is null
       		beq $t4, 0x0000000a, ifNewLine	#if $t4 is new line
       		sb $t4, 0($t2)			#store the byte from $t4 to $t2
       		srl $t3, $t3, 8			#shift $t3 right by 8 bits
       		addi $t5, $t5, 1			#increase $t5, $t2 by 1
       		addi $t2, $t2, 1
       		beq $t5, 4, wordCount		#if $t5 is 4 change word
       		j loop
       	wordCount:	
       		li $t5, 0				#initialiaze $t5 to 0
       		addi $t8, $t8, 4			#increase $s3 by 4
       		j newWord
       	ifNull:
       		srl $t3, $t3, 8			#shift $t3 right by 8 bits
       		addi $t5, $t5, 1			#increase $t5 by 1
       		beq $t5, 4, wordCount		#if $t5 is 4 change word
       		j loop
       	ifNewLine:
       	       	addi $t6, $t6, 1
       		li $t4, 0x00000020			#store " " in $t2
       		sb $t4, 0($t2)
       		srl $t3, $t3, 8			#shift $t3 right by 8 bits
       		addi $t5, $t5, 1			#increase $t5, $t2 by 1
       		addi $t2, $t2, 1
       		beq $t5, 4, wordCount		#if $t5 is 4 change word
       		j loop
       	printIt:
       		li $t4, 0x0000000a			#store new line in $t2
       		sb $t4, 0($t2)
       		la $a0, outputString2		#load the outputString2
       		li $v0, 4				#print the string
       		syscall
       		li $t4, 0x00000000			#initialize $t4 to null
       		la $t2, outputString2		#load  the memory address of outputString1 in $t2
       		li $t6, 0
       		clearance: 
       			beq $t6, 15, return		#if $t6 is 15 exit
       			sw $t4, 0($t2)		#store the word in $t4 in $t2 
       			addi $t6, $t6, 1		#increase $t6 by 1
       			addi $t2, $t2, 4		#increase $t2 by 4
       			j clearance
       		return: 
       			j newOperation
	
	error:
		la $a0, errorMsg		#load the error message
		li $v0, 4			#print the message
		syscall
		j newOperation
Exit:		
	li $v0, 10	#exit program	
	syscall