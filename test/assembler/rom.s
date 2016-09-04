   .org 0x0  
   .set noat  
   .global _start  
_start:  
   ori  $1,$0,0xffff                    
   sll  $1,$1,16  
   ori  $1,$1,0xfffb           # $1 = -5    给$1赋初值  
   ori  $2,$0,6                # $2 = 6     给$2赋初值  
   mul  $3,$1,$2               # $3 = -30 = 0xffffffe2  
                               # $1乘以$2，有符号乘法，结果的低32位保存到$3  
    
   mult $1,$2                  # HI = 0xffffffff  
                               # LO = 0xffffffe2  
                               # $1乘以$2，有符号乘法，结果保存到HI、LO寄存器  
  
   multu $1,$2                 # HI = 0x5  
                               # LO = 0xffffffe2  
                               # $1乘以$2，无符号乘法，结果保存到HI、LO寄存器  
   nop  
   nop  
   