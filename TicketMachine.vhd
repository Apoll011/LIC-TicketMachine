LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(	
		CLK								: in std_logic;
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
		
	);
end TicketMachine;

architecture logicFunction of TicketMachine is
	component Key_Decode
	port( 
		Kack, RESET, CLK  	: in std_logic;
		Tdelay 							: in std_logic_vector(1 downto 0);
		Kval								: out std_logic;
		K 									: out std_logic_vector(3 downto 0);
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
	);
	end component;
	
	component UsbPort
	port( 
		inputPort:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	end component;
	
	signal inputPort, outputPort	: STD_LOGIC_VECTOR(7 DOWNTO 0);	
begin

	usb: UsbPort port map (

		inputPort 	=> inputPort,
		outputPort 	=> outputPort
	);

	decode: Key_Decode port map (
		Kack => outputPort(0),
		Tdelay =>"11",
		RESET => '0',
		CLK => CLK,
		K(0) => inputPort(6),
		K(1) => inputPort(5),
		K(2) => inputPort(4),
		K(3) => inputPort(3),
		Kval => inputPort(7),
		Keys_Vertical => Keys_Vertical,
		Keys_Horizontal => Keys_Horizontal
	);
end logicFunction;