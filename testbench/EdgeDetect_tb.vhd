library ieee;
use ieee.std_logic_1164.all;

entity EdgeDetect_tb is
end entity EdgeDetect_tb;

architecture behavioral of EdgeDetect_tb is

    component EdgeDetect is
        port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            SIG_IN : in  std_logic;
            RISE   : out std_logic
        );
    end component EdgeDetect;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal CLK_tb             : std_logic;
    signal RESET_tb           : std_logic;
    signal SIG_IN_tb          : std_logic;
    signal RISE_tb            : std_logic;

begin

    UUT: component EdgeDetect
    port map (
        CLK    => CLK_tb,
        RESET  => RESET_tb,
        SIG_IN => SIG_IN_tb,
        RISE   => RISE_tb
    );

    clk_gen: process
    begin
        CLK_tb    <= '0';
        wait for MCLK_HALF_PERIOD;
        CLK_tb    <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        RESET_tb  <= '1';
        SIG_IN_tb <= '0';
        wait for MCLK_PERIOD * 2;
        RESET_tb  <= '0';
        wait for MCLK_PERIOD * 2;

        SIG_IN_tb <= '1';
        wait for MCLK_PERIOD * 2;
        SIG_IN_tb <= '1';
        wait for MCLK_PERIOD * 2;
        SIG_IN_tb <= '0';
        wait for MCLK_PERIOD * 2;
        SIG_IN_tb <= '1';
        wait for MCLK_PERIOD * 2;

        RESET_tb  <= '1';
        wait for MCLK_PERIOD;
        RESET_tb  <= '0';
        SIG_IN_tb <= '0';
        wait for MCLK_PERIOD * 2;
        wait;
    end process stimulus;

end architecture behavioral;
