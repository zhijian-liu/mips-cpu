`define ASSERT(x) do begin \
        if (!(x)) begin \
            $display("\033[91;1m[%s:%0d]assertion failure: %s\033[0m", `__FILE__, `__LINE__, `"x`"); \
            $finish_and_return(1); \
        end \
    end while (0)

`define PASS #2 do begin \
		$display("\033[92;1mtest passed.\033[0m"); \
		$finish; \
	end while (0)

`define AR(id, expected) `ASSERT(sopc.cpu.register.storage[id]           === expected)
`define AHI(expected)    `ASSERT(sopc.cpu.stage_wb.register_hi_read_data === expected)
`define ALO(expected)    `ASSERT(sopc.cpu.stage_wb.register_lo_read_data === expected)