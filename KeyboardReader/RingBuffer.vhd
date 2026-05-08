library ieee;
use ieee.std_logic_1164.all;

entity RingBuffer is
    port (
        CLK   		: in  std_logic;
		  RESET 		: in  std_logic;
        CTS 		: in  std_logic;
		  DAV 		: in  std_logic;
		  D	      : in std_logic_vector(3 downto 0);
        Q	      : out std_logic_vector(3 downto 0);
		  Wreg	   : out  std_logic;
		  DAC		   : out  std_logic
    );
end entity RingBuffer;

architecture logicFunction of RingBuffer is
    component MAC is port (
		  CLK   		: in  std_logic;
        RESET 		: in  std_logic;
        putNget	: in  std_logic;
        incPut    : in  std_logic;
		  incGet    : in  std_logic;
        Addr      : out std_logic_vector(3 downto 0);
		  full	   : out  std_logic;
		  empty	   : out  std_logic
     );
    end component;
	 
	 component RAM is	port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;
        address : in  std_logic_vector(3 downto 0);
        wr      : in  std_logic;
        din     : in  std_logic_vector(3 downto 0);
        dout    : out std_logic_vector(3 downto 0)
     );
    end component;
	 

	 signal addrRam : std_logic_vector(3 downto 0);
	 
	 signal fullS, emptyS, incPutS, incGetS, putNgetS, wrS 	: std_logic;
begin
	
	memControl: component MAC
   port map (
        CLK  	=> CLK,
        RESET  => RESET,
        putNget=> putNgetS,
        incPut => incPutS,
		  incGet	=> incGetS,
		  Addr	=> addrRam,
		  full 	=> fullS,
		  empty 	=> emptyS
   );
	
	mem: component RAM
   port map (
		  CLK  	=> CLK,
        RESET  => RESET,
        address=> addrRam,
        wr		=> wrS,
        din		=> D,
		  dout	=> Q
   );
end architecture logicFunction;
