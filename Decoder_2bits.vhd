-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder_2bits is
    port (
    input: in std_logic;
    control: in std_logic;
    output: out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of Decoder_2bits is
begin
    output(0) <= (not control) and input;
    output(1) <= control and input;
end architecture;
