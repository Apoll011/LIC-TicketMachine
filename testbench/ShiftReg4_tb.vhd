library ieee;
use ieee.std_logic_1164.all;

entity ShiftReg4_tb is
end entity ShiftReg4_tb;

architecture behavioral of ShiftReg4_tb is

    component ShiftReg4 is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            LOAD  : in  std_logic;
            EN    : in  std_logic;
            D     : in  std_logic_vector(3 downto 0);
            Q_out : out std_logic
        );
    end component ShiftReg4;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal CLK_tb             : std_logic;
    signal RESET_tb           : std_logic;
    signal LOAD_tb            : std_logic;
    signal EN_tb              : std_logic;
    signal D_tb               : std_logic_vector(3 downto 0);
    signal Q_out_tb           : std_logic;

begin

    UUT: component ShiftReg4
    port map (
        CLK   => CLK_tb,
        RESET => RESET_tb,
        LOAD  => LOAD_tb,
        EN    => EN_tb,
        D     => D_tb,
        Q_out => Q_out_tb
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
        LOAD_tb  <= '0';
        EN_tb    <= '0';
        D_tb     <= "0000";
        wait for MCLK_PERIOD * 2;
        RESET_tb <= '0';
        EN_tb    <= '1';
        LOAD_tb  <= '1';
        D_tb     <= "1011";
        wait for MCLK_PERIOD * 2;

        LOAD_tb  <= '0';
        wait for MCLK_PERIOD * 6;

        EN_tb    <= '0';
        wait for MCLK_PERIOD * 2;
        EN_tb    <= '1';
        LOAD_tb  <= '1';
        D_tb     <= "0101";
        wait for MCLK_PERIOD * 2;
        LOAD_tb  <= '0';
        wait for MCLK_PERIOD * 4;
        wait;
    end process stimulus;

end architecture behavioral;
