module ram(
    input             clock        ,
    input             chip_enable  ,
    input             read_enable  ,
    input      [31:0] read_address ,
    output reg [31:0] read_data    ,
    input             write_enable ,
    input      [31:0] write_address,
    input      [ 3:0] write_select ,
    input      [31:0] write_data    
);
    reg [31:0] storage[0:1024];

    always @ (*) begin
        if (chip_enable == `CHIP_ENABLE && read_enable == `READ_ENABLE) begin
            read_data <= storage[read_address[18:2]];
        end
        else begin
            read_data <= 32'b0;
        end
    end

    always @ (negedge clock) begin
        if (chip_enable == `CHIP_ENABLE && write_enable == `WRITE_ENABLE) begin
            if (write_select[3] == 1'b1) begin
                storage[write_address[18:2]][31:24] <= write_data[31:24];
            end
            if (write_select[2] == 1'b1) begin
                storage[write_address[18:2]][23:16] <= write_data[23:16];
            end
            if (write_select[1] == 1'b1) begin
                storage[write_address[18:2]][15:8] <= write_data[15:8];
            end
            if (write_select[0] == 1'b1) begin
                storage[write_address[18:2]][7:0] <= write_data[7:0];
            end
        end
    end
endmodule