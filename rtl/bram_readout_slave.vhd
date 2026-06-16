-- bram_readout_slave
-- IPBus slave: direct-mapped read-only window onto the data BRAM.
-- The IPBus word address (lower BRAM_DEPTH_LOG2 bits) selects the BRAM word.
-- 1-cycle BRAM read latency is absorbed by the ACK delay.

library ieee;
use ieee.std_logic_1164.all;
use work.ipbus.all;

entity bram_readout_slave is
    generic(
        BRAM_DEPTH_LOG2 : integer := 14
    );
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        ipb_in    : in  ipb_wbus;
        ipb_out   : out ipb_rbus;
        -- BRAM read port (1-cycle latency, rclk = clk)
        bram_addr : out std_logic_vector(BRAM_DEPTH_LOG2 - 1 downto 0);
        bram_data : in  std_logic_vector(31 downto 0)
    );
end bram_readout_slave;

architecture rtl of bram_readout_slave is

    signal strobe_d : std_logic;

begin

    -- Present the word address to the BRAM immediately
    bram_addr <= ipb_in.ipb_addr(BRAM_DEPTH_LOG2 - 1 downto 0);

    -- ACK one cycle after strobe to absorb BRAM read latency
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                strobe_d <= '0';
            else
                strobe_d <= ipb_in.ipb_strobe and not strobe_d;
            end if;
        end if;
    end process;

    ipb_out.ipb_ack   <= strobe_d;
    ipb_out.ipb_err   <= '0';
    ipb_out.ipb_rdata <= bram_data;

end rtl;
