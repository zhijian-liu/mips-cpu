# `mips-cpu`

## Introduction

This project is an `OpenMIPS`-like toy CPU with five-stage MIPS pipeline.

## Preparation for Linux

### Install the `iverilog`
```shell
git clone https://github.com/steveicarus/iverilog.git
cd iverilog && git checkout --track -b v10-branch origin/v10-branch
sudo apt-get install autoconf gperf flex bison
sh autoconf.sh && ./configure
sudo make && sudo make install
```

After installation, you may try the following command to see the version information:

```shell
iverilog -v
```

### Install the `GCC toolchain`	
```shell
wget https://sourcery.mentor.com/GNUToolchain/package12725/public/mips-sde-elf/mips-2014.05-24-mips-sde-elf-i686-pc-linux-gnu.tar.bz2
tar jxvf mips-2014.05-24-mips-sde-elf-i686-pc-linux-gnu.tar.bz2
rm mips-2014.05-24-mips-sde-elf-i686-pc-linux-gnu.tar.bz2
mv mips-2014.05 ~
```

### One more step for 64-bit Linux
```shell
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
```

## Preparation for Mac OS X

### Install the `iverilog`
```shell
brew install icarus-verilog
```

After installation, you may try the following command to see the version information:

```shell
iverilog -v
```

### Install the `GCC toolchain`	
```shell
wget https://github.com/sergev/LiteBSD/releases/download/tools/gcc-4.8.1-mips-macosx.tgz
tar zxvf gcc-4.8.1-mips-macosx.tgz
rm gcc-4.8.1-mips-macosx.tgz
mv mips-gcc-4.8.1 ~
```

## Installation
```shell
git clone https://github.com/zhijian-liu/mips-cpu.git
```

## Usages
```shell
cd test && make all
```

In detail, the `test` is composed of the following unit test cases:	
	test-logic
	test-shift
	test-move
	test-arithmetic
	test-jump
	test-branch
	test-memory
	test-stall
	test-forwarding
	test-yamin

If you want to run a single unit test case, you may use the following command:



```shell
cd test/<test-name> && make all
```
For example, you can check whether the `data forwarding` module is implemented correctly by



```Bash
cd test/test-forwarding && make all
```

## License
This project is released under the [open-source MIT license](https://github.com/zhijian-liu/mips-cpu/blob/master/LICENSE).

