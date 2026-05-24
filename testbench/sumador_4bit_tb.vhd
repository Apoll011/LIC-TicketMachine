library ieee;
use ieee.std_logic_1164.all;

entity sumador_4bit_tb is
end entity sumador_4bit_tb;

architecture behavioral of sumador_4bit_tb is

    component sumador_4bit is
        port (
            A, B : in  std_logic_vector(3 downto 0);
            R    : out std_logic_vector(3 downto 0);
            Ci   : in  std_logic;
            Co   : out std_logic
        );
    end component sumador_4bit;

    signal A_tb  : std_logic_vector(3 downto 0);
    signal B_tb  : std_logic_vector(3 downto 0);
    signal Ci_tb : std_logic;
    signal R_tb  : std_logic_vector(3 downto 0);
    signal Co_tb : std_logic;

begin

    UUT: component sumador_4bit
    port map (
        A  => A_tb,
        B  => B_tb,
        R  => R_tb,
        Ci => Ci_tb,
        Co => Co_tb
    );

    stimulus: process
    begin
        A_tb <= "0000"; B_tb <= "0000"; Ci_tb <= '0'; wait for 20 ns;
        A_tb <= "0001"; B_tb <= "0001"; Ci_tb <= '0'; wait for 20 ns;
        A_tb <= "0011"; B_tb <= "0100"; Ci_tb <= '0'; wait for 20 ns;
        A_tb <= "1111"; B_tb <= "0001"; Ci_tb <= '0'; wait for 20 ns;
        A_tb <= "1010"; B_tb <= "0101"; Ci_tb <= '1'; wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
