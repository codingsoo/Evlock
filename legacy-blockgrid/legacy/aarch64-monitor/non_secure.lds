/*
 * Loader script for non-secure domain program in Secure Monitor Example
 *
 * Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
 */


SECTIONS
{
  /DISCARD/ : { *(.ARM.attributes);}
 
  /* Load to secure memory (ns_load_ram), but relocate for non-secure DRAM */
  .ns_load : { ns_load_addr = .; } >ns_load_ram
  .ns_world : AT( ns_load_addr ) { *(*); } >nonsecure_dram
}

