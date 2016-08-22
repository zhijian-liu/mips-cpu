module latch_mem_wb (
	input	wire		clock,
	input	wire		reset,

	//	input
	input	wire 		mem_register_write_enable,
	input	wire[4:0]	mem_register_write_address,
	input	wire[31:0]	mem_register_write_data,

	//	output
	output	reg			wb_register_write_enable,
	output	reg[4:0]	wb_register_write_address,
	output	reg[31:0]	wb_register_write_data
);
	always @ (posedge reset) begin
		if (reset == 1) begin
			wb_register_write_enable <= 0;
			wb_register_write_address <= 0;
			wb_register_write_data <= 0;
		end
		else begin
			wb_register_write_enable <= mem_register_write_enable;
			wb_register_write_address <= mem_register_write_address;
			wb_register_write_data <= mem_register_write_data;
		end
	end
endmodule