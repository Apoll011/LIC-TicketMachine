library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- KeyTransmitter
--
-- Serialises a 4-bit key code over a single TXD line, clocked
-- by an external TXclk signal.  Based on Francisco's
-- KEY_TRANSMITTER design, adapted to use Common/ components.
--
-- Serial frame (8 TXclk periods):
--
--   Counter  Mux slot  TXD value
--   -------  --------  ---------
--      0     M(0)      TXD_INIT  ('0' while STATE_SEND, init/sync bit)
--      1     M(1)      '1'       (START bit)
--      2     M(2)      D(0)      (LSB of key code)
--      3     M(3)      D(1)
--      4     M(4)      D(2)
--      5     M(5)      D(3)      (MSB of key code)
--      6     M(6)      '0'       (STOP bit)
--      7     M(7)      '1'       (placeholder / frame guard)
--
-- CFlag goes high at counter=7 while TXclk='0', triggering the
-- control FSM to return to STATE_IDLE.
-- ============================================================

entity KeyTransmitter is

    port (
        CLK    : in  STD_LOGIC;
        RESET  : in  STD_LOGIC;

        DataIn : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit key code
        Load   : in  STD_LOGIC;                     -- pulse: key is valid
        KBfree : out STD_LOGIC;                     -- '1' when ready for next key

        TXclk  : in  STD_LOGIC;                     -- serial clock (from host)
        TXD    : out STD_LOGIC                       -- serial data output
    );

end entity KeyTransmitter;

architecture behavioral of KeyTransmitter is

    -- --------------------------------------------------------
    -- Component declarations
    -- --------------------------------------------------------

    component KeyTransmitter_Control is
        port (
            CLK      : in  STD_LOGIC;
            RESET    : in  STD_LOGIC;
            DAV      : in  STD_LOGIC;
            CFlag    : in  STD_LOGIC;
            ENR      : out STD_LOGIC;
            RESET_C  : out STD_LOGIC;
            ENC      : out STD_LOGIC;
            DAC      : out STD_LOGIC;
            TXD_INIT : out STD_LOGIC
        );
    end component KeyTransmitter_Control;

    -- 4-bit register from Common/
    component Reg is
        port (
            CLK   : in  STD_LOGIC;
            RESET : in  STD_LOGIC;
            D     : in  STD_LOGIC_VECTOR(3 downto 0);
            EN    : in  STD_LOGIC;
            Q     : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component Reg;

    -- 4-bit up counter from Common/ (CounterDown.vhd entity name is Counter)
    component Counter is
        port (
            CE    : in  STD_LOGIC;
            CLK   : in  STD_LOGIC;
            Q     : out STD_LOGIC_VECTOR(3 downto 0);
            RESET : in  STD_LOGIC
        );
    end component Counter;

    -- 8-to-1 mux with 3-bit select
    component Mux8x3 is
        port (
            A : in  STD_LOGIC_VECTOR(7 downto 0);
            S : in  STD_LOGIC_VECTOR(2 downto 0);
            O : out STD_LOGIC
        );
    end component Mux8x3;

    -- --------------------------------------------------------
    -- Internal signals
    -- --------------------------------------------------------

    -- Control FSM outputs
    signal ENR_LINK      : STD_LOGIC;
    signal RESET_C_LINK  : STD_LOGIC;
    signal ENC_LINK      : STD_LOGIC;
    signal TXD_INIT_LINK : STD_LOGIC;

    -- Registered key code
    signal Q_LINK        : STD_LOGIC_VECTOR(3 downto 0);

    -- Bit counter output
    signal O_LINK        : STD_LOGIC_VECTOR(3 downto 0);

    -- 3-bit mux select (lower 3 bits of counter)
    signal S_LINK        : STD_LOGIC_VECTOR(2 downto 0);

    -- 8-slot mux input vector
    signal M_LINK        : STD_LOGIC_VECTOR(7 downto 0);

    -- Terminal count flag: counter=7 and TXclk is LOW
    signal C_FLAG        : STD_LOGIC;

begin

    -- --------------------------------------------------------
    -- Terminal count: frame complete when counter reaches 7
    -- and TXclk is LOW (matches Francisco's original condition)
    -- --------------------------------------------------------
    C_FLAG <= (O_LINK(2) and O_LINK(1) and O_LINK(0)) and not TXclk;

    -- --------------------------------------------------------
    -- Control FSM
    -- --------------------------------------------------------
    M0 : component KeyTransmitter_Control
    port map (
        CLK      => CLK,
        RESET    => RESET,
        DAV      => Load,
        CFlag    => C_FLAG,
        ENR      => ENR_LINK,
        RESET_C  => RESET_C_LINK,
        ENC      => ENC_LINK,
        DAC      => KBfree,
        TXD_INIT => TXD_INIT_LINK
    );

    -- --------------------------------------------------------
    -- Data register: latches DataIn when ENR is asserted
    -- Uses Common/Reg.vhd (replaces Francisco's REGISTER4BITS)
    -- --------------------------------------------------------
    M1 : component Reg
    port map (
        CLK   => CLK,
        RESET => RESET,
        D     => DataIn,
        EN    => ENR_LINK,
        Q     => Q_LINK
    );

    -- --------------------------------------------------------
    -- Bit counter: counts TXclk rising edges during transmission
    -- Uses Common/Counter (CounterDown.vhd, actually an up counter)
    -- CLK driven by TXclk so it advances once per serial clock
    -- RESET driven by RESET_C (active-high, matches Common/Counter)
    -- CE driven by ENC (enabled only during STATE_SEND)
    -- --------------------------------------------------------
    M2 : component Counter
    port map (
        CLK   => TXclk,
        RESET => RESET_C_LINK,
        CE    => ENC_LINK,
        Q     => O_LINK
    );

    -- --------------------------------------------------------
    -- Mux select: lower 3 bits of counter choose the frame slot
    -- --------------------------------------------------------
    S_LINK(2 downto 0) <= O_LINK(2 downto 0);

    -- --------------------------------------------------------
    -- Serial frame definition (8 slots)
    -- --------------------------------------------------------
    M_LINK(0) <= TXD_INIT_LINK;  -- Slot 0 : INIT bit  ('0' while sending)
    M_LINK(1) <= '1';             -- Slot 1 : START bit
    M_LINK(2) <= Q_LINK(0);      -- Slot 2 : D(0) / LSB
    M_LINK(3) <= Q_LINK(1);      -- Slot 3 : D(1)
    M_LINK(4) <= Q_LINK(2);      -- Slot 4 : D(2)
    M_LINK(5) <= Q_LINK(3);      -- Slot 5 : D(3) / MSB
    M_LINK(6) <= '0';             -- Slot 6 : STOP bit
    M_LINK(7) <= '1';             -- Slot 7 : placeholder / frame guard

    -- --------------------------------------------------------
    -- Output mux: selects the correct frame slot onto TXD
    -- --------------------------------------------------------
    M3 : component Mux8x3
    port map (
        A => M_LINK,
        S => S_LINK,
        O => TXD
    );

end architecture behavioral;