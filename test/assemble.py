#!/usr/bin/env python
import os, sys, argparse, platform, binascii

if not platform.system() in ["Darwin", "Linux"]:
	print "Operator system {} is not supported!".format(platform.system())

parser = argparse.ArgumentParser()
parser.add_argument("-s", dest = "s", default = "assemble.s", type = str)
parser.add_argument("-o", dest = "o", default = "rom.txt", type = str)
if platform.system() == "Darwin":
	parser.add_argument("-bin", dest = "bin", default = "~/mips-gcc-4.8.1/bin", type = str)
elif platform.system() == "Linux":
	parser.add_argument("-bin", dest = "bin", default = "~/mips-2014.05/bin", type = str)
args = parser.parse_args()

if platform.system() == "Darwin":
	os.system("{}/mips-elf-as -mips32 {} -o rom.o".format(args.bin, args.s))
	os.system("{}/mips-elf-ld rom.o -o rom.om".format(args.bin))
	os.system("{}/mips-elf-objcopy -O binary rom.om rom.bin".format(args.bin))
elif platform.system() == "Linux":
	os.system("{}/mips-sde-elf-as -mips32 {} -o rom.o".format(args.bin, args.s))
	os.system("{}/mips-sde-elf-ld rom.o -o rom.om".format(args.bin))
	os.system("{}/mips-sde-elf-objcopy -O binary rom.om rom.bin".format(args.bin))

with open(args.o, "w") as f:
	s = binascii.b2a_hex(open("rom.bin", "rb").read())
	for i in xrange(len(s) / 8):
		print >> f, s[i * 8 : (i + 1) * 8]

os.system("rm rom.o rom.om rom.bin")