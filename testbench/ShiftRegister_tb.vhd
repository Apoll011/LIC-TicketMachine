library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister_tb is
end entity ShiftRegister_tb;

architecture behavioral of ShiftRegister_tb is

    component ShiftRegister is
        port (
            CLK   : in  std_logic;
            RESET : in  STD_LOGIC;
            S     : in  STD_LOGIC;
            EN    : in  STD_LOGIC;
            Q     : out std_logic_VECTOR(9 downto 0)
        );
    end component ShiftRegister;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb             : std_logic;
    signal reset_tb           : std_logic;
    signal s_tb               : std_logic;
    signal en_tb              : std_logic;
    signal q_tb               : std_logic_vector(9 downto 0);

begin

    UUT: component ShiftRegister
    port map (
        CLK   => clk_tb,
        RESET => reset_tb,
        S     => s_tb,
        EN    => en_tb,
        Q     => q_tb
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
        reset_tb <= '1';
        en_tb <= '0';
        s_tb <= '0';
        wait for MCLK_PERIOD * 4;

        reset_tb <= '0';
        en_tb <= '1';
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0';
        wait for MCLK_PERIOD;
        wait for MCLK_PERIOD * 2;

        en_tb <= '0';
        s_tb <= '1';
        wait for MCLK_PERIOD * 4;

        en_tb <= '1';
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0';
        wait for MCLK_PERIOD;
        wait for MCLK_PERIOD * 2;

        reset_tb <= '1';
        wait for MCLK_PERIOD * 2;
        reset_tb <= '0';
        en_tb <= '1';
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '0'; wait for MCLK_PERIOD;
        s_tb <= '1'; wait for MCLK_PERIOD;
        s_tb <= '0';
        wait for MCLK_PERIOD;
        wait for MCLK_PERIOD * 2;

        wait;
    end process stimulus;

end architecture behavioral;
