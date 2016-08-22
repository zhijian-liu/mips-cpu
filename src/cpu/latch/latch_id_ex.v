module latch_id_ex(
	input	wire		clock,
	input	wire		reset,

	//	input
	input	wire[7:0]	id_operator,
	input	wire[2:0]	id_category,
	input	wire[31:0]	id_operand_a,
	input	wire[31:0]	id_operand_b,
	input	wire 		id_register_write_enable,
	input	wire[4:0]	id_register_write_address,

	//	output
	output	reg[7:0]	ex_operator,
	output	reg[2:0]	ex_category,
	output	reg[31:0]	ex_operand_a,
	output	reg[31:0]	ex_operand_b,
	output	reg 		ex_register_write_enable,
	output	reg[4:0]	ex_register_write_address
);
	always @ (posedge clock) begin
		if (reset == 1) begin
			ex_operator <= 0;
			ex_category <= 0;
			ex_operand_a <= 0;
			ex_operand_b <= 0;
			ex_register_write_enable <= 0;
			ex_register_write_address <= 0;
		end
		else begin
			ex_operator <= id_operator;
			ex_category <= id_category;
			ex_operand_a <= id_operand_a;
			ex_operand_b <= id_operand_b;
			ex_register_write_enable <= id_register_write_enable;
			ex_register_write_address <= id_register_write_address;
		end
	end
endmodule