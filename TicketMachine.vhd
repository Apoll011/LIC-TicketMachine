LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(	
		Kack, Tdelay, RESET, CLK  	: in std_logic;
		Kval								: out std_logic;
		K 									: out std_logic_vector(3 downto 0);
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
	);
end TicketMachine;

architecture logicFunction of TicketMachine is
	component Key_Decode
	port( 
		Kack, Tdelay, RESET, CLK  	: in std_logic;
		Kval								: out std_logic;
		K 									: out std_logic_vector(3 downto 0);
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
	);
	end component;
begin
	decode: Key_Decode port map (
		Kack => Kack,
		Tdelay => Tdelay,
		RESET => RESET,
		CLK => CLK,
		Kval => Kval,
		K => K,
		Keys_Vertical => Keys_Vertical,
		Keys_Horizontal => Keys_Horizontal
	);
end logicFunction;