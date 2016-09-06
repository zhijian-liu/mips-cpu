module register(
    input             clock         ,
    input             reset         ,
    input             read_enable_a ,
    input      [ 4:0] read_address_a,
    output reg [31:0] read_data_a   ,
    input             read_enable_b ,
    input      [ 4:0] read_address_b,
    output reg [31:0] read_data_b   ,
    input             write_enable  ,
    input      [ 4:0] write_address ,
    input      [31:0] write_data     
);
    reg [31:0] storage[31:0];

    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            read_data_a <= 32'b0;
        end
        else if (read_enable_a == `READ_ENABLE && read_address_a != 5'b0) begin
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
        else if (read_enable_b == `READ_ENABLE && read_address_b != 5'b0) begin
            read_data_b <= storage[read_address_b];
        end
        else begin
            read_data_b <= 32'b0;
        end
    end

    always @ (negedge clock) begin
        if (
            reset         == `RESET_DISABLE && 
            write_enable  == `WRITE_ENABLE  &&
            write_address != 5'b0
        ) begin
            storage[write_address] <= write_data;
        end
    end
endmodule