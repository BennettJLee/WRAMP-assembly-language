.global parallel_task
.text

parallel_task:
    subui $sp, $sp, 1
    sw $ra, 0($sp)
    add $4, $0, $0
loop:
    lw $2, 0x73000($0)
    lw $3, 0x73001($0)
    seqi $11, $3, 4 #button2
    bnez $11, parallel_exit

base10:
    seqi $11, $3, 2 #button1
    beqz $11, base16
    addi $4, $0, 1 #set b1
base16:
    seqi $11, $3, 1 #button0
    beqz $11, print
    add $4, $0, $0 
print:
    beqz $4, writeb16ssd
    bnez $4, writeb10ssd

parallel_exit:
    lw $ra, 0($sp)
    addui $sp, $sp, 1
    jr $ra

writeb10ssd:
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
    j loop

writeb16ssd:
    sw $2, 0x73009($0)
    srli $2, $2, 4
    sw $2, 0x73008($0)
    srli $2, $2, 4
    sw $2, 0x73007($0)
    srli $2, $2, 4
    sw $2, 0x73006($0)
    j loop







