   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start

_start:
    jal start
    nop

loop:
    add $1, $1, 1
    j loop
    nop

start:
    add $1, $0, $0
    jr $ra
    nop