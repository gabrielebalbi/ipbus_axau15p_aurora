########################################################
# 1.8V
# Bank 64 (HP) VCCO - 1.8 V -- 124.992 MHz DMTD clock

#set_property PACKAGE_PIN XX [get_ports clk_125m_dmtd_p]
#set_property PACKAGE_PIN XX [get_ports clk_125m_dmtd_n]
#set_property IOSTANDARD LVDS [get_ports clk_125m_dmtd_p]
#set_property IOSTANDARD LVDS [get_ports clk_125m_dmtd_n]



#set_property PACKAGE_PIN XX [get_ports clk_100MHz_p]
#set_property PACKAGE_PIN XX [get_ports clk_100MHz_n]

#set_property IOSTANDARD LVDS [get_ports clk_100MHz_p]
#set_property IOSTANDARD LVDS [get_ports clk_100MHz_n]

#Alinx compliant
#set_property IOSTANDARD LVCMOS18 [get_ports areset_n_i_WR]
#set_property PACKAGE_PIN N26 [get_ports areset_n_i_WR]
####################################################



set_property IOSTANDARD LVDS_25 [get_ports irig_b]
set_property PACKAGE_PIN J13 [get_ports irig_b]

#set_property PACKAGE_PIN XX [get_ports scl_b]
#set_property IOSTANDARD LVCMOS18 [get_ports scl_b]
#set_property PACKAGE_PIN XX [get_ports sda_b]
#set_property IOSTANDARD LVCMOS18 [get_ports sda_b]


#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[17]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[16]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[15]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[14]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[13]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[12]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[11]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[10]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[9]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[8]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[7]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[6]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[5]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_n[4]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[17]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[16]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[15]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[14]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[13]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[12]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[11]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[10]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[9]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[8]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[7]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[6]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[5]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J30_p[4]}]
#set_property PACKAGE_PIN Y20 [get_ports {GPIO_J30_p[17]}]
#set_property PACKAGE_PIN Y21 [get_ports {GPIO_J30_n[17]}]
#set_property PACKAGE_PIN Y18 [get_ports {GPIO_J30_p[16]}]
#set_property PACKAGE_PIN Y19 [get_ports {GPIO_J30_n[16]}]
#set_property PACKAGE_PIN Y14 [get_ports {GPIO_J30_p[15]}]
#set_property PACKAGE_PIN Y15 [get_ports {GPIO_J30_n[15]}]
#set_property PACKAGE_PIN V22 [get_ports {GPIO_J30_p[13]}]
#set_property PACKAGE_PIN W22 [get_ports {GPIO_J30_n[13]}]
#set_property PACKAGE_PIN U14 [get_ports {GPIO_J30_p[12]}]
#set_property PACKAGE_PIN V15 [get_ports {GPIO_J30_n[12]}]
#set_property PACKAGE_PIN N21 [get_ports {GPIO_J30_p[11]}]
#set_property PACKAGE_PIN N22 [get_ports {GPIO_J30_n[11]}]
#set_property PACKAGE_PIN M22 [get_ports {GPIO_J30_p[10]}]
#set_property PACKAGE_PIN L22 [get_ports {GPIO_J30_n[10]}]
#set_property PACKAGE_PIN U17 [get_ports {GPIO_J30_p[14]}]
#set_property PACKAGE_PIN V17 [get_ports {GPIO_J30_n[14]}]
#set_property PACKAGE_PIN U18 [get_ports {GPIO_J30_p[9]}]
#set_property PACKAGE_PIN U19 [get_ports {GPIO_J30_n[9]}]
#set_property PACKAGE_PIN T22 [get_ports {GPIO_J30_p[8]}]
#set_property PACKAGE_PIN U22 [get_ports {GPIO_J30_n[8]}]
#set_property PACKAGE_PIN V21 [get_ports {GPIO_J30_p[7]}]
#set_property PACKAGE_PIN W21 [get_ports {GPIO_J30_n[7]}]
#set_property PACKAGE_PIN AB20 [get_ports {GPIO_J30_p[6]}]
#set_property PACKAGE_PIN AB21 [get_ports {GPIO_J30_n[6]}]
#set_property PACKAGE_PIN AB17 [get_ports {GPIO_J30_p[5]}]
#set_property PACKAGE_PIN AB18 [get_ports {GPIO_J30_n[5]}]
#set_property PACKAGE_PIN V14 [get_ports {GPIO_J30_p[4]}]
#set_property PACKAGE_PIN W14 [get_ports {GPIO_J30_n[4]}]

