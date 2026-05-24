library ieee;
use ieee.std_logic_1164.all;

entity DecoderBuffer_tb is
end entity DecoderBuffer_tb;

architecture behavioral of DecoderBuffer_tb is

    component DecoderBuffer is
        port (
            S : in  std_logic_vector(3 downto 0);
            C : out std_logic_vector(15 downto 0)
        );
    end component DecoderBuffer;

    signal S_tb : std_logic_vector(3 downto 0);
    signal C_tb : std_logic_vector(15 downto 0);

begin

    UUT: component DecoderBuffer
    port map (
        S => S_tb,
        C => C_tb
    );

    stimulus: process
    begin
        S_tb <= "0000"; wait for 20 ns;
        S_tb <= "0001"; wait for 20 ns;
        S_tb <= "0011"; wait for 20 ns;
        S_tb <= "0111"; wait for 20 ns;
        S_tb <= "1111"; wait for 20 ns;
        wait;
    end process stimulus;

end architecture behavioral;
