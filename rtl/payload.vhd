-- payload
-- Application payload: Aurora 64B/66B RX + BRAM + IPBus slaves.
-- Instantiated by top_axau15 inside the IPBus framework.
--
-- IPBus address map (word address, base 0x00000000):
--   0x00000000  acq_ctrl      (4 words)  acquisition control/status
--   0x00000100  remote_ctrl   (32 words) remote device configuration
--   0x00001000  bram_readout  (BRAM_DEPTH words) data buffer
--
-- Aurora IP (aurora_64b66b_0) must be generated in Vivado:
--   Line rate:    6.25 Gbps
--   RefClk:       156.25 MHz (MGTREFCLK0_225, core board oscillator)
--   Lane width:   4 bytes (32-bit) or 8 bytes (64-bit) — set AXIS_DATA_BITS
--   GT location:  GTHE4_CHANNEL_X0Y0 (Bank 224, lane 0, SFP1 on FH1223)
--   Flow ctrl:    None
--   Shared logic: In example design (or In core)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.VComponents.all;
use work.ipbus.all;
use work.ipbus_decode_payload.all;

entity payload is
    generic(
        -- Log2 of BRAM depth in 32-bit words (14 → 16 K words = 64 KB)
        BRAM_DEPTH_LOG2 : integer := 14
    );
    port(
        ipb_clk         : in  std_logic;
        ipb_rst         : in  std_logic;
        ipb_in          : in  ipb_wbus;
        ipb_out         : out ipb_rbus;
        clk_aux         : in  std_logic;
        rst_aux         : in  std_logic;
        nuke            : out std_logic;
        soft_rst        : out std_logic;

        -- Aurora GTH signals (passed through from top)
        aurora_refclk_p : in  std_logic;
        aurora_refclk_n : in  std_logic;
        aurora_rx_p     : in  std_logic;
        aurora_rx_n     : in  std_logic;
        aurora_tx_p     : out std_logic;
        aurora_tx_n     : out std_logic
    );
end payload;

architecture rtl of payload is

    -- IPBus fabric
    signal ipb_to_slaves  : ipb_wbus_array(N_SLAVES - 1 downto 0);
    signal ipb_from_slaves: ipb_rbus_array(N_SLAVES - 1 downto 0);

    -- Aurora 156.25 MHz reference clock (after IBUFDS_GTE4)
    signal aurora_refclk_buf : std_logic;

    -- Aurora user clock (recovered from link, typically 156.25 MHz)
    signal aurora_user_clk : std_logic;
    signal aurora_rx_ready : std_logic;

    -- Aurora 64B/66B RX AXI4-Stream (8 bytes wide for 64-bit user data)
    signal aurora_rx_tdata  : std_logic_vector(63 downto 0);
    signal aurora_rx_tvalid : std_logic;
    signal aurora_rx_tkeep  : std_logic_vector(7 downto 0);
    signal aurora_rx_tlast  : std_logic;

    -- Aurora TX AXI4-Stream (for remote_ctrl commands)
    signal aurora_tx_tdata  : std_logic_vector(63 downto 0);
    signal aurora_tx_tvalid : std_logic;
    signal aurora_tx_tready : std_logic;
    signal aurora_tx_tkeep  : std_logic_vector(7 downto 0);
    signal aurora_tx_tlast  : std_logic;

    -- BRAM write-side (from Aurora RX, aurora_user_clk domain)
    signal bram_waddr  : std_logic_vector(BRAM_DEPTH_LOG2 - 1 downto 0);
    signal bram_wdata  : std_logic_vector(31 downto 0);
    signal bram_we     : std_logic;
    signal bram_wfull  : std_logic;

    -- BRAM read-side (from bram_readout slave, ipb_clk domain)
    signal bram_raddr  : std_logic_vector(BRAM_DEPTH_LOG2 - 1 downto 0);
    signal bram_rdata  : std_logic_vector(31 downto 0);

    -- acq_ctrl registers
    signal acq_start   : std_logic;
    signal acq_stop    : std_logic;
    signal acq_running : std_logic;
    signal acq_words   : std_logic_vector(31 downto 0);

    -- remote_ctrl outgoing FIFO signals
    signal rctrl_tdata  : std_logic_vector(63 downto 0);
    signal rctrl_tvalid : std_logic;
    signal rctrl_tready : std_logic;

