module cpu(
    input   wire        clock,
    input   wire        reset,

    //  instruction rom
    output  wire        rom_chip_enable,
    output  wire[31:0]  rom_address,
    input   wire[31:0]  rom_data
);
    wire[31:0]  register_pc;

    wire[31:0]  id_register_pc;
    wire[31:0]  id_instruction;
    wire[7:0]   id_operator;
    wire[2:0]   id_category;
    wire[31:0]  id_operand_a;
    wire[31:0]  id_operand_b;
    wire        id_register_write_enable;
    wire[4:0]   id_register_write_address;

    wire        register_read_enable_a;
    wire[4:0]   register_read_address_a;
    wire[31:0]  register_read_data_a;
    wire        register_read_enable_b;
    wire[4:0]   register_read_address_b;
    wire[31:0]  register_read_data_b;

    wire[7:0]   ex_operator;
    wire[2:0]   ex_category;
    wire[31:0]  ex_operand_a;
    wire[31:0]  ex_operand_b;
    wire        ex_register_write_enable_;
    wire[4:0]   ex_register_write_address_;
    wire        ex_register_write_enable;
    wire[4:0]   ex_register_write_address;
    wire[31:0]  ex_register_write_data;

    wire        mem_register_write_enable_;
    wire[4:0]   mem_register_write_address_;
    wire[31:0]  mem_register_write_data_;
    wire        mem_register_write_enable;
    wire[4:0]   mem_register_write_address;
    wire[31:0]  mem_register_write_data;

    wire        wb_register_write_enable;
    wire[4:0]   wb_register_write_address;
    wire[31:0]  wb_register_write_data;

    stage_if stage_if(
        .clock(clock),
        .reset(reset),
        .register_pc(register_pc),
        .chip_enable(rom_chip_enable)
    );

    assign rom_address = register_pc;

    latch_if_id latch_if_id(
        .clock(clock),
        .reset(reset),
        .if_register_pc(register_pc),
        .if_instruction(rom_data),
        .id_register_pc(id_register_pc),
        .id_instruction(id_instruction)
    );

    stage_id stage_id(
        .reset(reset),
        .register_pc(id_register_pc),
        .instruction(id_instruction),
        .register_read_enable_a(register_read_enable_a),
        .register_read_address_a(register_read_address_a),
        .register_read_data_a(register_read_data_a),
        .register_read_enable_b(register_read_enable_b),
        .register_read_address_b(register_read_address_b),
        .register_read_data_b(register_read_data_b),
        .operator(id_operator),
        .category(id_category),
        .operand_a(id_operand_a),
        .operand_b(id_operand_b),
        .register_write_enable(id_register_write_enable),
        .register_write_address(id_register_write_address),
        .ex_register_write_enable(ex_register_write_enable),
        .ex_register_write_address(ex_register_write_address),
        .ex_register_write_data(ex_register_write_data),
        .mem_register_write_enable(mem_register_write_enable),
        .mem_register_write_address(mem_register_write_address),
        .mem_register_write_data(mem_register_write_data)
    );

    register register(
        .clock(clock),
        .reset(reset),
        .read_enable_a(register_read_enable_a),
        .read_address_a(register_read_address_a),
        .read_data_a(register_read_data_a),
        .read_enable_b(register_read_enable_b),
        .read_address_b(register_read_address_b),
        .read_data_b(register_read_data_b),
        .write_enable(wb_register_write_enable),
        .write_address(wb_register_write_address),
        .write_data(wb_register_write_data)
    );

    latch_id_ex latch_id_ex(
        .clock(clock),
        .reset(reset),
        .id_operator(id_operator),
        .id_category(id_category),
        .id_operand_a(id_operand_a),
        .id_operand_b(id_operand_b),
        .id_register_write_enable(id_register_write_enable),
        .id_register_write_address(id_register_write_address),
        .ex_operator(ex_operator),
        .ex_category(ex_category),
        .ex_operand_a(ex_operand_a),
        .ex_operand_b(ex_operand_b),
        .ex_register_write_enable(ex_register_write_enable_),
        .ex_register_write_address(ex_register_write_address_)
    );

    stage_ex stage_ex(
        .reset(reset),
        .operator(ex_operator),
        .category(ex_category),
        .operand_a(ex_operand_a),
        .operand_b(ex_operand_b),
        .register_write_enable_(ex_register_write_enable_),
        .register_write_address_(ex_register_write_address_),
        .register_write_enable(ex_register_write_enable),
        .register_write_address(ex_register_write_address),
        .register_write_data(ex_register_write_data)
    );

    latch_ex_mem latch_ex_mem(
        .clock(clock),
        .reset(reset),
        .ex_register_write_enable(ex_register_write_enable),
        .ex_register_write_address(ex_register_write_address),
        .ex_register_write_data(ex_register_write_data),
        .mem_register_write_enable(mem_register_write_enable_),
        .mem_register_write_address(mem_register_write_address_),
        .mem_register_write_data(mem_register_write_data_)
    );

    stage_mem stage_mem(
        .reset(reset),
        .register_write_enable_(mem_register_write_enable_),
        .register_write_address_(mem_register_write_address_),
        .register_write_data_(mem_register_write_data_),
        .register_write_enable(mem_register_write_enable),
        .register_write_address(mem_register_write_address),
        .register_write_data(mem_register_write_data)
    );

    latch_mem_wb latch_mem_wb(
        .clock(clock),
        .reset(reset),
        .mem_register_write_enable(mem_register_write_enable),
        .mem_register_write_address(mem_register_write_address),
        .mem_register_write_data(mem_register_write_data),
        .wb_register_write_enable(wb_register_write_enable),
        .wb_register_write_address(wb_register_write_address),
        .wb_register_write_data(wb_register_write_data)
    );
endmodule