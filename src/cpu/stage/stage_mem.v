module stage_mem(
	input	wire		reset,

	//	input
	input	wire 		ex_register_write_enable,
	input	wire[4:0]	ex_register_write_address,
	input	wire[31:0]	ex_register_write_data,

	//	output
	output	reg 		register_write_enable,
	output	reg[4:0]	register_write_address,
	output	reg[31:0]	register_write_data
);

endmodule