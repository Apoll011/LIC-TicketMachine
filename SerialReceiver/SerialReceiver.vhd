library ieee;
use ieee.std_logic_1164.all;

entity SerialReceiver IS
    port(
        SDX, CLK, SS    : in  std_logic;
        Q           : out std_logic_vector(9 downto 0)
    );
end SerialReceiver;

architecture logicFunction of SerialReceiver is

   component ShiftRegister
	PORT( CLK : in std_logic;
	RESET : in STD_LOGIC;
	S : IN STD_LOGIC;
	EN : IN STD_LOGIC;
	Q : out std_logic_VECTOR(9 downto 0));
   end component;

   component HoldRegister
	PORT( CLK : in std_logic;
	RESET : in STD_LOGIC;
	D : IN STD_LOGIC_VECTOR(9 downto 0);
	EN : IN STD_LOGIC;
	Q : out std_logic_VECTOR(9 downto 0));
   end component;
	
	signal shift_out 	: std_logic_vector(9 downto 0);
	signal RESET 		: std_logic;
begin

    shift: ShiftRegister port map (
		 CLK 		=> CLK,
		 RESET 	=> RESET,
		 S		 	=> SDX,
		 EN		=> not SS,
		 Q 		=> shift_out
    );

    hold: HoldRegister port map (
		 CLK 		=> CLK,
		 RESET	=> RESET,
		 D 		=> shift_out,
		 EN 		=> SS,
		 Q 		=> Q
    );
	 
	 RESET <= '0';


end logicFunction;