module rom(
    input            chip_enable ,
    input     [31:0] read_address,
    output reg[31:0] read_data
);
    reg [31:0] storage[0:1024];

    always @ (*) begin
        if (chip_enable == `CHIP_DISABLE) begin
            read_data <= 32'b0;
        end
        else begin
            read_data <= storage[read_address[18:2]];
        end
    end
endmodule