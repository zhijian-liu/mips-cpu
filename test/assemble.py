#!/usr/bin/env python
import os, sys, argparse, binascii

parser = argparse.ArgumentParser()
parser.add_argument("-s", dest = "s", default = "assemble.s", type = str)
parser.add_argument("-o", dest = "o", default = "rom.txt", type = str)
parser.add_argument("-bin", dest = "bin", default = "~/mips-gcc-4.8.1/bin", type = str)
args = parser.parse_args()

os.system("{}/mips-elf-as -mips32 {} -o rom.o".format(args.bin, args.s))
os.system("{}/mips-elf-ld rom.o -o rom.om".format(args.bin))
os.system("{}/mips-elf-objcopy -O binary rom.om rom.bin".format(args.bin))

with open(args.o, "w") as f:
	s = binascii.b2a_hex(open("rom.bin", "rb").read())
	for i in xrange(len(s) / 8):
		print >> f, s[i * 8 : (i + 1) * 8]

os.system("rm rom.o rom.om rom.bin")