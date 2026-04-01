library ieee;
use ieee.std_logic_1164.all;

entity SerialReceiver_tb is
end entity SerialReceiver_tb;

architecture behavioral of SerialReceiver_tb is

    component SerialReceiver is
        port (
            SDX, CLK, SS, RESET : in  std_logic;
            Q                   : out std_logic_vector(9 downto 0)
        );
    end component SerialReceiver;

    constant MCLK_PERIOD      : time := 20 ns;
    constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

    signal reset_tb : std_logic;
    signal clk_tb   : std_logic;
    signal SDX_tb   : std_logic;
    signal SS_tb    : std_logic;
    signal Q_tb     : std_logic_vector(9 downto 0);

begin

    UUT: component SerialReceiver
    port map (
        RESET => reset_tb,
        CLK   => clk_tb,
        SDX   => SDX_tb,
        SS    => SS_tb,
        Q     => Q_tb
    );

    clk_gen: process
    begin
        clk_tb <= '0';
        wait for MCLK_HALF_PERIOD;
        clk_tb <= '1';
        wait for MCLK_HALF_PERIOD;
    end process clk_gen;

    stimulus: process

        -- Envia 10 bits em serie pelo SDX com SS='0' (shift activo)
        -- Os bits sao enviados LSB primeiro
        procedure send_serial(data : std_logic_vector(9 downto 0)) is
        begin
            SS_tb <= '0';
            wait for MCLK_PERIOD;
            for i in 0 to 9 loop
                SDX_tb <= data(i);
                wait for MCLK_PERIOD;
            end loop;
            SDX_tb <= '0';
            -- SS sobe -> HoldRegister captura o resultado
            SS_tb  <= '1';
            wait for MCLK_PERIOD * 2;
            SS_tb  <= '0';
            wait for MCLK_PERIOD;
        end procedure;

    begin
        -- Reset
        reset_tb <= '1';
        SS_tb    <= '0';
        SDX_tb   <= '0';
        wait for MCLK_PERIOD * 6;

        reset_tb <= '0';
        wait for MCLK_PERIOD * 4;

        -- Teste 1: envia "0101010101" -> Q deve ser "0101010101"
        send_serial("0101010101");
        wait for MCLK_PERIOD * 4;

        -- Teste 2: envia "1111100000" -> Q deve ser "1111100000"
        send_serial("1111100000");
        wait for MCLK_PERIOD * 4;

        -- Teste 3: envia "1000000001" -> Q deve ser "1000000001"
        send_serial("1000000001");
        wait for MCLK_PERIOD * 4;

        -- Teste 4: envia "0000000000" -> Q deve ser "0000000000"
        send_serial("0000000000");
        wait for MCLK_PERIOD * 4;

        -- Teste 5: envia "1111111111" -> Q deve ser "1111111111"
        send_serial("1111111111");
        wait for MCLK_PERIOD * 4;

        -- Teste 6: reset a meio de uma transmissao
        -- Q deve voltar a "0000000000"
        SS_tb    <= '0';
        SDX_tb   <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb <= '1';
        wait for MCLK_PERIOD * 4;
        reset_tb <= '0';
        SS_tb    <= '0';
        SDX_tb   <= '0';
        wait for MCLK_PERIOD * 4;

        wait;
    end process stimulus;
	 
	 -- 2400 ns

end architecture behavioral;