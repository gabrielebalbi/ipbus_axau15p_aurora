## ============================================================
##  create_project.tcl  —  AXAU15 + FH1223
##  Vivado 2025.2  —  XCAU15P-2FFVB676
##
##  Usage (from scripts/ directory):
##    source /home/labele/amd/2025.2/Vivado/settings64.sh
##    vivado -mode batch -source create_project.tcl
##
##  Prerequisites:
##    1) Clone ipbus-firmware beside this repo:
##         cd /home/labele/axau15_fh1223
##         git clone https://github.com/ipbus/ipbus-firmware.git
##    2) Run this script once to create the project + generate IPs
##    3) Open the .xpr in Vivado GUI to verify Aurora IP LOC
## ============================================================

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJ_ROOT  [file normalize "$SCRIPT_DIR/.."]

set PROJ_NAME  axau15_fh1223
set PROJ_DIR   "$PROJ_ROOT/vivado"
set IP_DIR     "$PROJ_ROOT/ip"
set IPBUS_DIR  "$PROJ_ROOT/ipbus-firmware"

set PART   xcau15p-2ffvb676-e
set BOARD  {}

# ------------------------------------------------------------
# Create project
# ------------------------------------------------------------
file mkdir $PROJ_DIR
file mkdir $IP_DIR

create_project $PROJ_NAME $PROJ_DIR/$PROJ_NAME -part $PART -force

set_property target_language VHDL [current_project]

# ------------------------------------------------------------
# ipbus-firmware sources
# ------------------------------------------------------------
if {![file exists $IPBUS_DIR]} {
    puts "ERROR: ipbus-firmware not found at $IPBUS_DIR"
    puts "       Run: git clone https://github.com/ipbus/ipbus-firmware.git"
    return
}

set IPBUS_CORE "$IPBUS_DIR/components/ipbus_core/firmware/hdl"
set IPBUS_UDP  "$IPBUS_DIR/components/ipbus_transport_udp/firmware/hdl"
set IPBUS_UTIL "$IPBUS_DIR/components/ipbus_util/firmware/hdl"

# Core types package
add_files -norecurse [glob $IPBUS_CORE/ipbus_package.vhd]

# UDP transport + ipbus_ctrl (full set of HDL)
add_files -norecurse [glob $IPBUS_UDP/*.vhd]

# Utility helpers (clock_div, led_stretcher)
add_files -norecurse [glob $IPBUS_UTIL/led_stretcher.vhd]
add_files -norecurse [glob $IPBUS_UTIL/ipbus_clock_div.vhd]

# Fabric (address decoder)
add_files -norecurse [glob $IPBUS_CORE/ipbus_fabric_sel.vhd]
add_files -norecurse [glob $IPBUS_CORE/ipbus_fabric.vhd]
add_files -norecurse [glob $IPBUS_CORE/ipbus_trans_decl.vhd]
add_files -norecurse [glob $IPBUS_CORE/ipbus_transactor.vhd]

# ------------------------------------------------------------
# Our RTL sources
# ------------------------------------------------------------
add_files -norecurse [glob $PROJ_ROOT/rtl/*.vhd]

set_property top top [get_filesets sources_1]
update_compile_order -fileset sources_1

# ------------------------------------------------------------
# Constraints
# ------------------------------------------------------------
add_files -fileset constrs_1 $PROJ_ROOT/constraints/top_axau15.xdc

# ------------------------------------------------------------
# Tri-Mode Ethernet MAC  v9.0  (RGMII, 1G, shared logic in core)
# ------------------------------------------------------------
create_ip \
    -name tri_mode_ethernet_mac \
    -vendor xilinx.com \
    -library ip \
    -version 9.0 \
    -module_name temac_gbe_v9_0 \
    -dir $IP_DIR

set_property -dict [list \
    CONFIG.Physical_Interface  {RGMII}     \
    CONFIG.MAC_Speed           {1000_Mbps} \
    CONFIG.Management_Frequency {125}      \
    CONFIG.SupportLevel        {1}         \
    CONFIG.Make_MDIO           {true}      \
    CONFIG.EN_IODELAY          {false}     \
] [get_ips temac_gbe_v9_0]

generate_target all [get_ips temac_gbe_v9_0]
export_ip_user_files -of_objects [get_ips temac_gbe_v9_0] -no_script -force -quiet

# ------------------------------------------------------------
# Aurora 64B/66B  v13.0  —  6.25 Gbps  —  SFP1 (FMC DP0)
#
# NOTE: The GT location (GTHE4_CHANNEL) must match the SFP1
#       balls on the FH1223 FMC card.
#       From topGolden_3_ALINX.xdc, SFP TOLM uses Bank225.
#       The Aurora IP wizard (GUI) shows the device view;
#       verify by checking which GTHE4_X0Yy contains balls
#       Y2 (RX) / AA5 (TX) = Bank225 first lane.
#
#       RefClk: MGTREFCLK0_225  (V7, 156.25 MHz, Core board)
# ------------------------------------------------------------
create_ip \
    -name aurora_64b66b \
    -vendor xilinx.com \
    -library ip \
    -version 13.0 \
    -module_name aurora_64b66b_0 \
    -dir $IP_DIR

# Line rate 6.25 Gbps, refclk 156.25 MHz (MGTREFCLK0_225, ball V7).
# SFP1 on FH1223 = FMC DP0 = Bank225 lane 0.
# In XCAU15P-676 the GT quads are (from topGolden balls Y2/AA5 = Bank225):
#   C_START_QUAD = 1  (Bank225 is GT quad 1 of 3; 0=Bank224, 1=Bank225, 2=Bank226)
#   C_START_LANE = 0  (first lane of the quad)
# IMPORTANT: re-open the IP in Vivado GUI to confirm GT selection on the device view.
set_property -dict [list \
    CONFIG.C_LINE_RATE        {6.25}       \
    CONFIG.C_REFCLK_FREQUENCY {156.25}     \
    CONFIG.C_INIT_CLK         {50}         \
    CONFIG.C_START_QUAD       {1}          \
    CONFIG.C_START_LANE       {0}          \
    CONFIG.C_GT_LOC_1         {1}          \
    CONFIG.flow_mode          {None}       \
    CONFIG.C_UCOLUMN_USED     {y}          \
] [get_ips aurora_64b66b_0]

generate_target all [get_ips aurora_64b66b_0]
export_ip_user_files -of_objects [get_ips aurora_64b66b_0] -no_script -force -quiet

# ------------------------------------------------------------
# Final project save
# ------------------------------------------------------------
update_compile_order -fileset sources_1
save_project_as $PROJ_NAME $PROJ_DIR/$PROJ_NAME -force

puts ""
puts "=== Project created: $PROJ_DIR/$PROJ_NAME/$PROJ_NAME.xpr ==="
puts ""
puts "Next steps:"
puts "  1. Open the .xpr in Vivado GUI"
puts "  2. Re-customize aurora_64b66b_0 IP to select the correct GT channel"
puts "     (Bank225 lane corresponding to FH1223 FMC DP0)"
puts "  3. Verify temac_gbe_v9_0 port list vs eth_axau15_rgmii.vhd"
puts "  4. Run Synthesis"
