module latch_if_id(
	input	wire		clock,
	input	wire		reset,
	
	//	input
	input	wire[31:0]	if_program_counter,
	input	wire[31:0]	if_instruction,
	
	//	output
	output	reg[31:0]	id_program_counter,
	output	reg[31:0]	id_instruction
);
	always @ (posedge clock) begin
		if (reset == 1) begin
			id_program_counter <= 0;
			id_instruction <= 0;
		end
		else begin
			id_program_counter <= if_program_counter;
			id_instruction <= if_instruction;
		end
	end
endmodule