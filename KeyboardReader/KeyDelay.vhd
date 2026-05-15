library ieee;
use ieee.std_logic_1164.all;

entity KeyDelay is
    port (
	 CLK, CE, RESET	   : in std_logic;
	 Tdelay					: in std_logic_vector(1 downto 0);
	 F							: out std_logic
    );
end entity KeyDelay;

architecture logicFunction of KeyDelay is

	 component Counter is
    port (
        CE    : in  std_logic;
        CLK   : in  std_logic;
        Q     : out std_logic_vector(3 downto 0);
        RESET : in  std_logic
    );

	 end component Counter;

    component CLKDIV is
        generic (
            div     :     natural := 50000000
        );
        port (
            clk_in  : in  std_logic; -- Entrada do clock div
            clk_out : out std_logic  -- Saída do clock div
        );
    end component CLKDIV;
	
	 component KeyDelayTime is
       port (
            CLK     : in  std_logic;
            Tdelay  : in  std_logic_vector(1 downto 0);
            CLK_Out : out std_logic
        );
    end component KeyDelayTime;

    signal CLK_Divider  : std_logic;
	 signal ClkDelay		: std_logic;
	 signal Q				: std_logic_vector(3 downto 0);

begin

    Clk_div: component CLKDIV
    generic map (
        div => 16
    )
    port map (
        clk_in  => ClkDelay,
        clk_out => CLK_Divider
    );
	 
	 Count: component Counter 
    port map (
        CE    => CE,
        CLK   => ClkDelay,
        Q     => Q,
        RESET => RESET
    );
	 
	 F <= Q(3) and Q(2) and Q(1) and Q(0);
	 
	 DelayTime: component KeyDelayTime
        port map(
            CLK     => CLK,
            Tdelay  => Tdelay,
            CLK_Out => ClkDelay
        );
		  

end architecture logicFunction;
