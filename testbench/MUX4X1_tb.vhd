library ieee;
use ieee.std_logic_1164.all;

entity MUX4X1_tb is
end entity MUX4X1_tb;

architecture behavioral of MUX4X1_tb is

    component MUX4X1 is
        port (
            A  : in  std_logic_vector(3 downto 0);
            OP : in  std_logic_vector(1 downto 0);
            F  : out std_logic
        );
    end component MUX4X1;

    signal A_tb  : std_logic_vector(3 downto 0);
    signal OP_tb : std_logic_vector(1 downto 0);
    signal F_tb  : std_logic;

begin

    UUT: component MUX4X1
    port map (
        A  => A_tb,
        OP => OP_tb,
        F  => F_tb
    );

    stimulus: process
    begin
        A_tb  <= "0001";
        OP_tb <= "00";
        wait for 20 ns;
        A_tb  <= "0010";
        OP_tb <= "01";
        wait for 20 ns;
        A_tb  <= "0100";
        OP_tb <= "10";
        wait for 20 ns;
        A_tb  <= "1000";
        OP_tb <= "11";
        wait for 20 ns;
        A_tb  <= "1010";
        OP_tb <= "00";
        wait for 20 ns;
        A_tb  <= "1010";
        OP_tb <= "01";
        wait for 20 ns;
        A_tb  <= "1010";
        OP_tb <= "10";
        wait for 20 ns;
        A_tb  <= "1010";
        OP_tb <= "11";
        wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
