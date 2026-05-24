library ieee;
use ieee.std_logic_1164.all;

entity Counter_tb is
end entity Counter_tb;

architecture behavioral of Counter_tb is

    component Counter is
        port (
            CE    : in  std_logic;
            CLK   : in  std_logic;
            Q     : out std_logic_vector(3 downto 0);
            RESET : in  std_logic
        );
    end component Counter;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal CE_tb              : std_logic;
    signal CLK_tb             : std_logic;
    signal RESET_tb           : std_logic;
    signal Q_tb               : std_logic_vector(3 downto 0);

begin

    UUT: component Counter
    port map (
        CE    => CE_tb,
        CLK   => CLK_tb,
        Q     => Q_tb,
        RESET => RESET_tb
    );

    clk_gen: process
    begin
        CLK_tb   <= '0';
        wait for MCLK_HALF_PERIOD;
        CLK_tb   <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        RESET_tb <= '1';
        CE_tb    <= '0';
        wait for MCLK_PERIOD * 2;
        RESET_tb <= '0';
        CE_tb    <= '1';
        wait for MCLK_PERIOD * 8;
        CE_tb    <= '0';
        wait for MCLK_PERIOD * 4;
        CE_tb    <= '1';
        wait for MCLK_PERIOD * 6;
        RESET_tb <= '1';
        wait for MCLK_PERIOD;
        RESET_tb <= '0';
        wait for MCLK_PERIOD * 4;
        wait;
    end process stimulus;

end architecture behavioral;
