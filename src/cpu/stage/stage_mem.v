module stage_mem(
    input   wire        reset,

    //  input
    input   wire        register_write_enable_,
    input   wire[4:0]   register_write_address_,
    input   wire[31:0]  register_write_data_,

    //  output
    output  reg         register_write_enable,
    output  reg[4:0]    register_write_address,
    output  reg[31:0]   register_write_data
);
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_write_enable <= `WRITE_DISABLE;
            register_write_address <= 5'b0;
            register_write_data <= 32'b0;
        end
        else begin
            register_write_enable <= register_write_enable_;
            register_write_address <= register_write_address_;
            register_write_data <= register_write_data_;
        end
    end
endmodule