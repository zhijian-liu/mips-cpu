module stage_if(
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,

    output  reg         chip_enable,

    output  reg[31:0]   register_pc_read_data
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
            register_pc_read_data <= 32'b0;
        end
        else if (stall[0] == `STALL_DISABLE) begin
            register_pc_read_data <= register_pc_read_data + 32'd4;
        end
    end
endmodule