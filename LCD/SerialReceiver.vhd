library ieee;
use ieee.std_logic_1164.all;

entity SerialReceiver is
    port (
        SDX, CLK, SS, RESET : in  std_logic;
        Q                   : out std_logic_vector(9 downto 0)
    );
end entity SerialReceiver;

architecture logicFunction of SerialReceiver is

    component ShiftRegister is
        port (
            CLK   : in  std_logic;
            RESET : in  STD_LOGIC;
            S     : in  STD_LOGIC;
            EN    : in  STD_LOGIC;
            Q     : out std_logic_VECTOR(9 downto 0)
        );
    end component ShiftRegister;

    component HoldRegister is
        port (
            CLK   : in  std_logic;
            RESET : in  STD_LOGIC;
            D     : in  STD_LOGIC_VECTOR(9 downto 0);
            EN    : in  STD_LOGIC;
            Q     : out std_logic_VECTOR(9 downto 0)
        );
    end component HoldRegister;

    signal shift_out : std_logic_vector(9 downto 0);
    signal not_SS    : std_logic;
begin

    not_SS <= not SS;

    shift: component ShiftRegister
    port map (
        CLK   => CLK,
        RESET => RESET,
        S     => SDX,
        EN    => not_SS,
        Q     => shift_out
    );

    hold: component HoldRegister
    port map (
        CLK   => CLK,
        RESET => RESET,
        D     => shift_out,
        EN    => SS,
        Q     => Q
    );

end architecture logicFunction;
