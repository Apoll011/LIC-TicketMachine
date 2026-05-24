library ieee;
use ieee.std_logic_1164.all;

entity MUX4_tb is
end entity MUX4_tb;

architecture behavioral of MUX4_tb is

    component MUX4 is
        port (
            A, B : in  std_logic_vector(3 downto 0);
            OP   : in  std_logic;
            F    : out std_logic_vector(3 downto 0)
        );
    end component MUX4;

    signal A_tb  : std_logic_vector(3 downto 0);
    signal B_tb  : std_logic_vector(3 downto 0);
    signal OP_tb : std_logic;
    signal F_tb  : std_logic_vector(3 downto 0);

begin

    UUT: component MUX4
    port map (
        A  => A_tb,
        B  => B_tb,
        OP => OP_tb,
        F  => F_tb
    );

    stimulus: process
    begin
        A_tb  <= "0000"; B_tb <= "1111"; OP_tb <= '0'; wait for 20 ns;
        A_tb  <= "1010"; B_tb <= "0101"; OP_tb <= '0'; wait for 20 ns;
        A_tb  <= "1010"; B_tb <= "0101"; OP_tb <= '1'; wait for 20 ns;
        A_tb  <= "1111"; B_tb <= "0000"; OP_tb <= '1'; wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
