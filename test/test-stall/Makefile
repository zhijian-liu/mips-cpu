all:
	@printf "\e[96;1m==>\e[0m start testing stall\n"
	cd ../ && python assemble.py -s test-stall/asm.s -o test-stall/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp
	@printf "\n"