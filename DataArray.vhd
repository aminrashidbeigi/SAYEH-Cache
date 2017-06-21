-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataArray is
    port(
    clk: IN std_logic;
    address : IN std_logic_vector(5 downto 0);
    wren : IN std_logic;
    wrdata : IN std_logic_vector(31 downto 0);
    data : OUT std_logic_vector(31 downto 0)
    );
end DataArray;

architecture behavioral of DataArray is
    type data_array is array(0 to 63) of std_logic_vector(31 downto 0);
    signal datas : data_array := (others => "00000000000000000000000000000000");
    begin
        data <= datas(to_integer(unsigned(address)));
        identifier : process(clk)
        begin
            if wren = '1' then
                datas(to_integer(unsigned(address))) <= wrdata;
            end if;
        end process;
end behavioral;
