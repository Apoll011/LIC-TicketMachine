library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyDecoderFSM is
    port (
        reset        : in  std_logic;
        clk          : in  std_logic;
        Kpress, Kack : in  std_logic;
        Tdelay       : in  std_logic_vector(1 downto 0);
        Kval, Kscan, clko : out std_logic
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

    component FFD is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            SET   : in  std_logic;
            D     : in  std_logic;
            EN    : in  std_logic;
            Q     : out std_logic
        );
    end component FFD;

    type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);

    signal CurrentState, NextState : STATE_TYPE;
    signal clk_out                 : std_logic;
    signal clk_out_prev            : std_logic := '0';
    signal clk_out_rise            : std_logic;
    signal Kpress_latch            : std_logic;
    signal Kack_received           : std_logic;

begin

    clkd: component KeyDelay
    port map (
        CLK     => clk,
        Tdelay  => Tdelay,
        CLK_Out => clk_out
    );

    -- Kpress_latch: set em qualquer burst de Kpress
    --               reset quando volta a STANDING_BY
    kpress_latch_ff: component FFD
    port map (
        CLK   => clk,
        RESET => '0',
        SET   => Kpress,
        D     => '0',
        EN    => '0',
        Q     => Kpress_latch
    );

    -- Kack_received: set quando software envia Kack em READING_DATA
    --                reset quando volta a STANDING_BY
    kack_received_ff: component FFD
    port map (
        CLK   => clk,
        RESET => '0',
        SET   => Kack,
        D     => '0',
        EN    => '0',
        Q     => Kack_received
    );

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

    GenerateNextState: process (CurrentState, Kpress_latch, Kack_received, clk_out_rise) is
    begin
        case CurrentState is

            when STANDING_BY =>
                if (Kpress_latch = '1') then
                    NextState <= READING_DATA;
                else
                    NextState <= STANDING_BY;
                end if;

            when READING_DATA =>
                if (Kack_received = '1') then
                    NextState <= DATA_ACCEPTED;
                else
                    NextState <= READING_DATA;
                end if;

            when DATA_ACCEPTED =>
                if (clk_out_rise = '1' and Kpress_latch = '1') then
                    -- Key repeat: tecla ainda premida
                    NextState <= READING_DATA;
                elsif (clk_out_rise = '1' and Kpress_latch = '0') or
                      (Kack_received = '1' and Kpress_latch = '0') then
                    -- Tempo expirou sem tecla, ou software leu e tecla libertada
                    NextState <= STANDING_BY;
                else
                    NextState <= DATA_ACCEPTED;
                end if;

        end case;
    end process GenerateNextState;

    clko <= clk_out;
    Kscan <= '1' when (CurrentState = STANDING_BY)  else '0';
    Kval  <= '1' when (CurrentState = READING_DATA) else '0';

end architecture behavioral;