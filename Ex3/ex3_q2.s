.text
.global main
main:
	# Get the first serial port status
	lw $11, 0x70003($0)
	# Check if the RDR bit is set
	andi $11, $11, 0x1
	# If not, loop and try again
	beqz $11, main
	# Serial port now has a character
	# Get it into $9
	lw $9, 0x70001($0)
	#if $9 isnt greater or equal to 'a' branch to replace
	sgei $13, $9, 0x61
	beqz $13, replace
	#if $9 isnt less or equal to 'z' branch to replace
	slei $13, $9, 0x7A
	beqz $13, replace
check:
	#Get the first serial port status
	lw $11, 0x70003($0)
	#Check if the TDS bit is set
	andi $11, $11, 0x2
	#If not, loop and try gain
	beqz $11, check
	#Serial port is now ready so transmit character
	sw $9, 0x70000($0)
	j main
replace:
	#replace word with '*'
	addi $9, $0, 0x2A
	j check