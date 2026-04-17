library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister is
    port (
        CLK   : in  std_logic;
        RESET : in  STD_LOGIC;
        S     : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        Q     : out std_logic_VECTOR(9 downto 0)
    );
end entity ShiftRegister;

architecture logicFunction of ShiftRegister is

    component FFD is
        port (
            CLK   : in  std_logic;
            RESET : in  STD_LOGIC;
            SET   : in  std_logic;
            D     : in  STD_LOGIC;
            EN    : in  STD_LOGIC;
            Q     : out std_logic
        );
    end component FFD;

    signal D : std_logic_vector(9 downto 0);

begin

    U0: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => S,
        EN    => EN,
        Q     => D(0)
    );
    U1: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(0),
        EN    => EN,
        Q     => D(1)
    );
    U2: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(1),
        EN    => EN,
        Q     => D(2)
    );
    U3: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(2),
        EN    => EN,
        Q     => D(3)
    );
    U4: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(3),
        EN    => EN,
        Q     => D(4)
    );
    U5: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(4),
        EN    => EN,
        Q     => D(5)
    );
    U6: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(5),
        EN    => EN,
        Q     => D(6)
    );
    U7: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(6),
        EN    => EN,
        Q     => D(7)
    );
    U8: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(7),
        EN    => EN,
        Q     => D(8)
    );
    U9: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(8),
        EN    => EN,
        Q     => D(9)
    );

    Q <= D;

end architecture logicFunction;
