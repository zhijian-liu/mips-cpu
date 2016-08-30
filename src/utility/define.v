`define CHIP_ENABLE             1'b1
`define CHIP_DISABLE            1'b0

`define RESET_ENABLE            1'b1
`define RESET_DISABLE           1'b0

`define READ_ENABLE             1'b1
`define READ_DISABLE            1'b0

`define WRITE_ENABLE            1'b1
`define WRITE_DISABLE           1'b0

`define INSTRUCTION_VALID       1'b1
`define INSTRUCTION_INVALID     1'b0

`define OPCODE_AND              6'b100100
`define OPCODE_OR               6'b100101
`define OPCODE_XOR              6'b100110
`define OPCODE_NOR              6'b100111
`define OPCODE_ANDI             6'b001100
`define OPCODE_ORI              6'b001101
`define OPCODE_XORI             6'b001110
`define OPCODE_LUI              6'b001111
  
`define OPCODE_SLL              6'b000000
`define OPCODE_SLLV             6'b000100
`define OPCODE_SRL              6'b000010
`define OPCODE_SRLV             6'b000110
`define OPCODE_SRA              6'b000011
`define OPCODE_SRAV             6'b000111
  
`define OPCODE_SYNC             6'b001111
`define OPCODE_PREF             6'b110011

`define OPERATOR_NOP            8'b00000000
`define OPERATOR_AND            8'b00000001
`define OPERATOR_OR             8'b00000010
`define OPERATOR_XOR            8'b00000011
`define OPERATOR_NOR            8'b00000100
`define OPERATOR_SLL            8'b00000101
`define OPERATOR_SRL            8'b00000110
`define OPERATOR_SRA            8'b00000111

`define CATEGORY_NOP            3'b000
`define CATEGORY_LOGIC          3'b001
`define CATEGORY_SHIFT          3'b010