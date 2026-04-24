library ieee;
use ieee.std_logic_1164.all;

entity Key_Decode is
    port (
        Kack, RESET, CLK : in  std_logic;
        Tdelay           : in  std_logic_vector(1 downto 0);
        Kval		       : out std_logic;
        K                : out std_logic_vector(3 downto 0);
        Keys_Vertical    : out std_logic_vector(3 downto 0);
        Keys_Horizontal  : in  std_logic_vector(3 downto 0)
    );
end entity Key_Decode;

architecture logicFunction of Key_Decode is

    component Key_Control is
        port (
            Kack, Kpress, RESET, CLK : in  std_logic;
            Tdelay                   : in  std_logic_vector(1 downto 0);
            Kval, Kscan			       : out std_logic
        );
    end component Key_Control;

    component Key_Scan is
        port (
            Kscan, CLK, RESET : in  std_logic;
            Keys_Vertical     : out std_logic_vector(3 downto 0);
            Keys_Horizontal   : in  std_logic_vector(3 downto 0);
            K                 : out std_logic_vector(3 downto 0);
            Kpress            : out std_logic
        );
    end component Key_Scan;

    component CLKDIV is
        generic (
            div     :     natural := 50000000
        );
        port (
            clk_in  : in  std_logic; -- Entrada do clock div
            clk_out : out std_logic  -- Saída do clock div
        );
    end component CLKDIV;


    signal Kpress, Kscan, CLK_Divider : std_logic;

begin
    scan: component Key_Scan
    port map (
        RESET           => RESET,
        CLK             => CLK_Divider,
        Kpress          => Kpress,
        K               => K,
        Kscan           => Kscan,
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal
    );

    control: component Key_Control
    port map (
        RESET           => RESET,
        CLK             => CLK_Divider,
        Kpress          => Kpress,
        Kack            => Kack,
        Tdelay          => Tdelay,
        Kval            => Kval,
        Kscan           => Kscan
    );

    Clk_div: component CLKDIV
    generic map (
        50
    )
    port map (
        clk_in          => CLK,
        clk_out         => CLK_Divider
    );


end architecture logicFunction;
