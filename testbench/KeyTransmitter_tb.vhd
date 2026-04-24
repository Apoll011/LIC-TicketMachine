library ieee;
use ieee.std_logic_1164.all;

entity KeyTransmitter_tb is
end entity KeyTransmitter_tb;

architecture behavioral of KeyTransmitter_tb is

    component KeyTransmitter is
        port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            DataIn : in  std_logic_vector(3 downto 0);
            Load   : in  std_logic;
            KBfree : out std_logic;
            TXclk  : in  std_logic;
            TXD    : out std_logic
        );
    end component KeyTransmitter;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal clk_tb    : std_logic;
    signal reset_tb  : std_logic;
    signal datain_tb : std_logic_vector(3 downto 0);
    signal load_tb   : std_logic;
    signal kbfree_tb : std_logic;
    signal txclk_tb  : std_logic;
    signal txd_tb    : std_logic;

begin

    UUT: component KeyTransmitter
    port map (
        CLK    => clk_tb,
        RESET  => reset_tb,
        DataIn => datain_tb,
        Load   => load_tb,
        KBfree => kbfree_tb,
        TXclk  => txclk_tb,
        TXD    => txd_tb
    );

    clk_gen: process
    begin
        clk_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process
    begin
        -- Reset
        reset_tb  <= '1';
        load_tb   <= '0';
        txclk_tb  <= '0';
        datain_tb <= "0000";
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        wait for MCLK_PERIOD * 4;

        -- Carrega palavra "1010"
        datain_tb <= "1010";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        -- Aguarda notificacao (TXD desce)
        wait until txd_tb = '0';
        wait for MCLK_PERIOD * 4;

        -- 4 pulsos de TXclk para receber os bits
        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        -- Aguarda KBfree voltar a '1'
        wait for MCLK_PERIOD * 10;

        -- Carrega palavra "1111"
        datain_tb <= "1111";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        wait until txd_tb = '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        wait for MCLK_PERIOD * 10;

        -- Carrega palavra "0000"
        datain_tb <= "0000";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        wait until txd_tb = '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        wait for MCLK_PERIOD * 10;

        -- Reset a meio de uma transmissao
        datain_tb <= "1001";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        wait until txd_tb = '0';
        wait for MCLK_PERIOD * 4;

        -- so 2 pulsos e depois reset
        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        txclk_tb <= '1';
        wait for MCLK_PERIOD * 4;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 4;

        reset_tb <= '1';
        wait for MCLK_PERIOD * 6;
        reset_tb <= '0';
        wait for MCLK_PERIOD * 6;

        wait;

    end process stimulus;

end architecture behavioral;