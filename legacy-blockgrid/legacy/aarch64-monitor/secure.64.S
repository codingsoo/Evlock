//
// AArch64 Secure Monitor Example
//
// Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
//


// 64-bit secure world entry point and software
//  

  .include "monitor.h"

  .global secure_entry

secure_world:
  .word end - .       // code size
  .word MODE_EL1h
  .quad secure_entry

secure_entry:
  // enable fp
  mrs x4, cpacr_el1
  orr w4, w4, #(3<<20)  // FPEN = 11
  msr cpacr_el1, x4
  mov x0, #0
  mov x4, #1
  fmov d0, xzr
  fmov d1, #1.5
s_loop:
  smc #0
  add x0, x0, #1
  add x4, x4, #1
  tbz x4, 1, s_loop
  fadd d0, d0, d1   // do this when counter bit 1 is one
  b s_loop

end:
