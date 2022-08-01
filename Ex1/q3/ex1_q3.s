.text 
.global main   
		
       
main: 
	add $1, $0, $0
	add $2, $0, $0
	add $3, $0, $0
	jal readswitches
loop:
	andi $3, $1, 1
	add $2, $2, $3 
	srli $1, $1, 1 

    bnez $1, loop

    lw $2, encryption($2)

	jal writessd
	j main

.data
encryption:
	.word 0xA3 #c0
	.word 0x22 #c1
	.word 0x6B #c2
	.word 0x0D #c3
	.word 0x49 #c4
	.word 0xC0 #c5	
	.word 0x7F #c6
	.word 0xB8 #c7
	.word 0x31 #c8

	


