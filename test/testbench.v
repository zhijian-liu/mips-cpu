`timescale 1ns/1ps

module test_bench();
    reg     clock;
    reg     reset;

    initial begin
        clock = 1'b0;
        forever begin
            #10 clock = ~clock;
        end
    end

    initial begin
        reset = 1'b1;
        #195    reset = 1'b0;
        #1000   $finish;
    end

    sopc sopc(
        .clock(clock),
        .reset(reset)
    );

    initial begin: initialize_rom
        $readmemh("assembler/rom.txt", sopc.rom.storage);
    end
    
    initial begin: initialize_ram
        integer i;
        for (i = 0; i < 1024; ++i) begin
            sopc.ram.storage[i] = 32'b0;
        end
    end

    initial begin: initialize_register
        integer i;
        for (i = 0; i < 32; ++i) begin
            sopc.cpu.register.storage[i] = 32'b0;
        end
    end

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars;
    end
    
    wire[31:0]  register_0;
    wire[31:0]  register_1;
    wire[31:0]  register_2;
    wire[31:0]  register_3;
    wire[31:0]  register_4;
    wire[31:0]  register_5;
    wire[31:0]  register_6;
    wire[31:0]  register_7;
    wire[31:0]  register_8;
    wire[31:0]  register_9;
    wire[31:0]  register_10;
    wire[31:0]  register_11;
    wire[31:0]  register_12;
    wire[31:0]  register_13;
    wire[31:0]  register_14;
    wire[31:0]  register_15;
    wire[31:0]  register_16;
    wire[31:0]  register_17;
    wire[31:0]  register_18;
    wire[31:0]  register_19;
    wire[31:0]  register_20;
    wire[31:0]  register_21;
    wire[31:0]  register_22;
    wire[31:0]  register_23;
    wire[31:0]  register_24;
    wire[31:0]  register_25;
    wire[31:0]  register_26;
    wire[31:0]  register_27;
    wire[31:0]  register_28;
    wire[31:0]  register_29;
    wire[31:0]  register_30;
    wire[31:0]  register_31;
    wire[31:0]  register_pc;
    wire[31:0]  register_hi;
    wire[31:0]  register_lo;

    assign register_0  = sopc.cpu.register.storage[0];
    assign register_1  = sopc.cpu.register.storage[1];
    assign register_2  = sopc.cpu.register.storage[2];
    assign register_3  = sopc.cpu.register.storage[3];
    assign register_4  = sopc.cpu.register.storage[4];
    assign register_5  = sopc.cpu.register.storage[5];
    assign register_6  = sopc.cpu.register.storage[6];
    assign register_7  = sopc.cpu.register.storage[7];
    assign register_8  = sopc.cpu.register.storage[8];
    assign register_9  = sopc.cpu.register.storage[9];
    assign register_10 = sopc.cpu.register.storage[10];
    assign register_11 = sopc.cpu.register.storage[11];
    assign register_12 = sopc.cpu.register.storage[12];
    assign register_13 = sopc.cpu.register.storage[13];
    assign register_14 = sopc.cpu.register.storage[14];
    assign register_15 = sopc.cpu.register.storage[15];
    assign register_16 = sopc.cpu.register.storage[16];
    assign register_17 = sopc.cpu.register.storage[17];
    assign register_18 = sopc.cpu.register.storage[18];
    assign register_19 = sopc.cpu.register.storage[19];
    assign register_20 = sopc.cpu.register.storage[20];
    assign register_21 = sopc.cpu.register.storage[21];
    assign register_22 = sopc.cpu.register.storage[22];
    assign register_23 = sopc.cpu.register.storage[23];
    assign register_24 = sopc.cpu.register.storage[24];
    assign register_25 = sopc.cpu.register.storage[25];
    assign register_26 = sopc.cpu.register.storage[26];
    assign register_27 = sopc.cpu.register.storage[27];
    assign register_28 = sopc.cpu.register.storage[28];
    assign register_29 = sopc.cpu.register.storage[29];
    assign register_30 = sopc.cpu.register.storage[30];
    assign register_31 = sopc.cpu.register.storage[31];
    assign register_pc = sopc.cpu.stage_if.register_pc_read_data;
    assign register_hi = sopc.cpu.stage_wb.register_hi_read_data;
    assign register_lo = sopc.cpu.stage_wb.register_lo_read_data;
endmodule