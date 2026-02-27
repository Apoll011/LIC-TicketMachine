LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity sumador_binario is

	Port(A,B,Ci: in std_logic; 
        R : out std_logic;  
        Co : out std_logic);
	 end sumador_binario;

architecture teste of sumador_binario is
begin

R <= A xor B xor Ci;

Co <= (A and B) or (Ci and (A xor B ));
        
end teste;