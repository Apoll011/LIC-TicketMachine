LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
	port(	
		CLK  	: in std_logic;
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
	
	component clkDIV
	port ( clk_in: in std_logic;
		 clk_out: out std_logic);
		end component;
		
		signal clk_out : std_logic;
begin
	Clkdi: clkDIV port map (
		clk_in => CLK,
		clk_out => clk_out
	);
	decode: Key_Decode port map (
		Kack => '1',
		Tdelay => '0',
		RESET => '0',
		CLK => clk_out,
		Kval => Kval,
		K => K,
		Keys_Vertical => Keys_Vertical,
		Keys_Horizontal => Keys_Horizontal
	);
end logicFunction;