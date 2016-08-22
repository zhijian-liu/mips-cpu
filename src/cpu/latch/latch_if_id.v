module register_if_id(
	input	wire		clock,
	input	wire		reset,
	
	input	wire[31:0]	if_register_pc,
	input	wire[31:0]	if_instruction,
	
	output	reg[31:0]	id_register_pc,
	output	reg[31:0]	id_instruction
);

always @ (posedge clock) begin
	if (reset == 1) begin
		id_register_pc <= 0;
		id_instruction <= 0;
	end
	else begin
		id_register_pc <= if_register_pc;
		id_instruction <= if_instruction;
	end
end

endmodule