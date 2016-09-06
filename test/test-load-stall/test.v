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
        $dumpvars(0, sopc.cpu.register.storage[1]);

        $readmemh("rom.txt", sopc.rom.storage, 0, 12);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        #10 `AR(1, 32'h00001234);
        #2  `AR(1, 32'h00001234);
        #2  `AR(1, 32'h00001234);
        #2  `AR(1, 32'h00000000);
        #2  `AR(1, 32'h00001234);
        #2  `AR(1, 32'h00001234);
        #2  `AR(1, 32'h00001234);
        #2  `AR(1, 32'h00001234);
        #2  `AR(1, 32'h000089AB);
        `PASS;
    end
endmodule