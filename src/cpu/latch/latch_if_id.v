module latch_if_id(
    input   wire        clock,
    input   wire        reset,
    
    input   wire[31:0]  if_register_pc,
    input   wire[31:0]  if_instruction,
    
    output  reg[31:0]   id_register_pc,
    output  reg[31:0]   id_instruction
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            id_register_pc <= 32'b0;
            id_instruction <= 32'b0;
        end
        else begin
            id_register_pc <= if_register_pc;
            id_instruction <= if_instruction;
        end
    end
endmodule