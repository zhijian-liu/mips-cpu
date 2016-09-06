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
        $dumpvars(0, sopc.cpu.register.storage[2]);
        $dumpvars(0, sopc.cpu.register.storage[3]);
        $dumpvars(0, sopc.cpu.register.storage[4]);

        $readmemh("rom.txt", sopc.rom.storage, 0, 15);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        #10 `AR(1, 32'h00000000); `AR(2, 32'hxxxxxxxx); `AR(3, 32'hxxxxxxxx); `AR(4, 32'hxxxxxxxx); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'hxxxxxxxx); `AR(4, 32'hxxxxxxxx); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'hxxxxxxxx); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h00000000); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'hFFFF0000); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'hFFFF0000); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h00000000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'hFFFF0000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h05050000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h05050000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h05050000); `ALO(32'h05050000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h05050000); `ALO(32'hFFFF0000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h05050000); `AHI(32'h05050000); `ALO(32'h00000000);
        #2  `AR(1, 32'h00000000); `AR(2, 32'hFFFF0000); `AR(3, 32'h05050000); `AR(4, 32'h00000000); `AHI(32'h05050000); `ALO(32'h00000000);
        `PASS;
    end
endmodule