module stage_ex(
	input	wire		reset,

	input	wire[7:0]	operator,
	input	wire[2:0]	category,
	input	wire[31:0]	operand_a,
	input	wire[31:0]	operand_b,
	
	//	input
	input	wire 		id_register_write_enable,
	input	wire[4:0]	id_register_write_address,

	//	output
	output	reg 		register_write_enable,
	output	reg[4:0]	register_write_address,
	output	reg[31:0]	register_write_data
);
	reg[31:0] result;

	always @ (*) begin
		if (reset == 1) begin
			result <= 0;
		end else begin
			case (operator)
				6'b001101 :	begin
					result <= operand_a | operand_b;
				end
				default : begin
					result <= 0;
				end
			endcase
		end
	end

	always @ (*) begin
		
	end
endmodule