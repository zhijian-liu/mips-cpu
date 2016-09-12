`timescale 1ns/1ps

module test();
    reg clock, reset;

    sopc sopc(
        .clock(clock),
        .reset(reset)
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");

        $dumpvars;
        $dumpvars(0, sopc.cpu.register.storage[1]);
        $dumpvars(0, sopc.cpu.register.storage[2]);
        $dumpvars(0, sopc.cpu.register.storage[3]);
        $dumpvars(0, sopc.cpu.register.storage[4]);
        $dumpvars(0, sopc.cpu.register.storage[5]);
        $dumpvars(0, sopc.cpu.register.storage[6]);
        $dumpvars(0, sopc.cpu.register.storage[7]);

        $readmemh("rom.txt", sopc.rom.storage);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        `PASS;
    end
endmodule