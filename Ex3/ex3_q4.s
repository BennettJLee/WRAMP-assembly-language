.text
.global main

main:
	jal serial_job
	jal parallel_job
	j main


.global parallel_job

parallel_job:
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
	jr $ra

loop:
	subui $sp, $sp, 2
	sw $11, 0($sp)
	sw $ra, 1($sp)
pcheck:
	lw $11, 0x73001($0)
	# Check if the button was pressed
	sgt $11, $11, $0
	# If not, loop and try again
	beqz $11, pcheck
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


.global serial_job

serial_job:
	# Get the first serial port status
	lw $11, 0x70003($0)
	# Check if the RDR bit is set
	andi $11, $11, 0x1
	# If not, loop and try again
	beqz $11, return
	# Serial port now has a character
	# Get it into $9
	lw $9, 0x70001($0)
	#if $9 isnt greater or equal to 'a' branch to replace
	sgei $13, $9, 0x61
	beqz $13, replace
	#if $9 isnt less or equal to 'z' branch to replace
	slei $13, $9, 0x7A
	beqz $13, replace
scheck:
	#Get the first serial port status
	lw $11, 0x70003($0)
	#Check if the TDS bit is set
	andi $11, $11, 0x2
	#If not, loop and try gain
	beqz $11, scheck
	#Serial port is now ready so transmit character
	sw $9, 0x70000($0)
	j serial_job
replace:
	#replace word with '*'
	addi $9, $0, 0x2A
	j scheck
return:
	jr $ra
