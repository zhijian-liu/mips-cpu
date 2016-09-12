.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start

_start:
    add $1, $0, $0
    addi $2, $0, 4
    add $3, $0, $0

loop:
    lw $4, 80($1)
    addi $1, $1, 4
    add $3, $3, $4
    addi $2, $2, 0xffff
    bne $2, $0, loop
    nop
    sw $3, 80($1)
    lw $4, 80($1)
    sub $3, $4, $1
    addi $2, $0, 3

loop2:
    addi $2, $2, 0xffff
    ori $3, $2, 0xffff
    addi $4, $0, 0xffff
    andi $5, $4, 0xffff
    or $6, $5, $4
    and $7, $5, $6
    beq $2, $0, shift
    nop
    j loop2
    nop

shift: 
    addi $2, $0, 0xffff
    sll $3, $2, 15
    sll $3, $3, 16
    sra $3, $3, 16
    srl $3, $3, 15

finish:
    j finish
    nop