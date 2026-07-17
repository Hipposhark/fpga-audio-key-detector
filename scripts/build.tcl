# This script is used by the `build` make command on the server-side to build 
#   the project in Vivado batch mode. Vivado outputs `build/top.bit`.

set script_dir [file dirname [file normalize [info script]]]
set repo_dir   [file normalize "$script_dir/.."]

set project_name "fpga_audio_key_detector"
set top_name     "top"
set part_name    "xc7a100tcsg324-1"

if {$argc >= 1} {
    set part_name [lindex $argv 0]
}

set build_dir  "$repo_dir/build"
set vivado_dir "$build_dir/vivado"

file mkdir $build_dir

create_project -force $project_name "$vivado_dir/$project_name" -part $part_name
set_property target_language Verilog [current_project]
set_property source_mgmt_mode None [current_project]

# ip instantiation
create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name clk_wiz_0

set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {100.000} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {40.000} \
] [get_ips clk_wiz_0]

generate_target all [get_ips clk_wiz_0]
synth_ip [get_ips clk_wiz_0]

# source files
add_files -fileset sources_1 [glob "$repo_dir/rtl/*.sv"]
add_files -fileset sources_1 [glob "$repo_dir/rtl/common/*.sv"]
add_files -fileset sources_1 [glob "$repo_dir/rtl/video/*.sv"]
add_files -fileset constrs_1 "$repo_dir/constraints/nexys-a7-100t.xdc"

set_property top $top_name [get_filesets sources_1]
update_compile_order -fileset sources_1

# run synthesis
set jobs 4

if {[info exists env(VIVADO_JOBS)]} {
    set jobs $env(VIVADO_JOBS)
}

launch_runs synth_1 -jobs $jobs
wait_on_run synth_1

# generate bitstream
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1

set bitstream_src "$vivado_dir/$project_name/$project_name.runs/impl_1/$top_name.bit"
set bitstream_dst "$build_dir/$top_name.bit"

file copy -force $bitstream_src $bitstream_dst

puts ""
puts "============================================================"
puts "Bitstream generated:"
puts "$bitstream_dst"
puts "============================================================"
puts ""