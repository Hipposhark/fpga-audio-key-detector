#!/usr/bin/env bash

# This script is used by the `program` make command to program the connected 
#   Nexys A7 FPGA from a Mac using openFPGALoader. The script assumes the
#   target Vivado-generated bitstream has already been copied to build.

set -euo pipefail

BOARD="${1:-nexys_a7_100}"
BITSTREAM="${2:-build/top.bit}"

if [ ! -f "$BITSTREAM" ]; then
    echo "Bitstream not found: $BITSTREAM"
    echo "Build the design on the Linux server, then copy the .bit file back first."
    exit 1
fi

openFPGALoader -b "$BOARD" "$BITSTREAM"