.text
.global main
main:
	#Initialise
	addi $4, $0, 0x0
	addi $5, $0, 0x0
	addi $9, $0, 0x0
	add $13, $0, $0
lowercase:
	#give $9 a lowercase ASCII character
	addi $9, $4, 0x61
	addi $4, $4, 0x1
	#if $13 is greater than 'z' start check
	#otherwise move to uppercase
	sgti $13, $9, 0x7A
	beqz $13, check 
uppercase:
	#give $9 a uppercase ASCII character
	addi $9, $5, 0x41
	addi $5, $5, 0x1
	#if $13 is greater than 'z' start uppercase loop
	#otherwise print character
	sgti $13, $9, 0x5A
	beqz $13, check
	syscall
check:
	#Get the first serial port status
	lw $11, 0x71003($0)
	#Check if the TDS bit is set
	andi $11, $11, 0x2
	#If not, loop and try gain
	beqz $11, check 
	#Serial port is now ready so transmit character
	sw $9, 0x71000($0)
	sgti $13, $9, 0x5A
	beqz $13, uppercase
	j lowercase