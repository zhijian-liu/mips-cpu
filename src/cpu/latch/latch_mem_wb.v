module latch_mem_wb (
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,

    input   wire        mem_register_write_enable,
    input   wire[4:0]   mem_register_write_address,
    input   wire[31:0]  mem_register_write_data,
    input   wire        mem_register_hi_write_enable,
    input   wire[31:0]  mem_register_hi_write_data,
    input   wire        mem_register_lo_write_enable,
    input   wire[31:0]  mem_register_lo_write_data,

    output  reg         wb_register_write_enable,
    output  reg[4:0]    wb_register_write_address,
    output  reg[31:0]   wb_register_write_data,
    output  reg         wb_register_hi_write_enable,
    output  reg[31:0]   wb_register_hi_write_data,
    output  reg         wb_register_lo_write_enable,
    output  reg[31:0]   wb_register_lo_write_data
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            wb_register_write_enable    <= `WRITE_DISABLE;
            wb_register_write_address   <= 5'b0;
            wb_register_write_data      <= 32'b0;
            wb_register_hi_write_enable <= `WRITE_DISABLE;
            wb_register_hi_write_data   <= 32'b0;
            wb_register_lo_write_enable <= `WRITE_DISABLE;
            wb_register_lo_write_data   <= 32'b0;
        end
        else if (stall[4] == `STALL_ENABLE && stall[5] == `STALL_DISABLE) begin
            wb_register_write_enable    <= `WRITE_DISABLE;
            wb_register_write_address   <= 5'b0;
            wb_register_write_data      <= 32'b0;
            wb_register_hi_write_enable <= `WRITE_DISABLE;
            wb_register_hi_write_data   <= 32'b0;
            wb_register_lo_write_enable <= `WRITE_DISABLE;
            wb_register_lo_write_data   <= 32'b0;
        end
        else if (stall[4] == `STALL_DISABLE) begin
            wb_register_write_enable    <= mem_register_write_enable;
            wb_register_write_address   <= mem_register_write_address;
            wb_register_write_data      <= mem_register_write_data;
            wb_register_hi_write_enable <= mem_register_hi_write_enable;
            wb_register_hi_write_data   <= mem_register_hi_write_data;
            wb_register_lo_write_enable <= mem_register_lo_write_enable;
            wb_register_lo_write_data   <= mem_register_lo_write_data;
        end
    end
endmodule