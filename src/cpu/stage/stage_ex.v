module stage_ex(
    input   wire        reset,

    input   wire[7:0]   operator,
    input   wire[2:0]   category,
    input   wire[31:0]  operand_a,
    input   wire[31:0]  operand_b,
    
    input   wire        register_write_enable_i,
    input   wire[4:0]   register_write_address_i,
    
    output  reg         register_write_enable_o,
    output  reg[4:0]    register_write_address_o,
    output  reg[31:0]   register_write_data,

    output  reg         register_hi_write_enable,
    output  reg[31:0]   register_hi_write_data,
    output  reg         register_lo_write_enable,
    output  reg[31:0]   register_lo_write_data,

    /**
     *  Forwarding from the stage `mem`.
     */
    input   wire        mem_register_hi_write_enable,
    input   wire[31:0]  mem_register_hi_write_data,
    input   wire        mem_register_lo_write_enable,
    input   wire[31:0]  mem_register_lo_write_data,

    /**
     *  Forwarding from the stage `wb`.
     */
    input   wire[31:0]  wb_register_hi_read_data,
    input   wire        wb_register_hi_write_enable,
    input   wire[31:0]  wb_register_hi_write_data,
    input   wire[31:0]  wb_register_lo_read_data,
    input   wire        wb_register_lo_write_enable,
    input   wire[31:0]  wb_register_lo_write_data
);
    /**
     *  Update the newest version of the register `hi`.
     */
    reg[31:0]   register_hi;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_hi <= 32'b0;
        end
        else if (mem_register_hi_write_enable == `WRITE_ENABLE) begin
            register_hi <= mem_register_hi_write_data;
        end
        else if (wb_register_hi_write_enable == `WRITE_ENABLE) begin
            register_hi <= wb_register_hi_write_data;
        end
        else begin
            register_hi <= wb_register_hi_read_data;
        end
    end

    /**
     *  Update the newest version of the register `lo`.
     */
    reg[31:0]   register_lo;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_lo <= 32'b0;
        end
        else if (mem_register_lo_write_enable == `WRITE_ENABLE) begin
            register_lo <= mem_register_lo_write_data;
        end
        else if (wb_register_lo_write_enable == `WRITE_ENABLE) begin
            register_lo <= wb_register_lo_write_data;
        end
        else begin
            register_lo <= wb_register_lo_read_data;
        end
    end

    /**
     *  Calculate the result for the logic instructions.
     */
    reg[31:0]   result_logic;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_logic <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_AND : begin
                    result_logic <= operand_a & operand_b;
                end
                `OPERATOR_OR : begin
                    result_logic <= operand_a | operand_b;
                end
                `OPERATOR_XOR : begin
                    result_logic <= operand_a ^ operand_b;
                end
                `OPERATOR_NOR : begin
                    result_logic <= ~(operand_a | operand_b);
                end
                default : begin
                    result_logic <= 32'b0;
                end
            endcase
        end
    end

    /**
     *  Calculate the result for the shift instructions.
     */
    reg[31:0]   result_shift;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_shift <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_SLL : begin
                    result_shift <= operand_b << operand_a[4:0];
                end
                `OPERATOR_SRL : begin
                    result_shift <= operand_b >> operand_a[4:0];
                end
                `OPERATOR_SRA : begin
                    result_shift <= ({32 {operand_b[31]}} << (6'd32 - {1'b0, operand_a[4:0]})) | operand_b >> operand_a[4:0];
                end
                default : begin
                    result_shift <= 32'b0;
                end
            endcase
        end
    end

    /**
     *  Calculate the result for the move instructions.
     */
    reg[31:0]   result_move;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_move <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_MFHI : begin
                    result_move <= register_hi;
                end
                `OPERATOR_MFLO : begin
                    result_move <= register_lo;
                end
                `OPERATOR_MOVN : begin
                    result_move <= operand_a;
                end
                `OPERATOR_MOVZ : begin
                    result_move <= operand_a;
                end
                default : begin
                    result_move <= 32'b0;
                end
            endcase
        end
    end

    reg[31:0]   result_sum;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_sum <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_SLT : begin
                    result_sum <= operand_a + (~operand_b) + 1;
                end
                `OPERATOR_SUB, `OPERATOR_SUBU : begin
                    result_sum <= operand_a + (~operand_b) + 1;
                end
                default : begin
                    result_sum <= operand_a + operand_b;
                end
            endcase
        end
    end

    /**
     *  Calculate the result for the arithmetic instructions.
     */
    reg[31:0]   result_arithmetic;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_arithmetic <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_SLT : begin
                    result_arithmetic <= (operand_a[31] && !operand_b[31]) ||
                                         (!operand_a[31] && !operand_b[31] && result_sum[31]) ||
                                         (operand_a[31] && operand_b[31] && result_sum[31]);
                end
                `OPERATOR_SLTU : begin
                    result_arithmetic <= operand_a < operand_b;
                end
                `OPERATOR_ADD, `OPERATOR_ADDU, `OPERATOR_SUB, `OPERATOR_SUBU : begin
                    result_arithmetic <= result_sum;
                end
                `OPERATOR_CLZ : begin
                    result_arithmetic <= operand_a[31] ? 0 :
                                         operand_a[30] ? 1 :
                                         operand_a[29] ? 2 :
                                         operand_a[28] ? 3 :
                                         operand_a[27] ? 4 :
                                         operand_a[26] ? 5 :
                                         operand_a[25] ? 6 :
                                         operand_a[24] ? 7 :
                                         operand_a[23] ? 8 :
                                         operand_a[22] ? 9 :
                                         operand_a[21] ? 10 :
                                         operand_a[20] ? 11 :
                                         operand_a[19] ? 12 :
                                         operand_a[18] ? 13 :
                                         operand_a[17] ? 14 :
                                         operand_a[16] ? 15 :
                                         operand_a[15] ? 16 :
                                         operand_a[14] ? 17 :
                                         operand_a[13] ? 18 :
                                         operand_a[12] ? 19 :
                                         operand_a[11] ? 20 :
                                         operand_a[10] ? 21 :
                                         operand_a[9] ? 22 :
                                         operand_a[8] ? 23 :
                                         operand_a[7] ? 24 :
                                         operand_a[6] ? 25 :
                                         operand_a[5] ? 26 :
                                         operand_a[4] ? 27 :
                                         operand_a[3] ? 28 :
                                         operand_a[2] ? 29 :
                                         operand_a[1] ? 30 :
                                         operand_a[0] ? 31 : 32;
                end
                `OPERATOR_CLO : begin
                    result_arithmetic <= !operand_a[31] ? 0 :
                                         !operand_a[30] ? 1 :
                                         !operand_a[29] ? 2 :
                                         !operand_a[28] ? 3 :
                                         !operand_a[27] ? 4 :
                                         !operand_a[26] ? 5 :
                                         !operand_a[25] ? 6 :
                                         !operand_a[24] ? 7 :
                                         !operand_a[23] ? 8 :
                                         !operand_a[22] ? 9 :
                                         !operand_a[21] ? 10 :
                                         !operand_a[20] ? 11 :
                                         !operand_a[19] ? 12 :
                                         !operand_a[18] ? 13 :
                                         !operand_a[17] ? 14 :
                                         !operand_a[16] ? 15 :
                                         !operand_a[15] ? 16 :
                                         !operand_a[14] ? 17 :
                                         !operand_a[13] ? 18 :
                                         !operand_a[12] ? 19 :
                                         !operand_a[11] ? 20 :
                                         !operand_a[10] ? 21 :
                                         !operand_a[9] ? 22 :
                                         !operand_a[8] ? 23 :
                                         !operand_a[7] ? 24 :
                                         !operand_a[6] ? 25 :
                                         !operand_a[5] ? 26 :
                                         !operand_a[4] ? 27 :
                                         !operand_a[3] ? 28 :
                                         !operand_a[2] ? 29 :
                                         !operand_a[1] ? 30 :
                                         !operand_a[0] ? 31 : 32;
                end
                default : begin
                    result_arithmetic <= 32'b0;
                end
            endcase
        end
    end

    always @ (*) begin
        register_write_enable_o     <= register_write_enable_i;
        register_write_address_o    <= register_write_address_i;
        
        case (category)
            `CATEGORY_LOGIC : begin
                register_write_data <= result_logic;
            end
            `CATEGORY_SHIFT : begin
                register_write_data <= result_shift;
            end
            `CATEGORY_MOVE : begin
                register_write_data <= result_move;
            end
            `CATEGORY_ARITHMETIC : begin
                register_write_data <= result_arithmetic;
            end
            default : begin
                register_write_data <= 32'b0;
            end
        endcase
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_hi_write_enable    <= `WRITE_DISABLE;
            register_hi_write_data      <= 32'b0;
            register_lo_write_enable    <= `WRITE_DISABLE;
            register_lo_write_data      <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_MTHI : begin
                    register_hi_write_enable    <= `WRITE_ENABLE;
                    register_hi_write_data      <= operand_a;
                    register_lo_write_enable    <= `WRITE_DISABLE;
                    register_lo_write_data      <= 32'b0;
                end
                `OPERATOR_MTLO : begin
                    register_hi_write_enable    <= `WRITE_DISABLE;
                    register_hi_write_data      <= 32'b0;
                    register_lo_write_enable    <= `WRITE_ENABLE;
                    register_lo_write_data      <= operand_a;
                end
                default : begin
                    register_hi_write_enable    <= `WRITE_DISABLE;
                    register_hi_write_data      <= 32'b0;
                    register_lo_write_enable    <= `WRITE_DISABLE;
                    register_lo_write_data      <= 32'b0;
                end
            endcase
        end
    end
endmodule