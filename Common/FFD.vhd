library ieee;
use ieee.std_logic_1164.all;

entity FFD IS
	port(	
		CLK 	: in std_logic;
		RESET : in STD_LOGIC;
		SET 	: in std_logic;
		D 		: IN STD_LOGIC;
		EN 	: IN STD_LOGIC;
		Q 		: out std_logic
	);
end FFD;

architecture logicFunction of FFD is

begin
	Q <= '0' when RESET = '1' else '1' when SET = '1' else D WHEN rising_edge(clk) and EN = '1';
end LogicFunction;