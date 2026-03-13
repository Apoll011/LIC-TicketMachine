library ieee;
use ieee.std_logic_1164.all;

entity Key_Control IS
    port(
        Kack, Kpress, RESET, CLK   : in  std_logic;
        Tdelay                     : in  std_logic_vector(1 downto 0);
        Kval, Kscan                : out std_logic
    );
end Key_Control;

architecture logicFunction of Key_Control is

    component KeyDecode_FSM
    port(
        reset           : in  std_logic;
        clk             : in  std_logic;
        Kpress, Kack    : in  std_logic;
        Tdelay          : in  std_logic_vector(1 downto 0);
        Kval, Kscan     : out std_logic
    );
    end component;

    signal k_val : std_logic;

begin

    fsm: KeyDecode_FSM port map (
        reset   => RESET,
        clk     => CLK,
        Kpress  => Kpress,
        Kack    => Kack,
        Tdelay  => Tdelay,
        Kval    => Kval,
		  Kscan   => Kscan
    );
end logicFunction;