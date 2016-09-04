.org 0x0
.global _start

_start:
	addi $2, $0, 4
	addi $3, $0, 4
	beq $2, $3, Label1
	addi $4, $0, 4
	j Label3
Label1:
	addi $4, $0, 3
	bne $3, $4, Label2

Label2:
	addi $5, $0, 12
	jr $5

Label3:
	jal final

final:
	addi $6, $0, 42
