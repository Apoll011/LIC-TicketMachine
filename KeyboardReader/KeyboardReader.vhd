library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyboardReader is
    port (
        CLK             : in  STD_LOGIC;
        RESET           : in  STD_LOGIC;

        Tdelay          : in  STD_LOGIC_VECTOR(1 downto 0);

        Keys_Vertical   : out STD_LOGIC_VECTOR(3 downto 0);
        Keys_Horizontal : in  STD_LOGIC_VECTOR(3 downto 0);

        TXclk           : in  STD_LOGIC;
        TXD             : out STD_LOGIC
    );
end entity KeyboardReader;

architecture logicFunction of KeyboardReader is
    component Key_Decode is
        port (
            Kack, RESET, CLK : in  STD_LOGIC;
            Tdelay           : in  STD_LOGIC_VECTOR(1 downto 0);
            Kval             : out STD_LOGIC;
            K                : out STD_LOGIC_VECTOR(3 downto 0);
            Keys_Vertical    : out STD_LOGIC_VECTOR(3 downto 0);
            Keys_Horizontal  : in  STD_LOGIC_VECTOR(3 downto 0)
        );
    end component Key_Decode;

    component KeyInterface is
        port (
            CLK    : in  STD_LOGIC;
            RESET  : in  STD_LOGIC;
            Kval   : in  STD_LOGIC;
            KBfree : in  STD_LOGIC;
            Load   : out STD_LOGIC;
            Kack   : out STD_LOGIC
        );
    end component KeyInterface;

    component KeyTransmitter is
        port (
            CLK    : in  STD_LOGIC;
            RESET  : in  STD_LOGIC;
            DataIn : in  STD_LOGIC_VECTOR(3 downto 0);
            Load   : in  STD_LOGIC;
            KBfree : out STD_LOGIC;
            TXclk  : in  STD_LOGIC;
            TXD    : out STD_LOGIC
        );
    end component KeyTransmitter;


    signal KEY_CODE_LINK : STD_LOGIC_VECTOR(3 downto 0);
    signal KVAL_LINK     : STD_LOGIC;  -- Kval level from Key_Decode
    signal KACK_LINK     : STD_LOGIC;  -- Kack pulse back to Key_Decode
    signal LOAD_LINK     : STD_LOGIC;  -- single-cycle Load to KeyTransmitter
    signal KBFREE_LINK   : STD_LOGIC;  -- transmitter idle / done

begin


    DECODE : component Key_Decode
    port map (
        CLK             => CLK,
        RESET           => RESET,
        Kack            => KACK_LINK,
        Tdelay          => Tdelay,
        Kval            => KVAL_LINK,
        K               => KEY_CODE_LINK,
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal
    );

    IFACE : component KeyInterface
    port map (
        CLK    => CLK,
        RESET  => RESET,
        Kval   => KVAL_LINK,     -- from Key_Decode
        KBfree => KBFREE_LINK,   -- from KeyTransmitter
        Load   => LOAD_LINK,     -- to   KeyTransmitter
        Kack   => KACK_LINK      -- to   Key_Decode
    );

   TRANSMITTER : component KeyTransmitter
    port map (
        CLK    => CLK,
        RESET  => RESET,
        DataIn => KEY_CODE_LINK,
        Load   => LOAD_LINK,
        KBfree => KBFREE_LINK,
        TXclk  => TXclk,
        TXD    => TXD
    );

end architecture logicFunction;