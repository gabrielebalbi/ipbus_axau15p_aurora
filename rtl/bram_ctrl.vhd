-- bram_ctrl
-- True dual-port BRAM: write port in aurora_user_clk domain,
-- read port in ipb_clk domain.
-- Uses Xilinx XPM_MEMORY_TDPRAM (UltraScale+).

library ieee;
use ieee.std_logic_1164.all;
library xpm;
use xpm.vcomponents.all;

entity bram_ctrl is
    generic(
        DEPTH_LOG2 : integer := 14  -- 2^14 = 16 K × 32-bit words
    );
    port(
        -- Write port (Aurora clock domain)
        wclk   : in  std_logic;
        waddr  : in  std_logic_vector(DEPTH_LOG2 - 1 downto 0);
        wdata  : in  std_logic_vector(31 downto 0);
        we     : in  std_logic;
        wfull  : out std_logic;

        -- Read port (IPBus clock domain, 1-cycle latency)
        rclk   : in  std_logic;
        raddr  : in  std_logic_vector(DEPTH_LOG2 - 1 downto 0);
        rdata  : out std_logic_vector(31 downto 0)
    );
end bram_ctrl;

architecture rtl of bram_ctrl is

    -- wfull: asserted when write pointer reaches top of buffer
    signal waddr_top : std_logic;

begin

    waddr_top <= '1' when waddr = (waddr'range => '1') else '0';
    wfull     <= waddr_top;

    -- True dual-port RAM, independent clocks, write-first mode
    mem : xpm_memory_tdpram
        generic map(
            MEMORY_SIZE        => 32 * (2 ** DEPTH_LOG2),  -- total bits
            MEMORY_PRIMITIVE   => "block",
            CLOCKING_MODE      => "independent_clock",
            MEMORY_INIT_PARAM  => "0",
            USE_MEM_INIT       => 0,
            WAKEUP_TIME        => "disable_sleep",
            AUTO_SLEEP_TIME    => 0,
            -- Port A (write)
            WRITE_DATA_WIDTH_A => 32,
            READ_DATA_WIDTH_A  => 32,
            ADDR_WIDTH_A       => DEPTH_LOG2,
            WRITE_MODE_A       => "write_first",
            READ_LATENCY_A     => 1,
            -- Port B (read)
            WRITE_DATA_WIDTH_B => 32,
            READ_DATA_WIDTH_B  => 32,
            ADDR_WIDTH_B       => DEPTH_LOG2,
            WRITE_MODE_B       => "read_first",
            READ_LATENCY_B     => 1,
            RST_MODE_A         => "SYNC",
            RST_MODE_B         => "SYNC"
        )
        port map(
            -- Port A: write (Aurora clock)
            clka   => wclk,
            addra  => waddr,
            dina   => wdata,
            wea(0) => we,
            ena    => '1',
            rsta   => '0',
            douta  => open,
            regcea => '0',
            -- Port B: read (IPBus clock)
            clkb   => rclk,
            addrb  => raddr,
            dinb   => (others => '0'),
            web(0) => '0',
            enb    => '1',
            rstb   => '0',
            doutb  => rdata,
            regceb => '1',
            -- Unused
            injectdbiterra => '0',
            injectsbiterra => '0',
            injectdbiterrb => '0',
            injectsbiterrb => '0',
            sbiterra       => open,
            dbiterra       => open,
            sbiterrb       => open,
            dbiterrb       => open,
            sleep          => '0'
        );

end rtl;
