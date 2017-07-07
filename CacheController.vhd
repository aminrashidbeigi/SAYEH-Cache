-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CacheController is
    port(
    clk: IN std_logic;
    hit: IN std_logic;
    validWay: IN std_logic_vector(1 downto 0);
    is_read: in std_logic;
    is_write: in std_logic;
    chache_data_ready : IN std_logic;
    mem_data_ready : IN std_logic;
    mem_wren: OUT std_logic;
    reset_n: OUT std_logic;
    cache_wren: OUT std_logic;
    invalidate: OUT std_logic;
    MRUEnable: OUT std_logic;
    MRUReset : OUT std_logic
    );
end CacheController;

architecture behavioral of CacheController is

    type state is (initial_state, read_state, write_state);
    signal current_state, next_state : state := initial_state;

    begin
        process( clk )
	    begin
		   if rising_edge(clk) then
               state <= next_state;
           end if;
       end process;

       process(clk)
       begin
            cache_wren <= '0';
            invalidate <= '0';
            mem_wren <= '0';
            reset_n <= '0';
            MRUEnable <= '1';
            MRUReset <= '0';

            case( current_state ) is
                when initial_state =>
                    if (is_read) then
                        if chache_data_ready = '1' then
                            if hit = '0' then
                                cache_wren <= '1';
                            end if;
                            if validWay(0) and validWay(0) = '0'  then
                                invalidate <= '1';
                            end if;
                            current_state <= read_state;
                        end if;
                    elsif (is_write) then
                        mem_wren <= '1';
                        cache_wren <= '1';
                        if validWay(0) and validWay(0) = '0'  then
                            invalidate <= '1';
                        end if;
                        current_state <= write_state;
                    end if;

                when read_state =>
                    next_state <= initial_state;
                when write_state =>
                    mem_wren <= '1';
                    next_state <= initial_state;
                when others =>
                    next_state <= initial_state;
            end case;
        end process;
end behavioral;
