--------------------------------------------------------------------------------
-- Author:        Parham Alvani (parham.alvani@gmail.com)
--
-- Create Date:   16-03-2017
-- Module Name:   memory.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	generic (blocksize : integer := 1024);
	port(
	clk, readmem, writemem : in std_logic;
	addressbus: in std_logic_vector (9 downto 0);
	input : in std_logic_vector (31 downto 0);
	output : out std_logic_vector (31 downto 0);
	memdataready : out std_logic
	);
end entity memory;

architecture behavioral of memory is
	type mem is array (0 to blocksize - 1) of std_logic_vector (31 downto 0);
begin
	process (clk)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then

			init := false;
		end if;

		--databus <= (others => 'Z');
		--memdataready <= '0';

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then -- Readiing :)
				memdataready <= '1';
				if ad >= blocksize then
					output <= (others => 'Z');
				else
					output <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				memdataready <= '1';
				if ad < blocksize then
					buffermem(ad) := input;
				end if;
			else
			  memdataready <= '0';
			end if;
		end if;
	end process;
end architecture behavioral;
