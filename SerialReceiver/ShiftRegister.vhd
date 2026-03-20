LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ShiftRegister IS
PORT( CLK : in std_logic;
RESET : in STD_LOGIC;
S : IN STD_LOGIC;
EN : IN STD_LOGIC;
Q : out std_logic_VECTOR(9 downto 0));
END ShiftRegister;

ARCHITECTURE logicFunction OF ShiftRegister IS

component FFD
PORT( CLK : in std_logic;
RESET : in STD_LOGIC;
SET : in std_logic;
D : IN STD_LOGIC;
EN : IN STD_LOGIC;
Q : out std_logic);
end component;

signal D : std_logic_vector(9 downto 0);

BEGIN

U0: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => S	, EN => EN, Q => D(0));
U1: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(0), EN => EN, Q => D(1));
U2: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(1), EN => EN, Q => D(2));
U3: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(2), EN => EN, Q => D(3));
U4: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(3), EN => EN, Q => D(4));
U5: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(4), EN => EN, Q => D(5));
U6: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(5), EN => EN, Q => D(6));
U7: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(6), EN => EN, Q => D(7));
U8: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(7), EN => EN, Q => D(8));
U9: FFD port map(CLK => CLK, RESET => RESET, set => '0', D => D(8), EN => EN, Q => D(9));

Q <= D;

END LogicFunction;