set_property PACKAGE_PIN A12 [get_ports uart_rxd_i]
set_property PACKAGE_PIN A13 [get_ports uart_txd_o]
set_property IOSTANDARD LVCMOS18 [get_ports uart_rxd_i]
set_property IOSTANDARD LVCMOS18 [get_ports uart_txd_o]


########################################################
# BANK 65 VCCO 1.8V

#set_property PACKAGE_PIN XX [get_ports RTM_clk_n]
#set_property PACKAGE_PIN XX [get_ports RTM_clk_p]
#set_property IOSTANDARD LVDS [get_ports RTM_clk_n]
#set_property IOSTANDARD LVDS [get_ports RTM_clk_p]
#create_clock -period 10.000 -name RTM_clock_out [get_ports RTM_clk_p]


set_property IOSTANDARD LVDS_25 [get_ports AMC_TCLK_p]
create_clock -period 10.000 -name AMC_TCLK_pp [get_ports AMC_TCLK_p]

set_property IOSTANDARD LVDS_25 [get_ports AMC_CLK_p]
create_clock -period 10.000 -name AMC_CLK_pp [get_ports AMC_CLK_p]


set_property PACKAGE_PIN AE13 [get_ports pps_i_p]
set_property IOSTANDARD LVDS_25 [get_ports pps_i_p]
create_clock -period 10.000 -name pps_i_pp [get_ports pps_i_p]




#set_property PACKAGE_PIN H20 [get_ports sfp_TOLM_los]
#set_property IOSTANDARD LVCMOS18 [get_ports sfp_TOLM_los]
#set_property PACKAGE_PIN H21 [get_ports sfp_TOLM_tx_disable]
#set_property IOSTANDARD LVCMOS18 [get_ports sfp_TOLM_tx_disable]
#set_property PACKAGE_PIN H22 [get_ports sfp_TOLM_tx_fault]
#set_property IOSTANDARD LVCMOS18 [get_ports sfp_TOLM_tx_fault]

#set_property PACKAGE_PIN T17 [get_ports sfp_WR_mod_def0_i]
#set_property IOSTANDARD LVCMOS18 [get_ports sfp_WR_mod_def0_i]


#set_property PACKAGE_PIN K21 [get_ports led_TOLM_Rx_green]
#set_property IOSTANDARD LVCMOS18 [get_ports led_TOLM_Rx_green]


#set_property PACKAGE_PIN K20 [get_ports led_TOLM_Rx_red]
#set_property IOSTANDARD LVCMOS18 [get_ports led_TOLM_Rx_red]

#set_property PACKAGE_PIN J19 [get_ports led_TOLM_Tx_green]
#set_property IOSTANDARD LVCMOS18 [get_ports led_TOLM_Tx_green]

#set_property PACKAGE_PIN J18 [get_ports led_TOLM_Tx_red]
#set_property IOSTANDARD LVCMOS18 [get_ports led_TOLM_Tx_red]

set_property PULLUP true [get_ports pcie_rst_n]
set_property PACKAGE_PIN T19 [get_ports pcie_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rst_n]

set_property PACKAGE_PIN AC16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
set_property PACKAGE_PIN W21 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]

create_clock -period 50.000 -name txco_inpp -waveform {0.000 5.000} [get_ports txco_in_p]
set_property IOSTANDARD LVCMOS33 [get_ports txco_in_p]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets txco_in_p_IBUF_inst/O]

set_property IOSTANDARD LVDS_25 [get_ports clk_ext_10m_p_i]
set_property PACKAGE_PIN J15 [get_ports clk_ext_10m_p_i]
create_clock -period 100.000 -name clk_ext_10m -waveform {0.000 50.000} [get_ports clk_ext_10m_p_i]


#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_p[0]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_n[0]}]
#set_property PACKAGE_PIN R18 [get_ports {GPIO_J31_p[0]}]
#set_property PACKAGE_PIN P18 [get_ports {GPIO_J31_n[0]}]

