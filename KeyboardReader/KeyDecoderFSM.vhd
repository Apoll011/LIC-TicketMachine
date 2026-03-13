library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyDecode_FSM is
port(
    reset           : in  std_logic;
    clk             : in  std_logic;
    Kpress, Kack    : in  std_logic;
    Tdelay          : in  std_logic_vector(1 downto 0);
    Kval, Kscan     : out std_logic;
	 t : out std_logic
);
end KeyDecode_FSM;

architecture behavioral of KeyDecode_FSM is

	type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);

	signal CurrentState, NextState : STATE_TYPE;

begin

	CurrentState <= STANDING_BY when RESET = '1' else NextState when rising_edge(CLK);

GenerateNextState:
process (CurrentState, Kpress, Kack)
    begin 
        case CurrentState is 
            when STANDING_BY         => if (Kpress = '1') then 
                                                NextState <= READING_DATA;
                                            else
                                                NextState <= STANDING_BY;
                                            end if;

            when READING_DATA    => if (Kack = '1') then
                                                NextState <= DATA_ACCEPTED;
                                            else 
                                                NextState <= READING_DATA;
                                            end if;

            when DATA_ACCEPTED   => if (Kack = '0' and Kpress = '0') then
                                                NextState <= STANDING_BY;
                                            else 
                                                NextState <= DATA_ACCEPTED;
                                            end if;

        end case;
    end process;


	Kscan <= '1' when (CurrentState = STANDING_BY) else '0';

	Kval <= '1' when (CurrentState = READING_DATA) else '0';
	
	t <= '1' when (CurrentState = DATA_ACCEPTED) else '0';
end behavioral;