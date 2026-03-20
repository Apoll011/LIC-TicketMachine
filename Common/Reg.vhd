library ieee;
use ieee.std_logic_1164.all;

entity Reg is
    port (
        CLK   : in  std_logic;
        RESET : in  STD_LOGIC;
        D     : in  STD_LOGIC_VECTOR(3 downto 0);
        EN    : in  STD_LOGIC;
        Q     : out std_logic_VECTOR(3 downto 0)
    );
end entity Reg;

architecture logicFunction of Reg is
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
end architecture logicFunction;
