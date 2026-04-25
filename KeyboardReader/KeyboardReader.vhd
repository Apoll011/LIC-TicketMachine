library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- KeyboardReader
--
-- Top-level block connecting the keyboard decoder with the
-- serial transmitter.
--
-- For now the connection is direct (no ring buffer):
--   - Kval  from Key_Decode drives Load  on KeyTransmitter
--   - KBfree from KeyTransmitter feeds back as Kack to Key_Decode
--   - K (4-bit key code) goes straight into DataIn
--
-- When a ring buffer is added later, it will sit between
-- Key_Decode and KeyTransmitter on the DataIn/Load/KBfree path.
--
-- Ports:
--   CLK             : system clock
--   RESET           : active-high synchronous reset
--   Tdelay          : key debounce delay select (see Key_Decode)
--   Keys_Vertical   : column drives to the keypad
--   Keys_Horizontal : row reads from the keypad
--   TXclk           : serial transmission clock (from host)
--   TXD             : serial data output to host
-- ============================================================


entity KeyboardReader is
    port (
        CLK             : in  STD_LOGIC;
        RESET           : in  STD_LOGIC;

        Tdelay          : in  STD_LOGIC_VECTOR(1 downto 0);

        Keys_Vertical   : out STD_LOGIC_VECTOR(3 downto 0);
        Keys_Horizontal : in  STD_LOGIC_VECTOR(3 downto 0);

        -- Exposed for parent block (e.g. USB byte construction)
        Kval            : out STD_LOGIC;
        K               : out STD_LOGIC_VECTOR(3 downto 0);

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

    -- --------------------------------------------------------
    -- Internal signals
    -- --------------------------------------------------------

    signal KEY_CODE_LINK : STD_LOGIC_VECTOR(3 downto 0);
    signal KVAL_LINK     : STD_LOGIC;
    signal KBFREE_LINK   : STD_LOGIC;

begin

    -- Drive output ports from internal signals
    Kval <= KVAL_LINK;
    K    <= KEY_CODE_LINK;

    -- --------------------------------------------------------
    -- Keyboard decoder
    -- Kack driven by KBfree: transmitter free = key accepted
    -- --------------------------------------------------------
    DECODE : component Key_Decode
    port map (
        CLK             => CLK,
        RESET           => RESET,
        Kack            => KBFREE_LINK,
        Tdelay          => Tdelay,
        Kval            => KVAL_LINK,
        K               => KEY_CODE_LINK,
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal
    );

    -- --------------------------------------------------------
    -- Serial transmitter
    -- KBfree feeds back to decoder as Kack.
    --
    -- TODO: insert ring buffer here between DECODE and
    --       TRANSMITTER when ready. The buffer will:
    --         - accept (KEY_CODE_LINK, KVAL_LINK) from DECODE
    --         - present (BUF_DATA, BUF_LOAD) to TRANSMITTER
    --         - feed (BUF_FREE) back to DECODE as Kack
    --         - use (KBFREE_LINK) from TRANSMITTER internally
    -- --------------------------------------------------------
    TRANSMITTER : component KeyTransmitter
    port map (
        CLK    => CLK,
        RESET  => RESET,
        DataIn => KEY_CODE_LINK,
        Load   => KVAL_LINK,
        KBfree => KBFREE_LINK,
        TXclk  => TXclk,
        TXD    => TXD
    );

end architecture logicFunction;