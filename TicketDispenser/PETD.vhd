library ieee;
use ieee.std_logic_1164.all;

entity PETD is
    port (
        SDX, CLK, SS, RESET : in  std_logic;
        D            		 : out std_logic_vector(7 downto 0);
		  Prt, Rt				 : out std_logic
    );
end entity PETD;

architecture logicFunction of PETD is

    component SerialReceiver is
    port (
        SDX, CLK, SS, RESET : in  std_logic;
        Q            		 : out std_logic_vector(9 downto 0)
    );
    end component SerialReceiver;
	 
begin

serial: component SerialReceiver port map(
	SDX 				=> SDX,
	CLK 				=> CLK,
	SS 				=> SS,
	RESET 			=> RESET,
	Q(8 downto 1)  => D,
	Q(9) 				=> Prt,
	Q(0)				=> Rt
	
);
end architecture logicFunction;