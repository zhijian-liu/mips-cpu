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
        $dumpvars(0, sopc.cpu.register.storage[2]);
        $dumpvars(0, sopc.cpu.register.storage[5]);
        $dumpvars(0, sopc.cpu.register.storage[7]);
        $dumpvars(0, sopc.cpu.register.storage[8]);

        $readmemh("rom.txt", sopc.rom.storage, 0, 15);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        #10 `AR(2, 32'h04040000);
        #2  `AR(2, 32'h04040404);
        #2  `AR(7, 32'h00000007);
        #2  `AR(5, 32'h00000005);
        #2  `AR(8, 32'h00000008);
        #2  `AR(2, 32'h04040404); `AR(7, 32'h00000007); `AR(5, 32'h00000005); `AR(8, 32'h00000008);
        #2  `AR(2, 32'h04040400);
        #2  `AR(2, 32'h02020000);
        #2  `AR(2, 32'h00020200);
        #2  `AR(2, 32'h00001010);
        #2  `AR(2, 32'h00001010);
        #2  `AR(2, 32'h00001010); `AR(7, 32'h00000007); `AR(5, 32'h00000005); `AR(8, 32'h00000008);
        #2  `AR(2, 32'h80800000);
        #2  `AR(2, 32'h80800000);
        #2  `AR(2, 32'hffff8080);
        #2  `AR(2, 32'hffffff80);
        `PASS;
    end
endmodule