.global	count
.text
count:
	subui	$sp, $sp, 5
	sw	$6, 1($sp)
	sw	$7, 2($sp)
	sw	$13, 3($sp)
	sw	$ra, 4($sp)
	lw	$7, 5($sp)
	lw	$6, 6($sp)
	slt	$13, $7, $0
	bnez	$13, L.1
	sgti	$13, $7, 10000
	bnez	$13, L.1
	slt	$13, $6, $0
	bnez	$13, L.1
	sgti	$13, $6, 10000
	bnez	$13, L.1
	j	L.7
L.6:
	sw	$7, 0($sp)
	jal	writessd
	jal	delay
	addi	$7, $7, 1
L.7:
	slt	$13, $7, $6
	bnez	$13, L.6
	j	L.10
L.9:
	sw	$7, 0($sp)
	jal	writessd
	jal	delay
	subi	$7, $7, 1
L.10:
	sgt	$13, $7, $6
	bnez	$13, L.9
	sne	$13, $7, $6
	bnez	$13, L.1
	sw	$7, 0($sp)
	jal	writessd
	jal	delay
L.1:
	lw	$6, 1($sp)
	lw	$7, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 5
	jr	$ra
