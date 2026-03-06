LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(	
		inputPortT:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPortT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
end TicketMachine;

architecture logicFunction of TicketMachine is
	
	component UsbPort
	port( 
		inputPort:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	end component;
	
begin

	usb: UsbPort port map (
		inputPort 	=> inputPortT,
		outputPort 	=> outputPortT
	);
	
end logicFunction;