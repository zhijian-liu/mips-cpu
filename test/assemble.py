#!/usr/bin/env python
import os, sys, argparse, platform, binascii

assert platform.system() in ["Darwin", "Linux"]

parser = argparse.ArgumentParser()
parser.add_argument("-s", dest = "s", default = "assemble.s", type = str)
parser.add_argument("-o", dest = "o", default = "rom.txt", type = str)
args = parser.parse_args()

if platform.system() == "Darwin":
	args.tc = "~/mips-gcc-4.8.1/bin/mips-elf-"
elif platform.system() == "Linux":
	args.tc = "~/mips-2014.05/bin/mips-sde-elf-"

os.system("{}as -mips32 {} -o rom.o".format(args.tc, args.s))
os.system("{}ld -T ram.ld rom.o -o rom.om".format(args.tc))
os.system("{}objcopy -O binary rom.om rom.bin".format(args.tc))

with open(args.o, "w") as f:
	s = binascii.b2a_hex(open("rom.bin", "rb").read())
	for i in xrange(len(s) / 8):
		print >> f, s[i * 8 : (i + 1) * 8]

os.system("rm rom.o rom.om rom.bin")