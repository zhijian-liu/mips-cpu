module rom(
    input   wire        chip_enable,

    input   wire[31:0]  address,
    output  reg[31:0]   data
);
    reg[31:0]   storage[0:1024];

    always @ (*) begin
        if (chip_enable == `CHIP_DISABLE) begin
            data <= 32'b0;
        end
        else begin
            data <= storage[address[18:2]];
        end
    end
endmodule