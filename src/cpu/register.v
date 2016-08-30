module register(
    input   wire        clock,
    input   wire        reset,

    //  read port A
    input   wire        read_enable_a,
    input   wire[4:0]   read_address_a,
    output  reg[31:0]   read_data_a,

    //  read port B
    input   wire        read_enable_b,
    input   wire[4:0]   read_address_b,
    output  reg[31:0]   read_data_b,

    //  write port
    input   wire        write_enable,
    input   wire[4:0]   write_address,
    input   wire[31:0]  write_data
);
    reg[31:0]   storage[31:0];

    initial begin: initialize
        integer i;
        for (i = 0; i < 32; ++i) begin
            storage[i] = 32'b0;
        end
    end

    always @ (negedge clock) begin
        if (reset == `RESET_DISABLE) begin
            if ((write_enable == `WRITE_ENABLE) && (write_address != 5'b0)) begin
                storage[write_address] <= write_data;
            end
        end
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            read_data_a <= 32'b0;
        end
        else if (read_address_a == 5'b0) begin
            read_data_a <= 32'b0;
        end
        else if (read_enable_a == `READ_ENABLE) begin
            read_data_a <= storage[read_address_a];
        end
        else begin
            read_data_a <= 32'b0;
        end
    end

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            read_data_b <= 32'b0;
        end
        else if (read_address_b == 5'b0) begin
            read_data_b <= 32'b0;
        end
        else if (read_enable_b == `READ_ENABLE) begin
            read_data_b <= storage[read_address_b];
        end
        else begin
            read_data_b <= 32'b0;
        end
    end
endmodule