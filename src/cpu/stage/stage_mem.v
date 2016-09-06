module stage_mem(
    input             reset                     ,
    input      [31:0] instruction               ,
    input      [ 7:0] operator                  ,
    input      [31:0] operand_a                 ,
    input      [31:0] operand_b                 ,
    output reg        memory_read_enable        ,
    output reg [31:0] memory_read_address       ,
    input      [31:0] memory_read_data          ,
    output reg        memory_write_enable       ,
    output reg [31:0] memory_write_address      ,
    output reg [3:0]  memory_write_select       ,
    output reg [31:0] memory_write_data         ,
    input             register_write_enable_i   ,
    output reg        register_write_enable_o   ,
    input      [ 4:0] register_write_address_i  ,
    output reg [ 4:0] register_write_address_o  ,
    input      [31:0] register_write_data_i     ,
    output reg [31:0] register_write_data_o     ,
    input             register_hi_write_enable_i,
    output reg        register_hi_write_enable_o,
    input      [31:0] register_hi_write_data_i  ,
    output reg [31:0] register_hi_write_data_o  ,
    input             register_lo_write_enable_i,
    output reg        register_lo_write_enable_o,
    input      [31:0] register_lo_write_data_i  ,
    output reg [31:0] register_lo_write_data_o   
);
    wire [31:0] address = operand_a + {{16 {instruction[15]}}, instruction[15:0]};

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            memory_read_enable         <= `READ_DISABLE ;
            memory_read_address        <= 5'b0          ;
            memory_write_enable        <= `WRITE_DISABLE;
            memory_write_address       <= 5'b0          ;
            memory_write_select        <= 4'b0          ;
            memory_write_data          <= 32'b0         ;
            register_write_enable_o    <= `WRITE_DISABLE;
            register_write_address_o   <= 5'b0          ;
            register_write_data_o      <= 32'b0         ;
            register_hi_write_enable_o <= `WRITE_DISABLE;
            register_hi_write_data_o   <= 32'b0         ;
            register_lo_write_enable_o <= `WRITE_DISABLE;
            register_lo_write_data_o   <= 32'b0         ;
        end 
        else begin
            memory_read_enable         <= `READ_DISABLE             ;
            memory_read_address        <= 5'b0                      ;
            memory_write_enable        <= `WRITE_DISABLE            ;
            memory_write_address       <= 5'b0                      ;
            memory_write_select        <= 4'b0                      ;
            memory_write_data          <= 32'b0                     ;
            register_write_enable_o    <= register_write_enable_i   ;
            register_write_address_o   <= register_write_address_i  ;
            register_write_data_o      <= register_write_data_i     ;
            register_hi_write_enable_o <= register_hi_write_enable_i;
            register_hi_write_data_o   <= register_hi_write_data_i  ;
            register_lo_write_enable_o <= register_lo_write_enable_i;
            register_lo_write_data_o   <= register_lo_write_data_i  ;
            case (operator)
                `OPERATOR_LB : begin
                    memory_read_enable  <= `READ_ENABLE  ;
                    memory_read_address <= address       ;
                    memory_write_enable <= `WRITE_DISABLE;
                    case (address[1:0])
                        2'b00 : begin
                            register_write_data_o <= {{24 {memory_read_data[31]}}, memory_read_data[31:24]};  
                        end
                        2'b01 : begin
                            register_write_data_o <= {{24 {memory_read_data[23]}}, memory_read_data[23:16]};  
                        end
                        2'b10 : begin
                            register_write_data_o <= {{24 {memory_read_data[15]}}, memory_read_data[15:8]};  
                        end
                        2'b11 : begin
                            register_write_data_o <= {{24 {memory_read_data[7]}}, memory_read_data[7:0]};  
                        end
                        default : begin
                            register_write_data_o <= 32'b0;  
                        end
                    endcase
                end
                `OPERATOR_LBU : begin
                    memory_read_enable  <= `READ_ENABLE  ;
                    memory_read_address <= address       ;
                    memory_write_enable <= `WRITE_DISABLE;
                    case (address[1:0])
                        2'b00 : begin
                            register_write_data_o <= {24'b0, memory_read_data[31:24]};  
                        end
                        2'b01 : begin
                            register_write_data_o <= {24'b0, memory_read_data[23:16]};  
                        end
                        2'b10 : begin
                            register_write_data_o <= {24'b0, memory_read_data[15:8]};  
                        end
                        2'b11 : begin
                            register_write_data_o <= {24'b0, memory_read_data[7:0]};  
                        end
                        default : begin
                            register_write_data_o <= 32'b0;  
                        end
                    endcase
                end
                `OPERATOR_LH : begin
                    memory_read_enable  <= `READ_ENABLE  ;
                    memory_read_address <= address       ;
                    memory_write_enable <= `WRITE_DISABLE;
                    case (address[1:0])
                        2'b00 : begin
                            register_write_data_o <= {{16 {memory_read_data[31]}}, memory_read_data[31:16]};  
                        end
                        2'b10 : begin
                            register_write_data_o <= {{16 {memory_read_data[15]}}, memory_read_data[15:0]};  
                        end
                        default : begin
                            register_write_data_o <= 32'b0;  
                        end
                    endcase
                end
                `OPERATOR_LHU : begin
                    memory_read_enable  <= `READ_ENABLE  ;
                    memory_read_address <= address       ;
                    memory_write_enable <= `WRITE_DISABLE;
                    case (address[1:0])
                        2'b00 : begin
                            register_write_data_o <= {16'b0, memory_read_data[31:16]};  
                        end
                        2'b10 : begin
                            register_write_data_o <= {16'b0, memory_read_data[15:0]};  
                        end
                        default : begin
                            register_write_data_o <= 32'b0;  
                        end
                    endcase
                end
                `OPERATOR_LW : begin
                    memory_read_enable    <= `READ_ENABLE    ;
                    memory_read_address   <= address         ;
                    memory_write_enable   <= `WRITE_DISABLE  ;
                    register_write_data_o <= memory_read_data;
                end
                `OPERATOR_LWL : begin
                    memory_read_enable  <= `READ_ENABLE         ;
                    memory_read_address <= {address[31:2], 2'b0};
                    memory_write_enable <= `WRITE_DISABLE       ;
                    case (address[1:0])
                        2'b00 : begin
                            register_write_data_o <= memory_read_data;
                        end
                        2'b01 : begin
                            register_write_data_o <= {memory_read_data[23:0], operand_b[7:0]};  
                        end
                        2'b10 : begin
                            register_write_data_o <= {memory_read_data[15:0], operand_b[15:0]};
                        end
                        2'b11 : begin
                            register_write_data_o <= {memory_read_data[7:0], operand_b[23:0]};
                        end
                        default : begin
                            register_write_data_o <= 32'b0;  
                        end
                    endcase
                end
                `OPERATOR_LWR : begin
                    memory_read_enable  <= `READ_ENABLE         ;
                    memory_read_address <= {address[31:2], 2'b0};
                    memory_write_enable <= `WRITE_DISABLE       ;
                    case (address[1:0])
                        2'b00 : begin
                            register_write_data_o <= {operand_b[31:8], memory_read_data[31:24]};
                        end
                        2'b01 : begin
                            register_write_data_o <= {operand_b[31:16], memory_read_data[31:16]};  
                        end
                        2'b10 : begin
                            register_write_data_o <= {operand_b[31:24], memory_read_data[31:8]};
                        end
                        2'b11 : begin
                            register_write_data_o <= memory_read_data;
                        end
                        default : begin
                            register_write_data_o <= 32'b0;  
                        end
                    endcase
                end
                `OPERATOR_SB : begin
                    memory_read_enable   <= `READ_DISABLE       ;
                    memory_write_enable  <= `WRITE_ENABLE       ;
                    memory_write_address <= address             ;
                    memory_write_data    <= {4 {operand_b[7:0]}};
                    case (address[1:0])
                        2'b00 : begin
                            memory_write_select <= 4'b1000;
                        end
                        2'b01 : begin
                            memory_write_select <= 4'b0100;
                        end
                        2'b10 : begin
                            memory_write_select <= 4'b0010;
                        end
                        2'b11 : begin
                            memory_write_select <= 4'b0001;
                        end
                        default : begin
                            memory_write_select <= 4'b0000;
                        end
                    endcase
                end
                `OPERATOR_SH : begin
                    memory_read_enable   <= `READ_DISABLE        ;
                    memory_write_enable  <= `WRITE_ENABLE        ;
                    memory_write_address <= address              ;
                    memory_write_data    <= {2 {operand_b[15:0]}};
                    case (address[1:0])
                        2'b00 : begin
                            memory_write_select <= 4'b1100;
                        end
                        2'b10 : begin
                            memory_write_select <= 4'b0011;
                        end
                        default : begin
                            memory_write_select <= 4'b0000;
                        end
                    endcase
                end
                `OPERATOR_SW : begin
                    memory_read_enable   <= `READ_DISABLE;
                    memory_write_enable  <= `WRITE_ENABLE;
                    memory_write_address <= address      ;
                    memory_write_select  <= 4'b1111      ;
                    memory_write_data    <= operand_b    ;
                end
                `OPERATOR_SWL : begin
                    memory_read_enable   <= `READ_DISABLE        ;
                    memory_write_enable  <= `WRITE_ENABLE        ;
                    memory_write_address <= {address[31:2], 2'b0};
                    case (address[1:0])
                        2'b00 : begin
                            memory_write_select <= 4'b1111  ;
                            memory_write_data   <= operand_b;
                        end
                        2'b01 : begin
                            memory_write_select <= 4'b0111                ;
                            memory_write_data   <= {8'b0, operand_b[31:8]};
                        end
                        2'b10 : begin
                            memory_write_select <= 4'b0011                  ;
                            memory_write_data   <= {16'b0, operand_b[31:16]};
                        end
                        2'b11 : begin
                            memory_write_select <= 4'b0001                  ;
                            memory_write_data   <= {24'b0, operand_b[31:24]};
                        end
                        default : begin
                            memory_write_select <= 4'b0000;
                        end
                    endcase
                end
                `OPERATOR_SWR : begin
                    memory_read_enable   <= `READ_DISABLE        ;
                    memory_write_enable  <= `WRITE_ENABLE        ;
                    memory_write_address <= {address[31:2], 2'b0};
                    case (address[1:0])
                        2'b00 : begin
                            memory_write_select <= 4'b1000                ;
                            memory_write_data   <= {operand_b[7:0], 24'b0};
                        end
                        2'b01 : begin
                            memory_write_select <= 4'b1100                 ;
                            memory_write_data   <= {operand_b[15:0], 15'b0};
                        end
                        2'b10 : begin
                            memory_write_select <= 4'b1110                ;
                            memory_write_data   <= {operand_b[23:0], 8'b0};
                        end
                        2'b11 : begin
                            memory_write_select <= 4'b1111  ;
                            memory_write_data   <= operand_b;
                        end
                        default : begin
                            memory_write_select <= 4'b0000;
                        end
                    endcase
                end
            endcase
        end
    end
endmodule