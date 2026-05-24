library ieee;
use ieee.std_logic_1164.all;

entity Reg_tb is
end entity Reg_tb;

architecture behavioral of Reg_tb is

    component Reg is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            D     : in  std_logic_vector(3 downto 0);
            EN    : in  std_logic;
            Q     : out std_logic_vector(3 downto 0)
        );
    end component Reg;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal CLK_tb   : std_logic;
    signal RESET_tb : std_logic;
    signal D_tb     : std_logic_vector(3 downto 0);
    signal EN_tb    : std_logic;
    signal Q_tb     : std_logic_vector(3 downto 0);

begin

    UUT: component Reg
    port map (
        CLK   => CLK_tb,
        RESET => RESET_tb,
        D     => D_tb,
        EN    => EN_tb,
        Q     => Q_tb
    );

    clk_gen: process
    begin
        CLK_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        CLK_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        RESET_tb <= '1'; EN_tb <= '0'; D_tb <= "0000"; wait for MCLK_PERIOD * 2;
        RESET_tb <= '0'; EN_tb <= '1'; D_tb <= "1010"; wait for MCLK_PERIOD * 2;
        D_tb <= "0101"; wait for MCLK_PERIOD * 2;
        EN_tb <= '0'; D_tb <= "1111"; wait for MCLK_PERIOD * 2;
        EN_tb <= '1'; D_tb <= "0011"; wait for MCLK_PERIOD * 2;
        RESET_tb <= '1'; wait for MCLK_PERIOD;
        RESET_tb <= '0'; wait for MCLK_PERIOD * 2;
        wait;
    end process stimulus;

end architecture behavioral;
