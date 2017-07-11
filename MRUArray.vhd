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
    signal way: std_logic;
    begin
        integeredAddress <= to_integer(unsigned(index));
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    if w0_valid = '1' then
                        w0Array(integeredAddress)<=0;
                    elsif w1_valid = '1' then
                        w1Array(integeredAddress)<=0;
                    end if;
                elsif enable = '1' then
                    if w0_valid = '1' then
                        w0Array(integeredAddress) <= w0Array(integeredAddress) + 1;
                    elsif w1_valid = '1' then
                        w1Array(integeredAddress) <= w1Array(integeredAddress) + 1;
                    end if;
                end if;

                if w0Array(integeredAddress) >= w1Array(integeredAddress) then
                    validWay <= '0';
                else
                    validWay <= '1';
                end if;
            end if;
        end process;

end behavioral;
