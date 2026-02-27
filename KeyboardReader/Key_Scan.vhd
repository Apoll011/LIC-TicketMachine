LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Key_Scan is

	port(
		Kscan, CLK, RESET	: in std_logic; 
		Keys_Vertical 		: out std_logic_vector(3 downto 0);
		Keys_Horizontal	: in std_logic_vector(3 downto 0);
		K						: out std_logic_vector(3 downto 0);
		Kpress				: out std_logic
	);

end Key_Scan;

architecture scan of Key_Scan is

	component Counter
	port (
		CE 	: in std_logic;
		CLK 	: in std_logic;
		Q	 	: out std_logic_vector(3 downto 0);
		RESET : in std_logic
	);
	end component;
	
	component Decoder
	port (
		S 		: in std_logic_vector(1 downto 0); 
      C 		: out std_logic_vector(3 downto 0)
	);
	end component;
	
	component MUX4X1
	port (
		A 		:	in std_logic_vector(3 downto 0);
		OP		:	in std_logic_vector(1 downto 0);
		F 		:	out std_logic
	);
	end component;

	signal counter_out : std_logic_vector(3 downto 0);

begin
	Kcounter : Counter port map (
		CLK 	=> CLK, 
		RESET => RESET, 
		CE 	=> Kscan, 
		Q 		=> counter_out
	);
	
	mux : MUX4X1 port map (
		A		=> Keys_Horizontal, 
		OP		=> counter_out(1 downto 0), 
		F		=> Kpress
	);
	
	SKdecoder : Decoder port map (
		S 		=> counter_out(3 downto 2),
      C 		=> Keys_Vertical
	);

        
end scan;