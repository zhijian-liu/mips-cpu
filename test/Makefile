all:
	cd assembler && python assembler.py
	iverilog -c filelist.txt -o testbench.vvp
	vvp testbench.vvp
	rm testbench.vvp
	cd assembler && rm rom.txt

clean:
	rm simulation.vcd
