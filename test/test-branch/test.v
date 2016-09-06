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

        $readmemh("rom.txt", sopc.rom.storage);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        #10 `AR(1, 32'h00000005);
        #2  `AR(1, 32'h00000004);
        #2  `AR(1, 32'h00000004);
        #2  `AR(1, 32'h00000004);
        #2  `AR(1, 32'h00000004);
        #2  `AR(1, 32'h00000004);
        #2  `AR(1, 32'h00000003);
        #2  `AR(1, 32'h00000003);
        #2  `AR(1, 32'h00000003);
        #2  `AR(1, 32'h00000003);
        #2  `AR(1, 32'h00000003);
        #2  `AR(1, 32'h00000002);
        #2  `AR(1, 32'h00000002);
        #2  `AR(1, 32'h00000002);
        #2  `AR(1, 32'h00000002);
        #2  `AR(1, 32'h00000002);
        #2  `AR(1, 32'h00000001);
        #2  `AR(1, 32'h00000001);
        #2  `AR(1, 32'h00000001);
        #2  `AR(1, 32'h00000001);
        #2  `AR(1, 32'h00000001);
        #2  `AR(1, 32'h00000000);
        #2  `AR(1, 32'h00000000);
        #2  `AR(1, 32'h00000000);
        #2  `AR(1, 32'h00000001);
        #2  `AR(1, 32'h00000002);
        `PASS;
    end
endmodule