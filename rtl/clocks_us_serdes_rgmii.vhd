-- clocks_us_serdes_rgmii
-- Clock management for AXAU15 (RGMII variant, adapted from ipbus-firmware).
-- Input: 200 MHz free-running crystal clock.
-- VCO = 1000 MHz (200 × 5).
-- Outputs:
--   clko_ipb  = 31.25 MHz  (IPBus fabric clock)
--   clko_aux  = CLK_AUX_FREQ MHz (configurable, default 40 MHz)
--   clko_125  = 125 MHz    (RGMII TEMAC + GTX clock)
--   clko_200  = 200 MHz    (IDELAYCTRL reference)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.VComponents.all;
use work.ipbus_clock_div;   -- from ipbus-firmware

entity clocks_us_serdes_rgmii is
    generic(
        CLK_FR_FREQ  : real := 200.0;
        CLK_AUX_FREQ : real := 40.0
    );
    port(
        clki_fr       : in  std_logic;
        clko_ipb      : out std_logic;
        clko_aux      : out std_logic;
        clko_125      : out std_logic;
        clko_200      : out std_logic;
        clko_333      : out std_logic;   -- 333.333 MHz for TEMAC IDELAYCTRL
        eth_locked    : in  std_logic;
        locked        : out std_logic;
        nuke          : in  std_logic;
        soft_rst      : in  std_logic;
        rsto_125      : out std_logic;
        rsto_ipb      : out std_logic;
        rsto_eth      : out std_logic;
        rsto_ipb_ctrl : out std_logic;
        rsto_aux      : out std_logic;
        onehz         : out std_logic
    );
end clocks_us_serdes_rgmii;

architecture rtl of clocks_us_serdes_rgmii is

    constant CLK_VCO : real := 1000.0;

    signal clkfb                           : std_logic;
    signal dcm_locked                      : std_logic;
    signal clk_ipb_i, clk_aux_i           : std_logic;
    signal clk125_i, clk200_i, clk333_i   : std_logic;
    signal clk_ipb_b, clk_aux_b           : std_logic;
    signal clk125_b, clk200_b, clk333_b   : std_logic;
    signal d17, d17_d                      : std_logic;
    signal nuke_i, nuke_d, nuke_d2        : std_logic := '0';
    signal eth_done, rst, srst            : std_logic := '0';
    signal rst_ipb_i, rst_125_i           : std_logic := '1';
    signal rst_aux_i, rst_ipb_ctrl_i      : std_logic := '1';
    signal rctr                            : unsigned(3 downto 0) := (others => '0');

begin

    -- MMCM: 200 MHz → 31.25, aux, 125, 200
    mmcm : MMCME3_BASE
        generic map(
            CLKIN1_PERIOD     => 1000.0 / CLK_FR_FREQ,
            CLKFBOUT_MULT_F   => CLK_VCO / CLK_FR_FREQ,  -- 5.0
            CLKOUT0_DIVIDE_F  => CLK_VCO / 333.333,       -- 3.0 → 333.333 MHz
            CLKOUT1_DIVIDE    => integer(CLK_VCO / 31.25),   -- 32
            CLKOUT2_DIVIDE    => integer(CLK_VCO / CLK_AUX_FREQ),
            CLKOUT3_DIVIDE    => integer(CLK_VCO / 125.0),   -- 8
            CLKOUT4_DIVIDE    => integer(CLK_VCO / 200.0)    -- 5
        )
        port map(
            CLKIN1   => clki_fr,
            CLKFBIN  => clkfb,
            CLKFBOUT => clkfb,
            CLKOUT0  => clk333_i,
            CLKOUT1  => clk_ipb_i,
            CLKOUT2  => clk_aux_i,
            CLKOUT3  => clk125_i,
            CLKOUT4  => clk200_i,
            LOCKED   => dcm_locked,
            RST      => '0',
            PWRDWN   => '0'
        );

    bufg_ipb : BUFG port map(i => clk_ipb_i, o => clk_ipb_b);
    bufg_aux : BUFG port map(i => clk_aux_i,  o => clk_aux_b);
    bufg_125 : BUFG port map(i => clk125_i,   o => clk125_b);
    bufg_200 : BUFG port map(i => clk200_i,   o => clk200_b);
    bufg_333 : BUFG port map(i => clk333_i,   o => clk333_b);

    clko_ipb <= clk_ipb_b;
    clko_aux <= clk_aux_b;
    clko_125 <= clk125_b;
    clko_200 <= clk200_b;
    clko_333 <= clk333_b;
    locked   <= dcm_locked;

    -- 1 Hz blinker and ~1 ms soft-reset timing
    clkdiv : entity work.ipbus_clock_div
        port map(clk => clki_fr, d17 => d17, d28 => onehz);

    process(clki_fr)
    begin
        if rising_edge(clki_fr) then
            d17_d <= d17;
            if d17 = '1' and d17_d = '0' then
                rst      <= nuke_d2 or not dcm_locked;
                nuke_d   <= nuke_i;
                nuke_d2  <= nuke_d;
                eth_done <= (eth_done or eth_locked) and not rst;
                rsto_eth <= rst;
            end if;
        end if;
    end process;

    srst <= '1' when rctr /= "0000" else '0';

    process(clk_ipb_b)
    begin
        if rising_edge(clk_ipb_b) then
            rst_ipb_i <= rst or srst;
            nuke_i    <= nuke;
            if srst = '1' or soft_rst = '1' then
                rctr <= rctr + 1;
            end if;
        end if;
    end process;

    rsto_ipb <= rst_ipb_i;

    process(clk_ipb_b)
    begin
        if rising_edge(clk_ipb_b) then
            rst_ipb_ctrl_i <= rst;
        end if;
    end process;

    rsto_ipb_ctrl <= rst_ipb_ctrl_i;

    process(clk125_b)
    begin
        if rising_edge(clk125_b) then
            rst_125_i <= rst or not eth_done;
        end if;
    end process;

    rsto_125 <= rst_125_i;

    process(clk_aux_b)
    begin
        if rising_edge(clk_aux_b) then
            rst_aux_i <= rst;
        end if;
    end process;

    rsto_aux <= rst_aux_i;

end rtl;
