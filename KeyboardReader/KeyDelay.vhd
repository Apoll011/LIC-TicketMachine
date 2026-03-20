library ieee;
use ieee.std_logic_1164.all;

entity KeyDelay is
    port (
        CLK     : in  std_logic;
        Tdelay  : in  std_logic_vector(1 downto 0);
        CLK_Out : out std_logic
    );
end entity KeyDelay;

architecture logicFunction of KeyDelay is

    component MUX4X1 is
        port (
            A  : in  std_logic_vector(3 downto 0);
            OP : in  std_logic_vector(1 downto 0);
            F  : out std_logic
        );
    end component MUX4X1;

    component CLKDIV is
        generic (
            div     :     natural := 50000000
        );
        port (
            clk_in  : in  std_logic; -- Entrada do clock div
            clk_out : out std_logic  -- Saída do clock div
        );
    end component CLKDIV;


    signal CLK_Divider_00, CLK_Divider_01, CLK_Divider_10, CLK_Divider_11 : std_logic;

begin

    Clk_div_00: component CLKDIV
    generic map (
        500000
    )
    port map (
        clk_in  => CLK,
        clk_out => CLK_Divider_00
    );

    Clk_div_01: component CLKDIV
    generic map (
        1000000
    )
    port map (
        clk_in  => CLK,
        clk_out => CLK_Divider_01
    );

    Clk_div_10: component CLKDIV
    generic map (
        1500000
    )
    port map (
        clk_in  => CLK,
        clk_out => CLK_Divider_10
    );

    Clk_div_11: component CLKDIV
    generic map (
        2000000
    )
    port map (
        clk_in  => CLK,
        clk_out => CLK_Divider_11
    );

    mux: component MUX4X1
    port map (
        A(0)    => CLK_Divider_00,
        A(1)    => CLK_Divider_01,
        A(2)    => CLK_Divider_10,
        A(3)    => CLK_Divider_11,
        OP      => Tdelay,
        F       => CLK_Out
    );

end architecture logicFunction;
