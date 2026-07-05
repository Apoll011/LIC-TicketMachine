library ieee;
use ieee.std_logic_1164.all;

entity KeyDelay_tb is
end entity KeyDelay_tb;

architecture behavioral of KeyDelay_tb is

	 component KeyDelay is
    port (
        CLK, CE, RESET : in  std_logic;
        Tdelay         : in  std_logic_vector(1 downto 0);
        F              : out std_logic
    );
	 end component KeyDelay;

    constant MCLK_PERIOD      : time := 100 ms;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb, ce_tb, reset_tb 	: std_logic;
    signal Tdelay_tb          		: std_logic_vector(1 downto 0);
    signal F_tb        				   : std_logic;

begin

    UUT: component KeyDelay
    port map (
        CLK     => clk_tb,
		  CE		 => ce_tb,
		  RESET	 => reset_tb,
        Tdelay  => Tdelay_tb,
        F => F_tb
    );

    clk_gen: process
    begin
        clk_tb    <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb    <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
	 ce_tb <= '1';
	 reset_tb <= '1';
	 wait for MCLK_PERIOD;
	
		 
        -- Tdelay="00": 5  cycles = 500  ms
        Tdelay_tb <= "00";
		  reset_tb <= '0';
        wait for MCLK_PERIOD * 10;
		  reset_tb <= '1';
		  wait for MCLK_PERIOD;
	 
        -- Tdelay="01": 10 cycles = 1000 ms
        Tdelay_tb <= "01";
		  reset_tb <= '0';
        wait for MCLK_PERIOD * 15;
		  reset_tb <= '1';
		  wait for MCLK_PERIOD;
		  
        -- Tdelay="10": 15 cycles = 1500 ms
        Tdelay_tb <= "10";
		  reset_tb <= '0';
        wait for MCLK_PERIOD * 20;
		  reset_tb <= '1';
		  wait for MCLK_PERIOD;
		  
        -- Tdelay="11": 20 cycles = 2000 ms
        Tdelay_tb <= "11";
		  reset_tb <= '0';
        wait for MCLK_PERIOD * 25;
		  reset_tb <= '1';
		  wait for MCLK_PERIOD;

        wait;
    end process stimulus;

    -- 11 s

end architecture behavioral;
