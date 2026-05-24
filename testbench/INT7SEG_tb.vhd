library ieee;
use ieee.std_logic_1164.all;

entity INT7SEG_tb is
end entity INT7SEG_tb;

architecture behavioral of INT7SEG_tb is

    component INT7SEG is
        port (
            d    : in  std_logic_vector(3 downto 0);
            ewr  : in  std_logic_vector(7 downto 0);
            dOut : out std_logic_vector(7 downto 0)
        );
    end component INT7SEG;

    signal d_tb    : std_logic_vector(3 downto 0);
    signal ewr_tb  : std_logic_vector(7 downto 0);
    signal dOut_tb : std_logic_vector(7 downto 0);

begin

    UUT: component INT7SEG
    port map (
        d    => d_tb,
        ewr  => ewr_tb,
        dOut => dOut_tb
    );

    stimulus: process
    begin
        ewr_tb <= "11111111";
        d_tb   <= "0000";
        wait for 20 ns;
        d_tb   <= "0001";
        wait for 20 ns;
        d_tb   <= "1010";
        wait for 20 ns;
        d_tb   <= "1111";
        wait for 20 ns;

        -- override direto por ewr
        ewr_tb <= "00110011";
        wait for 20 ns;
        ewr_tb <= "11111111";
        d_tb   <= "0101";
        wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
