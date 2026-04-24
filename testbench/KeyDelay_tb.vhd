library ieee;
use ieee.std_logic_1164.all;

entity KeyDelay_tb is
end entity KeyDelay_tb;

architecture behavioral of KeyDelay_tb is

    component KeyDelay is
        port (
            CLK     : in  std_logic;
            Tdelay  : in  std_logic_vector(1 downto 0);
            CLK_Out : out std_logic
        );
    end component KeyDelay;

    -- 1 ns clock: dividers fire in microseconds, not milliseconds
    constant MCLK_PERIOD      : time := 1 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb             : std_logic;
    signal Tdelay_tb          : std_logic_vector(1 downto 0);
    signal CLKOut_tb          : std_logic;

begin

    UUT: component KeyDelay
    port map (
        CLK     => clk_tb,
        Tdelay  => Tdelay_tb,
        CLK_Out => CLKOut_tb
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
        -- Tdelay="00": CLK_Out period = 500000 cycles = 500 us at 1ns clk
        Tdelay_tb <= "00";
        wait for 1200 us;

        -- Tdelay="01": CLK_Out period = 1000000 cycles = 1 ms at 1ns clk
        Tdelay_tb <= "01";
        wait for 2200 us;

        -- Tdelay="10": CLK_Out period = 1500000 cycles = 1.5 ms at 1ns clk
        Tdelay_tb <= "10";
        wait for 3200 us;

        -- Tdelay="11": CLK_Out period = 2000000 cycles = 2 ms at 1ns clk
        Tdelay_tb <= "11";
        wait for 4200 us;

        -- Switch Tdelay mid-run from "11" back to "00"
        -- CLK_Out must switch to the faster divider output
        Tdelay_tb <= "00";
        wait for 1200 us;

        wait;
    end process stimulus;

    -- 12 000 us

end architecture behavioral;
