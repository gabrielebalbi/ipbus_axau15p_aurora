-- remote_ctrl_slave
-- IPBus slave: writes 64-bit configuration words into a small FIFO;
-- the FIFO output feeds the Aurora TX AXI-Stream (via payload.vhd).
-- Allows the host to configure the remote device over the Aurora link.
--
-- Register map (byte offset from slave base):
--   0x00       FIFO_DATA_LO [W]  lower 32 bits of 64-bit word
--   0x04       FIFO_DATA_HI [W]  upper 32 bits — write triggers push
--   0x08       FIFO_STATUS  [R]  bit[0]=full, bit[1]=empty
--
-- Up to 16 entries deep (xpm_fifo_sync).

library ieee;
use ieee.std_logic_1164.all;
library xpm;
use xpm.vcomponents.all;
use work.ipbus.all;

entity remote_ctrl_slave is
    port(
        clk       : in  std_logic;  -- ipb_clk
        rst       : in  std_logic;
        ipb_in    : in  ipb_wbus;
        ipb_out   : out ipb_rbus;
        -- AXI-Stream output to Aurora TX (ipb_clk domain)
        tx_tdata  : out std_logic_vector(63 downto 0);
        tx_tvalid : out std_logic;
        tx_tready : in  std_logic
    );
end remote_ctrl_slave;

architecture rtl of remote_ctrl_slave is

    signal ack         : std_logic;
    signal latch_lo    : std_logic_vector(31 downto 0);
    signal push        : std_logic;
    signal fifo_din    : std_logic_vector(63 downto 0);
    signal fifo_full   : std_logic;
    signal fifo_empty  : std_logic;
    signal fifo_dout   : std_logic_vector(63 downto 0);
    signal fifo_rd     : std_logic;

begin

    -- Write decode
    push <= ipb_in.ipb_strobe and ipb_in.ipb_write
            and ipb_in.ipb_addr(0);   -- addr bit0=1 → HI word triggers push

    process(clk)
    begin
        if rising_edge(clk) then
            if ipb_in.ipb_strobe = '1' and ipb_in.ipb_write = '1'
               and ipb_in.ipb_addr(0) = '0' then
                latch_lo <= ipb_in.ipb_wdata;   -- latch LO
            end if;
        end if;
    end process;

    fifo_din <= ipb_in.ipb_wdata & latch_lo;  -- HI:LO

    -- Synchronous FIFO (ipb_clk domain) — 16 entries deep
    fifo : xpm_fifo_sync
        generic map(
            FIFO_DEPTH     => 16,
            DATA_WIDTH     => 64,
            FIFO_MEMORY_TYPE => "distributed",
            READ_MODE      => "fwft",
            USE_ADV_FEATURES => "0000"
        )
        port map(
            clk      => clk,
            rst      => rst,
            din      => fifo_din,
            wr_en    => push,
            full     => fifo_full,
            dout     => fifo_dout,
            rd_en    => fifo_rd,
            empty    => fifo_empty,
            wr_ack   => open,
            overflow => open,
            underflow=> open,
            data_valid => open,
            almost_full  => open,
            almost_empty => open,
            prog_full    => open,
            prog_empty   => open,
            wr_data_count => open,
            rd_data_count => open,
            sleep        => '0',
            injectdbiterr => '0',
            injectsbiterr => '0',
            sbiterr  => open,
            dbiterr  => open
        );

    -- Drive Aurora TX AXI-Stream from FIFO (FWFT mode)
    tx_tdata  <= fifo_dout;
    tx_tvalid <= not fifo_empty;
    fifo_rd   <= tx_tready and not fifo_empty;

    -- IPBus ACK and read
    process(clk)
    begin
        if rising_edge(clk) then
            ack <= ipb_in.ipb_strobe and not ack;
        end if;
    end process;

    ipb_out.ipb_ack   <= ack;
    ipb_out.ipb_err   <= '0';
    ipb_out.ipb_rdata <= (31 downto 2 => '0') & fifo_empty & fifo_full;

end rtl;
