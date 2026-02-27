LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity sumador_4bit is
Port ( A,B : in  STD_LOGIC_VECTOR (3 downto 0);
R : out  STD_LOGIC_VECTOR (3 downto 0);
Ci : in  STD_LOGIC;
Co: out STD_LOGIC);
end sumador_4bit;

architecture teste of sumador_4bit is
	
component sumador_binario is
port (A, B: in STD_LOGIC;
Ci : in  STD_LOGIC;
R : out STD_LOGIC;
Co: out STD_LOGIC);
end component;    
signal
C : STD_LOGIC_VECTOR (4 downto 0);
begin
C(0) <= Ci;

u1: sumador_binario port map (A => A(0), B => B(0), R => R(0), Ci => C(0) , Co => C(1));
u2: sumador_binario port map (A => A(1), B => B(1), R => R(1), Ci => C(1) , Co => C(2));
u3: sumador_binario port map (A => A(2), B => B(2), R => R(2), Ci => C(2) , Co => C(3));
u4: sumador_binario port map (A => A(3), B => B(3), R => R(3), Ci => C(3) , Co => C(4));

Co <= C(4);

end teste;