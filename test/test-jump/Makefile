all:
	@printf "\e[96;1m==>\e[0m start testing jump\n"
	cd ../ && python assemble.py -s test-jump/asm.s -o test-jump/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp
	@printf "\n"