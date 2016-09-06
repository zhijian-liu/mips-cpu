module control(
    input            reset           ,
    input            id_stall_request,
    input            ex_stall_request,
    output reg[ 5:0] stall
);
    always @ (*) begin
        if (reset == `RESET_ENABLE) begin
            stall <= 6'b000000;
        end
        else begin
            if (ex_stall_request == `STALL_ENABLE) begin
                stall <= 6'b001111;
            end
            else if (id_stall_request == `STALL_ENABLE) begin
                stall <= 6'b000111;
            end
            else begin
                stall <= 6'b000000;
            end
        end
    end
endmodule