LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(	
		CLK, RESET						: in std_logic;
		t 									: out std_logic;
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
		
	);
end TicketMachine;

architecture logicFunction of TicketMachine is
	component Key_Decode
	port( 
		Kack, RESET, CLK			  	: in std_logic;
		Tdelay							: in std_logic_vector(1 downto 0);
		Kval, t							: out std_logic;
		K									: out std_logic_vector(3 downto 0);
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
	
	component clkDIV
	port ( clk_in: in std_logic;
		 clk_out: out std_logic);
	end component;
		 
	signal inputPort, outputPort	: STD_LOGIC_VECTOR(7 DOWNTO 0);	
	signal clk_out			: std_logic;
begin
	
	clkd: clkDIV port map (
	
		clk_in => CLK,
		clk_out => clk_out
	);
			
	usb: UsbPort port map (

		inputPort 	=> inputPort,
		outputPort 	=> outputPort
	);

	decode: Key_Decode port map (
		Kack => outputPort(0),
		Tdelay => "00",
		RESET => RESET,
		CLK => CLK,
		K(0) => inputPort(6),
		K(1) => inputPort(5),
		K(2) => inputPort(4),
		K(3) => inputPort(3),
		Kval => inputPort(7),
		Keys_Vertical => Keys_Vertical,
		Keys_Horizontal => Keys_Horizontal,
		t => inputPort(2)
	);
end logicFunction;