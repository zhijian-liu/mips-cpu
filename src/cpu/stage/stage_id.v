module stage_id(
    input             reset                     ,
    input      [31:0] instruction_i             ,
    output     [31:0] instruction_o             ,
    output reg [ 7:0] operator                  ,
    output reg [ 2:0] category                  ,
    output reg [31:0] operand_a                 ,
    output reg [31:0] operand_b                 ,
    output reg        register_read_enable_a    ,
    output reg [ 4:0] register_read_address_a   ,
    input      [31:0] register_read_data_a      ,
    output reg        register_read_enable_b    ,
    output reg [ 4:0] register_read_address_b   ,
    input      [31:0] register_read_data_b      ,
    output reg        register_write_enable     ,
    output reg [ 4:0] register_write_address    ,
    output reg [31:0] register_write_data       ,
    input      [31:0] register_pc_read_data     ,
    output reg        register_pc_write_enable  ,
    output reg [31:0] register_pc_write_data    ,
    input      [ 7:0] ex_operator               ,
    input             ex_register_write_enable  ,
    input      [ 4:0] ex_register_write_address ,
    input      [31:0] ex_register_write_data    ,
    input             mem_register_write_enable ,
    input      [ 4:0] mem_register_write_address,
    input      [31:0] mem_register_write_data   ,
    output reg        stall_request
);
    wire [31:0] register_pc_next      = register_pc_read_data + 32'd4                                            ;
    wire [31:0] register_pc_next_next = register_pc_read_data + 32'd8                                            ;
    wire [31:0] register_pc_branch    = register_pc_next + {{14 {instruction_i[15]}}, instruction_i[15:0], 2'b00};

    assign instruction_o = instruction_i;

    reg [31:0] immediate_value;

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            operator                 <= `OPERATOR_NOP ;
            category                 <= `CATEGORY_NONE;
            register_read_enable_a   <= `READ_DISABLE ;
            register_read_address_a  <= 5'b0          ;
            register_read_enable_b   <= `READ_DISABLE ;
            register_read_address_b  <= 5'b0          ;
            register_write_enable    <= `WRITE_DISABLE;
            register_write_address   <= 5'b0          ;
            register_write_data      <= 32'b0         ;
            register_pc_write_enable <= `WRITE_DISABLE;
            register_pc_write_data   <= 32'b0         ;
            immediate_value          <= 32'b0         ;
        end
        else begin
            operator                 <= `OPERATOR_NOP       ;
            category                 <= `CATEGORY_NONE      ;
            register_read_enable_a   <= `READ_DISABLE       ;
            register_read_address_a  <= instruction_i[25:21];
            register_read_enable_b   <= `READ_DISABLE       ;
            register_read_address_b  <= instruction_i[20:16];
            register_write_enable    <= `WRITE_DISABLE      ;
            register_write_address   <= instruction_i[15:11];
            register_write_data      <= 32'b0               ;
            register_pc_write_enable <= `WRITE_DISABLE      ;
            register_pc_write_data   <= 32'b0               ;
            immediate_value          <= 32'b0               ;

            case (instruction_i[31:26])
                6'b000000 : begin
                    case (instruction_i[10:6])
                        5'b00000 : begin
                            case (instruction_i[5:0])
                                `OPCODE_AND : begin
                                    operator               <= `OPERATOR_AND  ;
                                    category               <= `CATEGORY_LOGIC;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_OR : begin
                                    operator               <= `OPERATOR_OR   ;
                                    category               <= `CATEGORY_LOGIC;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_XOR : begin
                                    operator               <= `OPERATOR_XOR  ;
                                    category               <= `CATEGORY_LOGIC;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_NOR : begin
                                    operator               <= `OPERATOR_NOR  ;
                                    category               <= `CATEGORY_LOGIC;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_SLLV : begin
                                    operator               <= `OPERATOR_SLL  ;
                                    category               <= `CATEGORY_SHIFT;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_SRLV : begin
                                    operator               <= `OPERATOR_SRL  ;
                                    category               <= `CATEGORY_SHIFT;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_SRAV : begin
                                    operator               <= `OPERATOR_SRA  ;
                                    category               <= `CATEGORY_SHIFT;
                                    register_read_enable_a <= `READ_ENABLE   ;
                                    register_read_enable_b <= `READ_ENABLE   ;
                                    register_write_enable  <= `WRITE_ENABLE  ;
                                end
                                `OPCODE_SYNC : begin
                                    operator               <= `OPERATOR_NOP ;
                                    category               <= `CATEGORY_NONE;
                                    register_read_enable_a <= `READ_DISABLE ;
                                    register_read_enable_b <= `READ_ENABLE  ;
                                    register_write_enable  <= `WRITE_DISABLE;
                                end
                                `OPCODE_MFHI : begin
                                    operator               <= `OPERATOR_MFHI;
                                    category               <= `CATEGORY_MOVE;
                                    register_read_enable_a <= `READ_DISABLE ;
                                    register_read_enable_b <= `READ_DISABLE ;
                                    register_write_enable  <= `WRITE_ENABLE ;
                                end
                                `OPCODE_MFLO : begin
                                    operator               <= `OPERATOR_MFLO;
                                    category               <= `CATEGORY_MOVE;
                                    register_read_enable_a <= `READ_DISABLE ;
                                    register_read_enable_b <= `READ_DISABLE ;
                                    register_write_enable  <= `WRITE_ENABLE ;
                                end
                                `OPCODE_MTHI : begin
                                    operator               <= `OPERATOR_MTHI;
                                    category               <= `CATEGORY_MOVE;
                                    register_read_enable_a <= `READ_ENABLE  ;
                                    register_read_enable_b <= `READ_DISABLE ;
                                    register_write_enable  <= `WRITE_DISABLE;
                                end
                                `OPCODE_MTLO : begin
                                    operator               <= `OPERATOR_MTLO;
                                    category               <= `CATEGORY_MOVE;
                                    register_read_enable_a <= `READ_ENABLE  ;
                                    register_read_enable_b <= `READ_DISABLE ;
                                    register_write_enable  <= `WRITE_DISABLE;
                                end
                                `OPCODE_MOVN : begin
                                    operator               <= `OPERATOR_MOVN                                       ;
                                    category               <= `CATEGORY_MOVE                                       ;
                                    register_read_enable_a <= `READ_ENABLE                                         ;
                                    register_read_enable_b <= `READ_ENABLE                                         ;
                                    register_write_enable  <= (operand_b == 32'b0) ? `WRITE_DISABLE : `WRITE_ENABLE;
                                end
                                `OPCODE_MOVZ : begin
                                    operator               <= `OPERATOR_MOVZ                                       ;
                                    category               <= `CATEGORY_MOVE                                       ;
                                    register_read_enable_a <= `READ_ENABLE                                         ;
                                    register_read_enable_b <= `READ_ENABLE                                         ;
                                    register_write_enable  <= (operand_b == 32'b0) ? `WRITE_ENABLE : `WRITE_DISABLE;
                                end
                                `OPCODE_SLT : begin
                                    operator               <= `OPERATOR_SLT       ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_ENABLE       ;
                                end
                                `OPCODE_SLTU : begin
                                    operator               <= `OPERATOR_SLTU      ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_ENABLE       ;
                                end
                                `OPCODE_ADD : begin
                                    operator               <= `OPERATOR_ADD       ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_ENABLE       ;
                                end
                                `OPCODE_ADDU : begin
                                    operator               <= `OPERATOR_ADDU      ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_ENABLE       ;
                                end
                                `OPCODE_SUB : begin
                                    operator               <= `OPERATOR_SUB       ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_ENABLE       ;
                                end
                                `OPCODE_SUBU : begin
                                    operator               <= `OPERATOR_SUBU      ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_ENABLE       ;
                                end
                                `OPCODE_MULT : begin
                                    operator               <= `OPERATOR_MULT      ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_DISABLE      ;
                                end
                                `OPCODE_MULTU : begin
                                    operator               <= `OPERATOR_MULTU     ;
                                    category               <= `CATEGORY_ARITHMETIC;
                                    register_read_enable_a <= `READ_ENABLE        ;
                                    register_read_enable_b <= `READ_ENABLE        ;
                                    register_write_enable  <= `WRITE_DISABLE      ;
                                end
                                `OPCODE_JR : begin
                                    operator                    <= `OPERATOR_JR  ;
                                    category                    <= `CATEGORY_JUMP;
                                    register_read_enable_a      <= `READ_ENABLE  ;
                                    register_read_enable_b      <= `READ_DISABLE ;
                                    register_write_enable       <= `WRITE_DISABLE;
                                    register_pc_write_enable    <= `WRITE_ENABLE ;
                                    register_pc_write_data      <= operand_a     ;
                                end
                                `OPCODE_JALR : begin
                                    operator                    <= `OPERATOR_JALR       ;
                                    category                    <= `CATEGORY_JUMP       ;
                                    register_read_enable_a      <= `READ_ENABLE         ;
                                    register_read_enable_b      <= `READ_DISABLE        ;
                                    register_write_enable       <= `WRITE_ENABLE        ;
                                    register_write_address      <= instruction_i[15:11] ;
                                    register_write_data         <= register_pc_next_next;
                                    register_pc_write_enable    <= `WRITE_ENABLE        ;
                                    register_pc_write_data      <= operand_a            ;
                                end
                            endcase
                        end
                    endcase
                end
                6'b000001 : begin
                    case (instruction_i[20:16])
                        `OPCODE_BGEZ : begin
                            operator                 <= `OPERATOR_BGEZ                                          ;
                            category                 <= `CATEGORY_JUMP                                          ;
                            register_read_enable_a   <= `READ_ENABLE                                            ;
                            register_read_enable_b   <= `READ_DISABLE                                           ;
                            register_write_enable    <= `WRITE_DISABLE                                          ;
                            register_pc_write_enable <= (operand_a[31] == 1'b0) ? `WRITE_ENABLE : `WRITE_DISABLE;
                            register_pc_write_data   <= register_pc_branch                                      ;
                        end
                        `OPCODE_BGEZAL : begin
                            operator                 <= `OPERATOR_BGEZAL                                        ;
                            category                 <= `CATEGORY_JUMP                                          ;
                            register_read_enable_a   <= `READ_ENABLE                                            ;
                            register_read_enable_b   <= `READ_DISABLE                                           ;
                            register_write_enable    <= `WRITE_ENABLE                                           ;
                            register_write_address   <= 5'b11111                                                ;
                            register_write_data      <= register_pc_next_next                                   ;
                            register_pc_write_enable <= (operand_a[31] == 1'b0) ? `WRITE_ENABLE : `WRITE_DISABLE;
                            register_pc_write_data   <= register_pc_branch                                      ;
                        end
                        `OPCODE_BLTZ : begin
                            operator                 <= `OPERATOR_BLTZ                                          ;
                            category                 <= `CATEGORY_JUMP                                          ;
                            register_read_enable_a   <= `READ_ENABLE                                            ;
                            register_read_enable_b   <= `READ_DISABLE                                           ;
                            register_write_enable    <= `WRITE_DISABLE                                          ;
                            register_pc_write_enable <= (operand_a[31] == 1'b1) ? `WRITE_ENABLE : `WRITE_DISABLE;
                            register_pc_write_data   <= register_pc_branch                                      ;
                        end
                        `OPCODE_BLTZAL : begin
                            operator                 <= `OPERATOR_BLTZAL                                        ;
                            category                 <= `CATEGORY_JUMP                                          ;
                            register_read_enable_a   <= `READ_ENABLE                                            ;
                            register_read_enable_b   <= `READ_DISABLE                                           ;
                            register_write_enable    <= `WRITE_ENABLE                                           ;
                            register_write_address   <= 5'b11111                                                ;
                            register_write_data      <= register_pc_read_data + 32'd8                           ;
                            register_pc_write_enable <= (operand_a[31] == 1'b1) ? `WRITE_ENABLE : `WRITE_DISABLE;
                            register_pc_write_data   <= register_pc_branch                                      ;
                        end
                    endcase
                end
                6'b011100 : begin
                    case (instruction_i[5:0])
                        `OPCODE_CLZ : begin
                            register_read_enable_a  <= `READ_ENABLE;
                            register_read_enable_b  <= `READ_DISABLE;
                            operator                <= `OPERATOR_CLZ;
                            category                <= `CATEGORY_ARITHMETIC;
                            register_write_enable   <= `WRITE_ENABLE;
                        end
                        `OPCODE_CLO : begin
                            register_read_enable_a  <= `READ_ENABLE;
                            register_read_enable_b  <= `READ_DISABLE;
                            operator                <= `OPERATOR_CLO;
                            category                <= `CATEGORY_ARITHMETIC;
                            register_write_enable   <= `WRITE_ENABLE;
                        end
                        `OPCODE_MUL : begin
                            register_read_enable_a  <= `READ_ENABLE;
                            register_read_enable_b  <= `READ_ENABLE;
                            operator                <= `OPERATOR_MUL;
                            category                <= `CATEGORY_ARITHMETIC;
                            register_write_enable   <= `WRITE_ENABLE;
                        end
                    endcase
                end
                `OPCODE_ANDI : begin
                    operator               <= `OPERATOR_AND               ;
                    category               <= `CATEGORY_LOGIC             ;
                    register_read_enable_a <= `READ_ENABLE                ;
                    register_read_enable_b <= `READ_DISABLE               ;
                    register_write_enable  <= `WRITE_ENABLE               ;
                    register_write_address <= instruction_i[20:16]        ;
                    immediate_value        <= {16'b0, instruction_i[15:0]};
                end
                `OPCODE_ORI : begin
                    operator               <= `OPERATOR_OR                ;
                    category               <= `CATEGORY_LOGIC             ;
                    register_read_enable_a <= `READ_ENABLE                ;
                    register_read_enable_b <= `READ_DISABLE               ;
                    register_write_enable  <= `WRITE_ENABLE               ;
                    register_write_address <= instruction_i[20:16]        ;
                    immediate_value        <= {16'b0, instruction_i[15:0]};
                end
                `OPCODE_XORI : begin
                    operator               <= `OPERATOR_XOR;
                    category               <= `CATEGORY_LOGIC;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                    immediate_value        <= {16'b0, instruction_i[15:0]};
                end
                `OPCODE_LUI : begin
                    operator               <= `OPERATOR_OR;
                    category               <= `CATEGORY_LOGIC;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                    immediate_value        <= {instruction_i[15:0], 16'b0};
                end
                `OPCODE_PREF : begin
                    operator               <= `OPERATOR_NOP;
                    category               <= `CATEGORY_NONE;
                    register_read_enable_a <= `READ_DISABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_DISABLE;
                end
                `OPCODE_SLTI : begin
                    operator               <= `OPERATOR_SLT;
                    category               <= `CATEGORY_ARITHMETIC;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                    immediate_value        <= {{16 {instruction_i[15]}}, instruction_i[15:0]};
                end
                `OPCODE_SLTIU : begin
                    operator               <= `OPERATOR_SLTU;
                    category               <= `CATEGORY_ARITHMETIC;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                    immediate_value        <= {{16 {instruction_i[15]}}, instruction_i[15:0]};
                end
                `OPCODE_ADDI : begin
                    operator               <= `OPERATOR_ADD;
                    category               <= `CATEGORY_ARITHMETIC;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                    immediate_value        <= {{16 {instruction_i[15]}}, instruction_i[15:0]};
                end
                `OPCODE_ADDIU : begin
                    operator               <= `OPERATOR_ADDU;
                    category               <= `CATEGORY_ARITHMETIC;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                    immediate_value        <= {{16 {instruction_i[15]}}, instruction_i[15:0]};
                end
                `OPCODE_LB : begin
                    operator               <= `OPERATOR_LB;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_LBU : begin
                    operator               <= `OPERATOR_LBU;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_LH : begin
                    operator               <= `OPERATOR_LH;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_LHU : begin
                    operator               <= `OPERATOR_LHU;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_LW : begin
                    operator               <= `OPERATOR_LW;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_DISABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_LWL : begin
                    operator               <= `OPERATOR_LWL;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_LWR : begin
                    operator               <= `OPERATOR_LWR;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_ENABLE;
                    register_write_address <= instruction_i[20:16];
                end
                `OPCODE_SB : begin
                    operator               <= `OPERATOR_SB;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_DISABLE;
                end
                `OPCODE_SH : begin
                    operator               <= `OPERATOR_SH;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_DISABLE;
                end
                `OPCODE_SW : begin
                    operator               <= `OPERATOR_SW;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_DISABLE;
                end
                `OPCODE_SWL : begin
                    operator               <= `OPERATOR_SWL;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_DISABLE;
                end
                `OPCODE_SWR : begin
                    operator               <= `OPERATOR_SWR;
                    category               <= `CATEGORY_MEMORY;
                    register_read_enable_a <= `READ_ENABLE;
                    register_read_enable_b <= `READ_ENABLE;
                    register_write_enable  <= `WRITE_DISABLE;
                end
                `OPCODE_J : begin
                    operator                 <= `OPERATOR_J;
                    category                 <= `CATEGORY_JUMP;
                    register_read_enable_a   <= `READ_DISABLE;
                    register_read_enable_b   <= `READ_DISABLE;
                    register_write_enable    <= `WRITE_DISABLE;
                    register_pc_write_enable <= `WRITE_ENABLE;
                    register_pc_write_data   <= {register_pc_next[31:28], instruction_i[25:0], 2'b0};
                end
                `OPCODE_JAL : begin
                    operator                 <= `OPERATOR_JAL                                       ;
                    category                 <= `CATEGORY_JUMP                                      ;
                    register_read_enable_a   <= `READ_DISABLE                                       ;
                    register_read_enable_b   <= `READ_DISABLE                                       ;
                    register_write_enable    <= `WRITE_ENABLE                                       ;
                    register_write_address   <= 5'b11111                                            ;
                    register_write_data      <= register_pc_read_data + 32'd8                       ;
                    register_pc_write_enable <= `WRITE_ENABLE                                       ;
                    register_pc_write_data   <= {register_pc_next[31:28], instruction_i[25:0], 2'b0};
                end
                `OPCODE_BEQ : begin
                    operator                 <= `OPERATOR_BEQ                                                                         ;
                    category                 <= `CATEGORY_JUMP                                                                        ;
                    register_read_enable_a   <= `READ_ENABLE                                                                          ;
                    register_read_enable_b   <= `READ_ENABLE                                                                          ;
                    register_write_enable    <= `WRITE_DISABLE                                                                        ;
                    register_pc_write_enable <= (operand_a == operand_b) ? `WRITE_ENABLE : `WRITE_DISABLE                             ;
                    register_pc_write_data   <= register_pc_read_data + 32'd4 + {{14 {instruction_i[15]}}, instruction_i[15:0], 2'b00};
                end
                `OPCODE_BGTZ : begin
                    operator                 <= `OPERATOR_BGTZ                                                                        ;
                    category                 <= `CATEGORY_JUMP                                                                        ;
                    register_read_enable_a   <= `READ_ENABLE                                                                          ;
                    register_read_enable_b   <= `READ_DISABLE                                                                         ;
                    register_write_enable    <= `WRITE_DISABLE                                                                        ;
                    register_pc_write_enable <= (operand_a[31] == 1'b0 && operand_a != 32'b0) ? `WRITE_ENABLE : `WRITE_DISABLE        ;
                    register_pc_write_data   <= register_pc_read_data + 32'd4 + {{14 {instruction_i[15]}}, instruction_i[15:0], 2'b00};
                end
                `OPCODE_BLEZ : begin
                    operator                 <= `OPERATOR_BLEZ                                                                        ;
                    category                 <= `CATEGORY_JUMP                                                                        ;
                    register_read_enable_a   <= `READ_ENABLE                                                                          ;
                    register_read_enable_b   <= `READ_DISABLE                                                                         ;
                    register_write_enable    <= `WRITE_DISABLE                                                                        ;
                    register_pc_write_enable <= (operand_a[31] == 1'b1 || operand_a == 32'b0) ? `WRITE_ENABLE : `WRITE_DISABLE        ;
                    register_pc_write_data   <= register_pc_read_data + 32'd4 + {{14 {instruction_i[15]}}, instruction_i[15:0], 2'b00};
                end
                `OPCODE_BNE : begin
                    operator                 <= `OPERATOR_BNE                                                                         ;
                    category                 <= `CATEGORY_JUMP                                                                        ;
                    register_read_enable_a   <= `READ_ENABLE                                                                          ;
                    register_read_enable_b   <= `READ_ENABLE                                                                          ;
                    register_write_enable    <= `WRITE_DISABLE                                                                        ;
                    register_pc_write_enable <= (operand_a != operand_b ? `WRITE_ENABLE : `WRITE_DISABLE)                             ;
                    register_pc_write_data   <= register_pc_read_data + 32'd4 + {{14 {instruction_i[15]}}, instruction_i[15:0], 2'b00};
                end
            endcase

            if (instruction_i[31:21] == 11'b0) begin
                case (instruction_i[5:0])
                    `OPCODE_SLL : begin
                        operator               <= `OPERATOR_SLL       ;
                        category               <= `CATEGORY_SHIFT     ;
                        register_read_enable_a <= `READ_DISABLE       ;
                        register_read_enable_b <= `READ_ENABLE        ;
                        register_write_enable  <= `WRITE_ENABLE       ;
                        register_write_address <= instruction_i[15:11];
                        immediate_value[4:0]   <= instruction_i[10:6] ;
                    end
                    `OPCODE_SRL : begin
                        operator               <= `OPERATOR_SRL       ;
                        category               <= `CATEGORY_SHIFT     ;
                        register_read_enable_a <= `READ_DISABLE       ;
                        register_read_enable_b <= `READ_ENABLE        ;
                        register_write_enable  <= `WRITE_ENABLE       ;
                        register_write_address <= instruction_i[15:11];
                        immediate_value[4:0]   <= instruction_i[10:6] ;
                    end
                    `OPCODE_SRA : begin
                        operator               <= `OPERATOR_SRA       ;
                        category               <= `CATEGORY_SHIFT     ;
                        register_read_enable_a <= `READ_DISABLE       ;
                        register_read_enable_b <= `READ_ENABLE        ;
                        register_write_enable  <= `WRITE_ENABLE       ;
                        register_write_address <= instruction_i[15:11];
                        immediate_value[4:0]   <= instruction_i[10:6] ;
                    end
                endcase
            end
        end
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            stall_request <= `STALL_DISABLE;
        end
        else begin
            if (
                register_read_enable_a == `READ_ENABLE &&
                (
                    ex_operator == `OPERATOR_LB  ||
                    ex_operator == `OPERATOR_LBU ||
                    ex_operator == `OPERATOR_LH  ||
                    ex_operator == `OPERATOR_LHU ||
                    ex_operator == `OPERATOR_LW  ||
                    ex_operator == `OPERATOR_LWL ||
                    ex_operator == `OPERATOR_LWR
                ) &&
                ex_register_write_address == register_read_address_a
            ) begin
                stall_request <= `STALL_ENABLE;
            end
            else if (
                register_read_enable_b == `READ_ENABLE &&
                (
                    ex_operator == `OPERATOR_LB  ||
                    ex_operator == `OPERATOR_LBU ||
                    ex_operator == `OPERATOR_LH  ||
                    ex_operator == `OPERATOR_LHU ||
                    ex_operator == `OPERATOR_LW  ||
                    ex_operator == `OPERATOR_LWL ||
                    ex_operator == `OPERATOR_LWR
                ) &&
                ex_register_write_address == register_read_address_b
            ) begin
                stall_request <= `STALL_ENABLE;
            end
            else begin
                stall_request <= `STALL_DISABLE;
            end
        end
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            operand_a <= 32'b0;
        end
        else if (
            register_read_enable_a   == `READ_ENABLE  &&
            ex_register_write_enable == `WRITE_ENABLE &&
            register_read_address_a  == ex_register_write_address
        ) begin
            operand_a <= ex_register_write_data;
        end
        else if (
            register_read_enable_a    == `READ_ENABLE  &&
            mem_register_write_enable == `WRITE_ENABLE &&
            register_read_address_a   == mem_register_write_address
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
            register_read_enable_b   == `READ_ENABLE  &&
            ex_register_write_enable == `WRITE_ENABLE &&
            register_read_address_b  == ex_register_write_address
        ) begin
            operand_b <= ex_register_write_data;
        end
        else if (
            register_read_enable_b    == `READ_ENABLE  &&
            mem_register_write_enable == `WRITE_ENABLE &&
            register_read_address_b   == mem_register_write_address
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