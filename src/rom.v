module rom(
	input	wire		chip_enable,
	
	input	wire[31:0]	address,
	output	reg[31:0]	data
);
	reg[31:0]	storage[0:131070];

	initial begin
		$readmemh("data/rom.txt", storage);
	end

	always @ (*) begin
		if (chip_enable == 0) begin
			data <= 0;
		end
		else begin
			data <= storage[address[18:2]];
		end
	end
endmodule