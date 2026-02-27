library ieee;
use ieee.std_logic_1164.all;

entity KeyDecode_FSM is
port(
		reset 		: in std_logic;
		clk			: in std_logic;
		Kpress, Kack: in std_logic;
		Kval			: out std_logic
);
end KeyDecode_FSM;

architecture behavioral of KeyDecode_FSM is

	type STATE_TYPE is (STATE_WAITING_KEY, STATE_WAITING_BUFFER);

	signal CurrentState, NextState : STATE_TYPE;

begin

	CurrentState <= STATE_WAITING_KEY when RESET = '1' else NextState when rising_edge(clk);

GenerateNextState:
	process (CurrentState, Kpress, Kack)
	begin
		case CurrentState is
			when STATE_WAITING_KEY		=>	if (Kpress = '1') then 
												NextState <= STATE_WAITING_BUFFER;
											else 
												NextState <= STATE_WAITING_KEY;
											end if;
											
			when STATE_WAITING_BUFFER	=>	if (Kack = '1') then 
												NextState <= STATE_WAITING_KEY;
											else 
												NextState <= STATE_WAITING_BUFFER;
											end if;						
		end case;
	end process;
					
	Kval <= '1' when (CurrentState = STATE_WAITING_BUFFER) else '0';

end behavioral;