`timescale 1ns/1ps

module test();
    reg     clock, reset;
    integer i           ;

    sopc sopc(
        .clock(clock),
        .reset(reset)
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");

        $dumpvars;
        $dumpvars(0, sopc.cpu.register.storage[1]);
        $dumpvars(0, sopc.cpu.register.storage[3]);
        $dumpvars(0, sopc.ram.storage[0]);
        $dumpvars(0, sopc.ram.storage[1]);
        $dumpvars(0, sopc.ram.storage[2]);

        $readmemh("rom.txt", sopc.rom.storage, 0, 31);

        clock = 1'b0;
        reset = 1'b1;

        #20 reset = 1'b0;
        #10 `AR(1, 32'hxxxxxxxx); `AR(3, 32'h0000EEFF);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h0000EEFF);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h000000EE);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h000000EE);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h0000CCDD);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h0000CCDD);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h000000CC);
        #2  `AR(1, 32'hxxxxxxxx); `AR(3, 32'h000000CC);
        #2  `AR(1, 32'hFFFFFFFF); `AR(3, 32'h000000CC);
        #2  `AR(1, 32'h000000EE); `AR(3, 32'h000000CC);
        #2  `AR(1, 32'h000000EE); `AR(3, 32'h0000AABB);
        #2  `AR(1, 32'h000000EE); `AR(3, 32'h0000AABB);
        #2  `AR(1, 32'h0000AABB); `AR(3, 32'h0000AABB);
        #2  `AR(1, 32'hFFFFAABB); `AR(3, 32'h0000AABB);
        #2  `AR(1, 32'hFFFFAABB); `AR(3, 32'h00008899);
        #2  `AR(1, 32'hFFFFAABB); `AR(3, 32'h00008899);
        #2  `AR(1, 32'hFFFF8899); `AR(3, 32'h00008899);
        #2  `AR(1, 32'h00008899); `AR(3, 32'h00008899);
        #2  `AR(1, 32'h00008899); `AR(3, 32'h00004455);
        #2  `AR(1, 32'h00008899); `AR(3, 32'h44550000);
        #2  `AR(1, 32'h00008899); `AR(3, 32'h44556677);
        #2  `AR(1, 32'h00008899); `AR(3, 32'h44556677);
        #2  `AR(1, 32'h44556677); `AR(3, 32'h44556677);
        #2  `AR(1, 32'h44556677); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hBB889977); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hBB889977); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hBB889944); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hBB889944); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hBB889944); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hBB889944); `AR(3, 32'h44556677);
        #2  `AR(1, 32'h889944FF); `AR(3, 32'h44556677);
        #2  `AR(1, 32'hAABB88BB); `AR(3, 32'h44556677);
        `PASS;
    end
endmodule