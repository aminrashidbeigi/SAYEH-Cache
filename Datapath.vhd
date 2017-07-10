-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Datapath is
    port(
    clk: in std_logic;
    is_read: in std_logic;
    is_write: in std_logic;
    inData: in std_logic_vector(31 downto 0);
    address: in std_logic_vector(9 downto 0);
    data: out std_logic_vector(31 downto 0)
	 );
end Datapath;

architecture behavioral of Datapath is

    component Decoder_2bits is
        port (
        input: in std_logic;
        control: in std_logic;
        output: out std_logic_vector(1 downto 0)
        );
    end component;

    component DataArray is
        port(
        clk: IN std_logic;
        address : IN std_logic_vector(5 downto 0);
        wren : IN std_logic;
        wrdata : IN std_logic_vector(31 downto 0);
        data : OUT std_logic_vector(31 downto 0)
        );
    end component;

    component TagValidArray is
        port(
        clk: IN std_logic;
        reset_n: IN std_logic;
        address : IN std_logic_vector(5 downto 0);
        wren : IN std_logic;
        invalidate : IN std_logic;
        wrdata : IN std_logic_vector(3 downto 0);
        data : OUT std_logic_vector(4 downto 0)
        );
    end component;

    component MissHitLogic is
        port(
        tag: IN std_logic_vector(3 downto 0);
        w0 : IN std_logic_vector(4 downto 0);
        w1 : IN std_logic_vector(4 downto 0);
        hit : OUT std_logic;
        w0_valid : OUT std_logic;
        w1_valid : OUT std_logic
        );
    end component;

    component CacheController is
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
        wren0: OUT std_logic;
        wren1: OUT std_logic;
        reset_n0: OUT std_logic;
        reset_n1: OUT std_logic;
        MRUEnable: OUT std_logic;
        MRUReset : OUT std_logic;
        MRUWay : in std_logic
        );
    end component;


    component memory is
    	generic (blocksize : integer := 1024);

    	port (clk, readmem, writemem : in std_logic;
    		addressbus: in std_logic_vector (9 downto 0);
    		input : in std_logic_vector (31 downto 0);
    		output : out std_logic_vector (31 downto 0);
    		memdataready : out std_logic);
    end component;

	component MRUArray is

    port(
    clk: in std_logic;
    index: in std_logic_vector(5 downto 0);
    w0_valid: in std_logic;
    w1_valid: in std_logic;
    enable: in std_logic;
    reset: in std_logic;
    validWay: out std_logic
);
	end component;

    component DataSelector is
        port(
        clk: IN std_logic;
        is_read: IN std_logic;
        is_write : IN std_logic;
        memData : IN std_logic_vector(31 downto 0);
        cacheData : IN std_logic_vector(31 downto 0);
        data : OUT std_logic_vector(31 downto 0)
        );
    end component;

    signal tag : std_logic_vector(3 downto 0);
    signal index : std_logic_vector(5 downto 0);
    signal input_data : std_logic_vector(31 downto 0);
    signal data_array_out_data1, data_array_out_data2 : std_logic_vector(31 downto 0);
    signal tag_valid_out1 : std_logic_vector(4 downto 0);
    signal tag_valid_out2 : std_logic_vector(4 downto 0);
    signal reset_n, invalidate, w0_valid, w1_valid, way, MRUEnable, MRUReset, hit, read_mem,
     mem_data_ready, mem_wren,wren0, wren1, reset_n0, reset_n1, invalidate0, invalidate1, cache_data_ready: std_logic;
    signal mem_out : std_logic_vector(31 downto 0);


	begin

	tag <= address(9 downto 6);
    index <= address(5 downto 0);
	 cache_data_ready <= '1';

    DataArray_module1 : DataArray port map (clk, index, wren0, input_data, data_array_out_data1);
    DataArray_module2 : DataArray port map (clk, index, wren1, input_data, data_array_out_data2);

    TagValidArray_module1 : TagValidArray port map (clk, reset_n0, index, wren0, invalidate0, tag, tag_valid_out1);
    TagValidArray_module2 : TagValidArray port map (clk, reset_n1, index, wren1, invalidate1, tag, tag_valid_out2);

    MissHitLogic_module : MissHitLogic port map(tag, tag_valid_out1, tag_valid_out2, hit, w0_valid, w1_valid);
    memory_module : memory port map (clk, is_read, is_write, address, inData, mem_out, mem_data_ready);
    MRUArray_module : MRUArray port map (clk, index, w0_valid, w0_valid, MRUEnable, MRUReset, way);
    CacheController_module : CacheController port map(clk, hit, w0_valid, w1_valid, is_read, is_write, cache_data_ready, mem_data_ready,
        tag_valid_out1(4), tag_valid_out2(4), invalidate0, invalidate1, mem_wren, read_mem, wren0, wren1,reset_n0, reset_n1,
        MRUEnable, MRUReset, way);
    DataSelector_module : DataSelector port map(clk, is_read, is_write, mem_out, inData, input_data);

    CacheDataSelection : process(clk)
    begin
        if rising_edge(clk) then
            if hit = '1' then
                if w0_valid = '1' then
                    data <= data_array_out_data1;
                elsif w1_valid = '1' then
                    data <= data_array_out_data2;
                end if;
            else
                data <= mem_out;
				end if;
        end if;
    end process;

end behavioral;
