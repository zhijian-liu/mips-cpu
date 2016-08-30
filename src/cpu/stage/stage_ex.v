module stage_ex(
    input   wire        reset,

    input   wire[7:0]   operator,
    input   wire[2:0]   category,
    input   wire[31:0]  operand_a,
    input   wire[31:0]  operand_b,
    
    input   wire        register_write_enable_,
    input   wire[4:0]   register_write_address_,

    output  reg         register_write_enable,
    output  reg[4:0]    register_write_address,
    output  reg[31:0]   register_write_data
);
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

    always @ (*) begin
        register_write_enable <= register_write_enable_;
        register_write_address <= register_write_address_;
        
        case (category)
            `CATEGORY_LOGIC : begin
                register_write_data <= result_logic;
            end
            `CATEGORY_SHIFT : begin
                register_write_data <= result_shift;
            end
            default : begin
                register_write_data <= 32'b0;
            end
        endcase
    end
endmodule