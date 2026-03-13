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

	 component CLKDIV
    generic(div: natural := 50000000);
        port(
            clk_in: in std_logic; -- Entrada do clock div
            clk_out: out std_logic -- Saída do clock div
        );
	end component;

	type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);

	signal CurrentState, NextState : STATE_TYPE;
	signal clk_out: std_logic;

begin 

	clkd: CLKDIV generic map (500000)
	port map(
		clk_in => clk,
		clk_out => clk_out
		
	);

	CurrentState <= STANDING_BY when RESET = '1' else NextState when rising_edge(clk);

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

            when DATA_ACCEPTED   => if ((Kack = '0' and Kpress = '0') or clk_out = '1') then
                                                NextState <= STANDING_BY;
                                            else 
                                                NextState <= DATA_ACCEPTED;
                                            end if;

        end case;
    end process;


	Kscan <= '1' when (CurrentState = STANDING_BY) else '0';

	Kval <= '1' when (CurrentState = READING_DATA) else '0';
end behavioral;