library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyDecode_FSM is
port(
    reset           : in  std_logic;
    clk             : in  std_logic;
    Kpress, Kack    : in  std_logic;
    Tdelay          : in  std_logic_vector(1 downto 0);  -- 00=500ms 01=1000ms 10=1500ms 11=2000ms
    Kval            : out std_logic
);
end KeyDecode_FSM;

architecture behavioral of KeyDecode_FSM is

    type STATE_TYPE is (
        STATE_WAITING_KEY,
        STATE_WAITING_BUFFER,
        STATE_WAITING_TDELAY
    );

    signal CurrentState, NextState : STATE_TYPE;

    -- Contador interno para o período de repetição (27 bits para 100M ciclos @ 50MHz)
    signal counter      : unsigned(26 downto 0);
    signal max_count    : unsigned(26 downto 0);
    signal timer_done   : std_logic;

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

    -- Registo de estado
    CurrentState <= STATE_WAITING_KEY when reset = '1' else NextState when rising_edge(clk);

GenerateNextState:
    process (CurrentState, Kpress, Kack, timer_done)
    begin
        case CurrentState is

            when STATE_WAITING_KEY =>
                if (Kpress = '1') then
                    NextState <= STATE_WAITING_BUFFER;
                else
                    NextState <= STATE_WAITING_KEY;
                end if;

            when STATE_WAITING_BUFFER =>
                if (Kack = '1') then
                    if (Kpress = '1') then
                        NextState <= STATE_WAITING_TDELAY;
                    else
                        NextState <= STATE_WAITING_KEY;
                    end if;
                else
                    NextState <= STATE_WAITING_BUFFER;
                end if;

            when STATE_WAITING_TDELAY =>
                if (Kpress = '0') then
                    NextState <= STATE_WAITING_KEY;
                elsif (timer_done = '1') then
                    NextState <= STATE_WAITING_BUFFER;
                else
                    NextState <= STATE_WAITING_TDELAY;
                end if;

        end case;
    end process;

    Kval <= '1' when (CurrentState = STATE_WAITING_BUFFER) else '0';

end behavioral;