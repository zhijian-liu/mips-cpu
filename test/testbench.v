`timescale 1ns/1ps

`include "../src/utility/define.v"
`include "../src/cpu/stage/stage_if.v"
`include "../src/cpu/stage/stage_id.v"
`include "../src/cpu/stage/stage_ex.v"
`include "../src/cpu/stage/stage_mem.v"
`include "../src/cpu/latch/latch_if_id.v"
`include "../src/cpu/latch/latch_id_ex.v"
`include "../src/cpu/latch/latch_ex_mem.v"
`include "../src/cpu/latch/latch_mem_wb.v"
`include "../src/cpu/register.v"
`include "../src/cpu/cpu.v"
`include "../src/rom.v"
`include "../src/sopc.v"

module test_bench();
    reg clock;
    reg reset;

    initial begin
        $readmemh("assembler/rom.txt", sopc.rom.storage);
    end

    initial begin
        clock = 0;
        forever begin
            #10 clock = ~clock;
        end
    end

    initial begin
        reset = 1;
        #195    reset = 0;
        #1000   $stop;
    end

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars;
    end

    sopc sopc(
        .clock(clock),
        .reset(reset)
    );
endmodule