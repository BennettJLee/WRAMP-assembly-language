.global main
.text
.equ pcb_link, 0
.equ pcb_reg1, 1
.equ pcb_reg2, 2
.equ pcb_reg3, 3
.equ pcb_reg4, 4
.equ pcb_reg5, 5
.equ pcb_reg6, 6
.equ pcb_reg7, 7
.equ pcb_reg8, 8
.equ pcb_reg9, 9
.equ pcb_reg10, 10
.equ pcb_reg11, 11
.equ pcb_reg12, 12
.equ pcb_reg13, 13
.equ pcb_sp, 14
.equ pcb_ra, 15
.equ pcb_ear, 16
.equ pcb_cctrl, 17
.equ pcb_timeslice, 18

main:
    # Unmask IRQ2,KU=1,OKU=1,IE=0,OIE=1
    addi $5, $0, 0x4d
    # Setup the pcb for task 1
    la $1, task1_pcb
    # Setup the link field
    la $2, task2_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer
    la $2, task1_stack
    sw $2, pcb_sp($1)
    # Setup the $ear field
    la $2, serial_task
    sw $2, pcb_ear($1)
    # Setup the $cctrl field
    sw $5, pcb_cctrl($1)
    #setup exit
    la $2, exit
    sw $2, pcb_ra($1)
    #setup timeslice
    addi $2, $0, 1
    sw $2, pcb_timeslice($1)
    sw $2, timeslice($0)

    # Setup the pcb for task 2
    la $1, task2_pcb
    # Setup the link field
    la $2, task3_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer
    la $2, task2_stack
    sw $2, pcb_sp($1)
    # Setup the $ear field
    la $2, parallel_task
    sw $2, pcb_ear($1)
    # Setup the $cctrl field
    sw $5, pcb_cctrl($1)
    #setup exit
    la $2, exit
    sw $2, pcb_ra($1)
    #setup timeslice
    addi $2, $0, 1
    sw $2, pcb_timeslice($1)
    sw $2, timeslice($0)

     # Setup the pcb for task 2
    la $1, task3_pcb
    # Setup the link field
    la $2, task1_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer
    la $2, task3_stack
    sw $2, pcb_sp($1)
    # Setup the $ear field
    la $2, gameSelect_main
    sw $2, pcb_ear($1)
    # Setup the $cctrl field
    sw $5, pcb_cctrl($1)
    #setup exit
    la $2, exit
    sw $2, pcb_ra($1)
    #setup timeslice
    addi $2, $0, 4
    sw $2, pcb_timeslice($1)
    sw $2, timeslice($0)

    # Set first task as the current task
    la $1, task1_pcb
    sw $1, current_task($0)

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

    j load_context

handler:
    #get the status register
    movsg $13, $estat
    #looking for an IRQ2(timer) interrupt.
    andi $13, $13, 0xFFB0
    # If the result of this is zero it must be our deception
    beqz $13, handle_timer
    # Otherwise there was another exception that has
    # occurred, so call the old handler
    lw $13, old_vector($0)
    jr $13

handle_timer:
    #increment timer
    lw $13, counter($0)
    addi $13, $13, 0x1
    sw $13, counter($0)
    #acknowledge interrupt
    sw $0, 0x72003($0)
    lw $13, timeslice($0)
    subi $13, $13, 1
    sw $13, timeslice($0)
    beqz $13, dispatcher
    rfe

dispatcher:
save_context:
    lw $13, current_task($0)
    #save registers
    sw $1, pcb_reg1($13)
    sw $2, pcb_reg2($13)
    sw $3, pcb_reg3($13)
    sw $4, pcb_reg4($13)
    sw $5, pcb_reg5($13)
    sw $6, pcb_reg6($13)
    sw $7, pcb_reg7($13)
    sw $8, pcb_reg8($13)
    sw $9, pcb_reg9($13)
    sw $10, pcb_reg10($13)
    sw $11, pcb_reg11($13)
    sw $12, pcb_reg12($13)
    sw $sp, pcb_sp($13)
    sw $ra, pcb_ra($13)
    #save special registers
    movsg $1, $ers
    sw $1, pcb_reg13($13)
    movsg $1, $ear
    sw $1, pcb_ear($13)
    movsg $1, $cctrl
    sw $1, pcb_cctrl($13)

