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
            Q                   : out std_logic_vector(9 downto 0)
        );
    end component SerialReceiver;

begin

serial: component SerialReceiver port map(
	SDX 				=> SDX,
	CLK 				=> CLK,
	SS 				=> SS,
	RESET 			=> RESET,
   Q(1)    			=> D(7),
   Q(2)   			=> D(6),
   Q(3)   			=> D(5),
   Q(4)    			=> D(4),
   Q(5)    			=> D(3),
   Q(6)    			=> D(2),
   Q(7)    			=> D(1),
	Q(8)    			=> D(0),
	Q(0) 				=> Prt,
	Q(9)				=> Rt
	
);
end architecture logicFunction;
