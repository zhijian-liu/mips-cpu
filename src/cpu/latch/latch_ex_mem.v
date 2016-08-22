module latch_ex_mem(
	input	wire		clock,
	input	wire		reset,

	//	input
	input	wire 		ex_register_write_enable,
	input	wire[4:0]	ex_register_write_address,
	input	wire[31:0]	ex_register_write_data,

	//	output
	output	reg			mem_register_write_enable,
	output	reg[4:0]	mem_register_write_address,
	output	reg[31:0]	mem_register_write_data
);
	always @ (posedge reset) begin
		if (reset == 1) begin
			mem_register_write_enable <= 0;
			mem_register_write_address <= 0;
			mem_register_write_data <= 0;
		end
		else begin
			mem_register_write_enable <= ex_register_write_enable;
			mem_register_write_address <= ex_register_write_address;
			mem_register_write_data <= ex_register_write_data;
		end
	end
endmodule