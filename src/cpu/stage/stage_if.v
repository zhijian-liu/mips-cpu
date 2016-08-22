module stage_if(
	input	wire 		clock,
	input	wire 		reset,

	output	reg[31:0]	register_pc,
	output	reg 		chip_enable
);

always @ (posedge clock) begin
	if (reset == 1) begin
		chip_enable <= 0;
	end
	else begin
		chip_enable <= 1;
	end
end

always @ (posedge clock) begin
	if (chip_enable == 0) begin
		register_pc <= 0;
	end
	else begin
		register_pc <= register_pc + 4;
	end
end

endmodule