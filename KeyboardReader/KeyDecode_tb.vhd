library ieee;
use ieee.std_logic_1164.all;

entity KeyDecode_tb is
end KeyDecode_tb;

architecture behavioral of KeyDecode_tb is

component Key_Decode is
port(
		Kack, Tdelay, RESET, CLK  	: in std_logic;
		Kval								: out std_logic;
		K 									: out std_logic_vector(3 downto 0);
		Keys_Vertical 					: out std_logic_vector(3 downto 0);
		Keys_Horizontal				: in std_logic_vector(3 downto 0)
);
end component;

-- UUT signals
constant MCLK_PERIOD : time := 20 ns;
constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

signal reset_tb : std_logic;
signal clk_tb : std_logic;
signal Kack_tb : std_logic;
signal Tdelay_tb : std_logic;
signal Keys_Vertical_tb : std_logic_vector(3 downto 0);
signal Keys_Horizontal_tb : std_logic_vector(3 downto 0);
signal K_tb : std_logic_vector(3 downto 0);
signal Kval_tb : std_logic;


begin

-- Unit Under Test
UUT: Key_Decode
port map(
		RESET 				=> reset_tb,
		CLK 					=> clk_tb,
		Kack					=> Kack_tb,
		Tdelay 				=> Tdelay_tb,
		Keys_Horizontal	=> Keys_Horizontal_tb,
		Keys_Vertical 		=> Keys_Vertical_tb,
		K 						=> K_tb,
		Kval 					=> Kval_tb
);

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
Kack_tb <= '0';
Tdelay_tb <= '0';
Keys_Horizontal_tb <= "1111";

wait for MCLK_PERIOD*2;

reset_tb <= '0';

wait for MCLK_PERIOD*2;

-- Simulate key press by setting one horizontal to '0'
Keys_Horizontal_tb <= "1110";

wait for MCLK_PERIOD*50;

Kack_tb <= '1';

wait for MCLK_PERIOD*2;

Kack_tb <= '0';

wait for MCLK_PERIOD*2;

-- Release key
Keys_Horizontal_tb <= "1111";

wait for MCLK_PERIOD*50;

-- Another key press
Keys_Horizontal_tb <= "1101";

wait for MCLK_PERIOD*50;

Kack_tb <= '1';

wait for MCLK_PERIOD*2;

Kack_tb <= '0';

wait for MCLK_PERIOD*2;

Keys_Horizontal_tb <= "1111";

wait for MCLK_PERIOD*50;

wait;
end process;

end architecture;