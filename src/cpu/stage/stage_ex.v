module stage_ex(
    input             reset                       ,
    input      [31:0] instruction_i               ,
    output     [31:0] instruction_o               ,
    input      [ 7:0] operator_i                  ,
    output     [ 7:0] operator_o                  ,
    input      [ 2:0] category                    ,
    input      [31:0] operand_a_i                 ,
    output     [31:0] operand_a_o                 ,
    input      [31:0] operand_b_i                 ,
    output     [31:0] operand_b_o                 ,
    input             register_write_enable_i     ,
    output reg        register_write_enable_o     ,
    input      [ 4:0] register_write_address_i    ,
    output reg [ 4:0] register_write_address_o    ,
    input      [31:0] register_write_data_i       ,
    output reg [31:0] register_write_data_o       ,
    output reg        register_hi_write_enable    ,
    output reg [31:0] register_hi_write_data      ,
    output reg        register_lo_write_enable    ,
    output reg [31:0] register_lo_write_data      ,
    input             mem_register_hi_write_enable,
    input      [31:0] mem_register_hi_write_data  ,
    input             mem_register_lo_write_enable,
    input      [31:0] mem_register_lo_write_data  ,
    input      [31:0] wb_register_hi_read_data    ,
    input             wb_register_hi_write_enable ,
    input      [31:0] wb_register_hi_write_data   ,
    input      [31:0] wb_register_lo_read_data    ,
    input             wb_register_lo_write_enable ,
    input      [31:0] wb_register_lo_write_data   ,
    output reg        stall_request                
);
    wire [31:0] operand_a_complement = ~operand_a_i + 1;
    wire [31:0] operand_b_complement = ~operand_b_i + 1;
    wire [31:0] operand_sum          = operand_a_i + (operator_i == `OPERATOR_SLT  ||
                                                      operator_i == `OPERATOR_SUB  ||
                                                      operator_i == `OPERATOR_SUBU ?
                                                      operand_b_complement :
                                                      operand_b_i
                                                     );

    assign instruction_o = instruction_i;
    assign operator_o    = operator_i   ;
    assign operand_a_o   = operand_a_i  ;
    assign operand_b_o   = operand_b_i  ;

    reg [31:0] register_hi;
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

    reg [31:0] register_lo;
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

    reg [31:0] result_logic;
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_logic <= 32'b0;
        end
        else begin
            case (operator_i)
                `OPERATOR_AND : begin
                    result_logic <= operand_a_i & operand_b_i;
                end
                `OPERATOR_OR : begin
                    result_logic <= operand_a_i | operand_b_i;
                end
                `OPERATOR_XOR : begin
                    result_logic <= operand_a_i ^ operand_b_i;
                end
                `OPERATOR_NOR : begin
                    result_logic <= ~(operand_a_i | operand_b_i);
                end
                default : begin
                    result_logic <= 32'b0;
                end
            endcase
        end
    end

    reg [31:0] result_shift;
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_shift <= 32'b0;
        end
        else begin
            case (operator_i)
                `OPERATOR_SLL : begin
                    result_shift <= operand_b_i << operand_a_i[4:0];
                end
                `OPERATOR_SRL : begin
                    result_shift <= operand_b_i >> operand_a_i[4:0];
                end
                `OPERATOR_SRA : begin
                    result_shift <= ({32 {operand_b_i[31]}} << (6'd32 - {1'b0, operand_a_i[4:0]})) | operand_b_i >> operand_a_i[4:0];
                end
                default : begin
                    result_shift <= 32'b0;
                end
            endcase
        end
    end

    reg [31:0] result_move;
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_move <= 32'b0;
        end
        else begin
            case (operator_i)
                `OPERATOR_MFHI : begin
                    result_move <= register_hi;
                end
                `OPERATOR_MFLO : begin
                    result_move <= register_lo;
                end
                `OPERATOR_MOVN : begin
                    result_move <= operand_a_i;
                end
                `OPERATOR_MOVZ : begin
                    result_move <= operand_a_i;
                end
                default : begin
                    result_move <= 32'b0;
                end
            endcase
        end
    end

    reg [63:0] result_arithmetic;
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_arithmetic <= 32'b0;
        end
        else begin
            case (operator_i)
                `OPERATOR_SLT : begin
                    result_arithmetic <= (operand_a_i[31] == 1'b1 && operand_b_i[31] == 1'b0)                            ||
                                         (operand_a_i[31] == 1'b0 && operand_b_i[31] == 1'b0 && operand_sum[31] == 1'b1) ||
                                         (operand_a_i[31] == 1'b1 && operand_b_i[31] == 1'b1 && operand_sum[31] == 1'b1);
                end
                `OPERATOR_SLTU : begin
                    result_arithmetic <= operand_a_i < operand_b_i;
                end
                `OPERATOR_ADD, `OPERATOR_ADDU, `OPERATOR_SUB, `OPERATOR_SUBU : begin
                    result_arithmetic <= operand_sum;
                end
                `OPERATOR_CLZ : begin
                    result_arithmetic <= operand_a_i[31] == 1'b1 ? 32'd0 :
                                         operand_a_i[30] == 1'b1 ? 32'd1 :
                                         operand_a_i[29] == 1'b1 ? 32'd2 :
                                         operand_a_i[28] == 1'b1 ? 32'd3 :
                                         operand_a_i[27] == 1'b1 ? 32'd4 :
                                         operand_a_i[26] == 1'b1 ? 32'd5 :
                                         operand_a_i[25] == 1'b1 ? 32'd6 :
                                         operand_a_i[24] == 1'b1 ? 32'd7 :
                                         operand_a_i[23] == 1'b1 ? 32'd8 :
                                         operand_a_i[22] == 1'b1 ? 32'd9 :
                                         operand_a_i[21] == 1'b1 ? 32'd10 :
                                         operand_a_i[20] == 1'b1 ? 32'd11 :
                                         operand_a_i[19] == 1'b1 ? 32'd12 :
                                         operand_a_i[18] == 1'b1 ? 32'd13 :
                                         operand_a_i[17] == 1'b1 ? 32'd14 :
                                         operand_a_i[16] == 1'b1 ? 32'd15 :
                                         operand_a_i[15] == 1'b1 ? 32'd16 :
                                         operand_a_i[14] == 1'b1 ? 32'd17 :
                                         operand_a_i[13] == 1'b1 ? 32'd18 :
                                         operand_a_i[12] == 1'b1 ? 32'd19 :
                                         operand_a_i[11] == 1'b1 ? 32'd20 :
                                         operand_a_i[10] == 1'b1 ? 32'd21 :
                                         operand_a_i[9]  == 1'b1 ? 32'd22 :
                                         operand_a_i[8]  == 1'b1 ? 32'd23 :
                                         operand_a_i[7]  == 1'b1 ? 32'd24 :
                                         operand_a_i[6]  == 1'b1 ? 32'd25 :
                                         operand_a_i[5]  == 1'b1 ? 32'd26 :
                                         operand_a_i[4]  == 1'b1 ? 32'd27 :
                                         operand_a_i[3]  == 1'b1 ? 32'd28 :
                                         operand_a_i[2]  == 1'b1 ? 32'd29 :
                                         operand_a_i[1]  == 1'b1 ? 32'd30 :
                                         operand_a_i[0]  == 1'b1 ? 32'd31 :
                                                                   32'd32 ;
                end
                `OPERATOR_CLO : begin
                    result_arithmetic <= operand_a_i[31] == 1'b0 ? 32'd0 :
                                         operand_a_i[30] == 1'b0 ? 32'd1 :
                                         operand_a_i[29] == 1'b0 ? 32'd2 :
                                         operand_a_i[28] == 1'b0 ? 32'd3 :
                                         operand_a_i[27] == 1'b0 ? 32'd4 :
                                         operand_a_i[26] == 1'b0 ? 32'd5 :
                                         operand_a_i[25] == 1'b0 ? 32'd6 :
                                         operand_a_i[24] == 1'b0 ? 32'd7 :
                                         operand_a_i[23] == 1'b0 ? 32'd8 :
                                         operand_a_i[22] == 1'b0 ? 32'd9 :
                                         operand_a_i[21] == 1'b0 ? 32'd10 :
                                         operand_a_i[20] == 1'b0 ? 32'd11 :
                                         operand_a_i[19] == 1'b0 ? 32'd12 :
                                         operand_a_i[18] == 1'b0 ? 32'd13 :
                                         operand_a_i[17] == 1'b0 ? 32'd14 :
                                         operand_a_i[16] == 1'b0 ? 32'd15 :
                                         operand_a_i[15] == 1'b0 ? 32'd16 :
                                         operand_a_i[14] == 1'b0 ? 32'd17 :
                                         operand_a_i[13] == 1'b0 ? 32'd18 :
                                         operand_a_i[12] == 1'b0 ? 32'd19 :
                                         operand_a_i[11] == 1'b0 ? 32'd20 :
                                         operand_a_i[10] == 1'b0 ? 32'd21 :
                                         operand_a_i[9]  == 1'b0 ? 32'd22 :
                                         operand_a_i[8]  == 1'b0 ? 32'd23 :
                                         operand_a_i[7]  == 1'b0 ? 32'd24 :
                                         operand_a_i[6]  == 1'b0 ? 32'd25 :
                                         operand_a_i[5]  == 1'b0 ? 32'd26 :
                                         operand_a_i[4]  == 1'b0 ? 32'd27 :
                                         operand_a_i[3]  == 1'b0 ? 32'd28 :
                                         operand_a_i[2]  == 1'b0 ? 32'd29 :
                                         operand_a_i[1]  == 1'b0 ? 32'd30 :
                                         operand_a_i[0]  == 1'b0 ? 32'd31 :
                                                                   32'd32 ;
                end
                `OPERATOR_MULT, `OPERATOR_MUL : begin
                	if (operand_a_i[31] == 1'b0 && operand_b_i[31] == 1'b0) begin
                		result_arithmetic <= operand_a_i * operand_b_i;
                	end
                	else if (operand_a_i[31] == 1'b0 && operand_b_i[31] == 1'b1) begin
                		result_arithmetic <= ~(operand_a_i * operand_b_complement) + 1;
                	end
                	else if (operand_a_i[31] == 1'b1 && operand_b_i[31] == 1'b0) begin
                		result_arithmetic <= ~(operand_a_complement * operand_b_i) + 1;
                	end
                	else if (operand_a_i[31] == 1'b1 && operand_b_i[31] == 1'b1) begin
                		result_arithmetic <= operand_a_complement * operand_b_complement;
                	end
                end
                `OPERATOR_MULTU : begin
            		result_arithmetic <= operand_a_i * operand_b_i;
                end
                default : begin
                    result_arithmetic <= 32'b0;
                end
            endcase
        end
    end

    reg [31:0] result_jump;
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            result_jump <= 32'b0;
        end
        else begin
            result_jump <= register_write_data_i;
        end
    end

    always @ (*) begin
        case (operator_i)
            `OPERATOR_ADD : begin
                if ((operand_a_i[31] == 1'b0 && operand_b_i[31] == 1'b0 && operand_sum[31] == 1'b1) ||
                    (operand_a_i[31] == 1'b1 && operand_b_i[31] == 1'b1 && operand_sum[31] == 1'b0)
                ) begin
                    register_write_enable_o <= `WRITE_DISABLE;
                end
                else begin
                    register_write_enable_o <= register_write_enable_i;
                end
            end
            `OPERATOR_SUB : begin
                if ((operand_a_i[31] == 1'b0 && operand_b_complement[31] == 1'b0 && operand_sum[31] == 1'b1) ||
                    (operand_a_i[31] == 1'b1 && operand_b_complement[31] == 1'b1 && operand_sum[31] == 1'b0)
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
                register_write_data_o <= result_logic;
            end
            `CATEGORY_SHIFT : begin
                register_write_data_o <= result_shift;
            end
            `CATEGORY_MOVE : begin
                register_write_data_o <= result_move;
            end
            `CATEGORY_ARITHMETIC : begin
                register_write_data_o <= result_arithmetic[31:0];
            end
            `CATEGORY_JUMP : begin
                register_write_data_o <= result_jump;
            end
            default : begin
                register_write_data_o <= 32'b0;
            end
        endcase
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_hi_write_enable <= `WRITE_DISABLE;
            register_hi_write_data   <= 32'b0         ;
            register_lo_write_enable <= `WRITE_DISABLE;
            register_lo_write_data   <= 32'b0         ;
        end
        else begin
            case (operator_i)
                `OPERATOR_MTHI : begin
                    register_hi_write_enable <= `WRITE_ENABLE ;
                    register_hi_write_data   <= operand_a_i   ;
                    register_lo_write_enable <= `WRITE_DISABLE;
                    register_lo_write_data   <= 32'b0         ;
                end
                `OPERATOR_MTLO : begin
                    register_hi_write_enable <= `WRITE_DISABLE;
                    register_hi_write_data   <= 32'b0         ;
                    register_lo_write_enable <= `WRITE_ENABLE ;
                    register_lo_write_data   <= operand_a_i   ;
                end
                `OPERATOR_MULT, `OPERATOR_MULTU : begin
                    register_hi_write_enable <= `WRITE_ENABLE           ;
                    register_hi_write_data   <= result_arithmetic[63:32];
                    register_lo_write_enable <= `WRITE_ENABLE           ;
                    register_lo_write_data   <= result_arithmetic[31:0] ;
                end
                default : begin
                    register_hi_write_enable <= `WRITE_DISABLE;
                    register_hi_write_data   <= 32'b0         ;
                    register_lo_write_enable <= `WRITE_DISABLE;
                    register_lo_write_data   <= 32'b0         ;
                end
            endcase
        end
    end
endmodule