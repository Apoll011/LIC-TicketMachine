library ieee;
use ieee.std_logic_1164.all;

entity Decoder_tb is
end entity Decoder_tb;

architecture behavioral of Decoder_tb is

    component Decoder is
        port (
            S : in  std_logic_vector(1 downto 0);
            C : out std_logic_vector(3 downto 0)
        );
    end component Decoder;

    signal S_tb : std_logic_vector(1 downto 0);
    signal C_tb : std_logic_vector(3 downto 0);

begin

    UUT: component Decoder
    port map (
        S => S_tb,
        C => C_tb
    );

    stimulus: process
    begin
        S_tb <= "00";
        wait for 20 ns;
        S_tb <= "01";
        wait for 20 ns;
        S_tb <= "10";
        wait for 20 ns;
        S_tb <= "11";
        wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
