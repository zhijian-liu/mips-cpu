module stage_id(
	input	wire		reset,
	input	wire[31:0]	register_pc,
	input	wire[31:0]	instruction,
	input	wire[31:0]	register_a_read_data,
	input	wire[31:0]	register_b_read_data,
	output	reg 		register_a_read_enable,
	output	reg 		register_b_read_enable,
	output	reg[5:0]	register_a_read_address,
	output	reg[5:0]	register_b_read_address,
	output	reg[8:0]	alu_operator,
	output	reg[3:0]	alu_....,
	output	reg[3:0]	alu_operand_a
	output	reg[]		alu_operand_b
	output	reg	 		write_enable,
	output	reg[5:0]	write_address
);



endmodule