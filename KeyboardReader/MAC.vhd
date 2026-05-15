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
	 
	 component RAMEF is port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        inc, dec    : in  std_logic;
        full, empty : out std_logic
    );
	 end component;

	 signal putI, putIAdder, getI, getIAdder : std_logic_vector(3 downto 0);
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
	
	ef: component RAMEF port map (
		CLK 	=> CLK,
		RESET	=> RESET,
		inc 	=> incPut,
		dec	=> incGet,
		full 	=> full,
		empty => empty
	);

	
end architecture logicFunction;
