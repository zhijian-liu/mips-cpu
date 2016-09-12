.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start

_start:
    add $1, $0, 5

loop:
    sub $1, $1, 1
    beqz $1, merge
    nop
    j loop
    nop

merge:
    add $1, $1, 1
    add $1, $1, 1
