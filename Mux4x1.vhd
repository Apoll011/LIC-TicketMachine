library IEEE;
use IEEE.std_logic_1164.all;

entity MUX4X1 is
	port (
		A 	:	in std_logic_vector(3 downto 0);
		OP	:	in std_logic_vector(1 downto 0);
		F 	:	out std_logic
	);
end MUX4X1;

architecture logicfunction of MUX4X1 is 
	signal sA : std_logic_vector(3 downto 0);

begin

	sA(0) <= A(0) and (not OP(1) and not OP(0));
	sA(1) <= A(1) and (not OP(1) and OP(0));
	sA(2) <= A(2) and (OP(1) and not OP(0));
	sA(3) <= A(3) and (OP(1) and OP(0));

	F 		<= sA(0) or sA(1) or sA(2) or sA(3);


end logicfunction;