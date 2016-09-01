module stage_mem(
    input   wire        reset,

    input   wire        register_write_enable_i,
    input   wire[4:0]   register_write_address_i,
    input   wire[31:0]  register_write_data_i,

    output  reg         register_write_enable_o,
    output  reg[4:0]    register_write_address_o,
    output  reg[31:0]   register_write_data_o,

    input   wire        register_hi_write_enable_i,
    input   wire[31:0]  register_hi_write_data_i,
    input   wire        register_lo_write_enable_i,
    input   wire[31:0]  register_lo_write_data_i,

    output  reg         register_hi_write_enable_o,
    output  reg[31:0]   register_hi_write_data_o,
    output  reg         register_lo_write_enable_o,
    output  reg[31:0]   register_lo_write_data_o
);
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_write_enable_o     <= `WRITE_DISABLE;
            register_write_address_o    <= 5'b0;
            register_write_data_o       <= 32'b0;
            register_hi_write_enable_o  <= `WRITE_DISABLE;
            register_hi_write_data_o    <= 32'b0;
            register_lo_write_enable_o  <= `WRITE_DISABLE;
            register_lo_write_data_o    <= 32'b0;
        end
        else begin
            register_write_enable_o     <= register_write_enable_i;
            register_write_address_o    <= register_write_address_i;
            register_write_data_o       <= register_write_data_i;
            register_hi_write_enable_o  <= register_hi_write_enable_i;
            register_hi_write_data_o    <= register_hi_write_data_i;
            register_lo_write_enable_o  <= register_lo_write_enable_i;
            register_lo_write_data_o    <= register_lo_write_data_i;
        end
    end
endmodule