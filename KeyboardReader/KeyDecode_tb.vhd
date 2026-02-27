library ieee;
use ieee.std_logic_1164.all;

entity KeyDecode_tb is
end KeyDecode_tb;

architecture behavioral of KeyDecode_tb is

component Key_Scan is
port(
		Kscan, CLK, RESET	: in std_logic; 
		Keys_Vertical 		: out std_logic_vector(3 downto 0);
		Keys_Horizontal	: in std_logic_vector(3 downto 0);
		K						: out std_logic_vector(3 downto 0);
		Kpress				: out std_logic
);
end component;

-- UUT signals
constant MCLK_PERIOD : time := 20 ns;
constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

signal reset_tb 				: std_logic;
signal clk_tb 					: std_logic;
signal Kscan_tb 				: std_logic;
signal Keys_Vertical_tb 	: std_logic_vector(3 downto 0);
signal Keys_Horizontal_tb 	: std_logic_vector(3 downto 0);
signal K_tb 					: std_logic_vector(3 downto 0);
signal Kpress_tb 				: std_logic;



begin

-- Unit Under Test
UUT_Scan: Key_Scan 
		port map(RESET 			 => reset_tb,
					CLK				 => clk_tb,
					Kscan				 => Kscan_tb,
					Keys_Vertical   => Keys_Vertical_tb,
					Keys_Horizontal => Keys_Horizontal_tb,
					K 		 			 => K_tb,
					Kpress 			 => Kpress_tb);

clk_gen : process
begin
		clk_tb <= '0';
		wait for MCLK_HALF_PERIOD;
		clk_tb <= '1';
		wait for MCLK_HALF_PERIOD;
end process;

stimulus: process 
begin
	-- reset
	reset_tb <= '1';
	Kscan_tb <= '0';
	
	Sclose_tb <= '1';
	Spresence_tb <= '0';
	B_tb <= '0';
	wait for MCLK_PERIOD*2;
	
	reset_tb <= '0';
	wait for MCLK_PERIOD*2;
	
	Sclose_tb <= '0';
	wait for MCLK_PERIOD*5;
	
	Sopen_tb <= '1';
	wait for MCLK_PERIOD*5;
	
	Spresence_tb <= '1';
	wait for MCLK_PERIOD*5;
	
	Spresence_tb <= '0';
	wait for MCLK_PERIOD*5;
	
	Sclose_tb <= '1';
	B_tb <=	'0';
	wait for MCLK_PERIOD*5;

	wait;
end process;

end architecture;