.global	main
.text
main:
	subui	$sp, $sp, 7
	sw	$7, 2($sp)
	sw	$13, 3($sp)
	sw	$ra, 4($sp)
	jal	readswitches
	add	$13, $0, $1
	add	$7, $0, $13
	srai	$13, $7, 8
	andi	$13, $13, 255
	sw	$13, 6($sp)
	andi	$13, $7, 255
	sw	$13, 5($sp)
	lw	$13, 6($sp)
	sw	$13, 0($sp)
	lw	$13, 5($sp)
	sw	$13, 1($sp)
	jal	count
L.5:
	lw	$7, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 7
	jr	$ra
