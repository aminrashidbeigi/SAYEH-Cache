-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TagValidArray is
    port(
    clk: IN std_logic;
    reset_n: IN std_logic;
    address : IN std_logic_vector(5 downto 0);
    wren : IN std_logic;
    invalidate : IN std_logic;
    wrdata : IN std_logic_vector(3 downto 0);
    data : OUT std_logic_vector(4 downto 0)
    );
end TagValidArray;

architecture behavioral of TagValidArray is
    type tag_valid_array is array(0 to 63) of std_logic_vector(4 downto 0);
    signal tag_valid : tag_valid_array := (others => "00000");
    begin
        data <= tag_valid(to_integer(unsigned(address)));
        identifier : process(clk)
        begin
            if wren = '1' then
                tag_valid(to_integer(unsigned(address)))(3 downto 0) <= wrdata;
            end if;
            if invalidate = '1' then
                tag_valid(to_integer(unsigned(address)))(4) <= not invalidate;
            end if;
        end process;
end behavioral;
