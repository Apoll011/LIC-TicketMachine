library IEEE;
use IEEE.std_logic_1164.all;

entity EdgeDetect is
    port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;
        SIG_IN : in  std_logic;
        RISE   : out std_logic
    );
end entity EdgeDetect;

architecture logicFunction of EdgeDetect is

    component FFD is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            SET   : in  std_logic;
            D     : in  std_logic;
            EN    : in  std_logic;
            Q     : out std_logic
        );
    end component FFD;

    signal prev : std_logic;

begin

    FF: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        SET   => '0',
        D     => SIG_IN,
        EN    => '1',
        Q     => prev
    );

    RISE <= SIG_IN and (not prev);

end architecture logicFunction;