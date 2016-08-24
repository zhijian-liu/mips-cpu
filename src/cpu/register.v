module register(
	input	wire 		clock,
	input	wire 		reset,

	//	read port A
	input	wire 		read_enable_a,
	input 	wire[4:0]	read_address_a,
	output	reg[31:0]	read_data_a,

	//	read port B
	input	wire 		read_enable_b,
	input 	wire[4:0]	read_address_b,
	output	reg[31:0]	read_data_b,

	//	write port
	input	wire 		write_enable,
	input	wire[4:0] 	write_address,
	input	wire[31:0]	write_data
);
	reg[31:0]	storage[31:0];

	initial begin: initialize
		integer i;
		for (i = 0; i < 32; ++i) begin
			storage[i] = 0;
		end
	end

	always @ (posedge clock) begin
		if (reset == 0) begin
			if ((write_enable == 1) && (write_address != 0)) begin
				storage[write_address] <= write_data;
			end
		end
	end

	always @ (*) begin
		if (reset == 1) begin
			read_data_a <= 0;
		end
		else if (read_address_a == 0) begin
			read_data_a <= 0;
		end
		else if ((read_enable_a == 1) && (write_enable == 1) && (read_data_a == write_address)) begin
			read_data_a <= write_data;
		end
		else if (read_enable_a == 1) begin
			read_data_a <= storage[read_address_a];
		end
		else begin
			read_data_a <= 0;
		end
	end

	always @ (*) begin
		if (reset == 1) begin
			read_data_b <= 0;
		end
		else if (read_address_b == 0) begin
			read_data_b <= 0;
		end
		else if ((read_enable_b == 1) && (write_enable == 1) && (read_data_b == write_address)) begin
			read_data_b <= write_data;
		end
		else if (read_enable_b == 1) begin
			read_data_b <= storage[read_address_b];
		end
		else begin
			read_data_b <= 0;
		end
	end
endmodule