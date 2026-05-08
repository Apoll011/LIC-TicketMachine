library ieee;
use ieee.std_logic_1164.all;

entity Key_Control is
    port (
        CLK, RESET, Kack, Kpress : in  std_logic;
        Tdelay                   : in  std_logic_vector(1 downto 0);
        Kval, Kscan              : out std_logic
    );
end entity Key_Control;

architecture behavioral of Key_Control is

    component KeyDelay is
        port (
            CLK     : in  std_logic;
            Tdelay  : in  std_logic_vector(1 downto 0);
            CLK_Out : out std_logic
        );
    end component KeyDelay;

    component EdgeDetect is
        port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            SIG_IN : in  std_logic;
            RISE   : out std_logic
        );
    end component EdgeDetect;

    type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);
    signal CurrentState, NextState : STATE_TYPE;

    signal delay_clk  : std_logic;
    signal delay_rise : std_logic;

begin

    delay_gen : component KeyDelay
    port map (
        CLK     => CLK,
        Tdelay  => Tdelay,
        CLK_Out => delay_clk
    );

    edge_det : component EdgeDetect
    port map (
        CLK    => CLK,
        RESET  => RESET,
        SIG_IN => delay_clk,
        RISE   => delay_rise
    );

    StateRegister : process (CLK, RESET) is
    begin
        if RESET = '1' then
            CurrentState <= STANDING_BY;
        elsif rising_edge(CLK) then
            CurrentState <= NextState;
        end if;
    end process StateRegister;

    GenerateNextState : process (CurrentState, Kpress, Kack, delay_rise) is
    begin
        case CurrentState is

            when STANDING_BY =>
                if Kpress = '1' then
                    NextState <= READING_DATA;
                else
                    NextState <= STANDING_BY;
                end if;

            when READING_DATA =>
                if Kack = '1' then
                    NextState <= DATA_ACCEPTED;
                else
                    NextState <= READING_DATA;
                end if;

            when DATA_ACCEPTED =>
                if delay_rise = '1' or Kpress = '0' then
                    NextState <= STANDING_BY;
                else
                    NextState <= DATA_ACCEPTED;
                end if;

        end case;
    end process GenerateNextState;

    Kscan <= '1' when CurrentState = STANDING_BY  else '0';
    Kval  <= '1' when CurrentState = READING_DATA else '0';

end architecture behavioral;