library ieee;
use ieee.std_logic_1164.all;

entity sumador_binario_tb is
end entity sumador_binario_tb;

architecture behavioral of sumador_binario_tb is

    component sumador_binario is
        port (
            A, B, Ci : in  std_logic;
            R        : out std_logic;
            Co       : out std_logic
        );
    end component sumador_binario;

    signal A_tb  : std_logic;
    signal B_tb  : std_logic;
    signal Ci_tb : std_logic;
    signal R_tb  : std_logic;
    signal Co_tb : std_logic;

begin

    UUT: component sumador_binario
    port map (
        A  => A_tb,
        B  => B_tb,
        Ci => Ci_tb,
        R  => R_tb,
        Co => Co_tb
    );

    stimulus: process
    begin
        A_tb  <= '0';
        B_tb  <= '0';
        Ci_tb <= '0';
        wait for 20 ns;
        A_tb  <= '0';
        B_tb  <= '0';
        Ci_tb <= '1';
        wait for 20 ns;
        A_tb  <= '0';
        B_tb  <= '1';
        Ci_tb <= '0';
        wait for 20 ns;
        A_tb  <= '0';
        B_tb  <= '1';
        Ci_tb <= '1';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '0';
        Ci_tb <= '0';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '0';
        Ci_tb <= '1';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '1';
        Ci_tb <= '0';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '1';
        Ci_tb <= '1';
        wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
