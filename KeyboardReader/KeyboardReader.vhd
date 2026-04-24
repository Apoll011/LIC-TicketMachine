library ieee;
use ieee.std_logic_1164.all;

entity KeyboardReader is
    port (
        RESET, CLK 		 : in  std_logic;
        Tdelay           : in  std_logic_vector(1 downto 0);
        Keys_Vertical    : out std_logic_vector(3 downto 0);
        Keys_Horizontal  : in  std_logic_vector(3 downto 0);
		  
		  TXclk  : in  std_logic;
        TXD    : out std_logic
    );
end entity KeyboardReader;

architecture logicFunction of KeyboardReader is
	component Key_Decode is
    port (
        Kack, RESET, CLK : in  std_logic;
        Tdelay           : in  std_logic_vector(1 downto 0);
        Kval		       : out std_logic;
        K                : out std_logic_vector(3 downto 0);
        Keys_Vertical    : out std_logic_vector(3 downto 0);
        Keys_Horizontal  : in  std_logic_vector(3 downto 0)
    );
	end component;
	
	component KeyTransmitter is
    port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;

        DataIn : in  std_logic_vector(3 downto 0);
        Load   : in  std_logic;
        KBfree : out std_logic;

        TXclk  : in  std_logic;
        TXD    : out std_logic
    );
	end component;
	
	signal load, d : std_logic;
	signal data_In : std_logic_vector(3 downto 0);
begin
    decode: Key_Decode port map (
		  RESET          	=> RESET,
        CLK             => CLK,
        Kack            => d,				--- test
        Tdelay          => Tdelay,
        Kval            => load,			--- test
        K               => data_In, 	--- test
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal
	 );
	 
	 transmiter: KeyTransmitter port map (
		  RESET  => RESET,
        CLK		=> CLK,
		  TXclk	=> TXclk,
		  TXD		=> TXD,
		  
		  DataIn	=> data_In,
		  Load 	=> load,
		  KBfree => d
	);
end architecture logicFunction;
