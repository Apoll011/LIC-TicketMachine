library ieee;
use ieee.std_logic_1164.all;

entity KeyDecode_tb is
end entity KeyDecode_tb;

architecture behavioral of KeyDecode_tb is

    component Key_Decode is
        port (
            Kack, RESET, CLK : in  std_logic;
            Tdelay           : in  std_logic_vector(1 downto 0);
            Kval             : out std_logic;
            K                : out std_logic_vector(3 downto 0);
            Keys_Vertical    : out std_logic_vector(3 downto 0);
            Keys_Horizontal  : in  std_logic_vector(3 downto 0)
        );
    end component Key_Decode;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal reset_tb           : std_logic;
    signal clk_tb             : std_logic;
    signal Kack_tb            : std_logic;
    signal Tdelay_tb          : std_logic_vector(1 downto 0);
    signal Kval_tb            : std_logic;
    signal K_tb               : std_logic_vector(3 downto 0);
    signal Keys_Vertical_tb   : std_logic_vector(3 downto 0);
    signal Keys_Horizontal_tb : std_logic_vector(3 downto 0);

begin

    UUT: component Key_Decode
    port map (
        RESET           => reset_tb,
        CLK             => clk_tb,
        Kack            => Kack_tb,
        Tdelay          => Tdelay_tb,
        Kval            => Kval_tb,
        K               => K_tb,
        Keys_Vertical   => Keys_Vertical_tb,
        Keys_Horizontal => Keys_Horizontal_tb
    );

    clk_gen: process
    begin
        clk_tb             <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb             <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        -- Reset
        reset_tb           <= '1';
        Kack_tb            <= '0';
        Tdelay_tb          <= "00";
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 6;

        reset_tb           <= '0';
        -- Aguarda 1 ciclo completo de scan
        -- CLKDIV div=50 x 4 colunas = 200 ciclos = 4 us
        wait for MCLK_PERIOD * 200;

        -- Pressiona col0 (H(0)='0')
        Keys_Horizontal_tb <= "1110";
        wait for MCLK_PERIOD * 60;

        -- Kval deve estar alto, envia Kack
        Kack_tb            <= '1';
        wait for MCLK_PERIOD * 4;
        Kack_tb            <= '0';
        wait for MCLK_PERIOD * 4;

        -- Liberta col0
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 200;

        -- Pressiona col1 (H(1)='0')
        Keys_Horizontal_tb <= "1101";
        wait for MCLK_PERIOD * 60;

        Kack_tb            <= '1';
        wait for MCLK_PERIOD * 4;
        Kack_tb            <= '0';
        wait for MCLK_PERIOD * 4;

        -- Liberta col1
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 200;

        -- Pressiona col2 (H(2)='0')
        Keys_Horizontal_tb <= "1011";
        wait for MCLK_PERIOD * 60;

        Kack_tb            <= '1';
        wait for MCLK_PERIOD * 4;
        Kack_tb            <= '0';
        wait for MCLK_PERIOD * 4;

        -- Liberta col2
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 200;

        -- Reset a meio do scan
        reset_tb           <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb           <= '0';
        wait for MCLK_PERIOD * 6;

        wait;
    end process stimulus;

    -- 10 us

end architecture behavioral;
