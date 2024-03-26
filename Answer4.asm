#Title:Maman12 Qes4  Filename:Answer4
#Author:Matan Suliman   Date:27/11/22
#Description: this program count the number of instructions (lw, sw, beq, R-type) used and the use of registers
#Input: manuall storing of TheCode
#Output: list of counters with corisponding names
############### Data segment ###############
.data
TheCode: .word 0x30000000, 0x8c000000, 0x00000020, 0x1000fff4, 0xac000000, 0xffffffff
ArrayCounter: .space 31
msg: .asciiz        "\ninst code/reg               apperances"
msg_R_type: .asciiz "\nR-type                           "
msg_lw: .asciiz     "\nlw                               "
msg_sw: .asciiz     "\nsw                               "
msg_beq: .asciiz    "\nbeq                              "
msg_n: .asciiz      "\n"
msg_space: .asciiz     "                                "
msg_invalid: .asciiz "\n**found invalid defining of instruction in TheCode**"
msg_rd_0: .asciiz "\n**found rd=0 in R-type instruction**"
msg_rt_0_lw: .asciiz "\n**found rt=0 in lw instruction**"
msg_rs_eq_rt_beq: .asciiz "\n**found rs=rt in bwq instruction**"
############### Code segment ###############

#$v0 - for syscalls and return values from functions
#$a0 - for syscalls and functions

#$t0 - (1)instructions to store (2)Print loop counter
#$t1 - (1)current instruction in TheCode
#$t2 - current opcode
#$t3 - lw counter
#$t4 - sw counter
#$t5 - beq counter
#$t6 - R-type counter

#$s0 - current adrress of TheCode
#$s1 - current adrress in ArrayCounter
#$s3 - value of reg counter
#$s4 - value of rd
#$s5 - value of rs
#$s6 - value of rt

.text
.globl main
main: #main program entry
la $s0, TheCode #current instruction adrress of TheCode
TheCode_Loop:
	lw $t1, 0($s0) #load current instruction in TheCode
	beq $t1, 0xffffffff, End_TheCode_Loop
	srl $t2, $t1, 26 #opcode most right
	#check by opcode:
	beq $t2, 35, Instruction_lw
	beq $t2, 43, Instruction_sw
	beq $t2, 4, Instruction_beq
	beq $t2, 0, Instruction_R_type
	#invalid definition in TheCode - proper msg
	li $v0, 4 #print string
	la $a0, msg_invalid
	syscall
	j Next_Inst
	Instruction_R_type:
	addi $t6, $t6, 1 #R-type counter++
	move $a0, $t1 #argument for func
	jal func_R_type #returns $v0 = rd
	move $s4, $v0
	bne $s4, 0, rd_not_0 #if rd != 0
	#rd = 0 - proper msg
	li $v0, 4 #print string
	la $a0, msg_rd_0
	syscall
	
	rd_not_0:
	#count_rd:
	move $a0, $s4 #argument for func
	jal func_counter_plus #no return values
	j Count_Reg
	Instruction_lw:
	addi $t3, $t3, 1 #lw counter++
	j Count_Reg
	Instruction_sw:
	addi $t4, $t4, 1 #sw counter++
	j Count_Reg
	Instruction_beq:
	addi $t5, $t5, 1 #beq counter++
	Count_Reg:
	move $a0, $t1 #argument for func
	jal func #returns $v0 = rs, $v1 = rt
	move $s5, $v0
	move $s6, $v1
	
	#check if rt=0 and op=35(lw):
	bne $s6, 0, rtNotZero_or_opNotLw #if rd != 0
	#rt = 0 - check if op = 35(lw)
	bne $t2, 35, rtNotZero_or_opNotLw #if op != 35(lw)
	#rd = 0 and op = 35(lw) - proper msg
	li $v0, 4 #print string
	la $a0, msg_rt_0_lw
	syscall
	j rsNotEqualRt_or_opNotBeq #op is 35 so op isnt beq
	rtNotZero_or_opNotLw:
	
	#check if rt=rs and op=4(beq):
	bne $s5, $s6, rsNotEqualRt_or_opNotBeq #if rs != rt
	#rs = rt - check if op = 4(beq)
	bne $t2, 4, rsNotEqualRt_or_opNotBeq #if op != 4(beq)
	#rs = rt and op = 4(beq) - proper msg
	li $v0, 4 #print string
	la $a0, msg_rs_eq_rt_beq
	syscall
	rsNotEqualRt_or_opNotBeq:
	
	#count_rs:
	move $a0, $s5 #argument for func
	jal func_counter_plus #no return values
	#count_rt:
	move $a0, $s6 #argument for func
	jal func_counter_plus #no return values
	Next_Inst:
	addi $s0, $s0, 4 #next instruction adrress in TheCode
	j TheCode_Loop
End_TheCode_Loop:

#print msg:
li $v0, 4 #print string
la $a0, msg
syscall

#print type:
li $v0, 4 #print string
la $a0, msg_R_type
syscall
li $v0, 1 #print int
move $a0, $t6 #R_type counter
syscall

#print lw:
li $v0, 4 #print string
la $a0, msg_lw
syscall
li $v0, 1 #print int
move $a0, $t3 #lw counter
syscall

#print sw:
li $v0, 4 #print string
la $a0, msg_sw
syscall
li $v0, 1 #print int
move $a0, $t4 #sw counter
syscall

#print beq:
li $v0, 4 #print string
la $a0, msg_beq
syscall
li $v0, 1 #print int
move $a0, $t5 #beq counter
syscall

#init
la $s1, ArrayCounter #current adrress in ArrayCounter
li $t0, 0 #Print loop counter
Print_Loop:
	beq $t0, 31, End_Print_Loop #only 31 reg exsist 
	lb $t1, 0($s1) #value of reg counter
	beq $t1, 0, Next #if 0 move on
	#print string new line
	la $a0, msg_n
	li $v0, 4
	syscall
	#print int reg number
	move $a0, $t0
	li $v0, 1 
	syscall
	#print string space
	la $a0, msg_space
	li $v0, 4
	syscall
	#print int reg counter value
	move $a0, $t1
	li $v0, 1 
	syscall
	Next:
	addi $t0, $t0, 1 #Print loop counter++
	addi $s1, $s1, 0x1 #next byte adrress in ArrayCounter
	j Print_Loop
End_Print_Loop:
li $v0, 10 # Exit program
syscall

#functions:
func: #$a0 = current instruction in TheCode , return $v0=rs $v1=rt
	#align rs:
	sll $v0, $a0, 6 #rid of op
	srl $v0, $v0, 27 #put most right
	#align rt
	sll $v1, $a0, 11 #rid of op and rs
	srl $v1, $v1, 27 #put most right
	jr $ra #return

func_R_type: #$a0 = current instruction in TheCode, return $v0=rt
	#align rd:
	sll $v0, $a0, 16 #rid of op and rs and rt
	srl $v0, $v0, 27 #put most right
	jr $ra #return

func_counter_plus: #$a0 = reg number to count++, no return values
	la $t0, ArrayCounter #current adrress in ArrayCounter
	Loop:
		beq $a0, 0, End_Loop
		addi $t0, $t0, 0x1 #next byte adrress in ArrayCounter
		addi $a0, $a0, -1 #update the counter
		j Loop
	End_Loop:
	lb $s3, 0($t0) #get the current count
	addi $s3, $s3, 1 #add 1
	sb $s3,  0($t0) #store the new count (+1)
	jr $ra #return