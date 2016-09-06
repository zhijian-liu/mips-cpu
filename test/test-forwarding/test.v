`timescale 1ns/1ps

module test();
    reg clock, reset;

    sopc sopc(
        .clock(clock),
        .reset(reset)
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");

        $dumpvars;
        $dumpvars(0, sopc.cpu.register.storage[5]);

        $readmemh("rom.txt", sopc.rom.storage);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        #10 `AR(5, 32'h00001100);
        #2  `AR(5, 32'h00001120);
        #2  `AR(5, 32'h00005520);
        #2  `AR(5, 32'h00005564);
        `PASS;
    end
endmodule