#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_p[1]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_n[1]}]
#set_property PACKAGE_PIN R19 [get_ports {GPIO_J31_p[1]}]
#set_property PACKAGE_PIN R20 [get_ports {GPIO_J31_n[1]}]

#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_p[2]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_n[2]}]
#set_property PACKAGE_PIN P19 [get_ports {GPIO_J31_p[2]}]
#set_property PACKAGE_PIN N19 [get_ports {GPIO_J31_n[2]}]

#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_p[3]}]
#set_property IOSTANDARD LVDS [get_ports {GPIO_J31_n[3]}]
#set_property PACKAGE_PIN T21 [get_ports {GPIO_J31_p[3]}]
#set_property PACKAGE_PIN R21 [get_ports {GPIO_J31_n[3]}]


#set_property PACKAGE_PIN P22 [get_ports sfp_WR_mod_def1_i]
#set_property IOSTANDARD LVCMOS18 [get_ports sfp_WR_mod_def1_i]
#set_property PACKAGE_PIN P21 [get_ports sfp_WR_mod_def2_i]
#set_property IOSTANDARD LVCMOS18 [get_ports sfp_WR_mod_def2_i]

#set_property PACKAGE_PIN XX [get_ports irig_b_out_p]
#set_property IOSTANDARD LVDS [get_ports irig_b_out_p]
#set_property PACKAGE_PIN XX [get_ports irig_b_out_n]
#set_property IOSTANDARD LVDS [get_ports irig_b_out_n]


##########################################
############## SD define##################
##### SPI mode 4 pins, others 7 ##########
#######################################################
set_property IOSTANDARD LVCMOS18 [get_ports SD_CD]
set_property PACKAGE_PIN Y25 [get_ports SD_CD]

set_property IOSTANDARD LVCMOS18 [get_ports sd_dclk]
set_property PACKAGE_PIN AA25 [get_ports sd_dclk]

set_property IOSTANDARD LVCMOS18 [get_ports sd_mosi]
set_property PACKAGE_PIN AA24 [get_ports sd_mosi]

set_property IOSTANDARD LVCMOS18 [get_ports sd_ncs]
set_property PACKAGE_PIN W19 [get_ports sd_ncs]

set_property IOSTANDARD LVCMOS18 [get_ports SD_DATO2]
set_property PACKAGE_PIN W20 [get_ports SD_DATO2]

set_property IOSTANDARD LVCMOS18 [get_ports SD_DATO1]
set_property PACKAGE_PIN Y23 [get_ports SD_DATO1]

set_property IOSTANDARD LVCMOS18 [get_ports sd_miso]
set_property PACKAGE_PIN Y22 [get_ports sd_miso]

################END SD Card define #######################################



########################################################
# BANK 66 VCCO 1.8V
#####
set_property PACKAGE_PIN G25 [get_ports {c0_ddr4_adr[0]}]
set_property PACKAGE_PIN M26 [get_ports {c0_ddr4_adr[1]}]
set_property PACKAGE_PIN L25 [get_ports {c0_ddr4_adr[2]}]
set_property PACKAGE_PIN E26 [get_ports {c0_ddr4_adr[3]}]
set_property PACKAGE_PIN M25 [get_ports {c0_ddr4_adr[4]}]
set_property PACKAGE_PIN F22 [get_ports {c0_ddr4_adr[5]}]
set_property PACKAGE_PIN H26 [get_ports {c0_ddr4_adr[6]}]
set_property PACKAGE_PIN F24 [get_ports {c0_ddr4_adr[7]}]
set_property PACKAGE_PIN G26 [get_ports {c0_ddr4_adr[8]}]
set_property PACKAGE_PIN J23 [get_ports {c0_ddr4_adr[9]}]
set_property PACKAGE_PIN J25 [get_ports {c0_ddr4_adr[10]}]
set_property PACKAGE_PIN J24 [get_ports {c0_ddr4_adr[11]}]
set_property PACKAGE_PIN F25 [get_ports {c0_ddr4_adr[12]}]
set_property PACKAGE_PIN H24 [get_ports {c0_ddr4_adr[13]}]
set_property PACKAGE_PIN K26 [get_ports {c0_ddr4_adr[14]}]
set_property PACKAGE_PIN H22 [get_ports {c0_ddr4_adr[15]}]
set_property PACKAGE_PIN H21 [get_ports {c0_ddr4_adr[16]}]

