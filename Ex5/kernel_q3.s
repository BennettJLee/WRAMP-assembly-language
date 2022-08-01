.global main
.text

main:
    # Put the auto load value in
    addi $11, $0, 0x18
    sw $11, 0x72001($0)
    # set timer autorestart
    addi $11, $0, 0x3
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
    #enable IRQ2 and IE
    ori $2, $2, 0x42
    #copy the new CPU control value back to $cctrl
    movgs $cctrl, $2

    jal serial_task

handler:
    #get the status register
    movsg $13, $estat
    #looking for an IRQ2 interrupt.
    andi $13, $13, 0xFFB0
    # If the result of this is zero it must be our deception
    beqz $13, handle_intIRQ2
    # Otherwise there was another exception that has
    # occurred, so call the old handler
    lw $13, old_vector($0)
    jr $13

handle_intIRQ2:
    #increment timer
    lw $13, counter($0)
    addi $13, $13, 0x1
    sw $13, counter($0)
    #acknowledge interrupt
    sw $0, 0x72003($0)
    rfe

.bss
    #interrupt
    old_vector:
        .word 