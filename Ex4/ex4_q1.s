.global main
.text

main:
	#set variables
	add $5,$0,$0
	add $3,$0,$0
	addi $4, $0, 0x3

	#set up interrupts
	sw $4, 0x73004($0)
	#copy the current value of $cctrl into $2
 	movsg $2, $cctrl
 	#disable all interrupts
 	andi $2, $2, 0x000f
 	#enable IRQ1, IRQ3 and IE (global interrupt enable)
 	ori $2, $2, 0xA2
 	#copy the new CPU control value back to $cctrl
 	movgs $cctrl, $2

	#copy the old handler’s address to $2
 	movsg $2, $evec
 	#save it to memory
 	sw $2, old_vector($0)
 	#get the address of our handler
 	la $2, handler
 	#and copy it into the $evec register
 	movgs $evec, $2

loop:
	#load $2 with counter
	lw $2, counter($0)
	#divide number and get remainder
	divi $3, $2, 0xa
	remi $3, $3, 0xa
	sw $3, 0x73008($0)
	remi $3, $2, 0xa
	sw $3, 0x73009($0)
	j loop

handler:
	#get the status register
	movsg $13, $estat
	#looking for an IRQ1 interrupt.
	andi $13, $13, 0xFFD0
	# If the result of this is zero it must be our deception
	beqz $13, handle_intIRQ1
	#looking for an IRQ3 interrupt.
	andi $13, $13, 0xFF70
	# If the result of this is zero it must be our deception
	beqz $13, handle_intIRQ3
	# Otherwise there was another exception that has
	# occurred, so call the old handler
	lw $13, old_vector($0)
	jr $13

handle_intIRQ1:
	lw $13, counter($0)
	addi $13, $13, 1
	sw $13, counter($0)
	#acknowledge interrupt
	sw $0, 0x7F000($0)
	rfe
handle_intIRQ3:
	lw $13, 0x73001($0)
	beqz $13, handled
	lw $13, counter($0)
	addi $13, $13, 1
	sw $13, counter($0)
handled:
	#acknowledge interrupt
	sw $0, 0x73005($0)
	rfe

.data
	#counter variable
	counter:
		.word 0
.bss
	#interrupt
	old_vector:
 		.word 
