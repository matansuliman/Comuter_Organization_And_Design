#Title:Maman12 Qes3  Filename:Answer3 
#Author:Matan Suliman   Date:27/11/22
#Description: if ascii value is bigger print '+', if smaller print '-' and if equal print '='
#Input: string of any values
#Output: a new string based on ascii values 
############### Data segment ###############
.data
buf: .space 21
buf1: .space 20
msg: .asciiz "\nThe number of identical char in a row is: "
############### Code segment ###############

#$v0 - for syscalls
#$a0 - for syscalls
#$a1 - for syscalls

#$t0 - current byte value in buf
#$t1 - next byte value in buf
#$t2 - sign to store
#$t3 - equal sign counter

#$s0 - current adrress in buf
#$s1 - current adrress in buf1

.text
.globl main
main: #main program entry
#Get input from user:
la $a0, buf
li $a1, 21 #max size
li $v0, 8 #Read String of max length 20 and put in buf space
syscall
#init
move $s0, $a0 #current adrress in buf
la $s1, buf1 #coresponding adrress in buf1
Loop_Sign:
	lb $t0, 0($s0) #current byte value in buf
	beq $t0, 0xa, End_Loop_Sign #if \n
	beq $t0, 0x0, End_Loop_Sign #if 0
	#else not finished:
	addi $s0, $s0, 0x1 #next byte adrress in buf
	lb $t1, 0($s0) #next byte value in buf
	beq $t1, 0xa, End_Loop_Sign #if \n
	beq $t1, 0x0, End_Loop_Sign #if 0
	#else not finished:
	beq $t0, $t1, Equal
	blt $t0, $t1, Less_Then
	#$t0 > $t1 (current > next):
		li $t2, 0x2b #'2b' is ascii value of '+' in hex
	j Store
	Equal: #$t0 == $t1 (current == next):
		li $t2, 0x3d #'3d' is ascii value of '=' in hex
	j Store
	Less_Then: #$t0 < $t1 (current < next):
		li $t2, 0x2d #'2d' is ascii value of '-' in hex
	Store:
	sb $t2, 0($s1) #store the sign at coresponding adrress in buf1
	addi $s1, $s1, 0x1 #next coresponding adrress in buf1
	j Loop_Sign
End_Loop_Sign:

#init
la $s0, buf1
li $t3, 0
Print_Loop:
	lb $a0, 0($s0) #current byte value in buf1
	beq $a0, 0x0, End_Print_Loop #if 0
	li $v0, 11 #char print
	syscall
	bne $a0, 0x3d, Not_Equal #detect equal sign
	addi $t3, $t3, 1 #equal counter++
	Not_Equal:
	addi $s0, $s0, 0x1 #next byte adrress in buf1
	j Print_Loop
End_Print_Loop:
#print msg:
li $v0, 4 #print string
la $a0, msg
syscall
#print equal counter:
li $v0, 1 #print int
move $a0, $t3 #equal counter
syscall
li $v0, 10 # Exit program
syscall