## run_impl.tcl  —  Place & Route after successful synthesis
##
## Usage:
##   source /home/labele/amd/2025.2/Vivado/settings64.sh
##   vivado -mode batch -source scripts/run_impl.tcl

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJ_ROOT  [file normalize "$SCRIPT_DIR/.."]

open_project $PROJ_ROOT/vivado/axau15_fh1223/axau15_fh1223.xpr
puts "Opened: [current_project]"
update_compile_order -fileset sources_1

# Reset and launch implementation (includes opt_design + place + route)
reset_run impl_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1

set status   [get_property STATUS   [get_runs impl_1]]
set progress [get_property PROGRESS [get_runs impl_1]]
puts "=== Implementation: $status  $progress ==="

if {$progress eq "100%"} {
    open_run impl_1 -name impl_1

    report_utilization    -file $PROJ_ROOT/vivado/utilization_impl.rpt
    report_timing_summary -file $PROJ_ROOT/vivado/timing_impl.rpt -max_paths 10

    set wns [get_property STATS.WNS [get_runs impl_1]]
    set whs [get_property STATS.WHS [get_runs impl_1]]
    puts "=== Timing: WNS=$wns ns  WHS=$whs ns ==="

    if {$wns >= 0 && $whs >= 0} {
        puts "=== Timing PASSED — writing bitstream ==="
        launch_runs impl_1 -to_step write_bitstream -jobs 4
        wait_on_run impl_1
        puts "=== Bitstream written to $PROJ_ROOT/vivado/axau15_fh1223/axau15_fh1223.runs/impl_1/ ==="
    } else {
        puts "WARNING: Timing FAILED (WNS=$wns WHS=$whs) — bitstream not written"
    }
} else {
    puts "ERROR: Implementation did not complete"
}
