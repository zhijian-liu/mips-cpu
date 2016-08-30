module stage_id(
    input   wire        reset,

    input   wire[31:0]  register_pc,
    input   wire[31:0]  instruction,
    
    //  register read port A
    output  reg         register_read_enable_a,
    output  reg[4:0]    register_read_address_a,
    input   wire[31:0]  register_read_data_a,

    //  register read port B
    output  reg         register_read_enable_b,
    output  reg[4:0]    register_read_address_b,
    input   wire[31:0]  register_read_data_b,
    
    output  reg[7:0]    operator,
    output  reg[2:0]    category,
    output  reg[31:0]   operand_a,
    output  reg[31:0]   operand_b,

    output  reg         register_write_enable,
    output  reg[4:0]    register_write_address,

    //  forwarding from stage ex
    input   wire        ex_register_write_enable,
    input   wire[4:0]   ex_register_write_address,
    input   wire[31:0]  ex_register_write_data,

    //  forwarding from stage mem
    input   wire        mem_register_write_enable,
    input   wire[4:0]   mem_register_write_address,
    input   wire[31:0]  mem_register_write_data
);
    reg[31:0]   immediate_value;
    reg         instruction_valid;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_read_enable_a <= `READ_DISABLE;
            register_read_address_a <= 5'b0;
            register_read_enable_b <= `READ_DISABLE;
            register_read_address_b <= 5'b0;
            operator <= `OPERATOR_NOP;
            category <= `CATEGORY_NOP;
            register_write_enable <= `WRITE_DISABLE;
            register_write_address <= 5'b0;
            immediate_value <= 32'b0;
            instruction_valid <= `INSTRUCTION_VALID;
        end
        else begin
            register_read_enable_a <= `READ_DISABLE;
            register_read_address_a <= instruction[25:21];
            register_read_enable_b <= `READ_DISABLE;
            register_read_address_b <= instruction[20:16];
            operator <= `OPERATOR_NOP;
            category <= `CATEGORY_NOP;
            register_write_enable <= `WRITE_DISABLE;
            register_write_address <= instruction[15:11];
            immediate_value <= 32'b0;
            instruction_valid <= `INSTRUCTION_INVALID;

            case (instruction[31:26])
                6'b000000 : begin
                    case (instruction[10:6])
                        5'b00000 : begin
                            case (instruction[5:0])
                                `OPCODE_AND : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_AND;
                                    category <= `CATEGORY_LOGIC;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_OR : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_OR;
                                    category <= `CATEGORY_LOGIC;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_XOR : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_XOR;
                                    category <= `CATEGORY_LOGIC;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_NOR : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_NOR;
                                    category <= `CATEGORY_LOGIC;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SLLV : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_SLL;
                                    category <= `CATEGORY_SHIFT;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SRLV : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_SRL;
                                    category <= `CATEGORY_SHIFT;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SRAV : begin
                                    register_read_enable_a <= `READ_ENABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_SRA;
                                    category <= `CATEGORY_SHIFT;
                                    register_write_enable <= `WRITE_ENABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SYNC : begin
                                    register_read_enable_a <= `READ_DISABLE;
                                    register_read_enable_b <= `READ_ENABLE;
                                    operator <= `OPERATOR_NOP;
                                    category <= `CATEGORY_NOP;
                                    register_write_enable <= `WRITE_DISABLE;
                                    instruction_valid <= `INSTRUCTION_VALID;
                                end
                                default : begin
                                    
                                end
                            endcase
                        end
                        default : begin
                            
                        end
                    endcase
                end
                `OPCODE_ANDI : begin
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    operator <= `OPERATOR_AND;
                    category <= `CATEGORY_LOGIC;
                    register_write_enable <= `WRITE_ENABLE;
                    register_write_address <= instruction[20:16];
                    immediate_value <= {16'b0, instruction[15:0]};
                    instruction_valid <= `INSTRUCTION_VALID;
                end
                `OPCODE_ORI : begin
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    operator <= `OPERATOR_OR;
                    category <= `CATEGORY_LOGIC;
                    register_write_enable <= `WRITE_ENABLE;
                    register_write_address <= instruction[20:16];
                    immediate_value <= {16'b0, instruction[15:0]};
                    instruction_valid <= `INSTRUCTION_VALID;
                end
                `OPCODE_XORI : begin
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    operator <= `OPERATOR_XOR;
                    category <= `CATEGORY_LOGIC;
                    register_write_enable <= `WRITE_ENABLE;
                    register_write_address <= instruction[20:16];
                    immediate_value <= {16'b0, instruction[15:0]};
                    instruction_valid <= `INSTRUCTION_VALID;
                end
                `OPCODE_LUI : begin
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    operator <= `OPERATOR_OR;
                    category <= `CATEGORY_LOGIC;
                    register_write_enable <= `WRITE_ENABLE;
                    register_write_address <= instruction[20:16];
                    immediate_value <= {instruction[15:0], 16'b0};
                    instruction_valid <= `INSTRUCTION_VALID;
                end
                `OPCODE_ORI : begin
                    register_read_enable_a <= `READ_DISABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    operator <= `OPERATOR_NOP;
                    category <= `CATEGORY_NOP;
                    register_write_enable <= `WRITE_DISABLE;
                    instruction_valid <= `INSTRUCTION_VALID;
                end
                default : begin

                end
            endcase

            if (instruction[31:21] == 11'b0) begin
                case (instruction[5:0])
                    `OPCODE_SLL : begin
                        register_read_enable_a <= `READ_DISABLE;
                        register_read_enable_b <= `READ_ENABLE;
                        operator <= `OPERATOR_SLL;
                        category <= `CATEGORY_SHIFT;
                        register_write_enable <= `WRITE_ENABLE;
                        register_write_address <= instruction[15:11];
                        immediate_value[4:0] <= instruction[10:6];
                        instruction_valid <= `INSTRUCTION_VALID;
                    end
                    `OPCODE_SRL : begin
                        register_read_enable_a <= `READ_DISABLE;
                        register_read_enable_b <= `READ_ENABLE;
                        operator <= `OPERATOR_SRL;
                        category <= `CATEGORY_SHIFT;
                        register_write_enable <= `WRITE_ENABLE;
                        register_write_address <= instruction[15:11];
                        immediate_value[4:0] <= instruction[10:6];
                        instruction_valid <= `INSTRUCTION_VALID;
                    end
                    `OPCODE_SRA : begin
                        register_read_enable_a <= `READ_DISABLE;
                        register_read_enable_b <= `READ_ENABLE;
                        operator <= `OPERATOR_SRA;
                        category <= `CATEGORY_SHIFT;
                        register_write_enable <= `WRITE_ENABLE;
                        register_write_address <= instruction[15:11];
                        immediate_value[4:0] <= instruction[10:6];
                        instruction_valid <= `INSTRUCTION_VALID;
                    end
                endcase
            end
        end
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            operand_a <= 32'b0;
        end
        else if (
            (register_read_enable_a == `READ_ENABLE) && 
            (ex_register_write_enable == `WRITE_ENABLE) &&
            (register_read_address_a == ex_register_write_address)
        ) begin
            operand_a <= ex_register_write_data;
        end
        else if (
            (register_read_enable_a == `READ_ENABLE) && 
            (mem_register_write_enable == `WRITE_ENABLE) && 
            (register_read_address_a == mem_register_write_address)
        ) begin
            operand_a <= mem_register_write_data;
        end
        else if (register_read_enable_a == `READ_ENABLE) begin
            operand_a <= register_read_data_a;
        end
        else if (register_read_enable_a == `READ_DISABLE) begin
            operand_a <= immediate_value;
        end
        else begin
            operand_a <= 32'b0;
        end
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            operand_b <= 32'b0;
        end
        else if (
            (register_read_enable_b == `READ_ENABLE) &&
            (ex_register_write_enable == `WRITE_ENABLE) &&
            (register_read_address_b == ex_register_write_address)
        ) begin
            operand_b <= ex_register_write_data;
        end
        else if (
            (register_read_enable_b == `READ_ENABLE) &&
            (mem_register_write_enable == `WRITE_ENABLE) &&
            (register_read_address_b == mem_register_write_address)
        ) begin
            operand_b <= mem_register_write_data;
        end
        else if (register_read_enable_b == `READ_ENABLE) begin
            operand_b <= register_read_data_b;
        end
        else if (register_read_enable_b == `READ_DISABLE) begin
            operand_b <= immediate_value;
        end
        else begin
            operand_b <= 32'b0;
        end
    end
endmodule