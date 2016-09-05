module stage_if(
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,

    input   wire        register_pc_write_enable,
    input   wire[31:0]  register_pc_write_data,
    output  reg[31:0]   register_pc_read_data
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            register_pc_read_data <= 32'b0;
        end
        else if (stall[0] == `STALL_DISABLE) begin
            if (register_pc_write_enable == `WRITE_ENABLE) begin
                register_pc_read_data <= register_pc_write_data;      
            end
            else begin
                register_pc_read_data <= register_pc_read_data + 32'd4;
            end
        end
    end
endmodule