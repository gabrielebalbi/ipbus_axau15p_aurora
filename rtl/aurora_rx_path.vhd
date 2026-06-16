-- aurora_rx_path
-- Receives 64-bit AXI4-Stream frames from Aurora 64B/66B and writes
-- 32-bit words into the BRAM write port.
-- Runs in aurora_user_clk domain.
-- Acquisition controlled by 1-cycle pulses from IPBus clock domain
-- (acq_start / acq_stop are already CDC-synchronised by acq_ctrl_slave).

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aurora_rx_path is
    generic(
        BRAM_DEPTH_LOG2 : integer := 14  -- 16 K words = 64 KB
    );
    port(
        clk        : in  std_logic;  -- aurora_user_clk
        rst        : in  std_logic;

        -- Aurora RX AXI4-Stream (64-bit)
        rx_tdata   : in  std_logic_vector(63 downto 0);
        rx_tvalid  : in  std_logic;
        rx_tkeep   : in  std_logic_vector(7 downto 0);
        rx_tlast   : in  std_logic;

        -- BRAM write port
        wr_addr    : out std_logic_vector(BRAM_DEPTH_LOG2 - 1 downto 0);
        wr_data    : out std_logic_vector(31 downto 0);
        wr_en      : out std_logic;
        wr_full    : in  std_logic;

        -- Acquisition control (CDC-synchronised pulses from ipb_clk domain)
        acq_start  : in  std_logic;
        acq_stop   : in  std_logic;
        acq_running: out std_logic;
        acq_words  : out std_logic_vector(31 downto 0)
    );
end aurora_rx_path;

architecture rtl of aurora_rx_path is

    type state_t is (IDLE, RUNNING, FULL);
    signal state : state_t := IDLE;

    signal wptr     : unsigned(BRAM_DEPTH_LOG2 - 1 downto 0) := (others => '0');
    signal word_ctr : unsigned(31 downto 0)                  := (others => '0');

    -- Alternate between the two 32-bit halves of each 64-bit Aurora beat
    signal hi_word  : std_logic_vector(31 downto 0);
    signal beat_hi  : std_logic := '0';  -- 0 = write low half, 1 = write high half

begin

    acq_running <= '1' when state = RUNNING else '0';
    acq_words   <= std_logic_vector(word_ctr);
    wr_addr     <= std_logic_vector(wptr);

    -- Split each 64-bit Aurora beat into two 32-bit BRAM words
    -- (MSB first: beat_hi=0 → bits[31:0], beat_hi=1 → bits[63:32])
    process(clk)
    begin
        if rising_edge(clk) then
            wr_en <= '0';

            if rst = '1' then
                state    <= IDLE;
                wptr     <= (others => '0');
                word_ctr <= (others => '0');
                beat_hi  <= '0';

            else
                case state is

                    when IDLE =>
                        beat_hi  <= '0';
                        wptr     <= (others => '0');
                        word_ctr <= (others => '0');
                        if acq_start = '1' then
                            state <= RUNNING;
                        end if;

                    when RUNNING =>
                        if acq_stop = '1' then
                            state <= IDLE;

                        elsif rx_tvalid = '1' then
                            if wr_full = '1' then
                                state <= FULL;
                            else
                                if beat_hi = '0' then
                                    -- Write low 32 bits
                                    wr_data <= rx_tdata(31 downto 0);
                                    wr_en   <= '1';
                                    wptr     <= wptr + 1;
                                    word_ctr <= word_ctr + 1;
                                    hi_word  <= rx_tdata(63 downto 32);
                                    beat_hi  <= '1';
                                else
                                    -- Write high 32 bits (stored in hi_word)
                                    wr_data <= hi_word;
                                    wr_en   <= '1';
                                    wptr     <= wptr + 1;
                                    word_ctr <= word_ctr + 1;
                                    beat_hi  <= '0';
                                end if;
                            end if;
                        end if;

                    when FULL =>
                        -- Buffer full; hold state until next acq_start cycle
                        if acq_stop = '1' then
                            state <= IDLE;
                        end if;

                end case;
            end if;
        end if;
    end process;

    -- hi_word latch (only needs one register, not in the process above)
    -- Actually it IS in the process — no duplicate needed.

end rtl;
