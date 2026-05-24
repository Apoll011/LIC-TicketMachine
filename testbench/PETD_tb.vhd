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
        clk_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process

        procedure send_serial(data : std_logic_vector(9 downto 0)) is
        begin
            SS_tb <= '0';
            wait for MCLK_PERIOD;
            for i in 0 to 9 loop
                SDX_tb <= data(i);
                wait for MCLK_PERIOD;
            end loop;
            SDX_tb <= '0';
            SS_tb <= '1';
            wait for MCLK_PERIOD * 2;
            SS_tb <= '0';
            wait for MCLK_PERIOD;
        end procedure send_serial;

    begin
        reset_tb <= '1';
        SS_tb <= '0';
        SDX_tb <= '0';
        wait for MCLK_PERIOD * 6;

        reset_tb <= '0';
        wait for MCLK_PERIOD * 4;

        -- [Prt=1][D=01010101][Rt=0]
        send_serial("0010101011");
        wait for MCLK_PERIOD * 4;

        -- [Prt=0][D=11110000][Rt=1]
        send_serial("1100001110");
        wait for MCLK_PERIOD * 4;

        -- [Prt=1][D=00000000][Rt=1]
        send_serial("1000000001");
        wait for MCLK_PERIOD * 4;

        reset_tb <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb <= '0';
        wait for MCLK_PERIOD * 4;

        wait;
    end process stimulus;

end architecture behavioral;
