library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- KeyInterface
--
-- Bridges Key_Decode and KeyTransmitter, resolving the
-- level-vs-pulse mismatch in their handshake protocols.
--
-- Problem without this block:
--   Key_Decode holds Kval HIGH (level) while waiting for Kack.
--   KeyTransmitter_Control sits in STATE_ACK waiting for DAV
--   to DROP before it will start transmitting.
--   => Deadlock: each side waits for the other to move first.
--
-- Solution:
--   (1) EdgeDetect on Kval produces a single-cycle Load pulse,
--       which lets KeyTransmitter_Control exit STATE_ACK and
--       begin transmission immediately.
--   (2) A 'busy' flag ensures Kack only fires AFTER a real
--       transmission has finished (KBfree rises while busy=1),
--       not spuriously when the transmitter happens to be idle
--       at startup or between keys.
--
-- Timing diagram (happy path):
--
--   Kval   ____/‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\____
--   Load   ____/‾\_________________________________   (1 cycle pulse)
--   KBfree ‾‾‾‾\_________________________/‾‾‾‾‾‾‾   (low during TX)
--   busy   ____/‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\_______
--   Kack   _________________________________/‾\__   (1 cycle, TX done)
--
-- After Kack pulses:
--   Key_Decode transitions READING_DATA -> DATA_ACCEPTED,
--   then back to STANDING_BY (scanning resumes) either when
--   the key is released or the debounce delay timer fires.
-- ============================================================

entity KeyInterface is
    port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;

        -- From Key_Decode
        Kval   : in  std_logic;   -- level: high while a key is valid

        -- From KeyTransmitter
        KBfree : in  std_logic;   -- high when transmitter is idle/done

        -- To KeyTransmitter
        Load   : out std_logic;   -- single-cycle pulse: latch and send

        -- To Key_Decode
        Kack   : out std_logic    -- high for one cycle once TX is done
    );
end entity KeyInterface;

architecture behavioral of KeyInterface is

    component EdgeDetect is
        port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            SIG_IN : in  std_logic;
            RISE   : out std_logic
        );
    end component EdgeDetect;

    -- '1' from the moment a key event is triggered until TX finishes
    signal busy      : std_logic := '0';
    signal kval_rise : std_logic;

begin

    -- --------------------------------------------------------
    -- Detect the rising edge of Kval (Key_Decode just entered
    -- READING_DATA), and convert it to a single-cycle pulse.
    -- --------------------------------------------------------
    ed : component EdgeDetect
    port map (
        CLK    => CLK,
        RESET  => RESET,
        SIG_IN => Kval,
        RISE   => kval_rise
    );

    -- --------------------------------------------------------
    -- Busy flag
    --   Set   : on the same cycle as the Load pulse
    --   Clear : when KBfree rises (transmitter back to idle)
    -- Priority: set wins over clear (edge and free cannot
    -- coincide in normal operation, but be safe).
    -- --------------------------------------------------------
    process (CLK, RESET) is
    begin
        if RESET = '1' then
            busy <= '0';
        elsif rising_edge(CLK) then
            if kval_rise = '1' then
                busy <= '1';          -- new key event: mark as busy
            elsif KBfree = '1' then
                busy <= '0';          -- transmission complete: release
            end if;
        end if;
    end process;

    -- --------------------------------------------------------
    -- Output assignments
    -- --------------------------------------------------------

    -- Single-cycle pulse to KeyTransmitter: latch DataIn and begin TX
    Load <= kval_rise;

    -- Acknowledge to Key_Decode: high for exactly one cycle when
    -- transmission ends (KBfree='1' AND we were actually busy).
    -- This prevents a spurious ack at startup when KBfree is
    -- already '1' but no key has been sent yet.
    Kack <= KBfree and busy;

end architecture behavioral;