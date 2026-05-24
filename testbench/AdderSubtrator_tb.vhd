library ieee;
use ieee.std_logic_1164.all;

entity AdderSubtrator_tb is
end entity AdderSubtrator_tb;

architecture behavioral of AdderSubtrator_tb is

    component AdderSubtrator is
        port (
            A         : in  std_logic_vector(3 downto 0);
            B         : in  std_logic_vector(3 downto 0);
            CBi, OPau : in  std_logic;
            iCBO      : out std_logic;
            R         : out std_logic_vector(3 downto 0)
        );
    end component AdderSubtrator;

    signal A_tb    : std_logic_vector(3 downto 0);
    signal B_tb    : std_logic_vector(3 downto 0);
    signal CBi_tb  : std_logic;
    signal OPau_tb : std_logic;
    signal iCBO_tb : std_logic;
    signal R_tb    : std_logic_vector(3 downto 0);

begin

    UUT: component AdderSubtrator
    port map (
        A    => A_tb,
        B    => B_tb,
        CBi  => CBi_tb,
        OPau => OPau_tb,
        iCBO => iCBO_tb,
        R    => R_tb
    );

    stimulus: process
    begin
        -- soma
        A_tb    <= "0011";
        B_tb    <= "0001";
        CBi_tb  <= '0';
        OPau_tb <= '0';
        wait for 20 ns;
        A_tb    <= "1111";
        B_tb    <= "0001";
        CBi_tb  <= '0';
        OPau_tb <= '0';
        wait for 20 ns;

        -- subtracao (A - B)
        A_tb    <= "0101";
        B_tb    <= "0011";
        CBi_tb  <= '1';
        OPau_tb <= '1';
        wait for 20 ns;
        A_tb    <= "0011";
        B_tb    <= "0101";
        CBi_tb  <= '1';
        OPau_tb <= '1';
        wait for 20 ns;

        -- subtracao com borrow in
        A_tb    <= "1000";
        B_tb    <= "0001";
        CBi_tb  <= '0';
        OPau_tb <= '1';
        wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