set_property PACKAGE_PIN J26 [get_ports {c0_ddr4_ba[0]}]
set_property PACKAGE_PIN G22 [get_ports {c0_ddr4_ba[1]}]
set_property PACKAGE_PIN L22 [get_ports {c0_ddr4_bg[0]}]

set_property PACKAGE_PIN K22 [get_ports {c0_ddr4_ck_t[0]}]
set_property PACKAGE_PIN K23 [get_ports {c0_ddr4_ck_c[0]}]
set_property PACKAGE_PIN L23 [get_ports {c0_ddr4_cke[0]}]

set_property PACKAGE_PIN K25 [get_ports c0_ddr4_act_n]

set_property PACKAGE_PIN G24 [get_ports c0_ddr4_reset_n]
set_property PACKAGE_PIN M24 [get_ports {c0_ddr4_odt[0]}]
set_property PACKAGE_PIN H23 [get_ports {c0_ddr4_cs_n[0]}]

set_property PACKAGE_PIN D23 [get_ports {c0_ddr4_dqs_t[0]}]
set_property PACKAGE_PIN C24 [get_ports {c0_ddr4_dqs_c[0]}]
set_property PACKAGE_PIN E25 [get_ports {c0_ddr4_dm_dbi_n[0]}]
set_property PACKAGE_PIN F23 [get_ports {c0_ddr4_dq[0]}]
set_property PACKAGE_PIN D25 [get_ports {c0_ddr4_dq[1]}]
set_property PACKAGE_PIN E23 [get_ports {c0_ddr4_dq[2]}]
set_property PACKAGE_PIN B26 [get_ports {c0_ddr4_dq[3]}]
set_property PACKAGE_PIN D24 [get_ports {c0_ddr4_dq[4]}]
set_property PACKAGE_PIN D26 [get_ports {c0_ddr4_dq[5]}]
set_property PACKAGE_PIN B25 [get_ports {c0_ddr4_dq[6]}]
set_property PACKAGE_PIN C26 [get_ports {c0_ddr4_dq[7]}]

set_property PACKAGE_PIN M19 [get_ports {c0_ddr4_dqs_t[1]}]
set_property PACKAGE_PIN L19 [get_ports {c0_ddr4_dqs_c[1]}]
set_property PACKAGE_PIN L18 [get_ports {c0_ddr4_dm_dbi_n[1]}]
set_property PACKAGE_PIN M20 [get_ports {c0_ddr4_dq[8]}]
set_property PACKAGE_PIN J20 [get_ports {c0_ddr4_dq[9]}]
set_property PACKAGE_PIN J19 [get_ports {c0_ddr4_dq[10]}]
set_property PACKAGE_PIN M21 [get_ports {c0_ddr4_dq[11]}]
set_property PACKAGE_PIN L20 [get_ports {c0_ddr4_dq[12]}]
set_property PACKAGE_PIN J21 [get_ports {c0_ddr4_dq[13]}]
set_property PACKAGE_PIN K20 [get_ports {c0_ddr4_dq[14]}]
set_property PACKAGE_PIN K21 [get_ports {c0_ddr4_dq[15]}]

set_property INTERNAL_VREF 0.6 [get_iobanks 64]

set_property IOSTANDARD DIFF_SSTL12 [get_ports c0_sys_clk_p]
set_property PACKAGE_PIN T24 [get_ports c0_sys_clk_p]
set_property PACKAGE_PIN U24 [get_ports c0_sys_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports c0_sys_clk_n]




########################################################
# BANK 85 84   3.3V   GPIO
# DONT TOUCH



set_property PACKAGE_PIN XX [get_ports aux_scl]
set_property PACKAGE_PIN XX [get_ports aux_sda]

set_property IOSTANDARD LVCMOS33 [get_ports aux_scl]
set_property IOSTANDARD LVCMOS33 [get_ports aux_sda]

##set_property PACKAGE_PIN XX [get_ports oe_J30]
##set_property PACKAGE_PIN U13 [get_ports oe_J31]

