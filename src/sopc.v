module sopc(
    input   wire    clock,
    input   wire    reset
);
    wire        rom_chip_enable;
    wire[31:0]  rom_read_address;
    wire[31:0]  rom_read_data;

    wire        ram_chip_enable;
    wire        ram_read_enable;
    wire[31:0]  ram_read_address;
    wire[31:0]  ram_read_data;
    wire        ram_write_enable;
    wire[31:0]  ram_write_address;
    wire[3:0]   ram_write_select;
    wire[31:0]  ram_write_data;

    cpu cpu(
        .clock(clock),
        .reset(reset),
        .rom_read_address(rom_read_address),
        .rom_read_data(rom_read_data),
        .ram_read_enable(ram_read_enable),
        .ram_read_address(ram_read_address),
        .ram_read_data(ram_read_data),
        .ram_write_enable(ram_write_enable),
        .ram_write_address(ram_write_address),
        .ram_write_select(ram_write_select),
        .ram_write_data(ram_write_data)
    );

    rom rom(
        .chip_enable(rom_chip_enable),
        .read_address(rom_read_address),
        .read_data(rom_read_data)
    );

    assign rom_chip_enable = (reset == `RESET_ENABLE) ? `CHIP_DISABLE : `CHIP_ENABLE;

    ram ram(
        .clock(clock),
        .chip_enable(ram_chip_enable),
        .read_enable(ram_read_enable),
        .read_address(ram_read_address),
        .read_data(ram_read_data),
        .write_enable(ram_write_enable),
        .write_address(ram_write_address),
        .write_select(ram_write_select),
        .write_data(ram_write_data)
    );

    assign ram_chip_enable = (reset == `RESET_ENABLE) ? `CHIP_DISABLE : `CHIP_ENABLE;
endmodule