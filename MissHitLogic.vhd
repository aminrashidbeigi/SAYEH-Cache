-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;

entity MissHitLogic is
    port(
    tag: IN std_logic_vector(3 downto 0);
    w0 : IN std_logic_vector(4 downto 0);
    w1 : IN std_logic_vector(4 downto 0);
    hit : OUT std_logic;
    w0_valid : OUT std_logic;
    w1_valid : OUT std_logic
    );
end MissHitLogic;

architecture rtl of MissHitLogic is
    signal w0_equal : std_logic;
    signal w1_equal : std_logic;
    begin
        w0_equal <= (w0(0) xnor tag(0)) and (w0(1) xnor tag(1)) and (w0(2) xnor tag(2)) and (w0(3) xnor tag(3));
        w1_equal <= (w1(0) xnor tag(0)) and (w1(1) xnor tag(1)) and (w1(2) xnor tag(2)) and (w1(3) xnor tag(3));
        hit <= w0_equal or w1_equal;
        w0_valid <= w0_equal and w0(4);
        w1_valid <= w1_equal and w1(4);
end rtl;
