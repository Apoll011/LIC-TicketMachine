library ieee;
use ieee.std_logic_1164.all;

entity KeyTransmitter is
    port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;

        DataIn : in  std_logic_vector(3 downto 0);
        Load   : in  std_logic;
        KBfree : out std_logic;

        TXclk  : in  std_logic;
        TXD    : out std_logic
    );
end entity KeyTransmitter;

architecture behavioral of KeyTransmitter is

    component ShiftReg4 is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            LOAD  : in  std_logic;
            EN    : in  std_logic;
            D     : in  std_logic_vector(3 downto 0);
            Q_out : out std_logic
        );
    end component ShiftReg4;

    component EdgeDetect is
        port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            SIG_IN : in  std_logic;
            RISE   : out std_logic
        );
    end component EdgeDetect;

    component Counter is
        port (
            CE    : in  std_logic;
            CLK   : in  std_logic;
            Q     : out std_logic_vector(3 downto 0);
            RESET : in  std_logic
        );
    end component Counter;

    component MUX1 is
        port (
            A  : in  std_logic;
            B  : in  std_logic;
            OP : in  std_logic;
            F  : out std_logic
        );
    end component MUX1;

    type STATE_TYPE is (IDLE, LOADED, NOTIFY, TRANSMIT, DONE);
    signal CurrentState, NextState : STATE_TYPE;

    signal sr_load    : std_logic;
    signal sr_en      : std_logic;
    signal sr_out     : std_logic;
    signal txclk_rise : std_logic;
    signal txd_force  : std_logic;
    signal txd_sel    : std_logic;
    signal txd_int    : std_logic;

    signal cnt_q      : std_logic_vector(3 downto 0);
    signal cnt_ce     : std_logic;
    signal cnt_rst    : std_logic;

begin

    SR: component ShiftReg4
        port map (
            CLK   => CLK,
            RESET => RESET,
            LOAD  => sr_load,
            EN    => sr_en,
            D     => DataIn,
            Q_out => sr_out
        );

    EDGE: component EdgeDetect
        port map (
            CLK    => CLK,
            RESET  => RESET,
            SIG_IN => TXclk,
            RISE   => txclk_rise
        );

    BCNT: component Counter
        port map (
            CLK   => CLK,
            RESET => cnt_rst,
            CE    => cnt_ce,
            Q     => cnt_q
        );

    TXDMUX: component MUX1
        port map (
            A  => txd_force,
            B  => sr_out,
            OP => txd_sel,
            F  => txd_int
        );

    TXD <= txd_int;

    StateRegister: process (CLK, RESET) is
    begin
        if RESET = '1' then
            CurrentState <= IDLE;
        elsif rising_edge(CLK) then
            CurrentState <= NextState;
        end if;
    end process StateRegister;

    GenerateNextState: process (CurrentState, Load, TXclk, txclk_rise, cnt_q) is
    begin
        case CurrentState is
            when IDLE =>
                if Load = '1' then
                    NextState <= LOADED;
                else
                    NextState <= IDLE;
                end if;
            when LOADED =>
                if TXclk = '0' then
                    NextState <= NOTIFY;
                else
                    NextState <= LOADED;
                end if;
            when NOTIFY =>
                if txclk_rise = '1' then
                    NextState <= TRANSMIT;
                else
                    NextState <= NOTIFY;
                end if;
            when TRANSMIT =>
                if txclk_rise = '1' and cnt_q(2) = '1' then
                    NextState <= DONE;
                else
                    NextState <= TRANSMIT;
                end if;
            when DONE =>
                NextState <= IDLE;
        end case;
    end process GenerateNextState;

    KBfree    <= '1' when (CurrentState = IDLE)     or (CurrentState = DONE)              else '0';
    txd_force <= '0' when (CurrentState = NOTIFY)                                         else '1';
    txd_sel   <= '1' when (CurrentState = TRANSMIT)                                       else '0';
    sr_load   <= '1' when (CurrentState = LOADED)                                         else '0';
    sr_en     <= '1' when (CurrentState = LOADED)
                       or ((CurrentState = TRANSMIT) and (txclk_rise = '1'))              else '0';
    cnt_rst   <= '0' when (CurrentState = TRANSMIT)                                       else '1';
    cnt_ce    <= '1' when (CurrentState = TRANSMIT) and (txclk_rise = '1')                else '0';

end architecture behavioral;