library ieee;
use ieee.std_logic_1164.all;

entity RAMEF is
    port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        inc, dec    : in  std_logic;
        full, empty : out std_logic
    );
end entity RAMEF;

architecture structural of RAMEF is

    component Reg is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            D     : in  std_logic_vector(3 downto 0);
            EN    : in  std_logic;
            Q     : out std_logic_vector(3 downto 0)
        );
    end component;

    component AdderSubtrator is
        port (
            A         : in  std_logic_vector(3 downto 0);
            B         : in  std_logic_vector(3 downto 0);
            CBi, OPau : in  std_logic;
            iCBO      : out std_logic;
            R         : out std_logic_vector(3 downto 0)
        );
    end component;

    component MUX4 is
        port (
            A, B : in  std_logic_vector(3 downto 0);
            OP   : in  std_logic;
            F    : out std_logic_vector(3 downto 0)
        );
    end component;

    signal count_q      : std_logic_vector(3 downto 0);
    signal addsub		   : std_logic_vector(3 downto 0);
    signal next_count   : std_logic_vector(3 downto 0);
    signal en_reg       : std_logic;


begin
    U_C: AdderSubtrator
        port map (
            A    => count_q,
            B    => "0001",
            CBi  => '0',
            OPau => dec,
            R    => addsub
    );

    U_MUX_HOLD: MUX4
        port map (
            A  => count_q,
            B  => addsub,
            OP => en_reg,
            F  => next_count
        );

    en_reg <= inc xor dec;

    U_REG: Reg
        port map (
            CLK   => CLK,
            RESET => RESET,
            D     => next_count,
            EN    => en_reg,
            Q     => count_q
        );
	
	
    full  <= count_q(3) and count_q(2) and count_q(1) and count_q(0);
    empty <= (not count_q(3)) and (not count_q(2)) and (not count_q(1)) and (not count_q(0));
end architecture structural;