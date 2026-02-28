library ieee;
use ieee.std_logic_1164.all;

entity Key_Decode IS
	port(	
		Kack, Tdelay, RESET, CLK  	: in std_logic;
		Kval								: out std_logic;
		K 									: out std_logic_vector(3 downto 0);
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
	);
end Key_Decode;

architecture logicFunction of Key_Decode is
	component Key_Control
	port( 
		Kack, Kpress, Tdelay, RESET, CLK  	: in std_logic;
		Kval, Kscan									: out std_logic
	);
	end component;
	
	component Key_Scan
	port( 
		Kscan, CLK, RESET	: in std_logic; 
		Keys_Vertical 		: out std_logic_vector(3 downto 0);
		Keys_Horizontal	: in std_logic_vector(3 downto 0);
		K						: out std_logic_vector(3 downto 0);
		Kpress				: out std_logic
	);
	end component;
	
	signal Kpress, Kscan : std_logic;
	
begin
	
	scan: Key_Scan port map (
		RESET 			=> RESET,
		CLK 				=> CLK,
		Kpress 			=> Kpress,
		K 					=> K,
		Kscan				=> Kscan,
		Keys_Vertical 	=> Keys_Vertical,
		Keys_Horizontal=> Keys_Horizontal
	);

	control: Key_Control port map (
		RESET 			=> RESET,
		CLK 				=> CLK,
		Kpress 			=> Kpress,
		Kack 				=> Kack,
		Tdelay 			=> Tdelay,
		Kval				=> Kval,
		Kscan				=> Kscan
	);
end LogicFunction;