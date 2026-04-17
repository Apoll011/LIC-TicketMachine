library ieee;
use ieee.std_logic_1164.all;

entity Key_Control is
    port (
        Kack, Kpress, RESET, CLK : in  std_logic;
        Tdelay                   : in  std_logic_vector(1 downto 0);
        Kval, Kscan  ,clko            : out std_logic
    );
end entity Key_Control;

architecture logicFunction of Key_Control is

    component KeyDecoderFSM is
        port (
            reset        : in  std_logic;
            clk          : in  std_logic;
            Kpress, Kack : in  std_logic;
            Tdelay       : in  std_logic_vector(1 downto 0);
            Kval, Kscan ,clko : out std_logic
        );
    end component KeyDecoderFSM;

begin

    fsm: component KeyDecoderFSM
    port map (
        reset  => RESET,
        clk    => CLK,
        Kpress => Kpress,
        Kack   => Kack,
        Tdelay => Tdelay,
		  clko	=> clko,
        Kval   => Kval,
        Kscan  => Kscan
    );
end architecture logicFunction;
