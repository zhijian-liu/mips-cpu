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