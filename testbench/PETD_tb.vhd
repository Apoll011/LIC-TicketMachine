library ieee;
use ieee.std_logic_1164.all;

entity PETD_tb is
end entity PETD_tb;

architecture behavioral of PETD_tb is

    component PETD is
        port (
            SDX, CLK, SS, RESET : in  std_logic;
            D                   : out std_logic_vector(7 downto 0);
            Prt, Rt             : out std_logic
        );
    end component PETD;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal reset_tb           : std_logic;
    signal clk_tb             : std_logic;
    signal SDX_tb             : std_logic;
    signal SS_tb              : std_logic;
    signal D_tb               : std_logic_vector(7 downto 0);
    signal Prt_tb             : std_logic;
    signal Rt_tb              : std_logic;

begin

    UUT: component PETD
    port map (
        RESET => reset_tb,
        CLK   => clk_tb,
        SDX   => SDX_tb,
        SS    => SS_tb,
        D     => D_tb,
        Prt   => Prt_tb,
        Rt    => Rt_tb
    );

    clk_gen: process
    begin
        clk_tb   <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb   <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        reset_tb <= '1';
        SS_tb    <= '0';
        SDX_tb   <= '0';
        wait for MCLK_PERIOD * 6;

        reset_tb <= '0';
        wait for MCLK_PERIOD * 4;

        -- Expected: Prt=1, D=0x55, Rt=0
        SS_tb    <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        SS_tb    <= '1';
        wait for MCLK_PERIOD * 2;
        SS_tb    <= '0';
        wait for MCLK_PERIOD;
        wait for MCLK_PERIOD * 4;

        -- Expected: Prt=0, D=0xF0, Rt=1
        SS_tb    <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        SS_tb    <= '1';
        wait for MCLK_PERIOD * 2;
        SS_tb    <= '0';
        wait for MCLK_PERIOD;
        wait for MCLK_PERIOD * 4;

        -- Expected: Prt=1, D=0x00, Rt=1
        SS_tb    <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        wait for MCLK_PERIOD;
        SDX_tb   <= '1';
        wait for MCLK_PERIOD;
        SDX_tb   <= '0';
        SS_tb    <= '1';
        wait for MCLK_PERIOD * 2;
        SS_tb    <= '0';
        wait for MCLK_PERIOD;
        wait for MCLK_PERIOD * 4;

        reset_tb <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb <= '0';
        wait for MCLK_PERIOD * 4;

        wait;
    end process stimulus;

end architecture behavioral;
