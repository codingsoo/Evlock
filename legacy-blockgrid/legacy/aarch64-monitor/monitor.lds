/*
 * Loader script for secure monitor program in Secure Monitor Example
 *
 * Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
 */

ENTRY(monitor_reset);

SECTIONS
{
  /DISCARD/ : { *(.ARM.attributes);}
 
  /* Reset code in secure ROM */
  .reset : { *(.boot); } >secure_rom
  /* Monitor vectors */
  .vectors : { *(.vectors); } >secure_rom
  .handlers : { *(.handlers); } >secure_rom

  /* Monitor workspace in secure SRAM */
  .context : {
    monitor_context = ALIGN(0x1000);
    . += MAX_CPUS * 2 * context_size;
    monitor_econtext = .;
    } >secure_sram
  
  /* secure and non-secure entry-point data structure addresses */
  .s_world : { secure_world = .; } >secure_dram
  .ns_world : { non_secure_world = .; } >ns_load_ram
}

