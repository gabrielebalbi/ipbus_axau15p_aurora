-- eth_axau15_rgmii
-- RGMII Ethernet MAC wrapper for AXAU15.
-- Instantiates Vivado IP: temac_gbe_v9_0 (RGMII configuration).
--
-- Generate the IP in Vivado with these settings:
--   Product: Tri-Mode Ethernet MAC (temac_gbe_v9_0)
--   Physical interface: RGMII
--   Speed: 1000 Mbps
--   MDIO: enabled
--   Include shared logic: In core
--   GT type: none (RGMII uses FPGA IO, not GTH)
--
-- The 8-bit AXI-Stream interface is compatible with ipbus_ctrl.

library ieee;
use ieee.std_logic_1164.all;

entity eth_axau15_rgmii is
    port(
        -- 125 MHz clock from MMCM (drives TEMAC and GTXCLK)
        gtx_clk     : in  std_logic;
        rst         : in  std_logic;

        -- RGMII physical signals (to/from RTL8211F on carrier board)
        rgmii_txd   : out std_logic_vector(3 downto 0);
        rgmii_tx_ctl: out std_logic;
        rgmii_txc   : out std_logic;
        rgmii_rxd   : in  std_logic_vector(3 downto 0);
        rgmii_rx_ctl: in  std_logic;
        rgmii_rxc   : in  std_logic;

        -- MDIO management (PHY address 001)
        mdc         : out std_logic;
        mdio        : inout std_logic;
        phy_reset_n : out std_logic;

        -- Lock indicator (1 = MAC ready)
        locked      : out std_logic;

        -- 8-bit AXI-Stream  TX  (from ipbus_ctrl)
        tx_data     : in  std_logic_vector(7 downto 0);
        tx_valid    : in  std_logic;
        tx_last     : in  std_logic;
        tx_error    : in  std_logic;
        tx_ready    : out std_logic;

        -- 8-bit AXI-Stream  RX  (to ipbus_ctrl)
        rx_data     : out std_logic_vector(7 downto 0);
        rx_valid    : out std_logic;
        rx_last     : out std_logic;
        rx_error    : out std_logic
    );
end eth_axau15_rgmii;

architecture rtl of eth_axau15_rgmii is

    -- Internal signals between TEMAC and AXI-S adapter
    signal mac_tx_axis_tdata   : std_logic_vector(7 downto 0);
    signal mac_tx_axis_tvalid  : std_logic;
    signal mac_tx_axis_tlast   : std_logic;
    signal mac_tx_axis_tuser   : std_logic;
    signal mac_tx_axis_tready  : std_logic;

    signal mac_rx_axis_tdata   : std_logic_vector(7 downto 0);
    signal mac_rx_axis_tvalid  : std_logic;
    signal mac_rx_axis_tlast   : std_logic;
    signal mac_rx_axis_tuser   : std_logic;

    signal mac_rx_aclk, mac_tx_aclk : std_logic;
    signal glbl_rstn, rx_rstn, tx_rstn : std_logic;

    -- PHY reset counter (hold reset for ≥10 ms after power-on)
    signal rst_ctr : integer range 0 to 1249999 := 0;
    signal phy_rst_n_i : std_logic := '0';

begin

    glbl_rstn <= not rst;
    rx_rstn   <= not rst;
    tx_rstn   <= not rst;
    locked    <= glbl_rstn;

    -- PHY reset: assert for 10 ms (1,250,000 cycles @ 125 MHz) after rst
    phy_reset_proc : process(gtx_clk)
    begin
        if rising_edge(gtx_clk) then
            if rst = '1' then
                rst_ctr    <= 0;
                phy_rst_n_i <= '0';
            elsif rst_ctr < 1249999 then
                rst_ctr <= rst_ctr + 1;
            else
                phy_rst_n_i <= '1';
            end if;
        end if;
    end process;

    phy_reset_n <= phy_rst_n_i;

    -- Map ipbus_ctrl 8-bit stream interface to TEMAC AXI-S
    mac_tx_axis_tdata  <= tx_data;
    mac_tx_axis_tvalid <= tx_valid;
    mac_tx_axis_tlast  <= tx_last;
    mac_tx_axis_tuser  <= tx_error;
    tx_ready           <= mac_tx_axis_tready;

    rx_data  <= mac_rx_axis_tdata;
    rx_valid <= mac_rx_axis_tvalid;
    rx_last  <= mac_rx_axis_tlast;
    rx_error <= mac_rx_axis_tuser;

    -- Vivado TEMAC IP — generate with name "temac_gbe_v9_0" in RGMII mode
    mac : entity work.temac_gbe_v9_0
        port map(
            gtx_clk                => gtx_clk,
            glbl_rstn              => glbl_rstn,
            rx_axi_rstn            => rx_rstn,
            tx_axi_rstn            => tx_rstn,
            -- TX AXI-S
            tx_axis_mac_tdata      => mac_tx_axis_tdata,
            tx_axis_mac_tvalid     => mac_tx_axis_tvalid,
            tx_axis_mac_tlast      => mac_tx_axis_tlast,
            tx_axis_mac_tuser      => mac_tx_axis_tuser,
            tx_axis_mac_tready     => mac_tx_axis_tready,
            -- RX AXI-S
            rx_mac_aclk            => mac_rx_aclk,
            rx_axis_mac_tdata      => mac_rx_axis_tdata,
            rx_axis_mac_tvalid     => mac_rx_axis_tvalid,
            rx_axis_mac_tlast      => mac_rx_axis_tlast,
            rx_axis_mac_tuser      => mac_rx_axis_tuser,
            -- RGMII
            rgmii_txd              => rgmii_txd,
            rgmii_tx_ctl           => rgmii_tx_ctl,
            rgmii_txc              => rgmii_txc,
            rgmii_rxd              => rgmii_rxd,
            rgmii_rx_ctl           => rgmii_rx_ctl,
            rgmii_rxc              => rgmii_rxc,
            -- MDIO
            mdc                    => mdc,
            mdio                   => mdio,
            -- Statistics (not used)
            tx_statistics_vector   => open,
            tx_statistics_valid    => open,
            rx_statistics_vector   => open,
            rx_statistics_valid    => open,
            -- Speed/pause (hardwired)
            tx_ifg_delay           => X"00",
            pause_req              => '0',
            pause_val              => X"0000",
            speedis100             => open,
            speedis10100           => open,
            -- Status
            rx_reset               => open,
            tx_reset               => open,
            mac_tx_aclk            => mac_tx_aclk
        );

end rtl;
