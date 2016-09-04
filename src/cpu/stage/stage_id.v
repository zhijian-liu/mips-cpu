module stage_id(
    input   wire        reset,

    input   wire[31:0]  instruction,

    input   wire[31:0]  register_pc_read_data,
    
    /**
     *  Register read port A.
     */
    output  reg         register_read_enable_a,
    output  reg[4:0]    register_read_address_a,
    input   wire[31:0]  register_read_data_a,

    /**
     *  Register read port B.
     */
    output  reg         register_read_enable_b,
    output  reg[4:0]    register_read_address_b,
    input   wire[31:0]  register_read_data_b,
    
    output  reg[7:0]    operator,
    output  reg[2:0]    category,
    output  reg[31:0]   operand_a,
    output  reg[31:0]   operand_b,

    output  reg         register_write_enable,
    output  reg[4:0]    register_write_address,

    /**
     *  Forwarding from the stage `ex`.
     */
    input   wire        ex_register_write_enable,
    input   wire[4:0]   ex_register_write_address,
    input   wire[31:0]  ex_register_write_data,

    /**
     *  Forwarding from the stage `mem`.
     */
    input   wire        mem_register_write_enable,
    input   wire[4:0]   mem_register_write_address,
    input   wire[31:0]  mem_register_write_data,

    output  reg         stall_request
);
    reg[31:0]   immediate_value;
    reg         instruction_valid;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            register_read_enable_a  <= `READ_DISABLE;
            register_read_address_a <= 5'b0;
            register_read_enable_b  <= `READ_DISABLE;
            register_read_address_b <= 5'b0;
            operator                <= `OPERATOR_NOP;
            category                <= `CATEGORY_NONE;
            register_write_enable   <= `WRITE_DISABLE;
            register_write_address  <= 5'b0;
            immediate_value         <= 32'b0;
            instruction_valid       <= `INSTRUCTION_VALID;
        end
        else begin
            register_read_enable_a  <= `READ_DISABLE;
            register_read_address_a <= instruction[25:21];
            register_read_enable_b  <= `READ_DISABLE;
            register_read_address_b <= instruction[20:16];
            operator                <= `OPERATOR_NOP;
            category                <= `CATEGORY_NONE;
            register_write_enable   <= `WRITE_DISABLE;
            register_write_address  <= instruction[15:11];
            immediate_value         <= 32'b0;
            instruction_valid       <= `INSTRUCTION_INVALID;

            case (instruction[31:26])
                6'b000000 : begin
                    case (instruction[10:6])
                        5'b00000 : begin
                            case (instruction[5:0])
                                `OPCODE_AND : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_AND;
                                    category                <= `CATEGORY_LOGIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_OR : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_OR;
                                    category                <= `CATEGORY_LOGIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_XOR : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_XOR;
                                    category                <= `CATEGORY_LOGIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_NOR : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_NOR;
                                    category                <= `CATEGORY_LOGIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SLLV : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SLL;
                                    category                <= `CATEGORY_SHIFT;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SRLV : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SRL;
                                    category                <= `CATEGORY_SHIFT;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SRAV : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SRA;
                                    category                <= `CATEGORY_SHIFT;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SYNC : begin
                                    register_read_enable_a  <= `READ_DISABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_NOP;
                                    category                <= `CATEGORY_NONE;
                                    register_write_enable   <= `WRITE_DISABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MFHI : begin
                                    register_read_enable_a  <= `READ_DISABLE;
                                    register_read_enable_b  <= `READ_DISABLE;
                                    operator                <= `OPERATOR_MFHI;
                                    category                <= `CATEGORY_MOVE;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MFLO : begin
                                    register_read_enable_a  <= `READ_DISABLE;
                                    register_read_enable_b  <= `READ_DISABLE;
                                    operator                <= `OPERATOR_MFLO;
                                    category                <= `CATEGORY_MOVE;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MTHI : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_DISABLE;
                                    operator                <= `OPERATOR_MTHI;
                                    category                <= `CATEGORY_MOVE;
                                    register_write_enable   <= `WRITE_DISABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MTLO : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_DISABLE;
                                    operator                <= `OPERATOR_MTLO;
                                    category                <= `CATEGORY_MOVE;
                                    register_write_enable   <= `WRITE_DISABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MOVN : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_MOVN;
                                    category                <= `CATEGORY_MOVE;
                                    register_write_enable   <= (operand_b == 32'b0) ? `WRITE_DISABLE : `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MOVZ : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_MOVZ;
                                    category                <= `CATEGORY_MOVE;
                                    register_write_enable   <= (operand_b == 32'b0) ? `WRITE_ENABLE : `WRITE_DISABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SLT : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SLT;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SLTU : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SLTU;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_ADD : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_ADD;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_ADDU : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_ADDU;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SUB : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SUB;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_SUBU : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_SUBU;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_ENABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MULT : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_MULT;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_DISABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                `OPCODE_MULTU : begin
                                    register_read_enable_a  <= `READ_ENABLE;
                                    register_read_enable_b  <= `READ_ENABLE;
                                    operator                <= `OPERATOR_MULTU;
                                    category                <= `CATEGORY_ARITHMETIC;
                                    register_write_enable   <= `WRITE_DISABLE;
                                    instruction_valid       <= `INSTRUCTION_VALID;
                                end
                                default : begin

                                end
                            endcase
                        end
                        default : begin

                        end
                    endcase
                end
                6'b011100 : begin
                    case (instruction[5:0])
                        `OPCODE_CLZ : begin
                            register_read_enable_a  <= `READ_ENABLE;
                            register_read_enable_b  <= `READ_DISABLE;
                            operator                <= `OPERATOR_CLZ;
                            category                <= `CATEGORY_ARITHMETIC;
                            register_write_enable   <= `WRITE_ENABLE;
                            instruction_valid       <= `INSTRUCTION_VALID;
                        end
                        `OPCODE_CLO : begin
                            register_read_enable_a  <= `READ_ENABLE;
                            register_read_enable_b  <= `READ_DISABLE;
                            operator                <= `OPERATOR_CLO;
                            category                <= `CATEGORY_ARITHMETIC;
                            register_write_enable   <= `WRITE_ENABLE;
                            instruction_valid       <= `INSTRUCTION_VALID;
                        end
                        `OPCODE_MUL : begin
                            register_read_enable_a  <= `READ_ENABLE;
                            register_read_enable_b  <= `READ_ENABLE;
                            operator                <= `OPERATOR_MUL;
                            category                <= `CATEGORY_ARITHMETIC;
                            register_write_enable   <= `WRITE_ENABLE;
                            instruction_valid       <= `INSTRUCTION_VALID;
                        end
                    endcase
                end
                `OPCODE_ANDI : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_AND;
                    category                <= `CATEGORY_LOGIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {16'b0, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_ORI : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_OR;
                    category                <= `CATEGORY_LOGIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {16'b0, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_XORI : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_XOR;
                    category                <= `CATEGORY_LOGIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {16'b0, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_LUI : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_OR;
                    category                <= `CATEGORY_LOGIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {instruction[15:0], 16'b0};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_PREF : begin
                    register_read_enable_a  <= `READ_DISABLE;
                    register_read_enable_b  <= `READ_ENABLE;
                    operator                <= `OPERATOR_NOP;
                    category                <= `CATEGORY_NONE;
                    register_write_enable   <= `WRITE_DISABLE;
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_SLTI : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_SLT;
                    category                <= `CATEGORY_ARITHMETIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {{16 {instruction[15]}}, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_SLTIU : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_SLTU;
                    category                <= `CATEGORY_ARITHMETIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {{16 {instruction[15]}}, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_ADDI : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_ADD;
                    category                <= `CATEGORY_ARITHMETIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {{16 {instruction[15]}}, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                `OPCODE_ADDIU : begin
                    register_read_enable_a  <= `READ_ENABLE;
                    register_read_enable_b  <= `READ_DISABLE;
                    operator                <= `OPERATOR_ADDU;
                    category                <= `CATEGORY_ARITHMETIC;
                    register_write_enable   <= `WRITE_ENABLE;
                    register_write_address  <= instruction[20:16];
                    immediate_value         <= {{16 {instruction[15]}}, instruction[15:0]};
                    instruction_valid       <= `INSTRUCTION_VALID;
                end
                default : begin

                end
            endcase

            if (instruction[31:21] == 11'b0) begin
                case (instruction[5:0])
                    `OPCODE_SLL : begin
                        register_read_enable_a  <= `READ_DISABLE;
                        register_read_enable_b  <= `READ_ENABLE;
                        operator                <= `OPERATOR_SLL;
                        category                <= `CATEGORY_SHIFT;
                        register_write_enable   <= `WRITE_ENABLE;
                        register_write_address  <= instruction[15:11];
                        immediate_value[4:0]    <= instruction[10:6];
                        instruction_valid       <= `INSTRUCTION_VALID;
                    end
                    `OPCODE_SRL : begin
                        register_read_enable_a  <= `READ_DISABLE;
                        register_read_enable_b  <= `READ_ENABLE;
                        operator                <= `OPERATOR_SRL;
                        category                <= `CATEGORY_SHIFT;
                        register_write_enable   <= `WRITE_ENABLE;
                        register_write_address  <= instruction[15:11];
                        immediate_value[4:0]    <= instruction[10:6];
                        instruction_valid       <= `INSTRUCTION_VALID;
                    end
                    `OPCODE_SRA : begin
                        register_read_enable_a  <= `READ_DISABLE;
                        register_read_enable_b  <= `READ_ENABLE;
                        operator                <= `OPERATOR_SRA;
                        category                <= `CATEGORY_SHIFT;
                        register_write_enable   <= `WRITE_ENABLE;
                        register_write_address  <= instruction[15:11];
                        immediate_value[4:0]    <= instruction[10:6];
                        instruction_valid       <= `INSTRUCTION_VALID;
                    end
                    default : begin
                        
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