library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyDecode_FSM is
port(
    reset           : in  std_logic;
    clk             : in  std_logic;
    Kpress, Kack    : in  std_logic;
    Tdelay          : in  std_logic_vector(1 downto 0);  -- 00=500ms 01=1000ms 10=1500ms 11=2000ms
    Kval, Kscan     : out std_logic
);
end KeyDecode_FSM;

architecture behavioral of KeyDecode_FSM is

	type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);

	signal CurrentState, NextState : STATE_TYPE;

begin 


begin

    -- Limite do contador conforme Tabela 1
    with Tdelay select
        max_count <=
            to_unsigned(25_000_000, 27) when "00",   -- 500 ms
            to_unsigned(50_000_000, 27) when "01",   -- 1000 ms
            to_unsigned(75_000_000, 27) when "10",   -- 1500 ms
            to_unsigned(100_000_000,27) when "11",   -- 2000 ms_
            to_unsigned(25_000_000, 27) when others;

    -- Contador: só corre em STATE_WAITING_TDELAY
    process (CLK, reset)
    begin
        if (reset = '1') then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if (CurrentState /= STATE_WAITING_TDELAY) then
                counter <= (others => '0');
            elsif (counter < max_count - 1) then
                counter <= counter + 1;
            end if;
        end if;
    end process;

    timer_done <= '1' when (counter = max_count - 1) else '0';

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
end behavioral;