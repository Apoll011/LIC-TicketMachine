library ieee;
use ieee.std_logic_1164.all;

entity Key_Control IS
	port(	
		Kack, Kpress, Tdelay, RESET, CLK  	: in std_logic;
		Kval, Kscan									: out std_logic
	);
end Key_Control;

architecture logicFunction of Key_Control is
	component KeyDecode_FSM
	port( 
		reset 		: in std_logic;
		clk			: in std_logic;
		Kpress, Kack: in std_logic;
		Kval			: out std_logic
	);
	end component;
	
	signal k_val : std_logic;
	
begin
	
	fsm: KeyDecode_FSM port map (
		reset 	=> RESET,
		clk 		=> CLK,
		Kpress 	=> Kpress,
		Kack 		=> Kack,
		Kval 		=> k_val
	);
	
	Kval	<= k_val;
	Kscan <= not k_val;
end LogicFunction;