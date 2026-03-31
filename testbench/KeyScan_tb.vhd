library ieee;
use ieee.std_logic_1164.all;

entity KeyScan_tb is
end entity KeyScan_tb;

architecture behavioral of KeyScan_tb is

    component Key_Scan is
        port (
            Kscan, CLK, RESET : in  std_logic;
            Keys_Vertical     : out std_logic_vector(3 downto 0);
            Keys_Horizontal   : in  std_logic_vector(3 downto 0);
            K                 : out std_logic_vector(3 downto 0);
            Kpress            : out std_logic
        );
    end component Key_Scan;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal reset_tb           : std_logic;
    signal clk_tb             : std_logic;
    signal Kscan_tb           : std_logic;
    signal Keys_Vertical_tb   : std_logic_vector(3 downto 0);
    signal Keys_Horizontal_tb : std_logic_vector(3 downto 0);
    signal K_tb               : std_logic_vector(3 downto 0);
    signal Kpress_tb          : std_logic;

begin

    UUT: component Key_Scan
    port map (
        RESET           => reset_tb,
        CLK             => clk_tb,
        Kscan           => Kscan_tb,
        Keys_Horizontal => Keys_Horizontal_tb,
        Keys_Vertical   => Keys_Vertical_tb,
        K               => K_tb,
        Kpress          => Kpress_tb
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
        -- Reset: counter frozen at 0, Kpress must be inactive
        reset_tb           <= '1';
        Kscan_tb           <= '0';
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 6;

        -- Release reset, enable scan
        reset_tb           <= '0';
        Kscan_tb           <= '1';
        wait for MCLK_PERIOD * 6;

        -- Press key col0 (H(0)='0') -> K="0000", Keys_Vertical="1110"
        Keys_Horizontal_tb <= "1110";
        wait for MCLK_PERIOD * 6;

        -- Release
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 6;

        -- Freeze counter (Kscan=0): K must not change
        Kscan_tb           <= '0';
        wait for MCLK_PERIOD * 6;

        -- Re-enable scan
        Kscan_tb           <= '1';
        wait for MCLK_PERIOD * 6;

        -- Press key col1 (H(1)='0')
        Keys_Horizontal_tb <= "1101";
        wait for MCLK_PERIOD * 6;

        -- Release
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 6;

        -- Press key col2 (H(2)='0')
        Keys_Horizontal_tb <= "1011";
        wait for MCLK_PERIOD * 6;

        -- Release
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 6;

        -- Press key col3 (H(3)='0')
        Keys_Horizontal_tb <= "0111";
        wait for MCLK_PERIOD * 6;

        -- Release
        Keys_Horizontal_tb <= "1111";
        wait for MCLK_PERIOD * 6;

        -- Reset mid-scan: counter must clear back to 0
        reset_tb           <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb           <= '0';
        wait for MCLK_PERIOD * 6;

        wait;
    end process stimulus;

	 -- 1640 ns
	 
end architecture behavioral;
