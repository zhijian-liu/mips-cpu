module latch_ex_mem(
    input             clock                       ,
    input             reset                       ,
    input      [ 5:0] stall                       ,
    input      [31:0] ex_instruction              ,
    output reg [31:0] mem_instruction             ,
    input      [ 7:0] ex_operator                 ,
    output reg [ 7:0] mem_operator                ,
    input      [31:0] ex_operand_a                ,
    output reg [31:0] mem_operand_a               ,
    input      [31:0] ex_operand_b                ,
    output reg [31:0] mem_operand_b               ,
    input             ex_register_write_enable    ,
    output reg        mem_register_write_enable   ,
    input      [ 4:0] ex_register_write_address   ,
    output reg [ 4:0] mem_register_write_address  ,
    input      [31:0] ex_register_write_data      ,
    output reg [31:0] mem_register_write_data     ,
    input             ex_register_hi_write_enable ,
    output reg        mem_register_hi_write_enable,
    input      [31:0] ex_register_hi_write_data   ,
    output reg [31:0] mem_register_hi_write_data  ,
    input             ex_register_lo_write_enable ,
    output reg        mem_register_lo_write_enable,
    input      [31:0] ex_register_lo_write_data   ,
    output reg [31:0] mem_register_lo_write_data   
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE || (stall[3] == `STALL_ENABLE && stall[4] == `STALL_DISABLE)) begin
            mem_instruction              <= 32'b0         ;
            mem_operator                 <= `OPERATOR_NOP ;
            mem_operand_a                <= 32'b0         ;
            mem_operand_b                <= 32'b0         ;
            mem_register_write_enable    <= `WRITE_DISABLE;
            mem_register_write_address   <= 5'b0          ;
            mem_register_write_data      <= 32'b0         ;
            mem_register_hi_write_enable <= `WRITE_DISABLE;
            mem_register_hi_write_data   <= 32'b0         ;
            mem_register_lo_write_enable <= `WRITE_DISABLE;
            mem_register_lo_write_data   <= 32'b0         ;
        end
        else if (stall[3] == `STALL_DISABLE) begin
            mem_instruction              <= ex_instruction             ;
            mem_operator                 <= ex_operator                ;
            mem_operand_a                <= ex_operand_a               ;
            mem_operand_b                <= ex_operand_b               ;
            mem_register_write_enable    <= ex_register_write_enable   ;
            mem_register_write_address   <= ex_register_write_address  ;
            mem_register_write_data      <= ex_register_write_data     ;
            mem_register_hi_write_enable <= ex_register_hi_write_enable;
            mem_register_hi_write_data   <= ex_register_hi_write_data  ;
            mem_register_lo_write_enable <= ex_register_lo_write_enable;
            mem_register_lo_write_data   <= ex_register_lo_write_data  ;
        end
    end
endmodule