.equ sp1_tx,		0x70000
.equ sp1_rx,		0x70001
.equ sp1_ctrl,		0x70002
.equ sp1_stat,		0x70003
.equ sp1_iack,		0x70004

.equ par_switch,	0x73000
.equ par_btn,		0x73001
.equ par_ctrl,		0x73004
.equ par_iack,		0x73005
.equ par_ulssd,		0x73006
.equ par_urssd,		0x73007
.equ par_llssd,		0x73008
.equ par_lrssd,		0x73009

.text

.global putch
putch:
	subui $sp, $sp, 1
	sw $13, 0($sp)
	putch_wait:
	lw $13, sp1_stat($0)
	andi $13, $13, 2
	beqz $13, putch_wait
	sw $2, sp1_tx($0)
	lw $13, 0($sp)
	addi $sp, $sp, 1
	jr $ra

.global putstr
putstr:
	subui $sp, $sp, 3
	sw $13, 0($sp)
	sw $2, 1($sp)
	sw $ra, 2($sp)
	
	add $13, $0, $2
	
	putstr_loop:
	lw $2, 0($13)
	beqz $2, putstr_end
	jal putch
	addi $13, $13, 1
	j putstr_loop
	
	putstr_end:
	
	lw $13, 0($sp)
	lw $2, 1($sp)
	lw $ra, 2($sp)
	addi $sp, $sp, 3
	jr $ra
	
.global readswitches
readswitches:
	lw $1, par_switch($0)
	jr $ra
	
.global writessd
writessd:
	subui $sp, $sp, 1
	sw $2, 0($sp)
	
	sw $2, par_lrssd($0)
	srli $2, $2, 4
	sw $2, par_llssd($0)
	srli $2, $2, 4
	sw $2, par_urssd($0)
	srli $2, $2, 4
	sw $2, par_ulssd($0)
	
	lw $2, 0($sp)
	addui $sp, $sp, 1
	jr $ra
