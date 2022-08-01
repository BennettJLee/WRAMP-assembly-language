.global main
.text

main:
    #set variables
    add $5,$0,$0
    add $3,$0,$0
    addi $4, $0, 0x3

    #set button interrupt
    sw $4, 0x73004($0)
    # Put the auto load value in
    addi $11, $0, 0x960
    sw $11, 0x72001($0)
    # set timer autorestart
    addi $11, $0, 0x2
    sw $11, 0x72000($0)
     #copy the old handler’s address to $2
    movsg $2, $evec
    #save it to memory
    sw $2, old_vector($0)
    #get the address of our handler
    la $2, handler
    #and copy it into the $evec register
    movgs $evec, $2
    #copy the current value of $cctrl into $2
    movsg $2, $cctrl
    #disable all interrupts
    andi $2, $2, 0x000F
    #enable IRQ2, IRQ3 and IE (global interrupt enable)
    ori $2, $2, 0xC2
    #copy the new CPU control value back to $cctrl
    movgs $cctrl, $2

loop:
    #load $2 with counter
    lw $2, counter($0)
    #write ssd
    jal writessd
    lw $2, flag($0)
    bnez $2, loop
    add $2, $0, $0
    jal writessd
    lw $ra, old_vector($0)
    jr $ra

writessd:
    subui $sp, $sp, 1
    sw $ra, 0($sp)
    #divide number and get remainder
    divi $3, $2, 0x3E8
    remi $3, $3, 0xa
    sw $3, 0x73006($0)
    divi $3, $2, 0x64
    remi $3, $3, 0xa
    sw $3, 0x73007($0)
    divi $3, $2, 0xa
    remi $3, $3, 0xa
    sw $3, 0x73008($0)
    remi $3, $2, 0xa
    sw $3, 0x73009($0)
    lw $ra, 0($sp)
    addui $sp, $sp, 1
    jr $ra

handler:
    #get the status register
    movsg $13, $estat
    #looking for an IRQ2 interrupt.
    andi $13, $13, 0xFFB0
    # If the result of this is zero it must be our deception
    beqz $13, handle_intIRQ2
    #looking for an IRQ3 interrupt.
    andi $13, $13, 0xFF70
    # If the result of this is zero it must be our deception
    beqz $13, handle_intIRQ3
    # Otherwise there was another exception that has
    # occurred, so call the old handler
    lw $13, old_vector($0)
    jr $13

handle_intIRQ2:
    lw $13, counter($0)
    addi $13, $13, 1
    sw $13, counter($0)
    #acknowledge interrupt
    sw $0, 0x72003($0)
    rfe

handle_intIRQ3:
    lw $13, 0x73001($0)
    #if button 0 was pressed
    subi $13, $13, 0x1
    beqz $13, handleB0
    #if button 1 was pressed
    subi $13, $13, 0x1
    beqz $13, handleB1
    #if button 2 was pressed
    subi $13, $13, 0x2
    beqz $13, handleB2
    j handled
handleB0:
    #reset counter if timer is not running
    lw $13, 0x72000($0)
    andi $13, $13, 0x1
    bnez $13, handled
    lw $13, counter($0)
    add $13, $0, $0
    sw $13, counter($0)
    j handled
handleB1:
    #toggle timer
    lw $13, 0x72000($0)
    xori $13, $13, 0x1
    sw $13, 0x72000($0)
    j handled
handleB2:
    #terminate the program
    sw $0, flag($0)
    j handled
handled:
    #acknowledge interrupt
    sw $0, 0x73005($0)
    rfe

.data
    #counter variable
    counter:
        .word 0
    flag:
        .word 1
.bss
    #interrupt
    old_vector:
        .word 





