library ieee;
use ieee.std_logic_1164.all;

entity KeyDelay is
    port (
        CLK, CE, RESET : in  std_logic;
        Tdelay         : in  std_logic_vector(1 downto 0);
        F              : out std_logic
    );
end entity KeyDelay;

architecture logicFunction of KeyDelay is
	 
    component Counter is
        port (
            CE    : in  std_logic;
            CLK   : in  std_logic;
            Q     : out std_logic_vector(3 downto 0);
            RESET : in  std_logic;
				CBO	: out std_logic
        );
    end component Counter;

    component MUX4X1 is
        port (
            A  : in  std_logic_vector(3 downto 0);
            OP : in  std_logic_vector(1 downto 0);
            F  : out std_logic
        );
    end component MUX4X1;	
	
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

    signal Q, Y        : std_logic_vector(3 downto 0);
	 signal CBO, C		  : std_logic;
	 
	 signal TD_00,TD_01,TD_10,TD_11 :std_logic;
	 
begin

    Count: component Counter
    port map (
        CE      => CE,
        CLK     => CLK,
        Q       => Q,
        RESET   => RESET,
		  CBO 	 => CBO

    );
	 
	 Count11: component Counter
    port map (
        CE      => C,
        CLK     => CLK,
        Q       => Y,
        RESET   => RESET
    );
	 
	 alavanca: component FFD
    port map (
        CLK   => CLK,
        RESET => RESET,
        set   => '0',
        D     => '1',
        EN    => CBO,
        Q     => C
    );
	 
    mux: component MUX4X1
    port map (
        A(0)    => TD_00,
        A(1)    => TD_01,
        A(2)    => TD_10,
        A(3)    => TD_11,
        OP      => Tdelay,
        F       => F
    );

	 TD_00 <= not Q(3) and Q(2) and not Q(1) and Q(0);
	 TD_01 <= Q(3) and not Q(2) and Q(1) and not Q(0);
	 TD_10 <= Q(3) and Q(2) and Q(1) and Q(0);
	 TD_11 <= not Y(3) and Y(2) and not Y(1) and not Y(0);
	 
end architecture logicFunction;
