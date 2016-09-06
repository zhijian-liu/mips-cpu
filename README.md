# `mips-cpu`

## Introduction

`mips-cpu` is an `OpenMIPS`-like toy CPU with five-stage MIPS pipeline.

## Prepare environment for Mac OS X

### Install the `iverilog`
From a terminal:

	brew install icarus-verilog
	
After installation, you can try the following command to see the version information:

	iverilog -v

### Install the `GCC toolchain`
From a terminal:
	
	T.B.D

## Installation
From a terminal:
	
	git clone git@github.com:zhijian-liu/mips-cpu.git

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
	test-load-store
	test-load-stall
	test-forwarding
	
If you want to run a single test case, you can use the following command:
	
	cd test/`test-case-name` && make all
	
For example, you can check whether the `data forwarding` is implemented correctly by
	
	cd test/test-forwarding && make all

