module stage_id(
	input	wire		reset,

	input	wire[31:0]	program_counter,
	input	wire[31:0]	instruction,
	
	//	register read port A
	output	reg 		register_read_enable_a,
	output	reg[4:0]	register_read_address_a,
	input	wire[31:0]	register_read_data_a,

	//	register read port B
	output	reg 		register_read_enable_b,
	output	reg[4:0]	register_read_address_b,
	input	wire[31:0]	register_read_data_b,
	
	output	reg[7:0]	operator,
	output	reg[3:0]	category,
	output	reg[31:0]	operand_a,
	output	reg[31:0]	operand_b,

	output	reg	 		register_write_enable,
	output	reg[4:0]	register_write_address
);

endmodule