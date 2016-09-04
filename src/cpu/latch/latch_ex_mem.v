module latch_ex_mem(
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,

    input   wire        ex_register_write_enable,
    input   wire[4:0]   ex_register_write_address,
    input   wire[31:0]  ex_register_write_data,
    input   wire        ex_register_hi_write_enable,
    input   wire[31:0]  ex_register_hi_write_data,
    input   wire        ex_register_lo_write_enable,
    input   wire[31:0]  ex_register_lo_write_data,

    output  reg         mem_register_write_enable,
    output  reg[4:0]    mem_register_write_address,
    output  reg[31:0]   mem_register_write_data,
    output  reg         mem_register_hi_write_enable,
    output  reg[31:0]   mem_register_hi_write_data,
    output  reg         mem_register_lo_write_enable,
    output  reg[31:0]   mem_register_lo_write_data
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            mem_register_write_enable       <= `WRITE_DISABLE;
            mem_register_write_address      <= 5'b0;
            mem_register_write_data         <= 32'b0;
            mem_register_hi_write_enable    <= `WRITE_DISABLE;
            mem_register_hi_write_data      <= 32'b0;
            mem_register_lo_write_enable    <= `WRITE_DISABLE;
            mem_register_lo_write_data      <= 32'b0;
        end
        else if (stall[3] == `STALL_ENABLE && stall[4] == `STALL_DISABLE) begin
            mem_register_write_enable       <= `WRITE_DISABLE;
            mem_register_write_address      <= 5'b0;
            mem_register_write_data         <= 32'b0;
            mem_register_hi_write_enable    <= `WRITE_DISABLE;
            mem_register_hi_write_data      <= 32'b0;
            mem_register_lo_write_enable    <= `WRITE_DISABLE;
            mem_register_lo_write_data      <= 32'b0;
        end
        else if (stall[3] == `STALL_DISABLE) begin
            mem_register_write_enable       <= ex_register_write_enable;
            mem_register_write_address      <= ex_register_write_address;
            mem_register_write_data         <= ex_register_write_data;
            mem_register_hi_write_enable    <= ex_register_hi_write_enable;
            mem_register_hi_write_data      <= ex_register_hi_write_data;
            mem_register_lo_write_enable    <= ex_register_lo_write_enable;
            mem_register_lo_write_data      <= ex_register_lo_write_data;
        end
    end
endmodule