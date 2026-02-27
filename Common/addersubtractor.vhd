library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AdderSubtrator is 
	port (
		A 				: in STD_LOGIC_VECTOR (3 downto 0); 
		B 				: iN STD_LOGIC_VECTOR (3 downto 0);
      CBi, OPau 	: in std_logic;
		iCBO 			: out std_logic;
      R 				: out STD_LOGIC_VECTOR (3 downto 0)
	);
end AdderSubtrator;

architecture teste of AdderSubtrator is 

	component sumador_4bit is
		port ( 
			A,B	: in  std_logic_vector(3 downto 0);
			R		: out  std_logic_vector(3 downto 0);
			Ci 	: in  std_logic;
			Co		: out std_logic
		);
	end component;
	
	signal BXOR : std_logic_vector(3 downto 0);
	signal Cib : std_logic;
	signal Cbo : std_logic;

begin
	BXOR(0)	<= (B(0) XOR OPau);
	BXOR(1)	<= (B(1) XOR OPau);
	BXOR(2)	<= (B(2) XOR OPau);
	BXOR(3)	<= (B(3) XOR OPau);
	Cib 		<= OPau XOR CBi;

	u1 : sumador_4bit port map (
		A	=> A, 
		B	=> BXOR, 
		R	=> R, 
		Ci => Cib, 
		Co	=> Cbo
	);

	iCBO <= Cbo XOR OPau;

end teste;