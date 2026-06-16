-- axau15_infra
-- Board-level infrastructure for AXAU15:
--   * 200 MHz sysclock → MMCM → ipbus (31.25 MHz), aux, 125 MHz, 200 MHz
--   * RGMII Ethernet MAC (temac_gbe_v9_0 in RGMII mode) + IPBus UDP engine
--
-- Depends on ipbus-firmware components (Apache 2.0, CERN):
--   components/ipbus_eth/firmware/hdl/eth_axau15_rgmii.vhd  (see note)
--   components/ipbus_util/firmware/hdl/clocks/clocks_us_serdes_rgmii.vhd
--   components/ipbus_util/firmware/hdl/masters/ipbus_ctrl.vhd
--   components/ipbus_util/firmware/hdl/led_stretcher.vhd
--
-- NOTE: use eth_axau15_rgmii.vhd in rtl/ (this repo) which wraps
--   the Vivado TEMAC IP (temac_gbe_v9_0) in RGMII mode.

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VComponents.all;
use work.ipbus.all;

entity axau15_infra is
    generic(
        CLK_AUX_FREQ   : real    := 40.0;
        DHCP_not_RARP  : std_logic := '0'
    );
    port(
        -- 200 MHz diff sysclock
        sysclk_p    : in  std_logic;
        sysclk_n    : in  std_logic;

        -- RGMII Ethernet
        eth_gtxclk  : out std_logic;
        eth_txen    : out std_logic;
        eth_txd     : out std_logic_vector(3 downto 0);
        eth_rxclk   : in  std_logic;
        eth_rxdv    : in  std_logic;
        eth_rxd     : in  std_logic_vector(3 downto 0);
        eth_mdc     : out std_logic;
        eth_mdio    : inout std_logic;
        eth_reset_n : out std_logic;

        -- IPBus clock / reset outputs
        clk_ipb_o   : out std_logic;
        rst_ipb_o   : out std_logic;
        clk_aux_o   : out std_logic;
        rst_aux_o   : out std_logic;

        nuke        : in  std_logic;
        soft_rst    : in  std_logic;
        leds        : out std_logic_vector(1 downto 0);
        mac_addr    : in  std_logic_vector(47 downto 0);
        ip_addr     : in  std_logic_vector(31 downto 0);
        ipb_in      : in  ipb_rbus;
        ipb_out     : out ipb_wbus
    );
end axau15_infra;

architecture rtl of axau15_infra is

    signal sysclk                                         : std_logic;
    signal clk_ipb, clk_ipb_i, clk_aux, clk125, clk200, clk333 : std_logic;
    signal locked, eth_locked, clk_locked                 : std_logic;
    signal rst125, rst_ipb, rst_ipb_ctrl, rst_eth, rst_aux, onehz : std_logic;
    signal mac_tx_data, mac_rx_data   : std_logic_vector(7 downto 0);
    signal mac_tx_valid, mac_tx_last, mac_tx_error, mac_tx_ready  : std_logic;
    signal mac_rx_valid, mac_rx_last, mac_rx_error                : std_logic;
    signal pkt                                            : std_logic;
    signal led_p                                          : std_logic_vector(0 downto 0);

begin

    ibuf : IBUFDS
        port map(i => sysclk_p, ib => sysclk_n, o => sysclk);

    -- Clock management: 200 MHz → 31.25 MHz (IPBus), aux, 125 MHz, 200 MHz
    clocks : entity work.clocks_us_serdes_rgmii
        generic map(
            CLK_FR_FREQ  => 200.0,
            CLK_AUX_FREQ => CLK_AUX_FREQ
        )
        port map(
            clki_fr       => sysclk,
            clko_ipb      => clk_ipb_i,
            clko_aux      => clk_aux,
            clko_125      => clk125,
            clko_200      => clk200,
            clko_333      => clk333,
            eth_locked    => eth_locked,
            locked        => clk_locked,
            nuke          => nuke,
            soft_rst      => soft_rst,
            rsto_125      => rst125,
            rsto_ipb      => rst_ipb,
            rsto_eth      => rst_eth,
            rsto_ipb_ctrl => rst_ipb_ctrl,
            rsto_aux      => rst_aux,
            onehz         => onehz
        );

    clk_ipb   <= clk_ipb_i;
    clk_ipb_o <= clk_ipb_i;
    rst_ipb_o <= rst_ipb;
    clk_aux_o <= clk_aux;
    rst_aux_o <= rst_aux;
    locked    <= clk_locked and eth_locked;

    stretch : entity work.led_stretcher
        generic map(WIDTH => 1)
        port map(clk => clk125, d(0) => pkt, q => led_p);

    leds <= (led_p(0), locked and onehz);

    -- RGMII Ethernet MAC: wraps Vivado temac_gbe_v9_0 IP
    eth : entity work.eth_axau15_rgmii
        port map(
            gtx_clk      => clk125,
            refclk       => clk333,
            rst          => rst_eth,
            -- RGMII physical interface
            rgmii_txd    => eth_txd,
            rgmii_tx_ctl => eth_txen,
            rgmii_txc    => eth_gtxclk,
            rgmii_rxd    => eth_rxd,
            rgmii_rx_ctl => eth_rxdv,
            rgmii_rxc    => eth_rxclk,
            -- MDIO management interface
            mdc          => eth_mdc,
            mdio         => eth_mdio,
            phy_reset_n  => eth_reset_n,
            -- Status
            locked       => eth_locked,
            -- 8-bit AXI-Stream to IPBus
            tx_data      => mac_tx_data,
            tx_valid     => mac_tx_valid,
            tx_last      => mac_tx_last,
            tx_error     => mac_tx_error,
            tx_ready     => mac_tx_ready,
            rx_data      => mac_rx_data,
            rx_valid     => mac_rx_valid,
            rx_last      => mac_rx_last,
            rx_error     => mac_rx_error
        );

    -- IPBus UDP/IP engine
    ipbus : entity work.ipbus_ctrl
        generic map(DHCP_RARP => DHCP_not_RARP)
        port map(
            mac_clk      => clk125,
            rst_macclk   => rst125,
            ipb_clk      => clk_ipb,
            rst_ipb      => rst_ipb_ctrl,
            mac_rx_data  => mac_rx_data,
            mac_rx_valid => mac_rx_valid,
            mac_rx_last  => mac_rx_last,
            mac_rx_error => mac_rx_error,
            mac_tx_data  => mac_tx_data,
            mac_tx_valid => mac_tx_valid,
            mac_tx_last  => mac_tx_last,
            mac_tx_error => mac_tx_error,
            mac_tx_ready => mac_tx_ready,
            ipb_out      => ipb_out,
            ipb_in       => ipb_in,
            mac_addr     => mac_addr,
            ip_addr      => ip_addr,
            ipam_select  => '0',
            pkt          => pkt
        );

end rtl;
