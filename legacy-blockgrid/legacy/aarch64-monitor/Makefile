#
# Makefile - build ELF images for Secure Monitor Example
#
# Copyright (C) 2011-2013 ARM Limited. All rights reserved.
#

# select Thumb2 instruction sets for 32 bit code
CFLAGS += -DTHUMB -DHAS_AARCH32_EL1=$(ARM_HAS_AARCH32_EL1) -DHAS_T2EE=$(ARM_HAS_THUMB2EE)

LDFLAGS += -T memory.lds

# locations of AArch32 and AArch64 toolchains should be defined in environment
include config

CC64		= $(ARM_AARCH64_GNU_TOOLS)gcc
LD64		= $(ARM_AARCH64_GNU_TOOLS)ld

CFLAGS64 = $(CFLAGS) 
LDFLAGS64 = $(LDFLAGS) --oformat=elf64-littleaarch64

CC32		= $(ARM_AARCH32_GNU_TOOLS)gcc
LD32		= $(ARM_AARCH32_GNU_TOOLS)ld

CFLAGS32 = $(CFLAGS) -mcpu=cortex-a9 -mfpu=vfp3
LDFLAGS32 = $(LDFLAGS) 

all: monitor.64.elf secure.32.elf secure.64.elf non_secure.32.elf non_secure.64.elf

clean:
	rm -f *.elf *.o model.script

%.64.elf: %.64.o %.lds memory.lds
	$(LD64) $(LDFLAGS64) -o $@ $< -T $(*).lds
	
%.64.o: %.64.S Makefile config monitor.h
	$(CC64) $(CFLAGS64) -c -o $@ $<
	
%.32.elf: %.32.o %.lds memory.lds
	$(LD32) $(LDFLAGS32) -o $@ $< -T $(*).lds
	
%.32.o: %.32.S Makefile config monitor.h
	$(CC32) $(CFLAGS32) -c -o $@ $<



