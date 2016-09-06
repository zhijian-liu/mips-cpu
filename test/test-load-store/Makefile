all:
	@printf "\e[96;1m================================================== test-load-store ==================================================\e[0m\n"
	cd ../ && python assemble.py -s test-load-store/asm.s -o test-load-store/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp