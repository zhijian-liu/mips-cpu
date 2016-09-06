all:
	@printf "\e[96;1m==>\e[0m start testing branch\n"
	cd ../ && python assemble.py -s test-branch/asm.s -o test-branch/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp
	@printf "\n"