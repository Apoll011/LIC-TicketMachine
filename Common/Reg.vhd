LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Reg IS
PORT( CLK : in std_logic;
RESET : in STD_LOGIC;
D : IN STD_LOGIC_VECTOR(3 downto 0);
EN : IN STD_LOGIC;
Q : out std_logic_VECTOR(3 downto 0));
END reg;

ARCHITECTURE logicFunction OF Reg IS
component FFD
PORT( CLK : in std_logic;
RESET : in STD_LOGIC;
SET : in std_logic;
D : IN STD_LOGIC;
EN : IN STD_LOGIC;
Q : out std_logic);
end component;

BEGIN
U0: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(0), EN => EN, Q => Q(0));
U1: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(1), EN => EN, Q => Q(1));
U2: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(2), EN => EN, Q => Q(2));
U3: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(3), EN => EN, Q => Q(3));
END LogicFunction;