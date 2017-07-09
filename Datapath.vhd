-- @author : Amin Rashidbeigi

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Datapath is
    port(
    clk: in std_logic;
    read_signal: in std_logic;
    write_signal: in std_logic;
    writeData: in std_logic_vector(31 downto 0);
    address: in std_logic_vector(9 downto 0);
    data: out std_logic_vector(31 downto 0)
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
    end component;

    component memory
        port (
        clk,
        readmem,
        writemem : in std_logic;
        addressbus: in std_logic_vector (15 downto 0);
        databus : inout std_logic_vector (15 downto 0);
        memdataready : out std_logic
        );
    end component;

    component MRUArray is
        port(
        address : in STD_LOGIC_VECTOR(5 downto 0);
        k : in STD_LOGIC;
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        validWay : out STD_LOGIC
        );
    end component;


    signal tag : std_logic_vector(3 downto 0);
    signal index : std_logic_vector(5 downto 0);
    signal input_data : std_logic_vector(31 downto 0);
    signal data_array_out_data1, data_array_out_data2 : std_logic_vector(31 downto 0);
    signal reset_n, wren, invalidate : std_logic;
    signal tag_valid_out1 : std_logic_vector(4 downto 0);
    signal tag_valid_out2 : std_logic_vector(4 downto 0);
    signal reset_ns, wrens, invalidates, w_valids: std_logic_vector(1 downto 0);
    signal reset_n, wren, invalidate, w_valid, way, MRUEnable, MRUReset, hit, is_write, is_read,cache_data_ready,
     mem_data_ready, mem_wren,cache_wren: std_logic;

    decoder_2bits_resetn_module : decoder_2bits port map (reset_n, way, reset_ns);
    decoder_2bits_wren_module : decoder_2bits port map (wren, way, wrens);

    DataArray_module : DataArray port map (clk, index, wrens(0), input_data, data_array_out_data1);
    DataArray_module : DataArray port map (clk, index, wrens(1), input_data, data_array_out_data2);

    TagValidArray_module1 : TagValidArray port map (clk, reset_ns(0), index, wrens(0), invalidates(0), tag, tag_valid_out1);
    TagValidArray_module2 : TagValidArray port map (clk, reset_ns(1), index, wrens(1), invalidates(1), tag, tag_valid_out2);

    MissHitLogic_module : MissHitLogic port map(tag, tag_valid_out1, tag_valid_out2, hit, w_valids(0), w_valids(1));
    memory_module : memory port map ();
    MRUArray_module : MRUArray port map(clk, index, w_valids, MRUEnable, MRUReset, way);
    CacheController_module : CacheController port map(clk, hit, w_valids, is_read, is_write, cache_data_ready, mem_data_ready, mem_wren, reset_n, cache_wren,invalidate,MRUEnable, MRUReset);


end behavioral;