begin

    -- IBUFDS_GTE4: differential refclk → single-ended for Aurora IP (SupportLevel=0)
    ibufds_refclk : IBUFDS_GTE4
        port map(
            I    => aurora_refclk_p,
            IB   => aurora_refclk_n,
            CEB  => '0',
            O    => aurora_refclk_buf,
            ODIV2 => open
        );

    -- IPBus fabric: decode address and fan out to slaves
    fabric : entity work.ipbus_fabric_sel
        generic map(
            NSLV      => N_SLAVES,
            SEL_WIDTH => IPBUS_SEL_WIDTH
        )
        port map(
            ipb_in          => ipb_in,
            ipb_out         => ipb_out,
            sel             => ipbus_sel_payload(ipb_in.ipb_addr),
            ipb_to_slaves   => ipb_to_slaves,
            ipb_from_slaves => ipb_from_slaves
        );

    nuke     <= '0';
    soft_rst <= '0';

    -- Aurora 64B/66B IP (Vivado-generated: aurora_64b66b_0)
    aurora_ip : entity work.aurora_64b66b_0
        port map(
            -- GT serial
            rxp              => aurora_rx_p,
            rxn              => aurora_rx_n,
            txp              => aurora_tx_p,
            txn              => aurora_tx_n,
            -- Reference clock 156.25 MHz (IBUFDS_GTE4 output, SupportLevel=0)
            refclk1_in       => aurora_refclk_buf,
            -- RX AXI-Stream
            m_axi_rx_tdata   => aurora_rx_tdata,
            m_axi_rx_tvalid  => aurora_rx_tvalid,
            m_axi_rx_tkeep   => aurora_rx_tkeep,
            m_axi_rx_tlast   => aurora_rx_tlast,
            -- TX AXI-Stream
            s_axi_tx_tdata   => aurora_tx_tdata,
            s_axi_tx_tvalid  => aurora_tx_tvalid,
            s_axi_tx_tready  => aurora_tx_tready,
            s_axi_tx_tkeep   => aurora_tx_tkeep,
            s_axi_tx_tlast   => aurora_tx_tlast,
            -- Clocks
            user_clk_out     => aurora_user_clk,
            sync_clk_out     => open,
            -- Reset / status
            reset            => ipb_rst,
            channel_up       => aurora_rx_ready,
            lane_up          => open,
            hard_err         => open,
            soft_err         => open,
            -- GT init
            gt_reset         => ipb_rst,
            init_clk         => ipb_clk,
            sys_reset_out    => open
        );

    -- Aurora RX → BRAM write path
    rx_path : entity work.aurora_rx_path
        generic map(BRAM_DEPTH_LOG2 => BRAM_DEPTH_LOG2)
        port map(
            clk        => aurora_user_clk,
            rst        => ipb_rst,
            -- AXI-Stream from Aurora
            rx_tdata   => aurora_rx_tdata,
            rx_tvalid  => aurora_rx_tvalid,
            rx_tkeep   => aurora_rx_tkeep,
            rx_tlast   => aurora_rx_tlast,
            -- Write port to BRAM controller
            wr_addr    => bram_waddr,
            wr_data    => bram_wdata,
            wr_en      => bram_we,
            wr_full    => bram_wfull,
            -- Acquisition control (ipb_clk domain, 1-cycle pulse)
            acq_start  => acq_start,
            acq_stop   => acq_stop,
            acq_running=> acq_running,
            acq_words  => acq_words
        );

    -- Dual-port BRAM (write: aurora_user_clk, read: ipb_clk)
    bram : entity work.bram_ctrl
        generic map(DEPTH_LOG2 => BRAM_DEPTH_LOG2)
        port map(
            -- Write port (Aurora clock domain)
            wclk   => aurora_user_clk,
            waddr  => bram_waddr,
            wdata  => bram_wdata,
            we     => bram_we,
            wfull  => bram_wfull,
            -- Read port (IPBus clock domain)
            rclk   => ipb_clk,
            raddr  => bram_raddr,
            rdata  => bram_rdata
        );

    -- Slave 0: acq_ctrl — start/stop/status
    acq : entity work.acq_ctrl_slave
        port map(
            clk        => ipb_clk,
            rst        => ipb_rst,
            ipb_in     => ipb_to_slaves(N_SLV_ACQ_CTRL),
            ipb_out    => ipb_from_slaves(N_SLV_ACQ_CTRL),
            acq_start  => acq_start,
            acq_stop   => acq_stop,
            acq_running=> acq_running,
            acq_words  => acq_words,
            chan_up    => aurora_rx_ready
        );

    -- Slave 1: remote_ctrl — configuration words → Aurora TX
    rctrl : entity work.remote_ctrl_slave
        port map(
            clk        => ipb_clk,
            rst        => ipb_rst,
            ipb_in     => ipb_to_slaves(N_SLV_REMOTE_CTRL),
            ipb_out    => ipb_from_slaves(N_SLV_REMOTE_CTRL),
            -- FIFO output to Aurora TX (ipb_clk domain; cross to aurora_user_clk inside)
            tx_tdata   => rctrl_tdata,
            tx_tvalid  => rctrl_tvalid,
            tx_tready  => rctrl_tready
        );

    -- Route remote_ctrl FIFO → Aurora TX AXI-Stream
    aurora_tx_tdata  <= rctrl_tdata;
    aurora_tx_tvalid <= rctrl_tvalid;
    aurora_tx_tkeep  <= X"FF";
    aurora_tx_tlast  <= '1';  -- single-beat frames for config words
    rctrl_tready     <= aurora_tx_tready;

    -- Slave 2: bram_readout — burst read of data BRAM
    rdout : entity work.bram_readout_slave
        generic map(BRAM_DEPTH_LOG2 => BRAM_DEPTH_LOG2)
        port map(
            clk        => ipb_clk,
            rst        => ipb_rst,
            ipb_in     => ipb_to_slaves(N_SLV_BRAM_RDOUT),
            ipb_out    => ipb_from_slaves(N_SLV_BRAM_RDOUT),
            bram_addr  => bram_raddr,
            bram_data  => bram_rdata
        );

end rtl;
