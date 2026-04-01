library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyDecoderFSM is
    port (
        reset        : in  std_logic;
        clk          : in  std_logic;
        Kpress, Kack : in  std_logic;
        Tdelay       : in  std_logic_vector(1 downto 0); -- 00=500ms 01=1000ms 10=1500ms 11=2000ms
        Kval, Kscan  : out std_logic
    );
end entity KeyDecoderFSM;

architecture behavioral of KeyDecoderFSM is

    component KeyDelay is
        port (
            CLK     : in  std_logic;
            Tdelay  : in  std_logic_vector(1 downto 0);
            CLK_Out : out std_logic
        );
    end component KeyDelay;

    type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);

    signal CurrentState, NextState : STATE_TYPE;
    signal clk_out                 : std_logic;
    signal clk_out_prev            : std_logic := '0';
    signal clk_out_rise            : std_logic;

begin

    -- Instantiate delay clock generator
    clkd: component KeyDelay
    port map (
        CLK     => clk,
        Tdelay  => Tdelay,
        CLK_Out => clk_out
    );

    -- Detect rising edge of the slow clock output
    DetectRise: process (clk, reset) is
    begin
        if reset = '1' then
            clk_out_prev <= '0';
        elsif rising_edge(clk) then
            clk_out_prev <= clk_out;
        end if;
    end process DetectRise;

    clk_out_rise <= '1' when (clk_out = '1' and clk_out_prev = '0') else '0';

    StateRegister: process (clk, reset) is
    begin
        if reset = '1' then
            CurrentState <= STANDING_BY;
        elsif rising_edge(clk) then
            CurrentState <= NextState;
        end if;
    end process StateRegister;

    GenerateNextState: process (CurrentState, Kpress, Kack, clk_out_rise) is
    begin
        case CurrentState is

            when STANDING_BY =>
                if (Kpress = '1') then
                    NextState <= READING_DATA;
                else
                    NextState <= STANDING_BY;
                end if;

            when READING_DATA =>
                if (Kack = '1') then
                    NextState <= DATA_ACCEPTED;
                else
                    NextState <= READING_DATA;
                end if;

            when DATA_ACCEPTED =>
                if (clk_out_rise = '1') or (Kack = '0' and Kpress = '0') then
                    NextState <= STANDING_BY;
                else
                    NextState <= DATA_ACCEPTED;
                end if;

        end case;
    end process GenerateNextState;

    Kscan <= '1' when (CurrentState = STANDING_BY)   else '0';
    Kval  <= '1' when (CurrentState = READING_DATA)  else '0';

end architecture behavioral;
