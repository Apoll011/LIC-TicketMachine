library ieee;
use ieee.std_logic_1164.all;

entity FFD_tb is
end entity FFD_tb;

architecture behavioral of FFD_tb is

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

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal CLK_tb             : std_logic;
    signal RESET_tb           : std_logic;
    signal SET_tb             : std_logic;
    signal D_tb               : std_logic;
    signal EN_tb              : std_logic;
    signal Q_tb               : std_logic;

begin

    UUT: component FFD
    port map (
        CLK   => CLK_tb,
        RESET => RESET_tb,
        SET   => SET_tb,
        D     => D_tb,
        EN    => EN_tb,
        Q     => Q_tb
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
        SET_tb   <= '0';
        EN_tb    <= '0';
        D_tb     <= '0';
        wait for MCLK_PERIOD * 2;
        RESET_tb <= '0';
        EN_tb    <= '1';
        D_tb     <= '1';
        wait for MCLK_PERIOD * 2;
        D_tb     <= '0';
        wait for MCLK_PERIOD * 2;
        EN_tb    <= '0';
        D_tb     <= '1';
        wait for MCLK_PERIOD * 2;
        SET_tb   <= '1';
        wait for MCLK_PERIOD * 1;
        SET_tb   <= '0';
        wait for MCLK_PERIOD * 2;
        RESET_tb <= '1';
        wait for MCLK_PERIOD * 1;
        RESET_tb <= '0';
        wait for MCLK_PERIOD * 2;
        wait;
    end process stimulus;

end architecture behavioral;
