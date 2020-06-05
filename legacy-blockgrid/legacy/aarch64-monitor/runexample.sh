#!/bin/sh
#
# runexample.sh - script to run example Secure Monitor program
#
# Copyright (C) 2011-2013 ARM Limited. All rights reserved.
#

# locations for model and licenses should be defined in the config file
. ./config

secure_code=64
non_secure_code=64

while getopts "s:n:?" optval "$@"
  do
    case $optval in
      "s") secure_code=$OPTARG ;;
      "n") non_secure_code=$OPTARG ;;
      "?")
        echo "`basename $0` [-s {32|64|image-file}] [-n {32|64|image-file}]

  -s : the secure domain program to load. A value of 32 or 64 selects
       the AArch32 and AArch64 example programs repsectively. Defaults
       to secure.64.elf
  -n : the non-secure domain program to load. A value of 32 or 64
       selects the AArch32 and AArch64 example programs repsectively.
       Defaults to non-secure.64.elf"
        exit
        ;;
    esac
  done

if [ ! -e "$secure_code" ]; then
  if [ ! -e "secure.${secure_code}.elf" ]; then
    echo "Image "$secure_code" not found!"
    exit 1
  fi
  secure_code="secure.${secure_code}.elf"
fi
if [ ! -e "$non_secure_code" ]; then
  if [ ! -e "non_secure.${non_secure_code}.elf" ]; then
    echo "Image \"$non_secure_code\" not found!"
    exit 1
  fi
  non_secure_code="non_secure.${non_secure_code}.elf"
fi

cat <<HERE >model.script
//
// ModelDebugger script to load all monitor example code and copy non-secure code
// from secure load address to non-secure run address. This is to workaround the
// model inability to load load code to non-secure address!
//
loadApp("$secure_code");
loadApp("$non_secure_code");
loadApp("monitor.64.elf");
// copy non-secure code from secure load address to non-secure run address
int sz, from, to, word, ns_mode;
from = 0x7ff00000;       // (secure) load address of non-secure code
to =   0x80000000;       // (non-secure) run address of non-secure code
sz = memRead("Secure Monitor", from, 4);
while (sz > 0) {
  word = memRead("Secure Monitor", from, 4);
  memWrite("NS Hyp", to, word, 4);
  from += 4;
  to += 4;
  sz -= 4;
}
hardReset();
// add a breakpoint on the secure world entry-point
bpAdd(memRead("Secure Monitor",0x7e000008,8) & ~1, "Guest");
// add a breakpoint on the non-secure world entry-point
// for hypervisor or kernel mode as required
ns_mode = memRead("Secure Monitor",0x7ff00004,4);
if (ns_mode == 8 || ns_mode == 9 || ns_mode == 26) {
	bpAdd(memRead("Secure Monitor",0x7ff00008,8) & ~1, "NS Hyp");
} else {
	bpAdd(memRead("Secure Monitor",0x7ff00008,8) & ~1, "Guest");
}
HERE

env PATH=${ARM_MODELDEBUGGER}:${PATH} ARMLMD_LICENSE_FILE=${ARM_MODEL_LICENSE:-${ARMLMD_LICENSE_FILE}}\
  ${ARM_MODELDEBUGGER}/modeldebugger -y -n \
 -m ${ARM_AEMv8}/RTSM_VE_AEMv8A.so \
 -C cluster.NUM_CORES=1 \
 -C cluster.has_thumb2ee=${ARM_HAS_THUMB2EE} \
 -C cluster.max_32bit_el=$((2*${ARM_HAS_AARCH32_EL1})) \
 -C daughterboard.secure_memory=true \
 -s model.script
 

