/* 
 * AArch64 Secure Monitor Example
 *
 * Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
 */


/* Common assembler defintions for ARMv8 Secure Monitor Example */


/* AArch64 processor modes */

  .equ MODE_EL3h, 0b01101
  .equ MODE_EL3t, 0b01100
  .equ MODE_EL2h, 0b01001
  .equ MODE_EL2t, 0b01000
  .equ MODE_EL1h, 0b00101
  .equ MODE_EL1t, 0b00100
  .equ MODE_EL0t, 0b00000

/* AArch32 processor modes */
  
  .equ MODE_usr, 0b10000
  .equ MODE_fiq, 0b10001
  .equ MODE_irq, 0b10010
  .equ MODE_svc, 0b10011
  .equ MODE_mon, 0b10110
  .equ MODE_abt, 0b10111
  .equ MODE_hyp, 0b11010
  .equ MODE_und, 0b11011
  .equ MODE_sys, 0b11111
  

