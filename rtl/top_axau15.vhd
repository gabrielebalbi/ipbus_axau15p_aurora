-- Top-level for AXAU15 + FH1223
-- IPBus over RGMII Ethernet; Aurora 64B/66B 6.25 Gbps RX/TX via SFP1.
-- Edit mac_addr / ip_addr before programming.

library ieee;
use ieee.std_logic_1164.all;
use work.ipbus.all;

entity top is
    port(
        -- 200 MHz differential sysclock (Bank 65, DIFF_SSTL18_II)
        sysclk_p        : in  std_logic;
        sysclk_n        : in  std_logic;

        -- RGMII Ethernet (Bank 84, LVCMOS18) — RTL8211F/JL2121
        eth_gtxclk      : out std_logic;
        eth_txen        : out std_logic;
        eth_txd         : out std_logic_vector(3 downto 0);
        eth_rxclk       : in  std_logic;
        eth_rxdv        : in  std_logic;
        eth_rxd         : in  std_logic_vector(3 downto 0);
        eth_mdc         : out std_logic;
        eth_mdio        : inout std_logic;
        eth_reset_n     : out std_logic;

        -- Aurora 64B/66B via SFP1 on FH1223 (Bank 224 GTH lane 0)
        -- RefClk = 156.25 MHz from core board (MGTREFCLK0_225)
        aurora_refclk_p : in  std_logic;
        aurora_refclk_n : in  std_logic;
        aurora_rx_p     : in  std_logic;   -- SFP1 RX (FMC DP0_C2M)
        aurora_rx_n     : in  std_logic;
        aurora_tx_p     : out std_logic;   -- SFP1 TX (FMC DP0_M2C)
        aurora_tx_n     : out std_logic;

        -- Status LEDs (Bank 84/85)
        led             : out std_logic_vector(1 downto 0)
    );
end top;

architecture rtl of top is

    signal clk_ipb, rst_ipb, clk_aux, rst_aux : std_logic;
    signal nuke, soft_rst                      : std_logic;
    signal mac_addr                            : std_logic_vector(47 downto 0);
    signal ip_addr                             : std_logic_vector(31 downto 0);
    signal ipb_out                             : ipb_wbus;
    signal ipb_in                              : ipb_rbus;

begin

    -- Infrastructure: clocks + RGMII MAC + IPBus UDP engine
    infra : entity work.axau15_infra
        generic map(
            CLK_AUX_FREQ => 40.0
        )
        port map(
            sysclk_p    => sysclk_p,
            sysclk_n    => sysclk_n,
            eth_gtxclk  => eth_gtxclk,
            eth_txen    => eth_txen,
            eth_txd     => eth_txd,
            eth_rxclk   => eth_rxclk,
            eth_rxdv    => eth_rxdv,
            eth_rxd     => eth_rxd,
            eth_mdc     => eth_mdc,
            eth_mdio    => eth_mdio,
            eth_reset_n => eth_reset_n,
            clk_ipb_o   => clk_ipb,
            rst_ipb_o   => rst_ipb,
            clk_aux_o   => clk_aux,
            rst_aux_o   => rst_aux,
            nuke        => nuke,
            soft_rst    => soft_rst,
            leds        => led,
            mac_addr    => mac_addr,
            ip_addr     => ip_addr,
            ipb_in      => ipb_in,
            ipb_out     => ipb_out
        );

    -- Edit these before programming!
    mac_addr <= X"020ddba11520";   -- locally administered, unicast
    ip_addr  <= X"c0a8c801";      -- 192.168.200.1  (change as needed)

    -- Application payload: Aurora + BRAM + IPBus slaves
    payload : entity work.payload
        port map(
            ipb_clk          => clk_ipb,
            ipb_rst          => rst_ipb,
            ipb_in           => ipb_out,
            ipb_out          => ipb_in,
            clk_aux          => clk_aux,
            rst_aux          => rst_aux,
            nuke             => nuke,
            soft_rst         => soft_rst,
            aurora_refclk_p  => aurora_refclk_p,
            aurora_refclk_n  => aurora_refclk_n,
            aurora_rx_p      => aurora_rx_p,
            aurora_rx_n      => aurora_rx_n,
            aurora_tx_p      => aurora_tx_p,
            aurora_tx_n      => aurora_tx_n
        );

end rtl;
