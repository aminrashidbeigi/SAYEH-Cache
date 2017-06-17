library IEEE;
use IEEE.std_logic_1164.all;

entity orco is
    port(
    clk: IN std_logic;
    address : IN std_logic_vector(5 downto 0);
    wren : IN std_logic;
    wrdata : IN std_logic_vector(31 downto 0);
    data : OUT std_logic_vector(31 downto 0)
    );
end orco;

architecture behavioral of orco is
    type date_array is array(0 to 63) of std_logic_vector(31 downto 0);
    signal datas : date_array := (others => "0000000000000000");
    begin
        data <= date_array(to_integer(unsigned(address)));
        identifier : process(clk)
        begin
            if wren = '1' then
                date_array(to_integer(unsigned(address))) <= wrdata;
            end if;
        end process;
end behavioral;
