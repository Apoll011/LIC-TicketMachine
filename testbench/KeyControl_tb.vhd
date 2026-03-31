library ieee;
use ieee.std_logic_1164.all;

entity KeyControl_tb is
end entity KeyControl_tb;

architecture behavioral of KeyControl_tb is

    component Key_Control is
        port (
            Kack, Kpress, RESET, CLK : in  std_logic;
            Tdelay                   : in  std_logic_vector(1 downto 0);
            Kval, Kscan              : out std_logic
        );
    end component Key_Control;

    constant MCLK_PERIOD      : time := 1 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal reset_tb  : std_logic;
    signal clk_tb    : std_logic;
    signal Kpress_tb : std_logic;
    signal Kack_tb   : std_logic;
    signal Tdelay_tb : std_logic_vector(1 downto 0);
    signal Kval_tb   : std_logic;
    signal Kscan_tb  : std_logic;

begin

    UUT: component Key_Control
    port map (
        RESET  => reset_tb,
        CLK    => clk_tb,
        Kpress => Kpress_tb,
        Kack   => Kack_tb,
        Tdelay => Tdelay_tb,
        Kval   => Kval_tb,
        Kscan  => Kscan_tb
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
        -- Reset: Kscan=1, Kval=0
        reset_tb  <= '1';
        Kpress_tb <= '0';
        Kack_tb   <= '0';
        Tdelay_tb <= "00";
        wait for MCLK_PERIOD * 6;

        reset_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        -- Kpress -> Kval deve subir (STANDING_BY -> READING_DATA)
        Kpress_tb <= '1';
        wait for MCLK_PERIOD * 6;

        -- Kack -> Kval deve descer (READING_DATA -> DATA_ACCEPTED)
        Kack_tb   <= '1';
        wait for MCLK_PERIOD * 6;
        Kack_tb   <= '0';
        Kpress_tb <= '0';
        wait for MCLK_PERIOD * 6;

        -- Aguarda timer -> STANDING_BY, Kscan=1
        wait for MCLK_PERIOD;

        wait;
    end process stimulus;
	 
	 -- 31 ns

end architecture behavioral;