##set_property IOSTANDARD LVCMOS33 [get_ports oe_J30]
##set_property IOSTANDARD LVCMOS33 [get_ports oe_J31]







##set_property PACKAGE_PIN Y11 [get_ports sfp_WR_tx_disable_o]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp_WR_tx_disable_o]
#set_property PACKAGE_PIN Y10 [get_ports sfp_WR_los_fault_i]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp_WR_los_fault_i]

set_property PACKAGE_PIN E11 [get_ports dac8560_sclk]
set_property PACKAGE_PIN D11 [get_ports dac8560_din]
set_property PACKAGE_PIN B10 [get_ports dac8560_sync_n]
set_property IOSTANDARD LVCMOS33 [get_ports dac8560_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports dac8560_din]
set_property IOSTANDARD LVCMOS33 [get_ports dac8560_sync_n]

set_property PACKAGE_PIN XX [get_ports refclk_sda]
set_property IOSTANDARD LVCMOS33 [get_ports refclk_sda]
set_property PACKAGE_PIN XX [get_ports refclk_scl]
set_property IOSTANDARD LVCMOS33 [get_ports refclk_scl]

set_property PACKAGE_PIN XX [get_ports dmtd_sda]
set_property IOSTANDARD LVCMOS33 [get_ports dmtd_sda]
set_property PACKAGE_PIN XX [get_ports dmtd_scl]
set_property IOSTANDARD LVCMOS33 [get_ports dmtd_scl]

##set_property PACKAGE_PIN A11 [get_ports ledPPS]
##set_property IOSTANDARD LVCMOS33 [get_ports ledPPS]


# BANK 85 84   3.3V   GPIO
########################################################


#############################################################
# FFVB676: Bank 224 DONT TOUCH


set_property PACKAGE_PIN AF2 [get_ports {pcie_mgt_rxp[3]}]
set_property PACKAGE_PIN AF7 [get_ports {pcie_mgt_txp[3]}]
set_property PACKAGE_PIN AE4 [get_ports {pcie_mgt_rxp[2]}]
set_property PACKAGE_PIN AE9 [get_ports {pcie_mgt_txp[2]}]
set_property PACKAGE_PIN AD2 [get_ports {pcie_mgt_rxp[1]}]
set_property PACKAGE_PIN AD7 [get_ports {pcie_mgt_txp[1]}]
set_property PACKAGE_PIN AB2 [get_ports {pcie_mgt_rxp[0]}]
set_property PACKAGE_PIN AC5 [get_ports {pcie_mgt_txp[0]}]

# Bank 224 -- 100.000 MHz GTH reference MGTREFCLK0
set_property PACKAGE_PIN AB7 [get_ports {pcie_ref_clk_p[0]}]
create_clock -period 10.000 -name pcie_ref_clk_p [get_ports pcie_ref_clk_p]


# Bank 224 -- 100.000 MHz GTH reference MGTREFCLK1
set_property PACKAGE_PIN Y6 [get_ports {user_clk_n[0]}]
set_property PACKAGE_PIN Y7 [get_ports {user_clk_p[0]}]
create_clock -period 10.000 -name usr_clk_p [get_ports user_clk_p]


#############################################################

#   ---------------------------------------------------------------------------`
#   -- FLASH PROM properties
#   ---------------------------------------------------------------------------

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

set_property PACKAGE_PIN N26 [get_ports sys_rst]
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst]



#############################################################################


# Bank 226 (GTH)
# Bank 226 -- 100.000 MHz GTH reference MGTREFCLK0

# Bank 226 (GTH)

set_property PACKAGE_PIN N5 [get_ports {GTH_TXp[4]}]
set_property PACKAGE_PIN M4 [get_ports {GTH_RXp[4]}]

set_property PACKAGE_PIN L5 [get_ports {GTH_TXp[5]}]
set_property PACKAGE_PIN K2 [get_ports {GTH_RXp[5]}]

set_property PACKAGE_PIN J5 [get_ports {GTH_TXp[6]}]
set_property PACKAGE_PIN H2 [get_ports {GTH_RXp[6]}]

set_property PACKAGE_PIN G5 [get_ports {GTH_TXp[7]}]
set_property PACKAGE_PIN F2 [get_ports {GTH_RXp[7]}]


