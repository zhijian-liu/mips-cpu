module stage_id(
	input	wire		reset,

	input	wire[31:0]	program_counter,
	input	wire[31:0]	instruction,
	
	//	register read port A
	output	reg 		register_read_enable_a,
	output	reg[4:0]	register_read_address_a,
	input	wire[31:0]	register_read_data_a,

	//	register read port B
	output	reg 		register_read_enable_b,
	output	reg[4:0]	register_read_address_b,
	input	wire[31:0]	register_read_data_b,
	
	output	reg[7:0]	operator,
	output	reg[2:0]	category,
	output	reg[31:0]	operand_a,
	output	reg[31:0]	operand_b,

	output	reg	 		register_write_enable,
	output	reg[4:0]	register_write_address
);
	reg[31:0]	immediate_value;
	reg 		instruction_valid;

	always @ (*) begin
		if (reset == 1) begin
			register_read_enable_a <= 0;
			register_read_address_a <= 0;
			register_read_enable_b <= 0;
			register_read_address_b <= 0;
			operator <= 0;
			category <= 0;
			register_write_enable <= 0;
			register_write_address <= 0;
			immediate_value <= 0;
			instruction_valid <= 1;
		end
		else begin
			register_read_enable_a <= 0;
			register_read_address_a <= instruction[25:21];
			register_read_enable_b <= 0;
			register_read_address_b <= instruction[20:16];
			operator <= 0;
			category <= 0;
			register_write_enable <= 0;
			register_write_address <= instruction[15:11];
			immediate_value <= 0;
			instruction_valid <= 0;

			case (instruction[31:26])
				6'b001101 : begin
					register_read_enable_a <= 1;
					register_read_enable_b <= 0;
					operator <= 8'b00100101;
					category <= 3'b001;
					register_write_enable <= 1;
					register_write_address <= instruction[20:16];
					immediate_value <= {16'b0, instruction[15:0]};
					instruction_valid <= 1;
				end
				default : begin
				end
			endcase
		end
	end

	always @ (*) begin
		if (reset == 1) begin
			operand_a <= 0;
		end
		else if (register_read_enable_a == 1) begin
			operand_a <= register_read_data_a;
		end
		else if (register_read_enable_a == 0) begin
			operand_a <= immediate_value;
		end
		else begin
			operand_a <= 0;
		end
	end

	always @ (*) begin
		if (reset == 1) begin
			operand_b <= 0;
		end
		else if (register_read_enable_b == 1) begin
			operand_b <= register_read_data_b;
		end
		else if (register_read_enable_b == 0) begin
			operand_b <= immediate_value;
		end
		else begin
			operand_b <= 0;
		end
	end
endmodule