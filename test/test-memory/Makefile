all:
	@printf "\e[96;1m==>\e[0m start testing memory\n"
	cd ../ && python assemble.py -s test-memory/asm.s -o test-memory/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp
	@printf "\n"