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
`define OPCODE_MOVZ				6'b001010  
`define OPCODE_MOVN				6'b001011  
`define OPCODE_MFHI				6'b010000  
`define OPCODE_MTHI				6'b010001  
`define OPCODE_MFLO				6'b010010  
`define OPCODE_MTLO				6'b010011  
`define OPCODE_SLT   			6'b101010
`define OPCODE_SLTU  			6'b101011
`define OPCODE_SLTI  			6'b001010
`define OPCODE_SLTIU 			6'b001011
`define OPCODE_ADD   			6'b100000
`define OPCODE_ADDU  			6'b100001
`define OPCODE_SUB   			6'b100010
`define OPCODE_SUBU  			6'b100011
`define OPCODE_ADDI  			6'b001000
`define OPCODE_ADDIU 			6'b001001
`define OPCODE_CLZ   			6'b100000
`define OPCODE_CLO   			6'b100001
// `define OPCODE_MULT  			6'b011000
// `define OPCODE_MULTU 			6'b011001
// `define OPCODE_MUL   			6'b000010

`define OPERATOR_NOP            8'b00000000
`define OPERATOR_AND            8'b00000001
`define OPERATOR_OR             8'b00000010
`define OPERATOR_XOR            8'b00000011
`define OPERATOR_NOR            8'b00000100
`define OPERATOR_SLL            8'b00000101
`define OPERATOR_SRL            8'b00000110
`define OPERATOR_SRA            8'b00000111
`define OPERATOR_MOVZ			8'b00001000
`define OPERATOR_MOVN			8'b00001001
`define OPERATOR_MFHI			8'b00001010
`define OPERATOR_MTHI			8'b00001011
`define OPERATOR_MFLO			8'b00001100
`define OPERATOR_MTLO			8'b00001101
`define OPERATOR_SLT   			8'b00001110
`define OPERATOR_SLTU  			8'b00001111
`define OPERATOR_ADD   			8'b00010000
`define OPERATOR_ADDU  			8'b00010001
`define OPERATOR_SUB   			8'b00010010
`define OPERATOR_SUBU  			8'b00010011
`define OPERATOR_CLZ   			8'b00010100
`define OPERATOR_CLO   			8'b00010101
// `define OPERATOR_MULT  			8'b00000000
// `define OPERATOR_MULTU 			8'b00000000
// `define OPERATOR_MUL   			8'b00000000

`define CATEGORY_NONE           3'b000
`define CATEGORY_LOGIC          3'b001
`define CATEGORY_SHIFT          3'b010
`define CATEGORY_MOVE			3'b011
`define CATEGORY_ARITHMETIC		3'b100