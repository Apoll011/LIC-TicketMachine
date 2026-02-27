library IEEE;
use IEEE.std_logic_1164.all;

entity MUX1 is
	port (
		A 	:	in std_logic;
		B 	:	in std_logic;
		OP	:	in std_logic;
		F 	:	out std_logic
	);
end MUX1;

architecture logicfunction of MUX1 is 
	signal sA : std_logic;
	signal sB : std_logic;

begin	sA <= A and not OP;
	sB <= B and OP;

	F	<= sA or sB;
end logicfunction;