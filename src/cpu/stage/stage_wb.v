module stage_wb(
    input   wire        clock,
    input   wire        reset,

    input   wire        register_hi_write_enable,
    input   wire[31:0]  register_hi_write_data,
    output  reg[31:0]   register_hi_read_data,

    input   wire        register_lo_write_enable,
    input   wire[31:0]  register_lo_write_data,
    output  reg[31:0]   register_lo_read_data
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            register_hi_read_data <= 32'b0;
        end
        else if (register_hi_write_enable) begin
            register_hi_read_data <= register_hi_write_data;
        end
    end

    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            register_lo_read_data <= 32'b0;
        end
        else if (register_lo_write_enable) begin
            register_lo_read_data <= register_lo_write_data;
        end
    end
endmodule