library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RBC is

    port (
        CLK      		: in  std_logic;
        RESET    		: in  std_logic;
        DAV, CTS 		: in  std_logic; 
        full, empty	: in  std_logic;

        Wr  		   : out std_logic;
		  selPnG  		: out std_logic;
		  Wreg  		   : out std_logic;
		  DAC  		   : out std_logic;
		  incP, incG 	: out std_logic
    );

end entity RBC;

architecture behavioral of RBC is

    type STATE_TYPE is (STATE_IDLE, STATE_START_DACCEPT, STATE_DACCEPT_ACK, STATE_AFTER_WRITE, STATE_WAIT_DAV_LOW, STATE_T_SEND_KEY, STATE_T_INCG);
    signal CurrentState, NextState : STATE_TYPE;

begin

    StateRegister : process (CLK, RESET) is
    begin
        if RESET = '1' then
            CurrentState <= STATE_IDLE;
        elsif rising_edge(CLK) then
            CurrentState <= NextState;
        end if;
    end process StateRegister;

    GenerateNextState : process (CurrentState, DAV, CTS, full, empty) is
    begin
        case CurrentState is
            when STATE_IDLE =>
                if DAV = '1' and full = '0' then
                    NextState <= STATE_START_DACCEPT;
					 elsif CTS = '1' and empty = '0' then
							NextState <= STATE_T_SEND_KEY;
                else
                    NextState <= STATE_IDLE;
                end if;
					 
            when STATE_START_DACCEPT =>
                   NextState <= STATE_DACCEPT_ACK;
            when STATE_DACCEPT_ACK =>
						 NextState <= STATE_AFTER_WRITE;
				when STATE_AFTER_WRITE =>
						 NextState <= STATE_WAIT_DAV_LOW;
				when STATE_WAIT_DAV_LOW =>
					 if DAV = '0' then
                    NextState <= STATE_IDLE;
                else
                    NextState <= STATE_WAIT_DAV_LOW;
                end if;
				when STATE_T_SEND_KEY =>
						 NextState <= STATE_T_INCG;
				when STATE_T_INCG =>
					 NextState <= STATE_IDLE;
        end case;
    end process GenerateNextState;
	
	 incP 	<= '1' when CurrentState = STATE_AFTER_WRITE else '0';
	 DAC 		<= '1' when CurrentState = STATE_AFTER_WRITE or CurrentState = STATE_WAIT_DAV_LOW else '0';
	 Wr 		<= '1' when CurrentState = STATE_DACCEPT_ACK else '0';
	 selPnG	<= '1' when CurrentState = STATE_START_DACCEPT or CurrentState = STATE_DACCEPT_ACK  else '0'; 
	 
	 Wreg		<= '1' when CurrentState = STATE_T_SEND_KEY else '0';
	 incG 	<= '1' when CurrentState = STATE_T_INCG else '0';

end architecture behavioral;