all:
	@printf "\e[96;1m==>\e[0m start testing logic\n"
	cd ../ && python assemble.py -s test-logic/asm.s -o test-logic/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp
	@printf "\n"