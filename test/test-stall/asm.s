.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start

_start:
    ori $1, $0, 0x1234
    sw  $1, 0x0($0)
    ori $2, $0, 0x1234
    ori $1, $0, 0x0
    lw  $1, 0x0($0)
    beq $1, $2, label
    nop
    ori $1, $0, 0x4567
    nop

label:
    ori $1, $0, 0x89ab
    nop
    
_loop:
    j _loop
    nop
