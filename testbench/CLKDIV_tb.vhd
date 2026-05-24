library ieee;
use ieee.std_logic_1164.all;

entity CLKDIV_tb is
end entity CLKDIV_tb;

architecture behavioral of CLKDIV_tb is

    component CLKDIV is
        generic (
            div     :     natural := 50000000
        );
        port (
            clk_in  : in  std_logic;
            clk_out : out std_logic
        );
    end component CLKDIV;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_in_tb          : std_logic;
    signal clk_out_tb         : std_logic;

begin

    UUT: component CLKDIV
    generic map (
        div     => 10
    )
    port map (
        clk_in  => clk_in_tb,
        clk_out => clk_out_tb
    );

    clk_gen: process
    begin
        clk_in_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_in_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        wait for MCLK_PERIOD * 80;
        wait;
    end process stimulus;

end architecture behavioral;
