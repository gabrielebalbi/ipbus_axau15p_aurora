-- acq_ctrl_slave
-- IPBus slave: acquisition control and status.
-- All in ipb_clk domain.
-- acq_start / acq_stop are 1-cycle pulses sent to aurora_rx_path
-- via xpm_cdc_pulse for clock-domain crossing.
--
-- Register map (byte offset from slave base):
--   0x00  CTRL   [W] bit[0]=start, bit[1]=stop
--   0x04  STATUS [R] bit[0]=chan_up, bit[1]=acq_running
--   0x08  WORDS  [R] words written in last/current acquisition (free-running)

library ieee;
use ieee.std_logic_1164.all;
library xpm;
use xpm.vcomponents.all;
use work.ipbus.all;

entity acq_ctrl_slave is
    port(
        clk        : in  std_logic;  -- ipb_clk
        rst        : in  std_logic;
        ipb_in     : in  ipb_wbus;
        ipb_out    : out ipb_rbus;

        -- 1-cycle pulses in ipb_clk domain → aurora_rx_path (aurora_user_clk)
        acq_start  : out std_logic;
        acq_stop   : out std_logic;

        -- Status from aurora_rx_path (aurora_user_clk domain, CDC inside)
        acq_running: in  std_logic;
        acq_words  : in  std_logic_vector(31 downto 0);
        chan_up    : in  std_logic
    );
end acq_ctrl_slave;

architecture rtl of acq_ctrl_slave is

    signal ack      : std_logic;
    signal ctrl_wr  : std_logic;
    signal start_i, stop_i : std_logic;

begin

    -- Single-cycle write decode
    ctrl_wr <= ipb_in.ipb_strobe and ipb_in.ipb_write
               and not ipb_in.ipb_addr(1);   -- addr bit1=0 → CTRL register

    start_i <= ctrl_wr and ipb_in.ipb_wdata(0);
    stop_i  <= ctrl_wr and ipb_in.ipb_wdata(1);

    acq_start <= start_i;
    acq_stop  <= stop_i;

    -- IPBus ACK and read mux
    process(clk)
    begin
        if rising_edge(clk) then
            ack <= ipb_in.ipb_strobe and not ack;
        end if;
    end process;

    ipb_out.ipb_ack   <= ack;
    ipb_out.ipb_err   <= '0';

    process(ipb_in.ipb_addr, chan_up, acq_running, acq_words)
    begin
        case ipb_in.ipb_addr(1 downto 0) is
            when "00"   => ipb_out.ipb_rdata <= X"00000000";  -- CTRL write-only
            when "01"   => ipb_out.ipb_rdata <= (31 downto 2 => '0')
                                                 & acq_running & chan_up;
            when "10"   => ipb_out.ipb_rdata <= acq_words;
            when others => ipb_out.ipb_rdata <= X"DEADBEEF";
        end case;
    end process;

end rtl;
