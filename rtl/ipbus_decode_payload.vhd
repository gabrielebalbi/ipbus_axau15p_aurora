-- ipbus_decode_payload
-- Auto-decoder for the payload IPBus fabric.
-- Address map (top 16 bits of 32-bit IPBus word address):
--   0x0000_xxxx  →  slave 0: acq_ctrl       (4 registers)
--   0x0001_xxxx  →  slave 1: remote_ctrl    (32 registers)
--   0x1000_xxxx  →  slave 2: bram_readout   (up to 16 K words)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

package ipbus_decode_payload is

    constant N_SLAVES     : integer := 3;
    constant IPBUS_SEL_WIDTH : integer := 2;

    constant N_SLV_ACQ_CTRL    : integer := 0;
    constant N_SLV_REMOTE_CTRL : integer := 1;
    constant N_SLV_BRAM_RDOUT  : integer := 2;

    function ipbus_sel_payload(addr : std_logic_vector(31 downto 0))
        return std_logic_vector;

end ipbus_decode_payload;

package body ipbus_decode_payload is

    function ipbus_sel_payload(addr : std_logic_vector(31 downto 0))
        return std_logic_vector is
        variable sel : std_logic_vector(IPBUS_SEL_WIDTH - 1 downto 0);
    begin
        sel := (others => '0');
        -- Top-of-range decode on bits [28:12]
        if    addr(28 downto 16) = "0000000000000" then
            sel := std_logic_vector(to_unsigned(N_SLV_ACQ_CTRL,    IPBUS_SEL_WIDTH));
        elsif addr(28 downto 16) = "0000000000001" then
            sel := std_logic_vector(to_unsigned(N_SLV_REMOTE_CTRL, IPBUS_SEL_WIDTH));
        elsif addr(28 downto 16) = "0001000000000" then  -- 0x1000_xxxx
            sel := std_logic_vector(to_unsigned(N_SLV_BRAM_RDOUT,  IPBUS_SEL_WIDTH));
        end if;
        return sel;
    end function;

end ipbus_decode_payload;
