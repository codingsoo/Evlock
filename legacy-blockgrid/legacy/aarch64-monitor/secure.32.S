@
@ AArch64 Secure Monitor Example
@
@ Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
@


@ 32-bit secure world entry point and software
@ Compile as either A2 or T2 instructions
@  

  .include "monitor.h"

  .global secure_entry

secure_world:
  .word end - .            @ code size
  .word MODE_svc
  .word secure_entry, 0    @ 64-bit address field

#ifdef THUMB
  .thumb_func
#endif
secure_entry:

@ Access the VFP by enabling cp10 and 11 in the CPACR and setting FPEXC.EN=1
  mrc p15, 0, r4, c1, c0, 2   @ CPACR
  mov r5, #0xf
  lsl r5, r5, #20
  orr r4, r4, r5
  mcr p15, 0, r4, c1, c0, 2
  isb

@ vmrs r4, fpexc             @ This form of the instruction only supported after
  mrc p10, 7, r4, c8, c0, 0  @ binutils 2.23.1 in very recent GCC toolchains
  
  mov r5, #1
  lsl r5, r5, #30
  orr r4, r4, r5
  
@ vmsr fpexc, r4             @ This form of the instruction only supported after
  mcr p10, 7, r4, c8, c0, 0  @ binutils 2.23.1 in very recent GCC toolchains

  vmov.f64 d1, #1.5
  vsub.f64 d0, d1, d1

  mov r0, #0
  mov r4, #1

s_loop:
  smc #1
  add r0, r0, #1
  add r4, r4, #1
  mov r5, #2
  tst r4, r5
  beq s_loop
  vadd.f64 d0, d0, d1
  b s_loop

end:
