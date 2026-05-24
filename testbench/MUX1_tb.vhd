library ieee;
use ieee.std_logic_1164.all;

entity MUX1_tb is
end entity MUX1_tb;

architecture behavioral of MUX1_tb is

    component MUX1 is
        port (
            A  : in  std_logic;
            B  : in  std_logic;
            OP : in  std_logic;
            F  : out std_logic
        );
    end component MUX1;

    signal A_tb  : std_logic;
    signal B_tb  : std_logic;
    signal OP_tb : std_logic;
    signal F_tb  : std_logic;

begin

    UUT: component MUX1
    port map (
        A  => A_tb,
        B  => B_tb,
        OP => OP_tb,
        F  => F_tb
    );

    stimulus: process
    begin
        A_tb  <= '0';
        B_tb  <= '0';
        OP_tb <= '0';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '0';
        OP_tb <= '0';
        wait for 20 ns;
        A_tb  <= '0';
        B_tb  <= '1';
        OP_tb <= '0';
        wait for 20 ns;
        A_tb  <= '0';
        B_tb  <= '1';
        OP_tb <= '1';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '0';
        OP_tb <= '1';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '1';
        OP_tb <= '0';
        wait for 20 ns;
        A_tb  <= '1';
        B_tb  <= '1';
        OP_tb <= '1';
        wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
