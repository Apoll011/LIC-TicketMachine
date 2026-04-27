library ieee;
use ieee.std_logic_1164.all;

entity keytransmitter_tb is
end entity;

architecture sim of keytransmitter_tb is
    signal clk_tb    : std_logic := '0';
    signal reset_tb  : std_logic := '1';
    signal datain_tb : std_logic_vector(3 downto 0) := "0000";
    signal load_tb   : std_logic := '0';
    signal kbfree_tb : std_logic;
    signal txclk_tb  : std_logic := '0';
    signal txd_tb    : std_logic;
	 
	 
    component KeyTransmitter is
    port (
        CLK    : in  STD_LOGIC;
        RESET  : in  STD_LOGIC;

        DataIn : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit key code
        Load   : in  STD_LOGIC;                     -- pulse: key is valid
        KBfree : out STD_LOGIC;                     -- '1' when ready for next key

        TXclk  : in  STD_LOGIC;                     -- serial clock (from host)
        TXD    : out STD_LOGIC                       -- serial data output
    );
    end component KeyTransmitter;
	 
begin

    -- Estas duas linhas TÊM de estar aqui, fora de qualquer process
    clk_tb   <= not clk_tb   after 5 ns;
    txclk_tb <= not txclk_tb after 10 ns;   -- <-- fora do process!

    uut: component KeyTransmitter
        port map (
            CLK    => clk_tb,
            RESET  => reset_tb,
            DataIn => datain_tb,
            Load   => load_tb,
            KBfree => kbfree_tb,
            TXclk  => txclk_tb,
            TXD    => txd_tb
        );

    process is
    begin
        reset_tb  <= '1';
        wait for 30 ns;
        reset_tb  <= '0';
		  
        wait for 30 ns;
        datain_tb <= "1010";
        load_tb   <= '1';
        wait for 10 ns;
        load_tb   <= '0';
		  

        wait until kbfree_tb = '1';
        wait for 500 ns;
        wait;
    end process;

end architecture sim;