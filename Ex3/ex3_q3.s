.text
.global main

main:
	#check button and read switches
	subui $sp, $sp, 1
	sw $ra, 0($sp)
	jal loop
	add $9, $0, $1
	jal readswitches
	add $2, $0, $1

buttonpress:
	#if button 0 was pressed leave value and print
	snei $13, $9, 1
	beqz $13, lightLED
	#if button 1 was pressed invert switch
	sgti $13, $9, 3
	beqz $13, invert
	#if button 2 is pressed close program and clear board
	lw $ra, 0($sp)
	addui $sp, $sp, 1
	add $2, $0, $0
	jal writessd
	sw $0, 0x7300A($0)
	syscall

invert:
	Xori $2, $2, 0xFFFF

lightLED:
	add $6, $0, $0
	#if $2 is a multiple of 4 give $6 0xFFFF
	remi $5, $2, 4
	seq $13, $5, $0
	beqz $13, print
	addi $6, $0, 0xFFFF

print:
	#put $6 into leds and print SSD
	sw $6, 0x7300A($0)
	jal writessd
	lw $ra, 0($sp)
	addui $sp, $sp, 1
	j main

loop:
	subui $sp, $sp, 2
	sw $11, 0($sp)
	sw $ra, 1($sp)
check:
	lw $11, 0x73001($0)
	# Check if the button was pressed
	sgt $11, $11, $0
	# If not, loop and try again
	beqz $11, check
	#load $1 with button value
	lw $1, 0x73001($0)
	lw $11, 0($sp)
	lw $ra, 1($sp)
	addui $sp, $sp, 2
	jr $ra

readswitches:
	lw $1, 0x73000($0)
	jr $ra

writessd:
	subui $sp, $sp, 2
	sw $2, 0($sp)
	sw $ra, 1($sp)
	sw $2, 0x73009($0)
	srli $2, $2, 4
	sw $2, 0x73008($0)
	srli $2, $2, 4
	sw $2, 0x73007($0)
	srli $2, $2, 4
	sw $2, 0x73006($0)
	lw $2, 0($sp)
	lw $ra, 1($sp)
	addui $sp, $sp, 2
	jr $ra