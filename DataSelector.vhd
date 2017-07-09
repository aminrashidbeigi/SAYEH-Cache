-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataSelector is
    port(
    clk: IN std_logic;
    is_read: IN std_logic;
    is_write : IN std_logic_vector(5 downto 0);
    memData : INOUT std_logic;
    cacheData : IN std_logic_vector(31 downto 0);
    data : OUT std_logic_vector(31 downto 0)
    );
end DataSelector;

architecture behavioral of DataSelector is
    identifier : process(clk)
    begin
        if is_write = '1' then
            data <= cacheData;
        elsif is_read = '1' then
            data <= memData;
        else
            data <= "00000000000000000000000000000000";
        end if;
    end process;
end behavioral;
