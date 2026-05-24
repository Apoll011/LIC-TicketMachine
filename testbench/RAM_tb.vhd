library ieee;
use ieee.std_logic_1164.all;

entity RAM_tb is
end entity RAM_tb;

architecture behavioral of RAM_tb is

    component RAM is
        port (
            CLK     : in  std_logic;
            RESET   : in  std_logic;
            address : in  std_logic_vector(3 downto 0);
            wr      : in  std_logic;
            din     : in  std_logic_vector(3 downto 0);
            dout    : out std_logic_vector(3 downto 0)
        );
    end component RAM;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal CLK_tb             : std_logic;
    signal RESET_tb           : std_logic;
    signal address_tb         : std_logic_vector(3 downto 0);
    signal wr_tb              : std_logic;
    signal din_tb             : std_logic_vector(3 downto 0);
    signal dout_tb            : std_logic_vector(3 downto 0);

begin

    UUT: component RAM
    port map (
        CLK     => CLK_tb,
        RESET   => RESET_tb,
        address => address_tb,
        wr      => wr_tb,
        din     => din_tb,
        dout    => dout_tb
    );

    clk_gen: process
    begin
        CLK_tb     <= '0';
        wait for MCLK_HALF_PERIOD;
        CLK_tb     <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        RESET_tb   <= '1';
        wr_tb      <= '0';
        address_tb <= "0000";
        din_tb     <= "0000";
        wait for MCLK_PERIOD * 2;
        RESET_tb   <= '0';
        wait for MCLK_PERIOD * 2;

        -- escreve em 0x0
        address_tb <= "0000";
        din_tb     <= "1010";
        wr_tb      <= '1';
        wait for MCLK_PERIOD * 2;
        wr_tb      <= '0';
        wait for MCLK_PERIOD * 2;

        -- escreve em 0x5
        address_tb <= "0101";
        din_tb     <= "0011";
        wr_tb      <= '1';
        wait for MCLK_PERIOD * 2;
        wr_tb      <= '0';
        wait for MCLK_PERIOD * 2;

        -- lê 0x0
        address_tb <= "0000";
        wait for MCLK_PERIOD * 2;

        -- lê 0x5
        address_tb <= "0101";
        wait for MCLK_PERIOD * 2;

        -- reset limpa memória
        RESET_tb   <= '1';
        wait for MCLK_PERIOD;
        RESET_tb   <= '0';
        address_tb <= "0000";
        wait for MCLK_PERIOD * 2;
        wait;
    end process stimulus;

end architecture behavioral;
