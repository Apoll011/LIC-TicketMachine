library ieee;
use ieee.std_logic_1164.all;

entity HoldRegister is
    port (
        CLK   : in  std_logic;
        RESET : in  STD_LOGIC;
        D     : in  STD_LOGIC_VECTOR(9 downto 0);
        EN    : in  STD_LOGIC;
        Q     : out std_logic_VECTOR(9 downto 0)
    );
end entity HoldRegister;

architecture logicFunction of HoldRegister is

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

begin

    U0: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(0),
        EN    => EN,
        Q     => Q(0)
    );
    U1: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(1),
        EN    => EN,
        Q     => Q(1)
    );
    U2: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(2),
        EN    => EN,
        Q     => Q(2)
    );
    U3: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(3),
        EN    => EN,
        Q     => Q(3)
    );
    U4: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(4),
        EN    => EN,
        Q     => Q(4)
    );
    U5: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(5),
        EN    => EN,
        Q     => Q(5)
    );
    U6: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(6),
        EN    => EN,
        Q     => Q(6)
    );
    U7: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(7),
        EN    => EN,
        Q     => Q(7)
    );
    U8: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(8),
        EN    => EN,
        Q     => Q(8)
    );
    U9: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => D(9),
        EN    => EN,
        Q     => Q(9)
    );

end architecture logicFunction;
