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
    wire[31:0]  operand_a_complement;
    wire[31:0]  operand_b_complement;

    assign operand_a_complement = ~operand_a + 1;
    assign operand_b_complement = ~operand_b + 1;

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


    reg[31:0]   operand_sum;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            operand_sum <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_SLT, `OPERATOR_SUB, `OPERATOR_SUBU : begin
                    operand_sum <= operand_a + operand_b_complement;
                end
                default : begin
                    operand_sum <= operand_a + operand_b;
                end
            endcase
        end
    end

    /**
     *  Calculate the result for the arithmetic instructions.
     */
    reg[63:0]   result_arithmetic;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_arithmetic <= 32'b0;
        end
        else begin
            case (operator)
                `OPERATOR_SLT : begin
                    result_arithmetic <= (operand_a[31] == 1'b1 && operand_b[31] == 1'b0) ||
                                         (operand_a[31] == 1'b0 && operand_b[31] == 1'b0 && operand_sum[31] == 1'b1) ||
                                         (operand_a[31] == 1'b1 && operand_b[31] == 1'b1 && operand_sum[31] == 1'b1);
                end
                `OPERATOR_SLTU : begin
                    result_arithmetic <= operand_a < operand_b;
                end
                `OPERATOR_ADD, `OPERATOR_ADDU, `OPERATOR_SUB, `OPERATOR_SUBU : begin
                    result_arithmetic <= operand_sum;
                end
                `OPERATOR_CLZ : begin
                    result_arithmetic <= operand_a[31] == 1'b1 ? 32'd0 :
                                         operand_a[30] == 1'b1 ? 32'd1 :
                                         operand_a[29] == 1'b1 ? 32'd2 :
                                         operand_a[28] == 1'b1 ? 32'd3 :
                                         operand_a[27] == 1'b1 ? 32'd4 :
                                         operand_a[26] == 1'b1 ? 32'd5 :
                                         operand_a[25] == 1'b1 ? 32'd6 :
                                         operand_a[24] == 1'b1 ? 32'd7 :
                                         operand_a[23] == 1'b1 ? 32'd8 :
                                         operand_a[22] == 1'b1 ? 32'd9 :
                                         operand_a[21] == 1'b1 ? 32'd10 :
                                         operand_a[20] == 1'b1 ? 32'd11 :
                                         operand_a[19] == 1'b1 ? 32'd12 :
                                         operand_a[18] == 1'b1 ? 32'd13 :
                                         operand_a[17] == 1'b1 ? 32'd14 :
                                         operand_a[16] == 1'b1 ? 32'd15 :
                                         operand_a[15] == 1'b1 ? 32'd16 :
                                         operand_a[14] == 1'b1 ? 32'd17 :
                                         operand_a[13] == 1'b1 ? 32'd18 :
                                         operand_a[12] == 1'b1 ? 32'd19 :
                                         operand_a[11] == 1'b1 ? 32'd20 :
                                         operand_a[10] == 1'b1 ? 32'd21 :
                                         operand_a[9] == 1'b1 ? 32'd22 :
                                         operand_a[8] == 1'b1 ? 32'd23 :
                                         operand_a[7] == 1'b1 ? 32'd24 :
                                         operand_a[6] == 1'b1 ? 32'd25 :
                                         operand_a[5] == 1'b1 ? 32'd26 :
                                         operand_a[4] == 1'b1 ? 32'd27 :
                                         operand_a[3] == 1'b1 ? 32'd28 :
                                         operand_a[2] == 1'b1 ? 32'd29 :
                                         operand_a[1] == 1'b1 ? 32'd30 :
                                         operand_a[0] == 1'b1 ? 32'd31 : 32'd32;
                end
                `OPERATOR_CLO : begin
                    result_arithmetic <= operand_a[31] == 1'b0 ? 32'd0 :
                                         operand_a[30] == 1'b0 ? 32'd1 :
                                         operand_a[29] == 1'b0 ? 32'd2 :
                                         operand_a[28] == 1'b0 ? 32'd3 :
                                         operand_a[27] == 1'b0 ? 32'd4 :
                                         operand_a[26] == 1'b0 ? 32'd5 :
                                         operand_a[25] == 1'b0 ? 32'd6 :
                                         operand_a[24] == 1'b0 ? 32'd7 :
                                         operand_a[23] == 1'b0 ? 32'd8 :
                                         operand_a[22] == 1'b0 ? 32'd9 :
                                         operand_a[21] == 1'b0 ? 32'd10 :
                                         operand_a[20] == 1'b0 ? 32'd11 :
                                         operand_a[19] == 1'b0 ? 32'd12 :
                                         operand_a[18] == 1'b0 ? 32'd13 :
                                         operand_a[17] == 1'b0 ? 32'd14 :
                                         operand_a[16] == 1'b0 ? 32'd15 :
                                         operand_a[15] == 1'b0 ? 32'd16 :
                                         operand_a[14] == 1'b0 ? 32'd17 :
                                         operand_a[13] == 1'b0 ? 32'd18 :
                                         operand_a[12] == 1'b0 ? 32'd19 :
                                         operand_a[11] == 1'b0 ? 32'd20 :
                                         operand_a[10] == 1'b0 ? 32'd21 :
                                         operand_a[9] == 1'b0 ? 32'd22 :
                                         operand_a[8] == 1'b0 ? 32'd23 :
                                         operand_a[7] == 1'b0 ? 32'd24 :
                                         operand_a[6] == 1'b0 ? 32'd25 :
                                         operand_a[5] == 1'b0 ? 32'd26 :
                                         operand_a[4] == 1'b0 ? 32'd27 :
                                         operand_a[3] == 1'b0 ? 32'd28 :
                                         operand_a[2] == 1'b0 ? 32'd29 :
                                         operand_a[1] == 1'b0 ? 32'd30 :
                                         operand_a[0] == 1'b0 ? 32'd31 : 32'd32;
                end
                `OPERATOR_MULT, `OPERATOR_MUL : begin
                	if (operand_a[31] == 1'b0 && operand_b[31] == 1'b0) begin
                		result_arithmetic <= operand_a * operand_b;
                	end
                	else if (operand_a[31] == 1'b0 && operand_b[31] == 1'b1) begin
                		result_arithmetic <= ~(operand_a * operand_b_complement) + 1;
                	end
                	else if (operand_a[31] == 1'b1 && operand_b[31] == 1'b0) begin
                		result_arithmetic <= ~(operand_a_complement * operand_b) + 1;
                	end
                	else if (operand_a[31] == 1'b1 && operand_b[31] == 1'b1) begin
                		result_arithmetic <= operand_a_complement * operand_b_complement;
                	end
                end
                `OPERATOR_MULTU : begin
            		result_arithmetic <= operand_a * operand_b;
                end
                default : begin
                    result_arithmetic <= 32'b0;
                end
            endcase
        end
    end

    always @ (*) begin
        case (operator)
            `OPERATOR_ADD : begin
                if ((operand_a[31] == 1'b0 && operand_b[31] == 1'b0 && operand_sum[31] == 1'b1) ||
                    (operand_a[31] == 1'b1 && operand_b[31] == 1'b1 && operand_sum[31] == 1'b0)
                ) begin
                    register_write_enable_o <= `WRITE_DISABLE;
                end
                else begin
                    register_write_enable_o <= register_write_enable_i;
                end
            end
            `OPERATOR_SUB : begin
                if ((operand_a[31] == 1'b0 && operand_b_complement[31] == 1'b0 && operand_sum[31] == 1'b1) ||
                    (operand_a[31] == 1'b1 && operand_b_complement[31] == 1'b1 && operand_sum[31] == 1'b0)
                ) begin
                    register_write_enable_o <= `WRITE_DISABLE;
                end
                else begin
                    register_write_enable_o <= register_write_enable_i;
                end
            end
            default : begin
                register_write_enable_o <= register_write_enable_i;
            end
        endcase
        register_write_address_o <= register_write_address_i;
        
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
                register_write_data <= result_arithmetic[31:0];
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
                `OPERATOR_MULT, `OPERATOR_MULTU : begin
                    register_hi_write_enable    <= `WRITE_ENABLE;
                    register_hi_write_data      <= result_arithmetic[63:32];
                    register_lo_write_enable    <= `WRITE_ENABLE;
                    register_lo_write_data      <= result_arithmetic[31:0];
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