schedule:
    lw $13, current_task($0)
    lw $13, pcb_link($13)
    sw $13, current_task($0) 

    # Reset the timeslice counter to an appropriate value
    lw $13, current_task($0)
    lw $13, pcb_timeslice($13)
    sw $13, timeslice($0)

load_context:
    # Load context for next task
    lw $13, current_task($0) #Get PCB of current task

    # Get the PCB value for $13 back into $ers
    lw $1, pcb_reg13($13)
    movgs $ers, $1

    # Restore $ear
    lw $1, pcb_ear($13)
    movgs $ear, $1

    # Restore $cctrl
    lw $1, pcb_cctrl($13)
    movgs $cctrl, $1

    # Restore the other registers
    lw $1, pcb_reg1($13)
    lw $2, pcb_reg2($13)
    lw $3, pcb_reg3($13)
    lw $4, pcb_reg4($13)
    lw $5, pcb_reg5($13)
    lw $6, pcb_reg6($13)
    lw $7, pcb_reg7($13)
    lw $8, pcb_reg8($13)
    lw $9, pcb_reg9($13)
    lw $10, pcb_reg10($13)
    lw $11, pcb_reg11($13)
    lw $12, pcb_reg12($13)
    lw $sp, pcb_sp($13)
    lw $ra, pcb_ra($13)
    # Return to the new task
    rfe

exit:
    #load current task is exit
    lw $2, current_task($0)
    #load taskpcbs
    la $3, task1_pcb
    la $4, task2_pcb
    la $5, task3_pcb

    lw $6, task1_status($0)
    lw $7, task2_status($0)
    lw $8, task3_status($0)

    #compare which pcb matches current task
    seq $11, $2, $3
    bnez $11, removetask1

    seq $11, $2, $4
    bnez $11, removetask2

    seq $11, $2, $5
    bnez $11, removetask3


removetask1: 
    #is task2 closed
    seq $2, $7, $0
    #is task3 closed
    seq $3, $8, $0
    #are both tasks closed
    seq $11, $2, $3
    sw $0, task1_status($0)
    bnez $11, dispatcher
    bnez $2, looptask3
    bnez $3, looptask2
    #if task1 is the first to exit
    sw $4, pcb_link($5) #T2 into T3 link
    j dispatcher

removetask2:
    #is task1 closed
    seq $2, $6, $0
    #is task3 closed
    seq $3, $8, $0
    #are both tasks closed
    seq $11, $2, $3
    sw $0, task2_status($0)
    bnez $11, dispatcher
    bnez $2, looptask3
    bnez $3, looptask1
    #if task2 is the first to exit
    sw $5, pcb_link($3) #T3 into T1 link
    j dispatcher

removetask3:
    #is task1 closed
    seq $2, $6, $0
    #is task2 closed
    seq $3, $7, $0
    #are both tasks closed
    seq $11, $2, $3
    sw $0, task3_status($0)
    bnez $11, dispatcher
    bnez $2, looptask3
    bnez $3, looptask1
    sw $3, pcb_link($4) #T1 into T2 link
    j dispatcher

looptask1:
    sw $3, pcb_link($3)
    j dispatcher
looptask2:
    sw $4, pcb_link($4)
    j dispatcher
looptask3:
    sw $5, pcb_link($5)
    j dispatcher

.data
    timeslice:
        .word 0
    task1_status:
        .word 1
    task2_status:
        .word 1
    task3_status:
        .word 1

.bss
    old_vector:
        .word 

    current_task:
        .word 

    task1_pcb:
        .space 19

    task2_pcb:
        .space 19

    task3_pcb:
        .space 19

        .space 200
    task1_stack:

       .space 200
    task2_stack:

       .space 200
    task3_stack: