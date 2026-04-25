library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- Mux8x3
--
-- 8-to-1 multiplexer with a 3-bit select.
-- Selects one bit from input vector A based on S.
--
--   S = "000" -> O = A(0)
--   S = "001" -> O = A(1)
--   ...
--   S = "111" -> O = A(7)
-- ============================================================

entity Mux8x3 is

    port (
        A : in  STD_LOGIC_VECTOR(7 downto 0);
        S : in  STD_LOGIC_VECTOR(2 downto 0);
        O : out STD_LOGIC
    );

end entity Mux8x3;

architecture logicFunction of Mux8x3 is

begin

    O <= (A(0) and not S(2) and not S(1) and not S(0)) or
         (A(1) and not S(2) and not S(1) and     S(0)) or
         (A(2) and not S(2) and     S(1) and not S(0)) or
         (A(3) and not S(2) and     S(1) and     S(0)) or
         (A(4) and     S(2) and not S(1) and not S(0)) or
         (A(5) and     S(2) and not S(1) and     S(0)) or
         (A(6) and     S(2) and     S(1) and not S(0)) or
         (A(7) and     S(2) and     S(1) and     S(0));

end architecture logicFunction;