# Bank 226 -- 100.000 MHz GTH reference MGTREFCLK0
set_property PACKAGE_PIN P7 [get_ports GTH_7_4_ref_clk_in_p]
create_clock -period 10.000 -name GTH_7_4_ref_clk_IN [get_ports GTH_7_4_ref_clk_in_p]

# Bank 226 -- 100.000 MHz GTH reference MGTREFCLK1
#set_property PACKAGE_PIN XX [get_ports GTH_7_4_ref_clk_out_p]
#set_property PACKAGE_PIN XX [get_ports GTH_7_4_ref_clk_out_n]
#create_clock -period 10.000 -name GTH_7_4_ref_clk_OUT [get_ports GTH_7_4_ref_clk_out_p]


#########################################################
# Bank 225 (GTH)  WHITE RABBIT and DAQ_section
# DONT TOUCH
#########################################################


#set_property LOC GTHE4_CHANNEL_X0Y0 [get_cells {cmp_xwrc_board_babywr/cmp_gth/U_gtwizard_gthe4/inst/gen_gtwizard_gthe4_top.gtwizard_ultrascale_2_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[0].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
#set_property PACKAGE_PIN Y6 [get_ports sfp_WR_txp_o]
#set_property PACKAGE_PIN Y5 [get_ports sfp_WR_txn_o]
#set_property LOC GTHE4_COMMON_X0Y0 [get_cells cmp_xwrc_board_babywr/cmp_gth_dedicated_clk]
#create_clock -period 10.000 -name clk_ref_gth_WR -waveform {0.000 5.000} [get_ports clk_ref_gth_p]



set_property PACKAGE_PIN Y2 [get_ports sfp_TOLM_Rx_data_p]
set_property PACKAGE_PIN AA5 [get_ports sfp_TOLM_Tx_data_p]
set_property PACKAGE_PIN V7 [get_ports ref_sfp_TOLM_clk_p]

create_clock -period 10.000 -name clk_ref_sfp_TOLM_gth -waveform {0.000 5.000} [get_ports ref_sfp_TOLM_clk_p]

#########################################################



## Il system clock per il setup IBERT (SFP+) prevede uno standard LVDS classico
## System clock pin locs and timing constraints
##

set_property PACKAGE_PIN T24 [get_ports gth_sysclkp]
set_property IOSTANDARD LVDS [get_ports gth_sysclkp]

create_clock -period 5.000 -name sysclk_main -waveform {0.000 2.500} [get_ports gth_sysclkp]

##  Il system clock per il setup DDR4 prevede uno standard DIFF_SSTL12

# set_property IOSTANDARD DIFF_SSTL12 [get_ports c0_sys_clk_p]
# set_property PACKAGE_PIN T24 [get_ports c0_sys_clk_p]
# set_property PACKAGE_PIN U24 [get_ports c0_sys_clk_n]
# set_property IOSTANDARD DIFF_SSTL12 [get_ports c0_sys_clk_n]



