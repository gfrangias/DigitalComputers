#Hello, <<String>> World!

.data

    answer: .space 20
    string1: .asciiz "Enter a string: "     
    string2: .asciiz "\nHello, "   
    string3: .asciiz "World!"
.text

main:
    la $a0, string1     ##Load and print string asking for string
    li $v0, 4
    syscall

    li $v0, 8           ##Take user input
    la $a0, answer      ##Load byte space to a0
    li $a1, 20          ##Set byte space for string
    move $t0, $a0       ##Save string to t0
    syscall 
    
    la $a0, string2     ##Load and print "Hello, "
    li $v0,4
    syscall

    la $a0, answer      ##Reload byte space to a0
    move $a0, $t0       ##Pointer from a0 pointing to t0
    li $v0, 4           ##Print given string
    syscall

    la $a0, string3     ##Load and print " World!"
    li $v0,4
    syscall

    li $v0, 10          ##End program
    syscall

