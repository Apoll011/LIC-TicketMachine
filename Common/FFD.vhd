library ieee;
use ieee.std_logic_1164.all;

entity FFD is
    port (
        CLK   : in  std_logic;
        RESET : in  STD_LOGIC;
        SET   : in  std_logic;
        D     : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        Q     : out std_logic
    );
end entity FFD;

architecture logicFunction of FFD is

begin
    Q <= '0' when RESET = '1' else '1' when SET = '1' else D when rising_edge(clk) and EN = '1';
end architecture logicFunction;
