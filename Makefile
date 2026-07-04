# This Makefile provided the commands for the Nexys A7 programming workflow
# 	once the rtl synthesizes:
# 
# given the target bitstream (e.g. build/top.bit), commands are provided for
#
# - building the bitstream on a Linux server supporting Vivado
# - copying the bitstream back to local (Mac)
# - programing the FPGA locally with bistream input to openFPGALoader.
# 
# A typical workflow is building on the server, then fetching and then
# 	programming locally

PART  ?= xc7a100tcsg324-1
BOARD ?= nexys_a7_100

-include config/local.mk

REMOTE        ?= your_username@your_linux_or_windows_server_with_vivado.edu
REMOTE_DIR    ?= ~/directory/to/test/project
BITSTREAM_DIR ?= build/top.bit # default is build/top.bit from the batch script

.PHONY: build fetch-bit program flash sync clean

# server command to execute vivado script and build the bitstream remotely
build:
	vivado -mode batch -source scripts/build.tcl -tclargs $(PART)

# local command to pull the remote bitstream
fetch-bit:
	mkdir -p build
	scp $(REMOTE):$(REMOTE_DIR)/$(BITSTREAM_DIR) build/top.bit

# local command to load available bitstream into the FPGA's SRAM (for testing)
program:
	bash ./scripts/program_nexysa7.sh nexys_a7_100 $(BITSTREAM_DIR)

# local command to load available bitstream into the FPGA's 
# nonvolatile flash memory (for production)
flash:
	openFPGALoader -b $(BOARD) -f $(BITSTREAM_DIR)

# copies local files to the remote server
sync:
	ssh $(REMOTE) 'mkdir -p $(REMOTE_DIR)'
	rsync -av --delete --exclude '.git' --exclude 'build' \
		./ $(REMOTE):$(REMOTE_DIR)/

# deletes the existing build files to start from a fresh build
clean:
	rm -rf build .Xil *.jou *.log *.str