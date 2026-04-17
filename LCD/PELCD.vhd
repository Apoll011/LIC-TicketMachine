library ieee;
use ieee.std_logic_1164.all;

entity PELCD is
    port (
        SDX, CLK, SS, RESET : in  std_logic;
        Q            		 : out std_logic_vector(9 downto 0)
    );
end entity PELCD;

architecture logicFunction of PELCD is

    component SerialReceiver is
    port (
        SDX, CLK, SS, RESET : in  std_logic;
        Q            		 : out std_logic_vector(9 downto 0)
    );
    end component SerialReceiver;
	 
begin

serial: component SerialReceiver port map(
	SDX => SDX,
	CLK => CLK,
	SS => SS,
	RESET => RESET,
	Q => Q
);
end architecture logicFunction;