.text
.global print

print:
   #create stack and back up registers
   subui $sp, $sp, 6
   sw $2, 1($sp) 
   sw $3, 2($sp) 
   sw $4, 3($sp)
   sw $5, 4($sp)
   sw $ra, 5($sp)
   #set variables to use
   lw $2, 6($sp) #get the first parameter from the stack
   add $3, $0, $2
   add $4, $0, $0 
   addi $5, $0, 0x2710
   #loop 5 times
   loop:
   slti $2, $4, 0x5
   beqz $2, pop
   div $2, $3, $5
   remi $2, $2, 0xa #get remainder of division and add ascii value
   addi $2, $2, 0x30
   sw $2, 0($sp) #put it on putc stack to print
   jal putc
   divi $5, $5, 0xa
   addi $4, $4, 0x1
   j loop

   pop:
   #restore registers 
   lw $ra, 5($sp)
   lw $5, 4($sp)
   lw $4, 3($sp)
   lw $3, 2($sp)
   lw $2, 1($sp)
   addui $sp, $sp, 6
   jr $ra