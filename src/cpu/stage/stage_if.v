module stage_if(
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,

    output  reg[31:0]   register_pc,
    output  reg         chip_enable
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            chip_enable <= `CHIP_DISABLE;
        end
        else begin
            chip_enable <= `CHIP_ENABLE;
        end
    end

    always @ (posedge clock) begin
        if (chip_enable == `CHIP_DISABLE) begin
            register_pc <= 32'b0;
        end
        else if (stall[0] == `STALL_DISABLE) begin
            register_pc <= register_pc + 32'd4;
        end
    end
endmodule