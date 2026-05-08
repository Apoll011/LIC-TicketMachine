library IEEE;
use IEEE.std_logic_1164.all;

entity DecoderBuffer is
    port (
        S : in  std_logic_vector(3 downto 0);
        C : out std_logic_vector(15 downto 0)
    );
end entity DecoderBuffer;

architecture decoder of DecoderBuffer is
begin
    C(0)  <= not S(3) and not S(2) and not S(1) and not S(0);
    C(1)  <= not S(3) and not S(2) and not S(1) and S(0);
    C(2)  <= not S(3) and not S(2) and S(1) and not S(0);
    C(3)  <= not S(3) and not S(2) and S(1) and S(0);
	 
    C(4)  <= not S(3) and S(2) and not S(1) and not S(0);
    C(5)  <= not S(3) and S(2) and not S(1) and S(0);
    C(6)  <= not S(3) and S(2) and S(1) and not S(0);
    C(7)  <= not S(3) and S(2) and S(1) and S(0);	 
	 
    C(8)  <= S(3) and not S(2) and not S(1) and not S(0);
    C(9)  <= S(3) and not S(2) and not S(1) and S(0);
    C(10) <= S(3) and not S(2) and S(1) and not S(0);
    C(11) <= S(3) and not S(2) and S(1) and S(0);	 
	 
    C(12) <= S(3) and S(2) and not S(1) and not S(0);
    C(13) <= S(3) and S(2) and not S(1) and S(0);
    C(14) <= S(3) and S(2) and S(1) and not S(0);
    C(15) <= S(3) and S(2) and S(1) and S(0);	 	 
	 
end architecture decoder;
