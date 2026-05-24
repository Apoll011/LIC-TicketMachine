library ieee;
use ieee.std_logic_1164.all;

entity HoldRegister_tb is
end entity HoldRegister_tb;

architecture behavioral of HoldRegister_tb is

    component HoldRegister is
        port (
            CLK   : in  std_logic;
            RESET : in  STD_LOGIC;
            D     : in  STD_LOGIC_VECTOR(9 downto 0);
            EN    : in  STD_LOGIC;
            Q     : out std_logic_VECTOR(9 downto 0)
        );
    end component HoldRegister;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb             : std_logic;
    signal reset_tb           : std_logic;
    signal d_tb               : std_logic_vector(9 downto 0);
    signal en_tb              : std_logic;
    signal q_tb               : std_logic_vector(9 downto 0);

begin

    UUT: component HoldRegister
    port map (
        CLK   => clk_tb,
        RESET => reset_tb,
        D     => d_tb,
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
        d_tb <= (others => '0');
        wait for MCLK_PERIOD * 4;

        reset_tb <= '0';
        d_tb <= "0101010101";
        en_tb <= '1';
        wait for MCLK_PERIOD * 2;

        en_tb <= '0';
        d_tb <= "1111100000";
        wait for MCLK_PERIOD * 3;

        en_tb <= '1';
        wait for MCLK_PERIOD * 2;

        d_tb <= "1000000001";
        wait for MCLK_PERIOD * 2;

        reset_tb <= '1';
        wait for MCLK_PERIOD * 2;
        reset_tb <= '0';
        en_tb <= '1';
        d_tb <= "1111111111";
        wait for MCLK_PERIOD * 2;

        wait;
    end process stimulus;

end architecture behavioral;
