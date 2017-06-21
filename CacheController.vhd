-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CacheController is
    port(
    clk: IN std_logic;
    hit: IN std_logic;
    w0_valid: IN std_logic;
    w1_valid: IN std_logic;
    read_mem : IN std_logic;
    write_mem : IN std_logic;
    chache_data_ready : IN std_logic;
    mem_data_ready : IN std_logic;
    reset_n: OUT std_logic;
    wren0: OUT std_logic;
    wren1: OUT std_logic;
    mem_wren: OUT std_logic;
    invalidate: OUT std_logic
    );
end CacheController;

architecture behavioral of CacheController is

    type state is (initial_state, read_state, write_state);
    signal current_state : state := initial_state;

    begin
        process(clk)
        begin
            reset_n <= '0';
            wren0 <= '0';
            wren1 <= '0';
            invalidate <= '0';

            case( current_state ) is

                when initial_state =>
                    if (read_mem = '1') then
                        if hit = '1' then
                            current_state <= read_state;
                        else
                            current_state <= write_state;
						end if;
                    elsif (write_mem = '1') then
                        mem_wren <= '1';
                        if hit = '1' then
                            invalidate <= '1';
                        end if;
                        current_state <= initial_state;
                    end if;

                when read_state =>
                    chache_data_ready <= '1';
                    current_state <= initial_state;

                when write_state =>
                    if w0_valid = '1' then
                        wren0 <= '1';
                    elsif w1_valid = '1' then
                        wren0 <= '1';
                    end if;
                    invalidate <= '1';
                    current_state <= write_state;

                when others =>
                    reset_n <= '0';
                    wren0 <= '0';
                    wren1 <= '0';
                    invalidate <= '0';

            end case;
        end process;

end behavioral;
