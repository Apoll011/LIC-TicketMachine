library IEEE;
use IEEE.std_logic_1164.all;

entity Key_Scan is

    port (
        Kscan, CLK, RESET : in  std_logic;
        Keys_Vertical     : out std_logic_vector(3 downto 0);
        Keys_Horizontal   : in  std_logic_vector(3 downto 0);
        K                 : out std_logic_vector(3 downto 0);
        Kpress            : out std_logic
    );

end entity Key_Scan;

architecture scan of Key_Scan is

    component Counter is
        port (
            CE    : in  std_logic;
            CLK   : in  std_logic;
            Q     : out std_logic_vector(3 downto 0);
            RESET : in  std_logic
        );
    end component Counter;

    component Decoder is
        port (
            S : in  std_logic_vector(1 downto 0);
            C : out std_logic_vector(3 downto 0)
        );
    end component Decoder;

    component MUX4X1 is
        port (
            A  : in  std_logic_vector(3 downto 0);
            OP : in  std_logic_vector(1 downto 0);
            F  : out std_logic
        );
    end component MUX4X1;

    signal counter_out, not_c : std_logic_vector(3 downto 0);

    signal not_k_press        : std_logic;
begin

    Kcounter: component Counter
    port map (
        CLK   => CLK,
        RESET => RESET,
        CE    => Kscan,
        Q     => counter_out
    );

    mux: component MUX4X1
    port map (
        A     => Keys_Horizontal,
        OP    => counter_out(1 downto 0),
        F     => not_k_press
    );

    SKdecoder: component Decoder
    port map (
        S     => counter_out(3 downto 2),
        C     => not_c
    );

    Kpress        <= not not_k_press;
    Keys_Vertical <= not not_c;
    K             <= counter_out;

end architecture scan;
