.global serial_task
.text

serial_task:
    subui $sp, $sp, 1
    sw $ra, 0($sp)
serial_loop:
    lw $3, format_value($0)
    seqi $11, $3, 'q'
    bnez $11, serial_exit
    lw $2, counter($0)

format_check:
    seqi $11, $3, '1'
    bnez $11, writef1sp
    seqi $11, $3, '2'
    bnez $11, writef2sp
    seqi $11, $3, '3'
    bnez $11, writef3sp

get_bit:
    # Get the second serial port status
    lw $11, 0x71003($0)
    # Check if the RDR bit is set
    andi $11, $11, 0x1
    # If not, loop and try again
    beqz $11, serial_loop
    lw $3, 0x71001($0)
    slti $11, $3, '1'
    bnez $11, serial_loop
    sgti $11, $3, '3'
    bnez $11, check_exit
    sw $3, format_value($0)
    j serial_loop

check_exit:
    seqi $11, $3, 'q'
    beqz $11, serial_exit
    sw $3, format_value($0)
    j serial_loop
serial_exit:
    lw $ra, 0($sp)
    addui $sp, $sp, 1
    jr $ra

spcheck:
    # Get the first serial port status
    lw $11, 0x71003($0)
    # Check if the TDS bit is set
    andi $11, $11, 0x2
    # If not, loop and try again
    beqz $11, spcheck
    jr $ra

#if formatvalue is 1
writef1sp:
    jal spcheck
    addi $3, $0, '\r'
    sw $3, 0x71000($0)
    jal spcheck
#divide to seconds
    divi $2, $2, 0x64
#divide to mins
    divi $3, $2, 0x3C
    remi $2, $2, 0x3C
#print minutes
    divi $4, $3, 0xa
    remi $4, $4, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    remi $4, $3, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
#print seconds
    jal spcheck
    addi $3, $0, ':'
    sw $3, 0x71000($0)
    jal spcheck
    divi $4, $2, 0xa
    remi $4, $4, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    remi $4, $2, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    addi $4, $0, 0x20
    sw $4, 0x71000($0)
    jal spcheck
    addi $4, $0, 0x20
    sw $4, 0x71000($0)
#return
    j get_bit

#if formatvalue is 2                              
writef2sp:
    jal spcheck
    addi $3, $0, '\r'
    sw $3, 0x71000($0)
    jal spcheck
    divi $3, $2, 0x64
    divi $4, $3, 0x3E8
    remi $4, $4, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    divi $4, $3, 0x64
    remi $4, $4, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    divi $4, $3, 0xa
    remi $4, $4, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    remi $4, $3, 0xa
    addi $4, $4, 0x30
    sw $4, 0x71000($0)
    jal spcheck
    addi $4, $0, '.'
    sw $4, 0x71000($0)
    jal spcheck
    divi $3, $2, 0xa
    remi $3, $3, 0xa
    addi $3, $3, 0x30
    sw $3, 0x71000($0)
    jal spcheck
    remi $3, $2, 0xa
    addi $3, $3, 0x30
    sw $3, 0x71000($0)
    j get_bit

#if format value is 3
writef3sp:
    jal spcheck
    addi $3, $0, '\r'
    sw $3, 0x71000($0)
    jal spcheck
    divi $2, $2, 0x64
    divi $3, $2, 0x3E8
    remi $3, $3, 0xa
    addi $3, $3, 0x30
    sw $3, 0x71000($0)
    jal spcheck
    divi $3, $2, 0x64
    remi $3, $3, 0xa
    addi $3, $3, 0x30
    sw $3, 0x71000($0)
    jal spcheck
    divi $3, $2, 0xa
    remi $3, $3, 0xa
    addi $3, $3, 0x30
    sw $3, 0x71000($0)
    jal spcheck
    remi $3, $2, 0xa
    addi $3, $3, 0x30
    sw $3, 0x71000($0)
    jal spcheck
    addi $4, $0, 0x20
    sw $4, 0x71000($0)
    jal spcheck
    addi $4, $0, 0x20
    sw $4, 0x71000($0)
    jal spcheck
    addi $4, $0, 0x20
    sw $4, 0x71000($0)
    j get_bit

.data
    .global counter
    counter:
        .word 0
    format_value:
        .word '1'
