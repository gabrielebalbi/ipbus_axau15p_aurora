## ============================================================
##  AXAU15 + FH1223  —  Master XDC
##  FPGA: XCAU15P-2FFVB676  (Artix UltraScale+)
##
##  All ball numbers confirmed from:
##    doc/top.xdc            — working RGMII reference design
##    doc/topGolden_3_ALINX.xdc — Alinx reference XDC
##    Schematic_CORE_ACAU15.pdf + Schematic_CARRIER_ACAU15.pdf
## ============================================================

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

## ------------------------------------------------------------
## System clock  200 MHz differential  (CORE schematic p.3,
##   net SYS_CLK_P/N, Bank 66, VCCIO 1.2 V — confirmed T24)
## ------------------------------------------------------------
set_property PACKAGE_PIN  T24             [get_ports sysclk_p]
set_property IOSTANDARD   DIFF_SSTL12     [get_ports sysclk_p]
set_property IOSTANDARD   DIFF_SSTL12     [get_ports sysclk_n]
create_clock -period 5.000 -name sysclk [get_ports sysclk_p]

## ------------------------------------------------------------
## RGMII Ethernet  — RTL8211F/JL2121
##   Carrier p.3: PHY_* signals → CON1 → Core Bank 64
##   VCCIO Bank 64 = 1.8 V  (PHY V_SEL=10 → RGMII IO = 1.8 V)
##   Confirmed from doc/top.xdc (working reference design)
## ------------------------------------------------------------

# TX (FPGA → PHY) — Bank 64
set_property PACKAGE_PIN  AE16  [get_ports eth_gtxclk]    ;# PHY_GTXC   B64_L18_N
set_property PACKAGE_PIN  AD16  [get_ports eth_txen]       ;# PHY_TXEN   B64_L18_P
set_property PACKAGE_PIN  Y18   [get_ports {eth_txd[0]}]   ;# PHY_TXD0   B64_L24_P
set_property PACKAGE_PIN  AA18  [get_ports {eth_txd[1]}]   ;# PHY_TXD1   B64_L24_N
set_property PACKAGE_PIN  AB24  [get_ports {eth_txd[2]}]   ;# PHY_TXD2   B64_L6_P
set_property PACKAGE_PIN  AC24  [get_ports {eth_txd[3]}]   ;# PHY_TXD3   B64_L6_N

# RX (PHY → FPGA) — Bank 64
set_property PACKAGE_PIN  AD21  [get_ports eth_rxclk]      ;# PHY_RXC    B64_L11_P
set_property PACKAGE_PIN  AE21  [get_ports eth_rxdv]       ;# PHY_RXDV   B64_L11_N
set_property PACKAGE_PIN  AC22  [get_ports {eth_rxd[0]}]   ;# PHY_RXD0   B64_L9_P
set_property PACKAGE_PIN  AC23  [get_ports {eth_rxd[1]}]   ;# PHY_RXD1   B64_L9_N
set_property PACKAGE_PIN  AD23  [get_ports {eth_rxd[2]}]   ;# PHY_RXD2   B64_L8_P
set_property PACKAGE_PIN  AE23  [get_ports {eth_rxd[3]}]   ;# PHY_RXD3   B64_L8_N

# MDIO / reset — Bank 64
set_property PACKAGE_PIN  AF20  [get_ports eth_mdc]        ;# PHY_MDC    B64_T1U
set_property PACKAGE_PIN  AE18  [get_ports eth_mdio]       ;# PHY_MDIO   B64_T2U
set_property PACKAGE_PIN  AF23  [get_ports eth_reset_n]    ;# PHY_RESET  B64_T0U

# RGMII IO standard (1.8 V)
set_property IOSTANDARD LVCMOS18 [get_ports eth_gtxclk]
set_property IOSTANDARD LVCMOS18 [get_ports eth_txen]
set_property IOSTANDARD LVCMOS18 [get_ports {eth_txd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports eth_rxclk]
set_property IOSTANDARD LVCMOS18 [get_ports eth_rxdv]
set_property IOSTANDARD LVCMOS18 [get_ports {eth_rxd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports eth_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports eth_mdio]
set_property IOSTANDARD LVCMOS18 [get_ports eth_reset_n]

# RGMII TX/RX output slew
set_property SLEW FAST [get_ports eth_gtxclk]
set_property SLEW FAST [get_ports {eth_txd[*]}]
set_property SLEW FAST [get_ports eth_txen]

# RGMII RX clock (created by Vivado's TEMAC IP from the recovered clock)
create_clock -period 8.000 -name eth_rxclk [get_ports eth_rxclk]

## ------------------------------------------------------------
## Aurora 64B/66B  —  6.25 Gbps  —  SFP1 (FH1223)
##   Bank 225, lane 0  =  GTHE4_CHANNEL_X0Y4
##   RefClk: MGTREFCLK0_225 (156.25 MHz, Core board oscillator)
##   FMC mapping:
##     FPGA TX → FMC_DP0_M2C_P/N → SFP1 TX
##     SFP1 RX → FMC_DP0_C2M_P/N → FPGA RX
## ------------------------------------------------------------

# MGT reference clock  156.25 MHz  (Core p.9: GTH_CLK_P/N → MGTREFCLK0_225)
# Clock is created on the package pin; Vivado propagates through IBUFDS_GTE4.
create_clock -period 6.400 -name aurora_refclk [get_ports aurora_refclk_p]

# Aurora MGT channel location  (Bank 225, lane 0)
set_property LOC GTHE4_CHANNEL_X0Y4 \
    [get_cells -hierarchical -filter {NAME =~ */aurora_*/gthe4_channel_wrapper_inst/GTHE4_CHANNEL_PRIM_INST}]

## ------------------------------------------------------------
## LEDs  —  Bank 64 / Bank 65 (confirmed from topGolden_3_ALINX.xdc)
## ------------------------------------------------------------
set_property PACKAGE_PIN  AC16  [get_ports {led[0]}]  ;# B64_T3U  Bank 64
set_property PACKAGE_PIN  W21   [get_ports {led[1]}]  ;# B65_T0U  Bank 65
set_property IOSTANDARD   LVCMOS18   [get_ports {led[*]}]
set_property SLEW         SLOW       [get_ports {led[*]}]

## ------------------------------------------------------------
## IBUFDS_GTE4 placement  (Bank 225 = GT Quad X0Y1)
## In UltraScale+, IBUFDS_GTE4 is located at the GTHE4_COMMON site.
## ------------------------------------------------------------
set_property LOC GTHE4_COMMON_X0Y1 \
    [get_cells -hierarchical -filter {NAME =~ *ibufds_refclk}]

## ------------------------------------------------------------
## Clock groups  (prevent false path analysis across domains)
## Vivado auto-derives all MMCM output clocks as generated clocks
## from sysclk; -include_generated_clocks picks them all up.
## ------------------------------------------------------------
set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks sysclk] \
    -group [get_clocks -include_generated_clocks aurora_refclk] \
    -group [get_clocks eth_rxclk]

## Reset signals driven in the free-running (pre-MMCM) domain are
## slow control signals; declare false path to MMCM output domains.
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *clocks/*rsto*_reg}]

set_false_path -to [get_ports {led[*]}]
set_false_path -to [get_ports eth_reset_n]
