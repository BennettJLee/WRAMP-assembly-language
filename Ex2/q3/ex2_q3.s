.global	main
.text
main:
	#create stack and back up registers
	subui	$sp, $sp, 7
	sw	$7, 2($sp)
	sw	$13, 3($sp)
	sw	$ra, 4($sp)
	#put switches into $1
	jal	readswitches
	addu	$13, $0, $1
	addu	$7, $0, $13
	srai	$13, $7, 0x8
	andi	$13, $13, 0xFF #allows for digits upto 255
	sw	$13, 6($sp)
	andi	$13, $7, 0xFF #limits to 8 bits
	sw	$13, 5($sp)
	#arguments to pass 0 start 1 end
	lw	$13, 6($sp)
	sw	$13, 1($sp) #set to end
	lw	$13, 5($sp)
	sw	$13, 0($sp) #set to start
	#count(start,end)
	jal	count
	#restore registers
	lw	$7, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 7
	jr	$ra
