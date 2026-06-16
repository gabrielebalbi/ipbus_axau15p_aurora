open_project /home/labele/axau15_fh1223/vivado/axau15_fh1223/axau15_fh1223.xpr
puts "Opened: [current_project]"
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
set status   [get_property STATUS   [get_runs synth_1]]
set progress [get_property PROGRESS [get_runs synth_1]]
puts "=== Synthesis: $status  $progress ==="
if {$progress eq "100%"} {
    open_run synth_1 -name synth_1
    report_utilization -file /home/labele/axau15_fh1223/vivado/utilization_synth.rpt
    report_timing_summary -file /home/labele/axau15_fh1223/vivado/timing_synth.rpt
    puts "=== Reports written ==="
}