create_interface SD_CARD_INTERFACE
set_property INTERFACE SD_CARD_INTERFACE [get_ports { SD_CD SD_DATO1 SD_DATO2 sd_miso sd_ncs sd_mosi sd_dclk }]
create_interface UART_interface
set_property INTERFACE UART_interface [get_ports { uart_rxd_i uart_txd_o }]
create_interface SFP_TOLM_Interface
set_property INTERFACE SFP_TOLM_Interface [get_ports { sfp_TOLM_Rx_data_n sfp_TOLM_Rx_data_p sfp_TOLM_Tx_data_p sfp_TOLM_Tx_data_n }]
create_interface DMTD_Interface
set_property INTERFACE DMTD_Interface [get_ports { dmtd_scl clk_125m_dmtd_n clk_125m_dmtd_p dmtd_sda }]
create_interface TXCO_interface
set_property INTERFACE TXCO_interface [get_ports { dac8560_din dac8560_sclk dac8560_sync_n txco_in_p txco_in_n }]
create_interface refclk_Interface
set_property INTERFACE refclk_Interface [get_ports { ref_sfp_TOLM_clk_p ref_sfp_TOLM_clk_n }]
create_interface Timing_Info_for_AMC
set_property INTERFACE Timing_Info_for_AMC [get_ports { clk_10m_p_o clk_10m_n_o clk_100MHz_p clk_100MHz_n pps_o_p pps_o_n }]
create_interface dummySignals_to_be_deleted
set_property INTERFACE dummySignals_to_be_deleted [get_ports { oe_J30 oe_J31 }]
create_interface Z3_Connections
set_property INTERFACE Z3_Connections [get_ports { pcie_ref_clk_p[0] pcie_ref_clk_n[0] pcie_mgt_txp[3] pcie_mgt_txp[2] pcie_mgt_txp[1] pcie_mgt_txp[0] pcie_mgt_txn[3] pcie_mgt_txn[2] pcie_mgt_txn[1] pcie_mgt_txn[0] pcie_mgt_rxp[3] pcie_mgt_rxp[2] pcie_mgt_rxp[1] pcie_mgt_rxp[0] pcie_mgt_rxn[3] pcie_mgt_rxn[2] pcie_mgt_rxn[1] pcie_mgt_rxn[0] AMC_TCLK_p AMC_TCLK_n AMC_CLK_p AMC_CLK_n }]
create_interface LED_Interface
set_property INTERFACE LED_Interface [get_ports { led[1] led[0] }]
create_interface daDiscutere
set_property INTERFACE daDiscutere [get_ports { pcie_rst_n }]

create_interface DDR4_Interface
set_property INTERFACE DDR4_Interface [get_ports { c0_ddr4_dm_dbi_n[1] c0_ddr4_dm_dbi_n[0] c0_ddr4_dq[15] c0_ddr4_dq[14] c0_ddr4_dq[13] c0_ddr4_dq[12] c0_ddr4_dq[11] c0_ddr4_dq[10] c0_ddr4_dq[9] c0_ddr4_dq[8] c0_ddr4_dq[7] c0_ddr4_dq[6] c0_ddr4_dq[5] c0_ddr4_dq[4] c0_ddr4_dq[3] c0_ddr4_dq[2] c0_ddr4_dq[1] c0_ddr4_dq[0] c0_ddr4_dqs_c[1] c0_ddr4_dqs_c[0] c0_ddr4_dqs_t[1] c0_ddr4_dqs_t[0] c0_ddr4_adr[16] c0_ddr4_adr[15] c0_ddr4_adr[14] c0_ddr4_adr[13] c0_ddr4_adr[12] c0_ddr4_adr[11] c0_ddr4_adr[10] c0_ddr4_adr[9] c0_ddr4_adr[8] c0_ddr4_adr[7] c0_ddr4_adr[6] c0_ddr4_adr[5] c0_ddr4_adr[4] c0_ddr4_adr[3] c0_ddr4_adr[2] c0_ddr4_adr[1] c0_ddr4_adr[0] c0_ddr4_ba[1] c0_ddr4_ba[0] c0_ddr4_bg[0] c0_ddr4_ck_c[0] c0_ddr4_ck_t[0] c0_ddr4_cke[0] c0_ddr4_odt[0] c0_ddr4_cs_n[0] c0_ddr4_act_n c0_ddr4_reset_n c0_sys_clk_n c0_sys_clk_p }]
create_interface SFP_WR_Interface
set_property INTERFACE SFP_WR_Interface [get_ports { areset_n_i_WR }]
create_interface I2C_AUX_Interface
set_property INTERFACE I2C_AUX_Interface [get_ports { aux_sda aux_scl }]
create_interface I2C_Interface
set_property INTERFACE I2C_Interface [get_ports { scl_b sda_b }]
create_interface Timing_Input_Interface
set_property INTERFACE Timing_Input_Interface [get_ports { clk_ext_10m_p_i clk_ext_10m_n_i irig_b irig_b_n pps_i_p pps_i_n }]



set_property PACKAGE_PIN AA14 [get_ports txco_in_p]

#set_property PACKAGE_PIN AF14 [get_ports txco_in_p]

set_property PACKAGE_PIN AB15 [get_ports AMC_CLK_p]
set_property PACKAGE_PIN AB16 [get_ports AMC_CLK_n]
set_property PACKAGE_PIN AC13 [get_ports AMC_TCLK_p]
set_property PACKAGE_PIN AC14 [get_ports AMC_TCLK_n]





