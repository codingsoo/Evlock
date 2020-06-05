// 
// AArch64 Secure Monitor Example
//
// Copyright (c) 2011-2013, ARM Ltd. All rights reserved.
//

// The EL3 software, including:
// * CPU initialisation following a Hard reset into EL3 RVBAR
// * Secure Monitor initialisation
// * Secure Monitor saved-context definition
// * Secure Monitor EL3 execption vectors, supporting secure/non-secure context
//   switch of CPU/system on SMC and lazy VFP/NEON context switch

// This example monitor can work with any "secure world" and "non-secure" world
// binaries that start with the following data stucture:
  .struct 0
world_codesize:    .space 4    // byte size of the binary code (including this header)
world_CPU_mode:    .space 4    // 5-bit CPU processor mode (see monitor.h) to use for entry
world_entry_point: .space 8    // 64-bit entry point address (lsb=1 for AArch32 THUMB ep)


  .include "monitor.h"
// ______________________________________________________________________________
//
// CPU initialisation from hard reset
//
// Assume minimal process state is initialised
//

  .section .boot, "ax"

  .global monitor_reset
monitor_reset:

  // Setup EL3 configuration registers
  
  // Very little state is defined at reset, but many bits of the system registers
  // are RES0, RES1, SBOP, SBZP or IMPDEF so those bits should not be modified
  // while initialising the other parts of the register state. Hence read-modify-
  // write is used for many of the control registers here.
  
  // If neccesary, initialisation of EL3 IMPDEF regsisters may be required as well

  // EL3 essential initialisation
  
  // VBAR_EL3
  //   zero for good measure (so when debugging boot it does not look valid)
  
  msr vbar_el3, xzr

  // SCTLR_EL3
  //   M, C, I are zero at reset
  //   EE: imp. def at reset. We propagate to EL2 and EL1: this example assumes that
  //       all code has same endianess
  //   WXN: set 1. Security, but only really matters when MMU enabled for EL3 memory
  //        translation
  //   SA: set 1. Enable stack alignment checking in EL3 (we are using the stack for
  //       other purposes but it needs to be aligned for the STP operations)
  //   A: set 1. Enable alignment checking (we don't expect to do anything clever in EL3)
  
  mrs x0, sctlr_el3
  orr w0, w0, #(1<<19)|(1<<3)
  orr w0, w0, #(1<<1)
  msr sctlr_el3, x0

  // CPTR_EL3
  //   TCPAC, TTA: set 0.
  //   TFP: set 1. Disable FP access from EL3 - makes context switch more complex
  //   expect monitor_init set this up as required
  
  mrs x1, cptr_el3
  bic w1, w1, #(1<<31)    // TCPAC
  bic w1, w1, #(1<<20)    // TTA
  orr w1, w1, #(1<<10)    // TFP
  msr cptr_el3, x1

  // SCR_EL3
  //   This register is logically part of the secure/non-secure world contex
  //   Initialise this register from monitor_init, where we know what the
  //   secure/non-secure worlds look like


  // General system initialisation required at EL3

  // Set Counter frequency (Writeable only from EL3)

  .equ CFG_COUNTERFREQ, 24000000

  mov x0, #(CFG_COUNTERFREQ & 0xffff)
  movk x0, #(CFG_COUNTERFREQ >> 16), lsl 16
  msr cntfrq_el0, x0

  //
  // ... other early init here ... (e.g. if translation required at EL3, or
  // cache should be enabled etc)
  //

  // Set up paramters for the Monitor initialisation
  
  // secure-world entry point. Load entry-point address and mode from memory
  ldr x0, =secure_world         // secure world load address (== run address)
  ldr w1, [x0, #world_CPU_mode]
  ldr x0, [x0, #world_entry_point]

  // non-secure-world entry point. Load entry-point address and mode from memory
  ldr x2, =non_secure_world     // non-secure world load address
  ldr w3, [x2, #world_CPU_mode]
  ldr x2, [x2, #world_entry_point]
  
  b monitor_init


// ______________________________________________________________________________
//
// Monitor workspace definition
//

// Structure, from base pointer:
//    offset : content
//   -0x0200 : 32 * 128-bit Q registers (Q0-Q31)
//    0x0000 : system registers
//    0x00e0 : GP registers X0-X30
//    0x01d8 : SP_EL0

// The context is arranged to pair up 64-bit and 32-bit registers so 
// that LDP instructions can be used to save and restore all the state
// 32-bit registers are stored at offsets 0x000-0x100 so that the LDP/STP
// immediate forms are adequate to address all context

	.struct 0
FP_q0:					.space 16
FP_q1:					.space 16
FP_q2:					.space 16
FP_q3:					.space 16
FP_q4:					.space 16
FP_q5:					.space 16
FP_q6:					.space 16
FP_q7:					.space 16
FP_q8:					.space 16
FP_q9:					.space 16
FP_q10:					.space 16
FP_q11:					.space 16
FP_q12:					.space 16
FP_q13:					.space 16
FP_q14:					.space 16
FP_q15:					.space 16
FP_q16:					.space 16
FP_q17:					.space 16
FP_q18:					.space 16
FP_q19:					.space 16
FP_q20:					.space 16
FP_q21:					.space 16
FP_q22:					.space 16
FP_q23:					.space 16
FP_q24:					.space 16
FP_q25:					.space 16
FP_q26:					.space 16
FP_q27:					.space 16
FP_q28:					.space 16
FP_q29:					.space 16
FP_q30:					.space 16
FP_q31:					.space 16

FP_qreg_size = .

  .struct 0

context_spsr_el3:    .space 4            // EL3 exception return processor state
context_spsr_el1:    .space 4            // EL1 exception return processor state
context_elr_el3:     .space 8            // EL3 exception return address
context_elr_el1:     .space 8            // EL1 exception return address
#if HAS_AARCH32_EL1
context_spsr_abt:    .space 4            // AArch32 abt mode spsr
context_spsr_und:    .space 4            // AArch32 und mode spsr
context_spsr_irq:    .space 4            // AArch32 irq mode spsr
context_spsr_fiq:    .space 4            // AArch32 fiq mode spsr
#endif

context_sctlr_el1:   .space 4            // EL1 System control register
context_actlr_el1:   .space 4            // EL1 Aux. control register (IMP DEF)
context_cpacr_el1:   .space 4            // (EL1) Coprocessor access control register
context_csselr_el1:  .space 4            // Cache size selection register

context_sp_el1:      .space 8            // EL1 'handler' stack pointer
context_vbar_el1:    .space 8            // EL1 Vector base address register

context_ttbr0_el1:   .space 8            // EL1 Translation table base register 0
context_ttbr1_el1:   .space 8            // EL1 Translation table base register 1
context_tcr_el1:     .space 8            // EL1 Translation control register
context_mair_el1:    .space 8            // EL1 Memory attribute indirection register
context_amair_el1:   .space 8            // EL1 Aux. Memory attribute indirection register (IMP DEF)

context_tpidr_el0:   .space 8            // EL0 Software thread ID register
context_tpidrro_el0: .space 8            // EL0 Read-only software thread ID register
context_tpidr_el1:   .space 8            // EL1 Software thread ID register

#if HAS_AARCH32_EL1
context_dacr32_el2:  .space 4						 // AArch32 Domain access control register

context_ifsr32_el2:  .space 4            // AArch32 Instruction fault status register
#endif
context_par_el1:     .space 8            // (EL1) Physical address register
context_far_el1:     .space 8            // EL1 Fault address register
context_afsr0_el1:   .space 4            // EL1 Aux. fault status register 0 (IMP DEF)
context_afsr1_el1:   .space 4            // EL1 Aux. fault status register 1 (IMP DEF)
context_esr_el1:     .space 4            // EL1 Exception syndrome register

context_contextidr_el1:.space 4          // (EL1) Context ID register

#if HAS_T2EE
context_teecr32_el1: .space 4            // AArch32 ThumbEE control register
context_teehbr32_el1:.space 4            // AArch32 ThumbEE handler base register
#endif

  // Generic timer registers. 
  //
  // TODO: does it make sense to effectively stop the EL0 timer on secure
  // side when we switch to non-secure? Should secure side actually be
  // using the EL3 timer registers?
  //
context_cntkctl_el1: .space 4            // Counter Kernel control
context_cntp_ctl_el0:.space 4            // EL0 physical timer control
context_cntp_cval_el0:.space 8           // EL0 physical timer compare value
context_cntv_cval_el0:.space 8           // EL0 virtual timer compare value
context_cntv_ctl_el0:.space 4            // EL0 virtual timer control

  // SCR_EL3 this register forms part of the secure/non-secure context as
  // it defines the behaviour of the lower ELs, which depends on which world
  // we are 'in'. We save and restore it in the same way as the rest of the
  // EL1/0 context.
  // Security failures due to overwrite of the NS bit in memory are a subset
  // of the issues related to context overwrite and buggy secure-world
  // software in general. This example does not attempt to counter such threats
context_scr_el3:     .space 4
  
  // debug state?
context_dspsr:
context_dlr:

  // floating point context
context_fpsr:        .space 4
context_fpcr:        .space 4
#if HAS_AARCH32_EL1
context_fpexc32_el2: .space 4
#endif

  // GP register context X0-X30
.align 3
context_x0:          .space 8
context_x1:					.space 8
context_x2:          .space 8
context_x3:					.space 8
context_x4:          .space 8
context_x5:					.space 8
context_x6:          .space 8
context_x7:					.space 8
context_x8:          .space 8
context_x9:					.space 8
context_x10:         .space 8
context_x11:					.space 8
context_x12:         .space 8
context_x13:					.space 8
context_x14:         .space 8
context_x15:					.space 8
context_x16:         .space 8
context_x17:					.space 8
context_x18:         .space 8
context_x19:					.space 8
context_x20:         .space 8
context_x21:					.space 8
context_x22:         .space 8
context_x23:					.space 8
context_x24:         .space 8
context_x25:					.space 8
context_x26:         .space 8
context_x27:					.space 8
context_x28:         .space 8
context_x29:					.space 8
context_x30:         .space 8
context_sp_el0:      .space 8            // Common stack pointer

.align 5

  .global context_size
context_size = . + FP_qreg_size


// _________________________________________________________________________
//
// Secure Monitor initialisation
//
// Initalise monitor context and EL3 register state
//
// On entry:
//   x0: secure world entry point address
//   w1: secure world entry point processor mode
//
//   x2: non-secure world entry point address
//   w3: non-secure world entry point processor mode
// 
// This function does not return to the caller, instead it 'returns' to the
// secure world entry point. The non-secure world context is initialised so
// that the first SMC from secure world 'returns' to the non-secure world
// entry point in the specified mode.
//
// Assume that the EL0/EL1/EL2 system register state is unused and needs to
// be initialised: provide minimal initialisation to ensure safe initial
// execution in EL2 and EL1 states. The [non-]secure entry points must then
// do any further initialisation as required.
//

  .section .boot, "ax"

  .global monitor_init
monitor_init:

  // set up the monitor vector base address to handle SMC & VFP traps
  ldr x8, =monitor_vectors
  msr vbar_el3, x8

  // Secure & non-secure context is stored in memory, secure first, laid out
  // as described in the monitor workspace definition. On subsequent entry
  // to EL3, SP_EL3 points to the block that is used to store the 'current'
  // executing context.
  // Each CPU has its own pair of contexts, starting with CPU0 at monitor_context
  
  // Read MPIDR and detect cpu ID
  mrs x8, mpidr_el1
  and w8, w8, #0x3                  // MPIDR.CPUID (Affinity Level 0)

  // Identify and zero-initialise context storage for this CPU
  ldr x9, =monitor_context          // base address
  mov w10, #context_size * 2        // per CPU context size
  umaddl x8, w8, w10, x9
  // Initialize EL3 stack pointer to secure mode context + offset for this CPU
  add sp, x8, #FP_qreg_size           // Base of monitor context for this CPU

  // zero initialise this CPU context
  add x9, x8, #context_size * 2
zero_loop:
  stp xzr, xzr, [x9, #-16]!
  cmp x9, x8
  b.gt zero_loop

  // use the entry point data to construct the initial S/NS spsr_el3, hcr_el2
  // and scr_el3 values. w1/w3 will be extended from the input mode values to
  // full spsrs for the entry points.
  // Separate secure and non-secure versions of SCR_EL3 are constructed
  mov x8, xzr               // hcr_el2 in w8: zero init is good
  mrs x9, scr_el3           // Secure copy of scr_el3 in w9
  mov w10, #0x78f           // clear most bits: lower level AArch32, disable HVC, enable SMC
  bic w9, w9, w10           //   do not intercept aborts and interrupts, secure world
  orr w9, w9, #(1<<9)       // set scr_el3.sif
  orr w10, w9, #1           // NS world scr_el3 in w10: set NS bit
  mrs x12, sctlr_el3
  ubfx w12, w12, 25, 1      // EE bit in w12[0]

  tbnz w3, 4, ns_aarch32_init // check NS entry-point type

ns_aarch64_init:            // 64 bit NS world, check for mode and setup state
  ubfx w11, w3, 2, 2        // extract EL from NS AArch64 processor mode
  cmp w11, #2
  orr w11, w10, #(1<<8)     // set scr_el3.hce
  csel w10, w11, w10, eq    // enable NS HVC if entering EL2
  orr w10, w10, #(1<<10)    // set NS scr_el3.rw for 64-bit
  orr w8, w8, #(1<<31)      // set hcr_el2.rw. Irrelevant but harmless if entering EL2
  orr w3, w3, #0x3c0        // set NS spsr_el3.DAIF (mask everything on entry)

  tbnz w1, 4, s_aarch32_init // check secure entry-point type

s_aarch64_init:             // 64 bit S world, check for mode and setup state
  orr w9, w9, #(1<<10)      // set Secure scr_el3.rw
  orr w1, w1, #0x3c0        // set Secure spsr_el3.DAIF (mask everything on entry)
  b ep_init_done
  
ns_aarch32_init:
  cmp w3, #MODE_hyp         // Check NS AArch32 processor mode
  orr w11, w10, #(1<<8)     // set scr_el3.hce
  csel w10, w11, w10, eq    // enable NS HVC if entering hyp mode
  bfi w3, w12, 9, 1         // spsr_el3(ns).e bit
  orr w3, w3, #0x1c0        // set spsr_el3(ns).AIF (mask everything)
  ubfx w11, w2, 0, 1        // extract bit 0 of NS ep address
  bfi w3, w11, 5, 1         // set T bit if THUMB entry point

  tbz w1, 4, s_aarch64_init // check secure entry-point type

s_aarch32_init:             // secure 32-bit entry-point
  bfi w1, w12, 9, 1         // spsr_el3(s).e bit
  orr w1, w1, #0x1c0        // set spsr_el3(s).AIF (mask everything)
  ubfx w11, w0, 0, 1        // extract bit 0 of Secure ep address
  bfi w1, w11, 5, 1         // set T bit if THUMB entry point

ep_init_done:
  // at this point w8 has an initial HCR, w9 and w10 have the secure and non-secure SCR

  // EL2 essential initialisation,
  //   also enabling safe execution of EL1 with no EL2 software
  
  // Runtime check for EL2 support on this CPU, skip init if not present
  mrs x11, id_aa64pfr0_el1
  ubfx x11, x11, 8, 4     // EL2 status on this CPU
  cbz x11, skip_el2_init

  // HCR_EL2
  //   Set up in x8 in preceeding code
  msr hcr_el2, x8

  // SCTLR_EL2
  //   M, C, I: set 0 to initially disable mmu and caches
  //   EE: borrow from EL3 reset value
  //   WXN, SA, A: ignore. EL2 initialisation must set these values
  mrs x8, sctlr_el2
  bfi w8, w12, 25, 1    // EE bit from sctlr_el3
  mov w11, #(1<<12)|(1<<2)|(1<<0)
  bic w8, w8, w11
  msr sctlr_el2, x8

  // CPTR_EL2
  //   TCPAC, TTA and TFP: set 0. In case EL2 not used, do not want EL1
  //   operation to trap to EL2!
  mrs x8, cptr_el2
  bic w8, w8, #(1<<31)
  bic w8, w8, #(1<<20)
  bic w8, w8, #(1<<10)
  msr cptr_el2, x8

	// VPIDR_EL2 and VMPIDR_EL2
	//   Set these to reflect the real MIDR and MPIDR for non-secure EL1 software
	mrs x8, midr_el1
	msr vpidr_el2, x8
	mrs x8, mpidr_el1
	msr vmpidr_el2, x8

  // VBAR_EL2
  //   zero for good measure (so when debugging OS bringup it is clearly invalid)
  msr vbar_el2, xzr
  
skip_el2_init:

  // EL1 essential initialisation, just enough to enable safe entry into EL1

  // SCTLR_EL1
  //   M, C, I: set 0 to initially disable mmu and caches
  //   EE: borrow from EL3 reset value
  //   others: ignore. EL1 initialisation must set these values
  mrs x8, sctlr_el1
  bfi w8, w12, 25, 1    // EE bit from sctlr_el3
  mov w11, #(1<<12)|(1<<2)|(1<<0)
  bic w8, w8, w11
  msr sctlr_el1, x8

  // CPACR_EL1
  //   can ignore: EL1 initialisation must init this register
  
  // VBAR_EL1
  //   zero for good measure (so when debugging OS bringup it is clearly invalid)
  msr vbar_el1, xzr

  // Initialise NS system register 'saved' context for 1st SMC switch.
  // Only do this for registers where zero-init is inappropriate, e.g. imp.def
  // registers, and the master control registers
  mrs x12, actlr_el1
  add x11, sp, #context_size        // non-secure context
  stp w8, w12, [x11, #context_sctlr_el1]
  str w10, [x11, #context_scr_el3]
  str x2, [x11, #context_elr_el3]          // non-secure entry point
  str w3, [x11, #context_spsr_el3]         // non-secure entry state

  // initialise FP ownership to secure side, and enable access in cptr_el3
  mov x10, sp
  msr  tpidr_el3, x10
  mrs x11, cptr_el3
  bic w11, w11, #(1<<10)            // cptr_el3.tfp
  msr cptr_el3, x11

  // set up secure world return and go there
  msr scr_el3, x9
  msr elr_el3, x0
  msr spsr_el3, x1
  .global enter_secure_world
enter_secure_world:
  eret


// _____________________________________________________________________________
//
// Secure Monitor exception vectors
//

  .section .vectors, "ax"
  .align 11             // VBAR_ELn bits [0:10] are RES0
 
  .global monitor_vectors
monitor_vectors:

  // Current EL with SP0

  b __panic_vector      // Synchronous
  .align 7
  b __panic_vector      // IRQ/vIRQ
  .align 7
  b __panic_vector      // FIQ/vFIQ
  .align 7
  b __panic_vector      // Error/vError
  .align 7

  // Current EL with SPx
  
  b __panic_vector      // Synchronous
  .align 7
  b __panic_vector      // IRQ/vIRQ
  .align 7
  b __panic_vector      // FIQ/vFIQ
  .align 7
  b __panic_vector      // Error/vError
  .align 7

  // Lower EL using AArch64

vector_EL012_64_sync:
  stp x20, x21, [sp, #context_x20]    // save some working registers
  stp x22, x23, [sp, #context_x22]
  mrs x20, esr_el3
  ubfx w21, w20, 26, 6  // syndrome class in w21
  cmp w21, #0x7
  b.eq CPTR_trap
  cmp w21, #0x13
  b.eq SMC_32
  cmp w21, #0x17
  b.eq SMC_64
  b __panic_vector      // ignore others for now
  .align 7

  b __panic_vector      // IRQ/vIRQ
  .align 7
  b __panic_vector      // FIQ/vFIQ
  .align 7
  b __panic_vector      // Error/vError
  .align 7

  // Lower EL using AArch32

  b vector_EL012_64_sync  // Synchronous
  .align 7
  b __panic_vector      // IRQ/vIRQ
  .align 7
  b __panic_vector      // FIQ/vFIQ
  .align 7
  b __panic_vector      // Error/vError
  .align 7


  .section .handlers, "ax"
  .align 2

__panic_vector:
  b __panic_vector

// _____________________________________________________________________________
//
// Secure Monitor lazy FP context switch
//
// The current owner of the FP register context is stored in tpidr_el3
// using the sp_el3 value for when that context is active
// We use x20-x23 as working space (saved by vector entry in SP context space)

CPTR_trap:
  mrs x21, cptr_el3
  mrs x20, tpidr_el3
  bic x21, x21, #(1 << 10)    // disable FP trap before accessing FP registers
  msr cptr_el3, x21
  isb													// ensure effective before touching FP registers
  cmp sp, x20
  b.eq FP_context_valid

// save fp context
  mrs x22, fpsr
  mrs x23, fpcr
  stp w22, w23, [x20, #context_fpsr]
  stp q0, q1, [x20, #(FP_q0 - FP_qreg_size)]
  stp q2, q3, [x20, #(FP_q2 - FP_qreg_size)]
  stp q4, q5, [x20, #(FP_q4 - FP_qreg_size)]
  stp q6, q7, [x20, #(FP_q6 - FP_qreg_size)]
  stp q8, q9, [x20, #(FP_q8 - FP_qreg_size)]
  stp q10, q11, [x20, #(FP_q10 - FP_qreg_size)]
  stp q12, q13, [x20, #(FP_q12 - FP_qreg_size)]
  stp q14, q15, [x20, #(FP_q14 - FP_qreg_size)]
  stp q16, q17, [x20, #(FP_q16 - FP_qreg_size)]
  stp q18, q19, [x20, #(FP_q18 - FP_qreg_size)]
  stp q20, q21, [x20, #(FP_q20 - FP_qreg_size)]
  stp q22, q23, [x20, #(FP_q22 - FP_qreg_size)]
  stp q24, q25, [x20, #(FP_q24 - FP_qreg_size)]
  stp q26, q27, [x20, #(FP_q26 - FP_qreg_size)]
  stp q28, q29, [x20, #(FP_q28 - FP_qreg_size)]
  stp q30, q31, [x20, #(FP_q30 - FP_qreg_size)]

// restore current mode FP context
  mov x20, sp
  msr  tpidr_el3, x20
  ldp w22, w23, [x20, #context_fpsr]
  ldp q0, q1, [x20, #(FP_q0 - FP_qreg_size)]
  ldp q2, q3, [x20, #(FP_q2 - FP_qreg_size)]
  ldp q4, q5, [x20, #(FP_q4 - FP_qreg_size)]
  ldp q6, q7, [x20, #(FP_q6 - FP_qreg_size)]
  ldp q8, q9, [x20, #(FP_q8 - FP_qreg_size)]
  ldp q10, q11, [x20, #(FP_q10 - FP_qreg_size)]
  ldp q12, q13, [x20, #(FP_q12 - FP_qreg_size)]
  ldp q14, q15, [x20, #(FP_q14 - FP_qreg_size)]
  ldp q16, q17, [x20, #(FP_q16 - FP_qreg_size)]
  ldp q18, q19, [x20, #(FP_q18 - FP_qreg_size)]
  ldp q20, q21, [x20, #(FP_q20 - FP_qreg_size)]
  ldp q22, q23, [x20, #(FP_q22 - FP_qreg_size)]
  ldp q24, q25, [x20, #(FP_q24 - FP_qreg_size)]
  ldp q26, q27, [x20, #(FP_q26 - FP_qreg_size)]
  ldp q28, q29, [x20, #(FP_q28 - FP_qreg_size)]
  ldp q30, q31, [x20, #(FP_q30 - FP_qreg_size)]
  msr fpsr, x22
  msr fpcr, x23       // ISB synchronisation not required on write
  										// to FPCR as about to do exception return

FP_context_valid:
  ldp x20, x21, [sp, #context_x20]
  ldp x22, x23, [sp, #context_x22]
  eret

// ______________________________________________________________________________
//
// Secure Monitor SMC handler
//
// This needs to store all GP and EL0/EL1 system register state in the current
// context workspace, and restore the other world's context.
// FP access is toggled in cptr_el3, so FP state can be handled lazily
//
// This handler supports a simple SMC ABI, where registers x0-x3 (r0-r3 in
// AArch32) are passed unmodified between the two worlds. Secure world should
// ensure that these registers are zeroed prior to invoking SMC if they are
// otherwise unused
//
// on entry x20-23 are already saved in the sp context
//
// x21 has the syndrome class, x20 the full syndrome. Nothing is done with
// the immediate value in the SMC instruction at present: this 16 bit value
// is in esr_el3 if the originating mode was AArch64, but would require
// ARM/THUMB instruction fetch and decode to extract the 4 bit value from
// AArch32
//   
// TODO: should the monitor manage the EL1 timer from the other side, using
// the EL3 physical timer?
//

SMC_32:
SMC_64:

// save current state
  mrs x22, sp_el0
  stp x4, x5, [sp, #context_x4]
  stp x6, x7, [sp, #context_x6]
  stp x8, x9, [sp, #context_x8]
  stp x10, x11, [sp, #context_x10]
  stp x12, x13, [sp, #context_x12]
  stp x14, x15, [sp, #context_x14]
  stp x16, x17, [sp, #context_x16]
  stp x18, x19, [sp, #context_x18]
  stp x24, x25, [sp, #context_x24]
  stp x26, x27, [sp, #context_x26]
  stp x28, x29, [sp, #context_x28]
  stp x30, x22, [sp, #context_x30] // SP0 in x22

  mrs x4, spsr_el3
  mrs x5, spsr_el1
  mrs x6, elr_el3
  mrs x7, elr_el1
#if HAS_AARCH32_EL1
  mrs x8, spsr_abt
  mrs x9, spsr_und
  mrs x10, spsr_irq
  mrs x11, spsr_fiq
#endif
  mrs x12, sctlr_el1
  mrs x13, actlr_el1
  mrs x14, cpacr_el1
  mrs x15, csselr_el1
  mrs x16, sp_el1
  mrs x17, vbar_el1
  mrs x18, ttbr0_el1
  mrs x19, ttbr1_el1
  mrs x20, tcr_el1
  mrs x21, mair_el1
  mrs x22, amair_el1
  mrs x23, tpidr_el0
  mrs x24, tpidrro_el0
  mrs x25, tpidr_el1
#if HAS_AARCH32_EL1
  mrs x26, dacr32_el2
  mrs x27, ifsr32_el2
#endif
  mrs x28, par_el1
  mrs x29, far_el1

  stp w4, w5, [sp, #context_spsr_el3]
  stp x6, x7, [sp, #context_elr_el3]
#if HAS_AARCH32_EL1
  stp w8, w9, [sp, #context_spsr_abt]
  stp w10, w11, [sp, #context_spsr_irq]
#endif
  stp w12, w13, [sp, #context_sctlr_el1]
  stp w14, w15, [sp, #context_cpacr_el1]
  stp x16, x17, [sp, #context_sp_el1]
  stp x18, x19, [sp, #context_ttbr0_el1]
  stp x20, x21, [sp, #context_tcr_el1]
  stp x22, x23, [sp, #context_amair_el1]
  stp x24, x25, [sp, #context_tpidrro_el0]
#if HAS_AARCH32_EL1
  stp w26, w27, [sp, #context_dacr32_el2]
#endif
  stp x28, x29, [sp, #context_par_el1]

  mrs x4, afsr0_el1
  mrs x5, afsr1_el1
  mrs x6, esr_el1
  mrs x7, contextidr_el1
#if HAS_T2EE
  mrs x8, teecr32_el1
  mrs x9, teehbr32_el1
#endif
  mrs x10, cntkctl_el1

// TODO: EL1/0 timer context. More work required here if the outgoing world's
// timer interrupts should be handled by the monitor in order to cause a
// return the this world
  mrs x11, cntp_ctl_el0
  mrs x12, cntp_cval_el0
  mrs x14, cntp_ctl_el0
  mrs x13, cntp_cval_el0
  mrs x15, scr_el3

  stp w4, w5, [sp, #context_afsr0_el1]
  stp w6, w7, [sp, #context_esr_el1]
#if HAS_T2EE
  stp w8, w9, [sp, #context_teecr32_el1]
#endif
  stp w10, w11, [sp, #context_cntkctl_el1]
  stp x12, x13, [sp, #context_cntp_cval_el0]
  stp w14, w15, [sp, #context_cntv_ctl_el0]

// update cptr_el3 (toggle ownership of FP context),
// and modify sp (el3_sp) to refer to the other domain context block
  mrs x20, cptr_el3
  mov w22, #context_size
  tst x15, #1                 // current SCR_EL3.NS bit
  cneg w22, w22, ne

#if HAS_AARCH32_EL1
// need to save/restore fpexc non-lazily,
  bic w21, w20, #(1<<10)			// which requires careful use of cptr_el3
  msr cptr_el3, x21						// during the switch. Clear CPTR_EL3.TFP
  isb
  mrs x16, fpexc32_el2
  str w16, [sp, #context_fpexc32_el2]
#endif

  add sp, sp, w22, sxtw       // switch to alternate workspace

#if HAS_AARCH32_EL1
  ldr w16, [sp, #context_fpexc32_el2]
  msr fpexc32_el2, x16
#endif

  eor w20, w20, #(1<<10)      // toggle CPTR_EL3.TFP
  msr cptr_el3, x20

// now restore the state

  ldp w4, w5, [sp, #context_spsr_el3]
  ldp x6, x7, [sp, #context_elr_el3]
#if HAS_AARCH32_EL1
  ldp w8, w9, [sp, #context_spsr_abt]
  ldp w10, w11, [sp, #context_spsr_irq]
#endif
  ldp w12, w13, [sp, #context_sctlr_el1]
  ldp w14, w15, [sp, #context_cpacr_el1]
  ldp x16, x17, [sp, #context_sp_el1]
  ldp x18, x19, [sp, #context_ttbr0_el1]
  ldp x20, x21, [sp, #context_tcr_el1]
  ldp x22, x23, [sp, #context_amair_el1]
  ldp x24, x25, [sp, #context_tpidrro_el0]
#if HAS_AARCH32_EL1
  ldp w26, w27, [sp, #context_dacr32_el2]
#endif
  ldp x28, x29, [sp, #context_par_el1]

  msr spsr_el3, x4
  msr spsr_el1, x5
  msr elr_el3, x6
  msr elr_el1, x7
#if HAS_AARCH32_EL1
  msr spsr_abt, x8
  msr spsr_und, x9
  msr spsr_irq, x10
  msr spsr_fiq, x11
#endif
  msr sctlr_el1, x12
  msr actlr_el1, x13
  msr cpacr_el1, x14
  msr csselr_el1, x15
  msr sp_el1, x16
  msr vbar_el1, x17
  msr ttbr0_el1, x18
  msr ttbr1_el1, x19
  msr tcr_el1, x20
  msr mair_el1, x21
  msr amair_el1, x22
  msr tpidr_el0, x23
  msr tpidrro_el0, x24
  msr tpidr_el1, x25
#if HAS_AARCH32_EL1
  msr dacr32_el2, x26
  msr ifsr32_el2, x27
#endif
  msr par_el1, x28
  msr far_el1, x29

  ldp w4, w5, [sp, #context_afsr0_el1]
  ldp w6, w7, [sp, #context_esr_el1]
#if HAS_T2EE
  ldp w8, w9, [sp, #context_teecr32_el1]
#endif
  ldp w10, w11, [sp, #context_cntkctl_el1]
  ldp x12, x13, [sp, #context_cntp_cval_el0]
  ldp w14, w15, [sp, #context_cntv_ctl_el0]

  msr afsr0_el1, x4
  msr afsr1_el1, x5
  msr esr_el1, x6
  msr contextidr_el1, x7
#if HAS_T2EE
  msr teecr32_el1, x8
  msr teehbr32_el1, x9
#endif
  msr cntkctl_el1, x10

// TODO: EL1/0 timer context. More work required here to ensure that restoring
// the timer register state has the corrcet effect in terms of generating the
// right interrupts
  msr cntp_ctl_el0, x11
  msr cntp_cval_el0, x12
  msr cntv_ctl_el0, x14
  msr cntv_cval_el0, x13

  msr scr_el3, x15

  ldp x30, x29, [sp, #context_x30] // SP0 in x29
  ldp x4, x5, [sp, #context_x4]
  ldp x6, x7, [sp, #context_x6]
  ldp x8, x9, [sp, #context_x8]
  ldp x10, x11, [sp, #context_x10]
  ldp x12, x13, [sp, #context_x12]
  ldp x14, x15, [sp, #context_x14]
  ldp x16, x17, [sp, #context_x16]
  ldp x18, x19, [sp, #context_x18]
  ldp x20, x21, [sp, #context_x20]
  ldp x22, x23, [sp, #context_x22]
  ldp x24, x25, [sp, #context_x24]
  ldp x26, x27, [sp, #context_x26]
  msr sp_el0, x29
  ldp x28, x29, [sp, #context_x28]

  .global monitor_return
monitor_return:
  eret

