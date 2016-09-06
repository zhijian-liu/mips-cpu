module cpu(
    input         clock            ,
    input         reset            ,
    output [31:0] rom_read_address ,
    input  [31:0] rom_read_data    ,
    output        ram_read_enable  ,
    output [31:0] ram_read_address ,
    input  [31:0] ram_read_data    ,
    output        ram_write_enable ,
    output [31:0] ram_write_address,
    output [ 3:0] ram_write_select ,
    output [31:0] ram_write_data
);
    wire [ 5:0] control_stall;
 
    wire        register_read_enable_a ;
    wire [ 4:0] register_read_address_a;
    wire [31:0] register_read_data_a   ;
    wire        register_read_enable_b ;
    wire [ 4:0] register_read_address_b;
    wire [31:0] register_read_data_b   ;
    wire        register_write_enable  ;
    wire [ 4:0] register_write_address ;
    wire [31:0] register_write_data    ;
 
    wire [31:0] if_register_pc_read_data   ;
    wire [31:0] if_instruction             ;
 
    wire [31:0] id_instruction_i           ;
    wire [31:0] id_instruction_o           ;
    wire        id_register_pc_write_enable;
    wire [31:0] id_register_pc_write_data  ;
    wire [31:0] id_register_pc_read_data   ;
    wire        id_register_read_enable_a  ;
    wire [ 4:0] id_register_read_address_a ;
    wire [31:0] id_register_read_data_a    ;
    wire        id_register_read_enable_b  ;
    wire [ 4:0] id_register_read_address_b ;
    wire [31:0] id_register_read_data_b    ;
    wire [ 7:0] id_operator                ;
    wire [ 2:0] id_category                ;
    wire [31:0] id_operand_a               ;
    wire [31:0] id_operand_b               ;
    wire        id_register_write_enable   ;
    wire [ 4:0] id_register_write_address  ;
    wire [31:0] id_register_write_data     ;
    wire        id_stall_request           ;
 
    wire [31:0] ex_instruction_i           ;
    wire [31:0] ex_instruction_o           ;
    wire [7:0]  ex_operator_i              ;
    wire [7:0]  ex_operator_o              ;
    wire [2:0]  ex_category                ;
    wire [31:0] ex_operand_a_i             ;
    wire [31:0] ex_operand_a_o             ;
    wire [31:0] ex_operand_b_i             ;
    wire [31:0] ex_operand_b_o             ;
    wire        ex_register_write_enable_i ;
    wire        ex_register_write_enable_o ;
    wire [ 4:0] ex_register_write_address_i;
    wire [ 4:0] ex_register_write_address_o;
    wire [31:0] ex_register_write_data_i   ;
    wire [31:0] ex_register_write_data_o   ;
    wire        ex_register_hi_write_enable;
    wire [31:0] ex_register_hi_write_data  ;
    wire        ex_register_lo_write_enable;
    wire [31:0] ex_register_lo_write_data  ;
    wire        ex_stall_request           ;
 
    wire [31:0] mem_instruction               ;
    wire [ 7:0] mem_operator                  ;
    wire [31:0] mem_operand_a                 ;
    wire [31:0] mem_operand_b                 ;
    wire        mem_register_write_enable_i   ;
    wire        mem_register_write_enable_o   ;
    wire [ 4:0] mem_register_write_address_i  ;
    wire [ 4:0] mem_register_write_address_o  ;
    wire [31:0] mem_register_write_data_i     ;
    wire [31:0] mem_register_write_data_o     ;
    wire        mem_register_hi_write_enable_i;
    wire        mem_register_hi_write_enable_o;
    wire [31:0] mem_register_hi_write_data_i  ;
    wire [31:0] mem_register_hi_write_data_o  ;
    wire        mem_register_lo_write_enable_i;
    wire        mem_register_lo_write_enable_o;
    wire [31:0] mem_register_lo_write_data_i  ;
    wire [31:0] mem_register_lo_write_data_o  ;
 
    wire        wb_register_write_enable   ;
    wire [ 4:0] wb_register_write_address  ;
    wire [31:0] wb_register_write_data     ;
    wire        wb_register_hi_write_enable;
    wire [31:0] wb_register_hi_write_data  ;
    wire [31:0] wb_register_hi_read_data   ;
    wire        wb_register_lo_write_enable;
    wire [31:0] wb_register_lo_write_data  ;
    wire [31:0] wb_register_lo_read_data   ;

    control control(
        .reset            (reset           ),
        .id_stall_request (id_stall_request),
        .ex_stall_request (ex_stall_request),
        .stall            (control_stall   )
    );

    register register(
        .clock          (clock                  ),
        .reset          (reset                  ),
        .read_enable_a  (register_read_enable_a ),
        .read_address_a (register_read_address_a),
        .read_data_a    (register_read_data_a   ),
        .read_enable_b  (register_read_enable_b ),
        .read_address_b (register_read_address_b),
        .read_data_b    (register_read_data_b   ),
        .write_enable   (register_write_enable  ),
        .write_address  (register_write_address ),
        .write_data     (register_write_data    )
    );

    stage_if stage_if(
        .clock                    (clock                      ),
        .reset                    (reset                      ),
        .stall                    (control_stall              ),
        .register_pc_write_enable (id_register_pc_write_enable),
        .register_pc_write_data   (id_register_pc_write_data  ),
        .register_pc_read_data    (if_register_pc_read_data   )
    );

    assign rom_read_address = if_register_pc_read_data;
    assign if_instruction   = rom_read_data           ;

    latch_if_id latch_if_id(
        .clock                    (clock                   ),
        .reset                    (reset                   ),
        .stall                    (control_stall           ),
        .if_register_pc_read_data (if_register_pc_read_data),
        .if_instruction           (if_instruction          ),
        .id_register_pc_read_data (id_register_pc_read_data),
        .id_instruction           (id_instruction_i        )
    );

    stage_id stage_id(
        .reset                      (reset                       ),
        .instruction_i              (id_instruction_i            ),
        .instruction_o              (id_instruction_o            ),
        .register_pc_write_enable   (id_register_pc_write_enable ),
        .register_pc_write_data     (id_register_pc_write_data   ),
        .register_pc_read_data      (id_register_pc_read_data    ),
        .register_read_enable_a     (id_register_read_enable_a   ),
        .register_read_address_a    (id_register_read_address_a  ),
        .register_read_data_a       (id_register_read_data_a     ),
        .register_read_enable_b     (id_register_read_enable_b   ),
        .register_read_address_b    (id_register_read_address_b  ),
        .register_read_data_b       (id_register_read_data_b     ),
        .operator                   (id_operator                 ),
        .category                   (id_category                 ),
        .operand_a                  (id_operand_a                ),
        .operand_b                  (id_operand_b                ),
        .register_write_enable      (id_register_write_enable    ),
        .register_write_address     (id_register_write_address   ),
        .register_write_data        (id_register_write_data      ),
        .ex_operator                (ex_operator_o               ),
        .ex_register_write_enable   (ex_register_write_enable_o  ),
        .ex_register_write_address  (ex_register_write_address_o ),
        .ex_register_write_data     (ex_register_write_data_o    ),
        .mem_register_write_enable  (mem_register_write_enable_o ),
        .mem_register_write_address (mem_register_write_address_o),
        .mem_register_write_data    (mem_register_write_data_o   ),
        .stall_request              (id_stall_request            )
    );

    assign register_read_enable_a  = id_register_read_enable_a ;
    assign register_read_address_a = id_register_read_address_a;
    assign id_register_read_data_a = register_read_data_a      ;
    assign register_read_enable_b  = id_register_read_enable_b ;
    assign register_read_address_b = id_register_read_address_b;
    assign id_register_read_data_b = register_read_data_b      ;

    latch_id_ex latch_id_ex(
        .clock                     (clock                      ),
        .reset                     (reset                      ),
        .stall                     (control_stall              ),
        .id_instruction            (id_instruction_o           ),
        .id_operator               (id_operator                ),
        .id_category               (id_category                ),
        .id_operand_a              (id_operand_a               ),
        .id_operand_b              (id_operand_b               ),
        .id_register_write_enable  (id_register_write_enable   ),
        .id_register_write_address (id_register_write_address  ),
        .id_register_write_data    (id_register_write_data     ),
        .ex_instruction            (ex_instruction_i           ),
        .ex_operator               (ex_operator_i              ),
        .ex_category               (ex_category                ),
        .ex_operand_a              (ex_operand_a_i             ),
        .ex_operand_b              (ex_operand_b_i             ),
        .ex_register_write_enable  (ex_register_write_enable_i ),
        .ex_register_write_address (ex_register_write_address_i),
        .ex_register_write_data    (ex_register_write_data_i   )
    );

    stage_ex stage_ex(
        .reset                        (reset                         ),
        .instruction_i                (ex_instruction_i              ),
        .instruction_o                (ex_instruction_o              ),
        .operator_i                   (ex_operator_i                 ),
        .operator_o                   (ex_operator_o                 ),
        .category                     (ex_category                   ),
        .operand_a_i                  (ex_operand_a_i                ),
        .operand_a_o                  (ex_operand_a_o                ),
        .operand_b_i                  (ex_operand_b_i                ),
        .operand_b_o                  (ex_operand_b_o                ),
        .register_write_enable_i      (ex_register_write_enable_i    ),
        .register_write_enable_o      (ex_register_write_enable_o    ),
        .register_write_address_i     (ex_register_write_address_i   ),
        .register_write_address_o     (ex_register_write_address_o   ),
        .register_write_data_i        (ex_register_write_data_i      ),
        .register_write_data_o        (ex_register_write_data_o      ),
        .register_hi_write_enable     (ex_register_hi_write_enable   ),
        .register_hi_write_data       (ex_register_hi_write_data     ),
        .register_lo_write_enable     (ex_register_lo_write_enable   ),
        .register_lo_write_data       (ex_register_lo_write_data     ),
        .mem_register_hi_write_enable (mem_register_hi_write_enable_o),
        .mem_register_hi_write_data   (mem_register_hi_write_data_o  ),
        .mem_register_lo_write_enable (mem_register_lo_write_enable_o),
        .mem_register_lo_write_data   (mem_register_lo_write_data_o  ),
        .wb_register_hi_read_data     (wb_register_hi_read_data      ),
        .wb_register_hi_write_enable  (wb_register_hi_write_enable   ),
        .wb_register_hi_write_data    (wb_register_hi_write_data     ),
        .wb_register_lo_read_data     (wb_register_lo_read_data      ),
        .wb_register_lo_write_enable  (wb_register_lo_write_enable   ),
        .wb_register_lo_write_data    (wb_register_lo_write_data     ),
        .stall_request                (ex_stall_request              )
    );

    latch_ex_mem latch_ex_mem(
        .clock                        (clock                         ),
        .reset                        (reset                         ),
        .stall                        (control_stall                 ),
        .ex_instruction               (ex_instruction_o              ),
        .ex_operator                  (ex_operator_o                 ),
        .ex_operand_a                 (ex_operand_a_o                ),
        .ex_operand_b                 (ex_operand_b_o                ),
        .ex_register_write_enable     (ex_register_write_enable_o    ),
        .ex_register_write_address    (ex_register_write_address_o   ),
        .ex_register_write_data       (ex_register_write_data_o      ),
        .ex_register_hi_write_enable  (ex_register_hi_write_enable   ),
        .ex_register_hi_write_data    (ex_register_hi_write_data     ),
        .ex_register_lo_write_enable  (ex_register_lo_write_enable   ),
        .ex_register_lo_write_data    (ex_register_lo_write_data     ),
        .mem_instruction              (mem_instruction               ),
        .mem_operator                 (mem_operator                  ),
        .mem_operand_a                (mem_operand_a                 ),
        .mem_operand_b                (mem_operand_b                 ),
        .mem_register_write_enable    (mem_register_write_enable_i   ),
        .mem_register_write_address   (mem_register_write_address_i  ),
        .mem_register_write_data      (mem_register_write_data_i     ),
        .mem_register_hi_write_enable (mem_register_hi_write_enable_i),
        .mem_register_hi_write_data   (mem_register_hi_write_data_i  ),
        .mem_register_lo_write_enable (mem_register_lo_write_enable_i),
        .mem_register_lo_write_data   (mem_register_lo_write_data_i  )
    );

    stage_mem stage_mem(
        .reset                      (reset                         ),
        .instruction                (mem_instruction               ),
        .operator                   (mem_operator                  ),
        .operand_a                  (mem_operand_a                 ),
        .operand_b                  (mem_operand_b                 ),
        .memory_read_enable         (ram_read_enable               ),
        .memory_read_address        (ram_read_address              ),
        .memory_read_data           (ram_read_data                 ),
        .memory_write_enable        (ram_write_enable              ),
        .memory_write_address       (ram_write_address             ),
        .memory_write_select        (ram_write_select              ),
        .memory_write_data          (ram_write_data                ),
        .register_write_enable_i    (mem_register_write_enable_i   ),
        .register_write_enable_o    (mem_register_write_enable_o   ),
        .register_write_address_i   (mem_register_write_address_i  ),
        .register_write_address_o   (mem_register_write_address_o  ),
        .register_write_data_i      (mem_register_write_data_i     ),
        .register_write_data_o      (mem_register_write_data_o     ),
        .register_hi_write_enable_i (mem_register_hi_write_enable_i),
        .register_hi_write_enable_o (mem_register_hi_write_enable_o),
        .register_hi_write_data_i   (mem_register_hi_write_data_i  ),
        .register_hi_write_data_o   (mem_register_hi_write_data_o  ),
        .register_lo_write_enable_i (mem_register_lo_write_enable_i),
        .register_lo_write_enable_o (mem_register_lo_write_enable_o),
        .register_lo_write_data_i   (mem_register_lo_write_data_i  ),
        .register_lo_write_data_o   (mem_register_lo_write_data_o  )
    );

    latch_mem_wb latch_mem_wb(
        .clock                        (clock                         ),
        .reset                        (reset                         ),
        .stall                        (control_stall                 ),
        .mem_register_write_enable    (mem_register_write_enable_o   ),
        .mem_register_write_address   (mem_register_write_address_o  ),
        .mem_register_write_data      (mem_register_write_data_o     ),
        .mem_register_hi_write_enable (mem_register_hi_write_enable_o),
        .mem_register_hi_write_data   (mem_register_hi_write_data_o  ),
        .mem_register_lo_write_enable (mem_register_lo_write_enable_o),
        .mem_register_lo_write_data   (mem_register_lo_write_data_o  ),
        .wb_register_write_enable     (wb_register_write_enable      ),
        .wb_register_write_address    (wb_register_write_address     ),
        .wb_register_write_data       (wb_register_write_data        ),
        .wb_register_hi_write_enable  (wb_register_hi_write_enable   ),
        .wb_register_hi_write_data    (wb_register_hi_write_data     ),
        .wb_register_lo_write_enable  (wb_register_lo_write_enable   ),
        .wb_register_lo_write_data    (wb_register_lo_write_data     )
    );

    assign register_write_enable  = wb_register_write_enable ;
    assign register_write_address = wb_register_write_address;
    assign register_write_data    = wb_register_write_data   ;

    stage_wb stage_wb(
        .clock                    (clock                      ),
        .reset                    (reset                      ),
        .register_hi_write_enable (wb_register_hi_write_enable),
        .register_hi_write_data   (wb_register_hi_write_data  ),
        .register_hi_read_data    (wb_register_hi_read_data   ),
        .register_lo_write_enable (wb_register_lo_write_enable),
        .register_lo_write_data   (wb_register_lo_write_data  ),
        .register_lo_read_data    (wb_register_lo_read_data   )
    );
endmodule