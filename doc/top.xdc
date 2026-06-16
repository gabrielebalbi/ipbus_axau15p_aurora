#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
############# clock define################################
set_property PACKAGE_PIN T24 [get_ports sys_clk_p]
create_clock -period 5.000 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]
#########################ethernet 1######################
create_clock -period 8.000 [get_ports rgmii1_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii1_rxd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii1_txd[*]}]
set_property SLEW FAST [get_ports {rgmii1_txd[*]}]

set_property IOSTANDARD LVCMOS18 [get_ports e1_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports e1_mdio]
set_property IOSTANDARD LVCMOS18 [get_ports e1_reset]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii1_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii1_rxctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii1_txc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii1_txctl]
set_property SLEW FAST [get_ports rgmii1_txc]
set_property SLEW FAST [get_ports rgmii1_txctl]

set_property PACKAGE_PIN AE23 [get_ports {rgmii1_rxd[3]}]
set_property PACKAGE_PIN AD23 [get_ports {rgmii1_rxd[2]}]
set_property PACKAGE_PIN AC23 [get_ports {rgmii1_rxd[1]}]
set_property PACKAGE_PIN AC22 [get_ports {rgmii1_rxd[0]}]
set_property PACKAGE_PIN AC24 [get_ports {rgmii1_txd[3]}]
set_property PACKAGE_PIN AB24 [get_ports {rgmii1_txd[2]}]
set_property PACKAGE_PIN AA18  [get_ports {rgmii1_txd[1]}]
set_property PACKAGE_PIN Y18 [get_ports {rgmii1_txd[0]}]

set_property PACKAGE_PIN AF20 [get_ports e1_mdc]
set_property PACKAGE_PIN AE18 [get_ports e1_mdio]
set_property PACKAGE_PIN AF23 [get_ports e1_reset]
set_property PACKAGE_PIN AD21 [get_ports rgmii1_rxc]
set_property PACKAGE_PIN AE21 [get_ports rgmii1_rxctl]
set_property PACKAGE_PIN AE16 [get_ports rgmii1_txc]
set_property PACKAGE_PIN AD16 [get_ports rgmii1_txctl]


set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_0/inst/mmcme3_adv_inst/CLKOUT1]] -to [get_clocks rgmii1_rxc]
set_false_path -from [get_clocks rgmii1_rxc] -to [get_clocks -of_objects [get_pins clk_wiz_0/inst/mmcme3_adv_inst/CLKOUT1]]




