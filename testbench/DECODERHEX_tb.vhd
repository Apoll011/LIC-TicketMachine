library ieee;
use ieee.std_logic_1164.all;

entity DECODERHEX_tb is
end entity DECODERHEX_tb;

architecture behavioral of DECODERHEX_tb is

    component DECODERHEX is
        port (
            A     : in  std_logic_vector(3 downto 0);
            ewr   : in  std_logic_vector(7 downto 0);
            clear : in  std_logic;
            HEX0  : out std_logic_vector(7 downto 0)
        );
    end component DECODERHEX;

    signal A_tb     : std_logic_vector(3 downto 0);
    signal ewr_tb   : std_logic_vector(7 downto 0);
    signal clear_tb : std_logic;
    signal HEX0_tb  : std_logic_vector(7 downto 0);

begin

    UUT: component DECODERHEX
    port map (
        A     => A_tb,
        ewr   => ewr_tb,
        clear => clear_tb,
        HEX0  => HEX0_tb
    );

    stimulus: process
    begin
        clear_tb <= '0'; ewr_tb <= "11111111"; A_tb <= "0000"; wait for 20 ns;
        A_tb <= "1001"; wait for 20 ns;
        A_tb <= "1111"; wait for 20 ns;

        -- ewr override
        ewr_tb <= "01010101"; wait for 20 ns;
        ewr_tb <= "11111111"; A_tb <= "0011"; wait for 20 ns;

        -- clear força display apagado
        clear_tb <= '1'; wait for 20 ns;
        clear_tb <= '0'; wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
