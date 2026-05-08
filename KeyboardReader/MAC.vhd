library ieee;
use ieee.std_logic_1164.all;

entity MAC is
    port (
        CLK   		: in  std_logic;
        RESET 		: in  std_logic;
        putNget	: in  std_logic;
        incPut    : in  std_logic;
		  incGet    : in  std_logic;
        Addr      : out std_logic_vector(3 downto 0);
		  full	   : out  std_logic;
		  empty	   : out  std_logic
    );
end entity MAC;

architecture logicFunction of MAC is
    component Reg is port (
		  CLK   : in  std_logic;
        RESET : in  std_logic;
        D     : in  std_logic_vector(3 downto 0);
        EN    : in  std_logic;
        Q     : out std_logic_vector(3 downto 0)
     );
    end component;
	 
	 component sumador_4bit is port (
        A, B : in  std_logic_vector(3 downto 0);
        R    : out std_logic_vector(3 downto 0);
        Ci   : in  std_logic;
        Co   : out std_logic
     );
    end component;
	 
	 component MUX4 is port (
        A  	: in  std_logic_vector(3 downto 0);
        B  	: in  std_logic_vector(3 downto 0);
        OP 	: in  std_logic;
        F  	: out std_logic_vector(3 downto 0)
		);
	 end component;

	 signal putI, putIAdder, getI, getIAdder : std_logic_vector(3 downto 0);
	 
	 signal putIPlusOne     : std_logic_vector(3 downto 0);
	 signal eqBits          : std_logic_vector(3 downto 0);
	 signal eqBitsFull      : std_logic_vector(3 downto 0);
begin
	
	incPutSum: component sumador_4bit
   port map (
        A  => putI,
        B  => "0000",
        R  => putIAdder,
        Ci => incPut
   );
	putIndex: component Reg
   port map (
        CLK		=> CLK,
        RESET  => RESET,
        D  		=> putIAdder,
        EN		=> '1',
        Q		=> putI
   );
	
	incGetSum: component sumador_4bit
   port map (
        A  => getI,
        B  => "0000",
        R  => getIAdder,
        Ci => incGet
   );
	getIndex: component Reg
   port map (
        CLK		=> CLK,
        RESET  => RESET,
        D  		=> getIAdder,
        EN		=> '1',
        Q		=> getI
   );
	
	m: component MUX4
	port map (
		 A 	=> getI,
		 B		=> putI,
		 OP 	=> putNget,
		 F		=> Addr
	);
	
	 putIPlusOneSum: component sumador_4bit
    port map (
        A  => putI,
        B  => "0000",
        R  => putIPlusOne,
        Ci => '1'
    );

	eqBits(0) <= putI(0) xnor getI(0);
	eqBits(1) <= putI(1) xnor getI(1);
	eqBits(2) <= putI(2) xnor getI(2);
	eqBits(3) <= putI(3) xnor getI(3);
	empty <= eqBits(0) and eqBits(1) and eqBits(2) and eqBits(3);

	eqBitsFull(0) <= putIPlusOne(0) xnor getI(0);
	eqBitsFull(1) <= putIPlusOne(1) xnor getI(1);
	eqBitsFull(2) <= putIPlusOne(2) xnor getI(2);
	eqBitsFull(3) <= putIPlusOne(3) xnor getI(3);
	full <= eqBitsFull(0) and eqBitsFull(1) and eqBitsFull(2) and eqBitsFull(3);
end architecture logicFunction;
