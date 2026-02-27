use ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port();
end TicketMachine;

architecture logicFunction OF TicketMachine IS
	component Key_Scan
		port(
			Kscan, CLK, RESET	: in std_logic; 
			Keys_Vertical 		: out std_logic_vector(3 downto 0);
			Keys_Horizontal	: in std_logic_vector(3 downto 0);
			K						: out std_logic_vector(3 downto 0);
			Kpress				: out std_logic
		);
	end Key_Scan;
begin
	key_scan01: Key_Scan port map (
		
	);
END TicketMachine;