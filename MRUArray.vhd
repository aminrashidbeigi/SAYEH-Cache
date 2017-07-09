-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MRUArray is
    port(
    clk: in std_logic;
    index: in std_logic_vector(5 downto 0);
    w0_valid: in std_logic;
    w1_valid: in std_logic;
    enable: in std_logic;
    reset: in std_logic;
    validWay: out std_logic
);
end MRUArray;

architecture behavioral of MRUArray is
    type dataArray is array (63 downto 0) of integer;
    signal w0Array: dataArray:= (others => 0);
    signal w1Array: dataArray:= (others => 0);
    signal integeredAddress: integer := to_integer(unsigned(index));
    signal lastWay: std_logic;
    signal lastAddress: std_logic_vector(5 downto 0);
    signal way: std_logic;
    begin
        way <= w1_valid or (not w0_valid);
        integeredAddress <= to_integer(unsigned(index));
        process(clk)
        begin
            if rising_edge(clk) then
            if reset = '1' then
                if way = '0' then
                    w0Array(integeredAddress)<=0;
                else
                    w1Array(integeredAddress)<=0;
                end if;
                lastWay <= 'Z';
                lastAddress <= "ZZZZZZ";
            elsif enable = '1' then
                if (way /= lastWay or index /= lastAddress) then
                    if way = '0' then
                        w0Array(integeredAddress) <= w0Array(integeredAddress) + 1;
                    elsif way = '1' then
                        w1Array(integeredAddress) <= w1Array(integeredAddress) + 1;
                    end if;
                end if;
                lastWay <= way;
                lastAddress <= index;
            end if;
            if w0Array(integeredAddress) >= w1Array(integeredAddress) then
                validWay <= '1';
            else
                validWay <= '0';
            end if;
        end if;
        end process;

end behavioral;
