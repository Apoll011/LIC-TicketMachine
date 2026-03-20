library IEEE;
use IEEE.std_logic_1164.all;

entity Counter is

    port (
        CE    : in  std_logic;
        CLK   : in  std_logic;
        Q     : out std_logic_vector(3 downto 0);
        RESET : in  std_logic
    );

end entity Counter;

architecture logicFuntion of Counter is

    component AdderSubtrator is
        port (
            A         : in  STD_LOGIC_VECTOR(3 downto 0);
            B         : in  STD_LOGIC_VECTOR(3 downto 0);
            CBi, OPau : in  std_logic;
            iCBO      : out std_logic;
            R         : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component AdderSubtrator;

    component Reg is
        port (
            CLK   : in  std_logic;
            RESET : in  STD_LOGIC;
            D     : in  STD_LOGIC_VECTOR(3 downto 0);
            EN    : in  STD_LOGIC;
            Q     : out std_logic_VECTOR(3 downto 0)
        );
    end component Reg;

    signal reg_out : std_logic_vector(3 downto 0);
    signal som_out : std_logic_vector(3 downto 0);

begin

    registo: component Reg
    port map (
        CLK   => CLK,
        RESET => RESET,
        D     => som_out,
        EN    => CE,
        Q     => reg_out
    );
    som: component AdderSubtrator
    port map (
        A     => reg_out,
        B     => "0000",
        R     => som_out,
        CBi   => '1',
        OPau  => '0'
    );

    Q <= reg_out;

end architecture logicFuntion;
