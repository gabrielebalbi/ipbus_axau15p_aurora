## run_sim.tcl  —  Launch XSim simulation for tb_payload
##
## Usage:
##   source /home/labele/amd/2025.2/Vivado/settings64.sh
##   vivado -mode batch -source scripts/run_sim.tcl
##
## Requires: project already created (create_project.tcl run first)

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJ_ROOT  [file normalize "$SCRIPT_DIR/.."]

open_project $PROJ_ROOT/vivado/axau15_fh1223/axau15_fh1223.xpr

# Add testbench to sim fileset if not present
set tb_file "$PROJ_ROOT/sim/tb_payload.vhd"
if {[llength [get_files -quiet $tb_file]] == 0} {
    add_files -fileset sim_1 -norecurse $tb_file
}

set_property top            tb_payload  [get_filesets sim_1]
set_property top_lib        xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sim_1

# Launch simulation (elaborate + simulate for 10 us)
launch_simulation

run 10 us

close_sim

puts "=== Simulation complete. Check transcript above for PASS/FAIL. ==="
