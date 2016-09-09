# `mips-cpu`

## Introduction

`mips-cpu` is an `OpenMIPS`-like toy CPU with five-stage MIPS pipeline.

## Prepare environment for Linux

### Install the `iverilog`
From a terminal:

	# install some dependency packages
	sudo apt-get update

	# download the iverilog
	git clone https://github.com/steveicarus/iverilog.git
	cd iverilog && git checkout --track -b v10-branch origin/v10-branch
	
	# configure and install the iverilog
	sh autoconf.sh
	./configure
	sudo make
	sudo make install
		
After installation, you can try the following command to see the version information:

	iverilog -v

### Install the `GCC toolchain`
From a terminal:
	
	wget https://sourcery.mentor.com/GNUToolchain/package12725/public/mips-sde-elf/mips-2014.05-24-mips-sde-elf-i686-pc-linux-gnu.tar.bz2
	tar jxvf mips-2014.05-24-mips-sde-elf-i686-pc-linux-gnu.tar.bz2
	rm mips-2014.05-24-mips-sde-elf-i686-pc-linux-gnu.tar.bz2
	mv mips-2014.05 ~

### One more step for 64-bit Linux
From a terminal:

	sudo dpkg --add-architecture i386
	sudo apt-get update
	sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386

## Prepare environment for Mac OS X

### Install the `iverilog`
From a terminal:

	brew install icarus-verilog
	
After installation, you can try the following command to see the version information:

	iverilog -v

### Install the `GCC toolchain`
From a terminal:
	
	wget https://github.com/sergev/LiteBSD/releases/download/tools/gcc-4.8.1-mips-macosx.tgz
	tar zxvf gcc-4.8.1-mips-macosx.tgz
	rm gcc-4.8.1-mips-macosx.tgz
	mv mips-gcc-4.8.1 ~

## Installation
From a terminal:
	
	git clone https://github.com/zhijian-liu/mips-cpu.git

## Run the tests
From a terminal:

	cd test && make all
	
The `test` is composed of the following test cases:
	
	test-logic
	test-shift
	test-move
	test-arithmetic
	test-jump
	test-branch
	test-memory
	test-stall
	test-forwarding
	
If you want to run a single test case, you can use the following command:
	
	cd test/`test-case-name` && make all
	
For example, you can check whether the `data forwarding` is implemented correctly by
	
	cd test/test-forwarding && make all

