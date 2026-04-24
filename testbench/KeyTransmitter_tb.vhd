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
    constant TXCLK_PERIOD     : time := MCLK_PERIOD * 20; -- TXclk muito mais lento que CLK

    signal clk_tb    : std_logic := '0';
    signal reset_tb  : std_logic := '0';
    signal datain_tb : std_logic_vector(3 downto 0) := "0000";
    signal load_tb   : std_logic := '0';
    signal kbfree_tb : std_logic;
    signal txclk_tb  : std_logic := '0';
    signal txd_tb    : std_logic;

    -- registo dos bits recebidos para verificação
    signal received  : std_logic_vector(3 downto 0) := "0000";

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

    -- ----------------------------------------------------------------
    -- Gerador de CLK do sistema
    -- ----------------------------------------------------------------
    clk_gen: process
    begin
        clk_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    -- ----------------------------------------------------------------
    -- Procedimento: envia 4 pulsos de TXclk e captura bits de TXD
    -- ----------------------------------------------------------------
    -- (implementado inline no stimulus para manter o estilo do exemplo)

    -- ----------------------------------------------------------------
    -- Stimulus
    -- ----------------------------------------------------------------
    stimulus: process

        -- gera um pulso de TXclk e captura o bit presente em TXD
        procedure txclk_pulse(bit_idx : integer) is
        begin
            txclk_tb <= '1';
            wait for TXCLK_PERIOD / 2;
            received(3 - bit_idx) <= txd_tb;  -- MSB primeiro
            txclk_tb <= '0';
            wait for TXCLK_PERIOD / 2;
        end procedure;

        -- sequência completa de receção de uma palavra
        procedure receive_word is
        begin
            -- aguarda flanco descendente de TXD (notificação) com TXclk='0'
            wait until txd_tb = '0';
            wait for MCLK_PERIOD * 2;

            -- 4 pulsos de TXclk para receber b3..b0
            txclk_pulse(0);
            txclk_pulse(1);
            txclk_pulse(2);
            txclk_pulse(3);

            -- sinaliza receção completa (activa KBfree no FPGA)
            wait for MCLK_PERIOD * 2;
        end procedure;

    begin

        -- ============================================================
        -- CASO 1: Reset inicial
        -- ============================================================
        reset_tb  <= '1';
        load_tb   <= '0';
        datain_tb <= "0000";
        txclk_tb  <= '0';
        wait for MCLK_PERIOD * 6;
        reset_tb  <= '0';
        wait for MCLK_PERIOD * 4;

        -- verifica que KBfree='1' após reset
        assert kbfree_tb = '1'
            report "ERRO CASO 1: KBfree devia ser '1' apos reset"
            severity error;

        -- verifica que TXD='1' (idle) após reset
        assert txd_tb = '1'
            report "ERRO CASO 1: TXD devia ser '1' (idle) apos reset"
            severity error;

        -- ============================================================
        -- CASO 2: Transmissão normal — palavra "1010"
        -- ============================================================
        datain_tb <= "1010";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        -- KBfree deve descer (dados aceites)
        wait for MCLK_PERIOD * 2;
        assert kbfree_tb = '0'
            report "ERRO CASO 2: KBfree devia ser '0' apos Load"
            severity error;

        -- recebe a palavra
        receive_word;

        -- verifica bits recebidos
        assert received = "1010"
            report "ERRO CASO 2: palavra recebida errada, esperado 1010"
            severity error;

        -- KBfree deve voltar a '1' após transmissão completa
        wait for MCLK_PERIOD * 4;
        assert kbfree_tb = '1'
            report "ERRO CASO 2: KBfree devia ser '1' apos transmissao"
            severity error;

        -- TXD deve voltar a idle
        assert txd_tb = '1'
            report "ERRO CASO 2: TXD devia ser '1' (idle) apos transmissao"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 3: Transmissão normal — palavra "0101"
        -- ============================================================
        datain_tb <= "0101";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        receive_word;

        assert received = "0101"
            report "ERRO CASO 3: palavra recebida errada, esperado 0101"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 4: Transmissão normal — palavra "1111"
        -- ============================================================
        datain_tb <= "1111";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        receive_word;

        assert received = "1111"
            report "ERRO CASO 4: palavra recebida errada, esperado 1111"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 5: Transmissão normal — palavra "0000"
        -- ============================================================
        datain_tb <= "0000";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        receive_word;

        assert received = "0000"
            report "ERRO CASO 5: palavra recebida errada, esperado 0000"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 6: Load ignorado enquanto KBfree='0' (bloco ocupado)
        -- ============================================================
        datain_tb <= "1100";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        -- enquanto o bloco está a transmitir, tenta carregar novo valor
        wait for MCLK_PERIOD * 5;
        datain_tb <= "0011";   -- valor diferente
        load_tb   <= '1';      -- Load ativo com KBfree='0': deve ser ignorado
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        receive_word;

        -- deve ter transmitido "1100" e não "0011"
        assert received = "1100"
            report "ERRO CASO 6: Load com KBfree=0 nao devia ser aceite"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 7: Reset a meio de uma transmissão
        -- ============================================================
        datain_tb <= "1001";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        -- aguarda notificação e envia apenas 2 pulsos de TXclk
        wait until txd_tb = '0';
        wait for MCLK_PERIOD * 2;
        txclk_tb <= '1';
        wait for TXCLK_PERIOD / 2;
        txclk_tb <= '0';
        wait for TXCLK_PERIOD / 2;
        txclk_tb <= '1';
        wait for TXCLK_PERIOD / 2;
        txclk_tb <= '0';
        wait for MCLK_PERIOD * 2;

        -- reset a meio
        reset_tb <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb <= '0';
        wait for MCLK_PERIOD * 4;

        -- verifica recuperação: KBfree='1' e TXD='1'
        assert kbfree_tb = '1'
            report "ERRO CASO 7: KBfree devia ser '1' apos reset a meio"
            severity error;

        assert txd_tb = '1'
            report "ERRO CASO 7: TXD devia ser '1' apos reset a meio"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 8: Duas transmissões consecutivas sem intervalo
        -- ============================================================
        datain_tb <= "1110";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        receive_word;

        assert received = "1110"
            report "ERRO CASO 8a: palavra recebida errada, esperado 1110"
            severity error;

        -- imediatamente após, nova palavra
        wait for MCLK_PERIOD * 2;
        datain_tb <= "0001";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        receive_word;

        assert received = "0001"
            report "ERRO CASO 8b: palavra recebida errada, esperado 0001"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- CASO 9: TXclk alto durante LOADED (deve aguardar TXclk='0')
        -- ============================================================
        txclk_tb  <= '1';   -- TXclk já está alto antes do Load
        wait for MCLK_PERIOD * 4;

        datain_tb <= "1011";
        load_tb   <= '1';
        wait for MCLK_PERIOD * 2;
        load_tb   <= '0';

        -- bloco deve aguardar TXclk='0' antes de notificar
        wait for MCLK_PERIOD * 10;
        assert txd_tb = '1'
            report "ERRO CASO 9: TXD nao devia descer com TXclk=1"
            severity error;

        txclk_tb <= '0';   -- agora desce TXclk

        receive_word;

        assert received = "1011"
            report "ERRO CASO 9: palavra recebida errada, esperado 1011"
            severity error;

        wait for MCLK_PERIOD * 10;

        -- ============================================================
        -- Fim da simulação
        -- ============================================================
        report "Simulacao concluida com sucesso" severity note;
        wait;

    end process stimulus;

end architecture behavioral;