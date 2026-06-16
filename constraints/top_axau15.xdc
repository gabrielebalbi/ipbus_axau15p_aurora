## ============================================================
##  AXAU15 + FH1223  —  Master XDC
##  FPGA: XCAU15P-2FFVB676  (Artix UltraScale+)
##
##  IMPORTANT: ball numbers marked TODO must be read from the
##  PDF schematics at higher zoom.
##  Sources:
##    Schematic_CORE_ACAU15.pdf  — FPGA ball assignments
##    Schematic_CARRIER_ACAU15.pdf — signal routing to PHY/FMC
## ============================================================

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

## ------------------------------------------------------------
## System clock  200 MHz differential  (CORE schematic p.3/9,
##   net SYS_CLK_P/N, Bank 65, VCCIO 1.8 V)
## ------------------------------------------------------------
set_property PACKAGE_PIN  TODO_SYS_CLK_P  [get_ports sysclk_p]
set_property PACKAGE_PIN  TODO_SYS_CLK_N  [get_ports sysclk_n]
set_property IOSTANDARD   DIFF_SSTL18_II  [get_ports sysclk_p]
set_property IOSTANDARD   DIFF_SSTL18_II  [get_ports sysclk_n]
create_clock -period 5.000 -name sysclk [get_ports sysclk_p]

## ------------------------------------------------------------
## RGMII Ethernet  — RTL8211F/JL2121
##   Carrier p.3: PHY_* signals → CON1 → Core p.5 Bank 84
##   VCCIO Bank 84 = 1.8 V  (PHY V_SEL=10 → RGMII IO = 1.8 V)
## ------------------------------------------------------------

# TX (FPGA → PHY) — Bank 84
set_property PACKAGE_PIN  TODO_ETH_GTXCLK  [get_ports eth_gtxclk]
set_property PACKAGE_PIN  TODO_ETH_TXEN    [get_ports eth_txen]
set_property PACKAGE_PIN  TODO_ETH_TXD0    [get_ports {eth_txd[0]}]
set_property PACKAGE_PIN  TODO_ETH_TXD1    [get_ports {eth_txd[1]}]
set_property PACKAGE_PIN  TODO_ETH_TXD2    [get_ports {eth_txd[2]}]
set_property PACKAGE_PIN  TODO_ETH_TXD3    [get_ports {eth_txd[3]}]

# RX (PHY → FPGA) — Bank 84
set_property PACKAGE_PIN  TODO_ETH_RXCLK   [get_ports eth_rxclk]
set_property PACKAGE_PIN  TODO_ETH_RXDV    [get_ports eth_rxdv]
set_property PACKAGE_PIN  TODO_ETH_RXD0    [get_ports {eth_rxd[0]}]
set_property PACKAGE_PIN  TODO_ETH_RXD1    [get_ports {eth_rxd[1]}]
set_property PACKAGE_PIN  TODO_ETH_RXD2    [get_ports {eth_rxd[2]}]
set_property PACKAGE_PIN  TODO_ETH_RXD3    [get_ports {eth_rxd[3]}]

# MDIO / reset — Bank 84
set_property PACKAGE_PIN  TODO_ETH_MDC     [get_ports eth_mdc]
set_property PACKAGE_PIN  TODO_ETH_MDIO    [get_ports eth_mdio]
set_property PACKAGE_PIN  TODO_ETH_RESET_N [get_ports eth_reset_n]

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
##   Bank 224, lane 0  =  GTHE4_CHANNEL_X0Y0
##   RefClk: MGTREFCLK0_225 (156.25 MHz, Core board oscillator)
##   FMC mapping:
##     FPGA TX → FMC_DP0_M2C_P/N → SFP1 TX
##     SFP1 RX → FMC_DP0_C2M_P/N → FPGA RX
## ------------------------------------------------------------

# MGT reference clock  156.25 MHz  (Core p.9: GTH_CLK_P/N → MGTREFCLK0_225)
# Ball numbers are MGT-specific — Vivado assigns them via the IP wizard.
# Create the clock on the IBUFDS_GTE4 output buffer:
create_clock -period 6.400 -name aurora_refclk \
    [get_pins -hierarchical -filter {NAME =~ */aurora_*/gt_refclk_ibuf/O}]

# Aurora MGT channel location  (Bank 224, lane 0)
set_property LOC GTHE4_CHANNEL_X0Y0 \
    [get_cells -hierarchical -filter {NAME =~ */aurora_*/gthe4_channel_wrapper_inst/GTHE4_CHANNEL_PRIM_INST}]

## ------------------------------------------------------------
## LEDs  —  Bank 84 or 85 (Carrier p.9)
## ------------------------------------------------------------
set_property PACKAGE_PIN  TODO_LED0  [get_ports {led[0]}]
set_property PACKAGE_PIN  TODO_LED1  [get_ports {led[1]}]
set_property IOSTANDARD   LVCMOS18   [get_ports {led[*]}]
set_property SLEW         SLOW       [get_ports {led[*]}]

## ------------------------------------------------------------
## Clock groups  (prevent false path analysis across domains)
## ------------------------------------------------------------
create_generated_clock -name ipbus_clk \
    -source [get_pins -hierarchical -filter {NAME =~ */infra/clocks/mmcm/CLKIN1}] \
    [get_pins -hierarchical -filter {NAME =~ */infra/clocks/mmcm/CLKOUT1}]

create_generated_clock -name clk_aux \
    -source [get_pins -hierarchical -filter {NAME =~ */infra/clocks/mmcm/CLKIN1}] \
    [get_pins -hierarchical -filter {NAME =~ */infra/clocks/mmcm/CLKOUT2}]

create_generated_clock -name clk125 \
    -source [get_pins -hierarchical -filter {NAME =~ */infra/clocks/mmcm/CLKIN1}] \
    [get_pins -hierarchical -filter {NAME =~ */infra/clocks/mmcm/CLKOUT3}]

set_clock_groups -asynchronous \
    -group [get_clocks sysclk] \
    -group [get_clocks -include_generated_clocks ipbus_clk] \
    -group [get_clocks -include_generated_clocks clk_aux] \
    -group [get_clocks -include_generated_clocks clk125] \
    -group [get_clocks aurora_refclk] \
    -group [get_clocks eth_rxclk]

set_false_path -to [get_ports {led[*]}]
set_false_path -to [get_ports eth_reset_n]
