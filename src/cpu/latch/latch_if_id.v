module latch_if_id(
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,
    
    input   wire[31:0]  if_register_pc_read_data,
    input   wire[31:0]  if_instruction,
    
    output  reg[31:0]   id_register_pc_read_data,
    output  reg[31:0]   id_instruction
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            id_register_pc_read_data    <= 32'b0;
            id_instruction              <= 32'b0;
        end
        else if (stall[1] == `STALL_ENABLE && stall[2] == `STALL_DISABLE) begin
            id_register_pc_read_data    <= 32'b0;
            id_instruction              <= 32'b0;
        end
        else if (stall[1] == `STALL_DISABLE) begin
            id_register_pc_read_data    <= if_register_pc_read_data;
            id_instruction              <= if_instruction;
        end
    end
endmodule