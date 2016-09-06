all:
	@printf "\e[96;1m===================== memory-2 =====================\e[0m\n"
	cd ../ && python assemble.py -s memory-2/asm.s -o memory-2/rom.txt
	iverilog -c ../filelist.txt -g2009 -o test.vvp
	vvp test.vvp
	rm -rf rom.txt test.vvp