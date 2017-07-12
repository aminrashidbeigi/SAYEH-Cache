-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CacheController is
    port(
    clk: IN std_logic;
    hit: IN std_logic;
    w0_valid : IN std_logic;
    w1_valid : IN std_logic;
    is_read: in std_logic;
    is_write: in std_logic;
    cache_data_ready : IN std_logic;
    mem_data_ready : IN std_logic;
    tva0valid : in std_logic;
    tva1valid : in std_logic;
    invalidate0 : out std_logic;
    invalidate1 : out std_logic;
    write_mem: OUT std_logic;
    read_mem : OUT std_logic;
    data_array0_enable: OUT std_logic;
    data_array1_enable: OUT std_logic;
    tag_valid0_enable: OUT std_logic;
    tag_valid1_enable: OUT std_logic;
    reset_n0: OUT std_logic;
    reset_n1: OUT std_logic;
    MRUEnable: OUT std_logic;
    MRUReset : OUT std_logic;
    MRUWay : in std_logic
    );
end CacheController;

architecture behavioral of CacheController is

    type state is (reset_state, initial_state, read_state, write_state, glitch_state, read_from_mem_state, write_to_cache_state);
    signal current_state, next_state : state := initial_state;
    signal which_way : std_logic := '0';

    begin
        process( clk )
	    begin
		   if rising_edge(clk) then
               current_state <= next_state;
           end if;
       end process;

       process(clk)
       begin
            invalidate0 <= '0';
            invalidate1 <= '0';
            data_array0_enable <= '0';
            data_array1_enable <= '0';
            tag_valid0_enable <= '0';
            tag_valid1_enable <= '0';
            write_mem <= '0';
            read_mem <= '0';
            reset_n0 <= '0';
            reset_n1 <= '0';
            MRUEnable <= '0';
            MRUReset <= '0';

            case(current_state) is
                when reset_state =>
                    next_state <= initial_state;

                when initial_state =>
                    if (is_read = '1') then
                        next_state <= read_state;
                    elsif (is_write = '1') then
                        write_mem <= '1';
                        next_state <= write_state;
                    end if;

                when read_state =>
                    if hit = '1' then
                        MRUEnable <= '1';
                        next_state <= reset_state;
                    else
                        read_mem <= '1';
                        next_state <= read_from_mem_state;
                    end if;

                when write_state =>
                    write_mem <= '1';
                    if w0_valid = '1' then
                        invalidate0 <= '1';
                        tag_valid0_enable <= '1';
                    end if;
                    if w1_valid = '1' then
                        invalidate1 <= '1';
                        tag_valid1_enable <= '1';
                    end if;
                    next_state <= reset_state;

                when read_from_mem_state =>
                    read_mem <= '1';
                    next_state <= glitch_state;

                when glitch_state =>
                    read_mem <= '1';
                    next_state <= write_to_cache_state;

                when write_to_cache_state =>
                    if tva0valid = '0' then
                        data_array0_enable <= '1';
                        tag_valid0_enable <= '1';
                        invalidate0 <= '0';
                    elsif tva1valid = '0' then
                        data_array1_enable <= '1';
                        tag_valid1_enable <= '1';
                        invalidate1 <= '0';
                    elsif MRUWay = '1' then
                        data_array1_enable <= '1';
                        tag_valid1_enable <= '1';
                        invalidate1 <= '0';
                    elsif MRUWay = '0' then
                        data_array0_enable <= '1';
                        tag_valid0_enable <= '1';
                        invalidate0 <= '0';
                    end if;
                    next_state <= reset_state;

                when others =>
                    next_state <= reset_state;
            end case;
        end process;
end behavioral;
