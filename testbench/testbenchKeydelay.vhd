library ieee;
use ieee.std_logic_1164.all;

entity testbenchKeyDelay is
end entity testbenchKeyDelay;

architecture behavioral of testbenchKeyDelay is

    component KeyDelay is
        port (
            CLK    : in  std_logic;
            CE     : in  std_logic;
            RESET  : in  std_logic;
            Tdelay : in  std_logic_vector(1 downto 0);
            F      : out std_logic
        );
    end component KeyDelay;

    -- 1 ns clock: torna os tempos de simulacao razoaveis
    -- F sobe apos: KeyDelayTime_period x CLKDIV(16) x 15 ticks do counter
    -- Com Tdelay="00": 500000 x 16 x 15 = ~120 ms de tempo simulado
    constant MCLK_PERIOD      : time := 1 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb    : std_logic;
    signal ce_tb     : std_logic;
    signal reset_tb  : std_logic;
    signal Tdelay_tb : std_logic_vector(1 downto 0);
    signal F_tb      : std_logic;

begin

    UUT: component KeyDelay
    port map (
        CLK    => clk_tb,
        CE     => ce_tb,
        RESET  => reset_tb,
        Tdelay => Tdelay_tb,
        F      => F_tb
    );

    clk_gen: process
    begin
        clk_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        -- Reset inicial: F deve permanecer '0', counter congelado
        reset_tb  <= '1';
        ce_tb     <= '0';
        Tdelay_tb <= "00";
        wait for MCLK_PERIOD * 6;

        reset_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        -- Teste 1: Tdelay="00", CE='1'
        -- KeyDelayTime emite pulso a cada 500000 ciclos
        -- CLKDIV(16) divide por 16 -> CLK_Divider
        -- Counter precisa de 15 ticks de CLK_Divider para Q="1111"
        -- F deve subir para '1' ao fim desse tempo
        ce_tb     <= '1';
        Tdelay_tb <= "00";
        wait for 500000 * 16 * 16 * 1 ns;

        -- F deve estar '1' aqui; reset para proximo teste
        reset_tb  <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        -- Teste 2: Tdelay="01" (KeyDelayTime div=1000000)
        -- Tempo de F subir e o dobro do Teste 1
        Tdelay_tb <= "01";
        wait for 1000000 * 16 * 16 * 1 ns;

        reset_tb  <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        -- Teste 3: CE='0' -> counter congelado, F nao deve subir
        ce_tb     <= '0';
        Tdelay_tb <= "00";
        wait for 500000 * 16 * 16 * 1 ns;
        -- F deve continuar '0'

        -- CE volta a '1': counter retoma e F deve subir
        ce_tb     <= '1';
        wait for 500000 * 16 * 16 * 1 ns;

        reset_tb  <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        -- Teste 4: RESET a meio da contagem -> counter limpa, F nao sobe
        ce_tb     <= '1';
        Tdelay_tb <= "00";
        wait for 500000 * 16 * 8 * 1 ns;  -- metade do tempo
        reset_tb  <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        -- F deve estar '0' pois o counter foi reiniciado
        wait for MCLK_PERIOD * 6;

        wait;
    end process stimulus;

end architecture behavioral;