library ieee;
use ieee.std_logic_1164.all;

entity KeyDecoderFSM_tb is
end entity KeyDecoderFSM_tb;

architecture behavioral of KeyDecoderFSM_tb is

    component KeyDecoderFSM is
        port (
            reset        : in  std_logic;
            clk          : in  std_logic;
            Kpress, Kack : in  std_logic;
            Tdelay       : in  std_logic_vector(1 downto 0);
            Kval, Kscan  : out std_logic
        );
    end component KeyDecoderFSM;

    -- 1 ns clock so the internal divider (500000 cycles at Tdelay="00")
    -- fires after 500 us of sim time instead of 10 ms.
    constant MCLK_PERIOD      : time := 1 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal reset_tb           : std_logic;
    signal clk_tb             : std_logic;
    signal Kpress_tb          : std_logic;
    signal Kack_tb            : std_logic;
    signal Tdelay_tb          : std_logic_vector(1 downto 0);
    signal Kval_tb            : std_logic;
    signal Kscan_tb           : std_logic;

begin

    UUT: component KeyDecoderFSM
    port map (
        reset  => reset_tb,
        clk    => clk_tb,
        Kpress => Kpress_tb,
        Kack   => Kack_tb,
        Tdelay => Tdelay_tb,
        Kval   => Kval_tb,
        Kscan  => Kscan_tb
    );

    clk_gen: process
    begin
        clk_tb    <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb    <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        -- Reset
        reset_tb  <= '1';
        Kpress_tb <= '0';
        Kack_tb   <= '0';
        Tdelay_tb <= "00";
        wait for MCLK_PERIOD * 6;

        reset_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        -- 1. STANDING_BY -> READING_DATA
        Kpress_tb <= '1';
        wait for MCLK_PERIOD * 6;

        -- 2. READING_DATA -> DATA_ACCEPTED
        Kack_tb   <= '1';
        wait for MCLK_PERIOD * 6;
        Kack_tb   <= '0';

        -- 3. Aguarda timer (500000 ciclos a 1ns = 500 us)
        --    Kpress ainda alto -> repeat imediato
        wait for MCLK_PERIOD;

        -- 4. Segundo Kack para o repeat
        Kack_tb   <= '1';
        wait for MCLK_PERIOD * 6;
        Kack_tb   <= '0';

        -- 5. Liberta tecla e aguarda timer -> STANDING_BY
        Kpress_tb <= '0';
        wait for MCLK_PERIOD;

        -- 6. Segundo ciclo completo
        Kpress_tb <= '1';
        wait for MCLK_PERIOD * 6;
        Kack_tb   <= '1';
        wait for MCLK_PERIOD * 6;
        Kack_tb   <= '0';
        Kpress_tb <= '0';
        wait for MCLK_PERIOD;

        -- 7. Reset a meio de READING_DATA
        Kpress_tb <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb  <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        Kpress_tb <= '0';
        wait for MCLK_PERIOD * 6;

        wait;
    end process stimulus;

    -- 2 ms

end architecture behavioral;
