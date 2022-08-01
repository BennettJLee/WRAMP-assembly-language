.text
.global main  

main: 
	jal readswitches
	add $2, $0, $1
	jal write
	j main
write:
	subui $sp, $sp, 2
    	sw $2, 0($sp)
    	sw $ra, 1($sp)
   	sw $2, 0x73009($0)
  	srli $2, $2, 4
   	sw $2, 0x73008($0)
 	srli $2, $2, 4
 	sw $2, 0x73007($0)
    	srli $2, $2, 4
    	sw $2, 0x73006($0)
    	lw $2, 0($sp)
    	lw $ra, 1($sp)
    	addui $sp, $sp, 2
    	jr $ra