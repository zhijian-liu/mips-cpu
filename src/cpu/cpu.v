module cpu(
	input	wire		clock,
	input	wire		reset,

	//	instruction rom
	output	wire		rom_chip_enable,
	output	wire[31:0]	rom_address,
	input	wire[31:0]	rom_data
);

endmodule