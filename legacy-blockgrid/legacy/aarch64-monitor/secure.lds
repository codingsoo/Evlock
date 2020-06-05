/*
 * Loader script for secure domain program in Secure Monitor Example
 *
 * Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
 */


SECTIONS
{
  /DISCARD/ : { *(.ARM.attributes);}
 
  /* Load to secure DRAM address */
  .s_world : { *(*); } >secure_dram
}

