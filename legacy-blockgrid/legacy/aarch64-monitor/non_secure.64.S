//
// AArch64 Secure Monitor Example
//
// Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
//


// 64-bit non-secure world entry point and software
//

  .include "monitor.h"

  .global non_secure_entry

non_secure_world:
  .word end - .       // code size
  .word MODE_EL1h
  .quad non_secure_entry

non_secure_entry:
  mrs x4, cpacr_el1
  orr w4, w4, #(3<<20)  // FPEN = 11
  msr cpacr_el1, x4
  mov x4, #-1
  fmov d0, xzr
  fmov d2, #2.5

ns_loop:
  add x0, x0, #1
  sub x4, x4, #1
  smc #0
  tbz x4, 2, ns_loop
  fsub d0, d0, d2
  b ns_loop
  
end:
