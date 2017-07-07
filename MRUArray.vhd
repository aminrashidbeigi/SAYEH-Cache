-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MRUArray is
    port(
    address : in STD_LOGIC_VECTOR(5 downto 0);
    k : in STD_LOGIC;
    clk : in STD_LOGIC;
    enable : in STD_LOGIC;
    reset : in STD_LOGIC;
    validWay : out STD_LOGIC
    );
end MRUArray;

architecture behavioral of MRUArray is
    type dataArray is array (63 downto 0) of integer;
    signal w0Array: dataArray:= (others => 0);
    signal w1Array: dataArray:= (others => 0);
    signal integeredAddress : integer := to_integer(unsigned(address));
    signal lastWay: std_logic;
    signal lastAddress: std_logic_vector(5 downto 0);
    signal way:std_logic;
    begin
        way <= w_validNo(1) or (not w_validNo(0));
        integeredAddress <= to_integer(unsigned(address));
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
                if (way /= lastWay or address /= lastAddress) the
                    if way = '0' then
                        w0Array(integeredAddress) <= w0Array(integeredAddress) + 1;
                    elsif way = '1' then
                        w1Array(integeredAddress) <= w1Array(integeredAddress) + 1;
                    end if;
                end if;
                lastWay <= way;
                lastAddress <= address;
            end if;
            if w0Array(integeredAddress) >= w1Array(integeredAddress) then
                validWay <= '1';
            else
                validWay <= '0';
            end if;
        end if;
        end process;

end behavioral;
