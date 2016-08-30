module sopc(
    input   wire    clock,
    input   wire    reset
);
    wire        chip_enable;
    wire[31:0]  address;
    wire[31:0]  data;

    cpu cpu(
        .clock(clock),
        .reset(reset),
        .rom_chip_enable(chip_enable),
        .rom_address(address),
        .rom_data(data)
    );

    rom rom(
        .chip_enable(chip_enable),
        .address(address),
        .data(data)
    );
endmodule