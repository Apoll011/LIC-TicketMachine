LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(
		RESET, CLK  	: in std_logic
	);
end TicketMachine;

architecture logicFunction of TicketMachine is
	component KeyDecode_FSM
	port( 
		reset 		: in std_logic;
		clk			: in std_logic;
		Kpress, Kack: in std_logic;
		Kval			: out std_logic
	);
	end component;
begin

end logicFunction;