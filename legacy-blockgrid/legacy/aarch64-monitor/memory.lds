/*
 * Common Loader Script definitions for ARMv8 Secure Monitor Example code
 *
 * Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
 */

/* Physical addresses used by linker to locate the monitor, secure and non-secure worlds.
 *
 * These are based on the memory map provided by the RTSM_VE_AEMv8 model with secure memory enabled
 * using option "-C daughterboard.secure_memory=true"
 */

MEMORY
  {
  secure_rom (rx) : org = 0x00000000, l = 128K
  secure_sram     : org = 0x04000000, l = 128K
  secure_dram     : org = 0x7e000000, l = 31M
  ns_load_ram     : org = 0x7ff00000, l = 1M
  nonsecure_dram  : org = 0x80000000, l = 2048M
  }

/* CPU limit used to reserve monitor working memory */
MAX_CPUS = 4;

