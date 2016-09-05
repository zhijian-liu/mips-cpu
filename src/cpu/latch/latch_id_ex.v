module latch_id_ex(
    input   wire        clock,
    input   wire        reset,
    input   wire[5:0]   stall,

    input   wire[31:0]  id_instruction,
    input   wire[7:0]   id_operator,
    input   wire[2:0]   id_category,
    input   wire[31:0]  id_operand_a,
    input   wire[31:0]  id_operand_b,
    input   wire        id_register_write_enable,
    input   wire[4:0]   id_register_write_address,
    input   wire[31:0]  id_register_write_data,

    output  reg[31:0]   ex_instruction,
    output  reg[7:0]    ex_operator,
    output  reg[2:0]    ex_category,
    output  reg[31:0]   ex_operand_a,
    output  reg[31:0]   ex_operand_b,
    output  reg         ex_register_write_enable,
    output  reg[4:0]    ex_register_write_address,
    output  reg[31:0]   ex_register_write_data
);
    always @ (posedge clock) begin
        if (reset == `RESET_ENABLE) begin
            ex_instruction              <= 32'b0;
            ex_operator                 <= `OPERATOR_NOP;
            ex_category                 <= `CATEGORY_NONE;
            ex_operand_a                <= 32'b0;
            ex_operand_b                <= 32'b0;
            ex_register_write_enable    <= `WRITE_DISABLE;
            ex_register_write_address   <= 32'b0;
            ex_register_write_data      <= 32'b0;
        end
        else if (stall[2] == `STALL_ENABLE && stall[3] == `STALL_DISABLE) begin
            ex_instruction              <= 32'b0;
            ex_operator                 <= `OPERATOR_NOP;
            ex_category                 <= `CATEGORY_NONE;
            ex_operand_a                <= 32'b0;
            ex_operand_b                <= 32'b0;
            ex_register_write_enable    <= `WRITE_DISABLE;
            ex_register_write_address   <= 32'b0;
            ex_register_write_data      <= 32'b0;
        end
        else if (stall[2] == `STALL_DISABLE) begin
            ex_instruction              <= id_instruction;
            ex_operator                 <= id_operator;
            ex_category                 <= id_category;
            ex_operand_a                <= id_operand_a;
            ex_operand_b                <= id_operand_b;
            ex_register_write_enable    <= id_register_write_enable;
            ex_register_write_address   <= id_register_write_address;
            ex_register_write_data      <= id_register_write_data;
        end
    end
endmodule