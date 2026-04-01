
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(	
		Kval,Kscan : out std_logic;
		CLK, RESET 						: in std_logic;
		Keys_Vertical					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0);
		LCD_DATA		           		: out std_logic_vector(9 downto 0)
	);
end TicketMachine;

architecture logicFunction of TicketMachine is
	component Key_Decode
	port( 
		Kack, RESET, CLK  			: in std_logic;
		Tdelay 							: in std_logic_vector(1 downto 0);
		Kval								: out std_logic;
		K 									: out std_logic_vector(3 downto 0);
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
	);
	end component;
	
	component UsbPort
	port( 
		inputPort	:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort 	:  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	end component;
	
	component SerialReceiver
    port(
        SDX, CLK, SS, RESET   : in  std_logic;
        Q           				: out std_logic_vector(9 downto 0)
    );
	end component;

	signal inputPort, outputPort	: STD_LOGIC_VECTOR(7 DOWNTO 0);	
begin

	usb: UsbPort port map (

		inputPort 	=> inputPort,
		outputPort 	=> outputPort
	);
	Kval <= outputPort(7);
	decode: Key_Decode port map (
		Kack => outputPort(7),
		Tdelay => "11",
		RESET => RESET,
		CLK => CLK,
		K(0) => inputPort(0),
		K(1) => inputPort(1),
		K(2) => inputPort(2),
		K(3) => inputPort(3),
		Kval => inputPort(7),
		Keys_Vertical => Keys_Vertical,
		Keys_Horizontal => Keys_Horizontal
	);
	
	lcd_serial : SerialReceiver port map (
		SDX 	=> outputPort(0),
		CLK 	=> outputPort(1),
		SS  	=> outputPort(2),
		Q 	 	=> LCD_DATA,
		RESET => RESET
	);
	
	
	
end logicFunction;
