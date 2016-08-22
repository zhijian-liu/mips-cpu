module register_id_ex(
	input	wire		clock,
	input	wire		reset,

	input	wire[3:0]	id_alu_type,
	input	wire[8:0]	id_operator,
	input	wire[31:0]	id_operand_1,
	input	wire[5:0]	id_register_write_address,
	input	wire 		id_register_write_enable,

	output	wire[31:0]	oInstructionAddress,
	output	wire[31:0]	oInstructionData
);

always @ (posedge clock) begin
	if (reset == 1) begin
		oInstructionAddress <= 0;
		oInstructionData <= 0;
	end
	else begin
		oInstructionAddress <= iInstructionAddress;
		oInstructionData <= iInstructionData;
	end
end

endmodule