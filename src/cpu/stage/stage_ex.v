module stage_ex(
	input	wire		reset,

	input	wire[2:0]	category,
	input	wire[7:0]	operator,
	input	wire[31:0]	operand_a,
	input	wire[31:0]	operand_b,
	
	input	wire[4:0]	result_address,
	input	wire		destination_write_enable,
);
	reg[31:0] result;

	always @ (*) begin
		if (reset == 1'b1) begin
			result <= 32'h00000000;
		end else begin
			case (operator)
				6'b001101 :	begin
					result <= operand_a | operand_b;
				end
				default : begin
					result <= 32'h00000000;
				end
			endcase
		end
	end

	always @ (*) begin
		
	end
endmodule