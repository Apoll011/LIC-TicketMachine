library ieee;
use ieee.std_logic_1164.all;

entity TicketMachine is
    port (
        CLK             : in  std_logic;
        RESET           : in  std_logic;

        Keys_Vertical   : out std_logic_vector(3 downto 0);
        Keys_Horizontal : in  std_logic_vector(3 downto 0);

        LCD_RS          : out std_logic;
        LCD_EN          : out std_logic;
        LCD_DATA        : out std_logic_vector(7 downto 0);

        INPUT           : out std_logic_vector(7 downto 0);

        CollectTicket   : in  std_logic;

        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(7 downto 0);

        TXclk           : in  std_logic;
        TXD             : out std_logic
    );
end entity TicketMachine;

architecture logicFunction of TicketMachine is

    -- --------------------------------------------------------
    -- Component declarations
    -- --------------------------------------------------------

    component KeyboardReader is
        port (
            CLK             : in  std_logic;
            RESET           : in  std_logic;
            Tdelay          : in  std_logic_vector(1 downto 0);
            Keys_Vertical   : out std_logic_vector(3 downto 0);
            Keys_Horizontal : in  std_logic_vector(3 downto 0);
            TXclk           : in  std_logic;
            TXD             : out std_logic;
            -- Exposed for USB input byte construction
            Kval            : out std_logic;
            K               : out std_logic_vector(3 downto 0)
        );
    end component KeyboardReader;

    component UsbPort is
        port (
            inputPort  : in  std_logic_vector(7 downto 0);
            outputPort : out std_logic_vector(7 downto 0)
        );
    end component UsbPort;

    component PELCD is
        port (
            SDX, CLK, SS, RESET : in  std_logic;
            Q                   : out std_logic_vector(9 downto 0)
        );
    end component PELCD;

    component PETD is
        port (
            SDX, CLK, SS, RESET : in  std_logic;
            D                   : out std_logic_vector(7 downto 0);
            Prt, Rt             : out std_logic
        );
    end component PETD;

    component TICKET_DISPENSER is
        port (
            RT, Prt, CollectTicket               : in  std_logic;
            O, D                                 : in  std_logic_vector(3 downto 0);
            Fn                                   : out std_logic;
            HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(7 downto 0)
        );
    end component TICKET_DISPENSER;

    -- --------------------------------------------------------
    -- Internal signals
    -- --------------------------------------------------------

    -- USB bridge
    signal INPUT_PORT_LINK  : std_logic_vector(7 downto 0);
    signal OUTPUT_PORT_LINK : std_logic_vector(7 downto 0);

    -- Keyboard
    signal KVAL_LINK        : std_logic;
    signal KEY_CODE_LINK    : std_logic_vector(3 downto 0);

    -- LCD serial frame
    signal LCD_FRAME_LINK   : std_logic_vector(9 downto 0);

    -- Ticket serial data
    signal PETD_D_LINK      : std_logic_vector(7 downto 0);
    signal PRT_LINK         : std_logic;
    signal RT_LINK          : std_logic;

    -- Ticket dispenser
    signal FN_LINK          : std_logic;

begin

    -- --------------------------------------------------------
    -- USB virtual JTAG port
    -- INPUT_PORT_LINK byte layout:
    --   [7]     = Kval  (key valid strobe)
    --   [6]     = '0'   (reserved)
    --   [5]     = '0'   (reserved)
    --   [4]     = Fn    (ticket dispenser finished flag)
    --   [3..0]  = K     (4-bit key code)
    -- --------------------------------------------------------
    INPUT_PORT_LINK(7)          <= KVAL_LINK;
    INPUT_PORT_LINK(6)          <= '0';
    INPUT_PORT_LINK(5)          <= '0';
    INPUT_PORT_LINK(4)          <= FN_LINK;
    INPUT_PORT_LINK(3 downto 0) <= KEY_CODE_LINK;

    USB : component UsbPort
    port map (
        inputPort  => INPUT_PORT_LINK,
        outputPort => OUTPUT_PORT_LINK
    );

    -- Expose the input byte on the top-level port for debugging
    INPUT <= INPUT_PORT_LINK;

    -- --------------------------------------------------------
    -- Keyboard reader
    -- Tdelay = "11" -> 2000 ms debounce (same as original)
    -- Kval and K are exposed so the USB byte can be built above.
    -- The Kack/KBfree feedback loop is handled inside
    -- KeyboardReader — no external wiring needed.
    --
    -- Note: if your KeyboardReader does not expose Kval/K as
    -- top-level ports, move those signals back here and wire
    -- Kack from a local KBfree signal instead.
    -- --------------------------------------------------------
    KBD : component KeyboardReader
    port map (
        CLK             => CLK,
        RESET           => RESET,
        Tdelay          => "11",
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal,
        TXclk           => TXclk,
        TXD             => TXD,
        Kval            => KVAL_LINK,
        K               => KEY_CODE_LINK
    );

    -- --------------------------------------------------------
    -- LCD serial decoder
    -- Software drives SDX/CLK/SS via output port bits 0,1,2
    -- OUTPUT_PORT_LINK bit assignment (set by software):
    --   [0] = SDX  (serial data)
    --   [1] = CLK  (serial clock)
    --   [2] = SS   (LCD slave select)
    --   [3] = SS   (ticket slave select)
    --   [7] = Kack (key acknowledge — only used in old design,
    --               now handled internally by KeyboardReader)
    -- --------------------------------------------------------
    LCD_SERIAL : component PELCD
    port map (
        RESET => RESET,
        CLK   => OUTPUT_PORT_LINK(1),
        SDX   => OUTPUT_PORT_LINK(0),
        SS    => OUTPUT_PORT_LINK(2),
        Q     => LCD_FRAME_LINK
    );

    -- LCD frame bit assignment (matches original):
    --   Q[9]   = RS   (register select)
    --   Q[8:1] = DATA (data byte, bit 0 first in frame = Q[8] = DATA[0])
    --   Q[0]   = E    (enable strobe)
    LCD_RS      <= LCD_FRAME_LINK(9);
    LCD_DATA(0) <= LCD_FRAME_LINK(8);
    LCD_DATA(1) <= LCD_FRAME_LINK(7);
    LCD_DATA(2) <= LCD_FRAME_LINK(6);
    LCD_DATA(3) <= LCD_FRAME_LINK(5);
    LCD_DATA(4) <= LCD_FRAME_LINK(4);
    LCD_DATA(5) <= LCD_FRAME_LINK(3);
    LCD_DATA(6) <= LCD_FRAME_LINK(2);
    LCD_DATA(7) <= LCD_FRAME_LINK(1);
    LCD_EN      <= LCD_FRAME_LINK(0);

    -- --------------------------------------------------------
    -- Ticket serial decoder
    -- Same SDX/CLK lines as LCD, different slave select (bit 3)
    -- --------------------------------------------------------
    TICKET_SERIAL : component PETD
    port map (
        RESET => RESET,
        CLK   => OUTPUT_PORT_LINK(1),
        SDX   => OUTPUT_PORT_LINK(0),
        SS    => OUTPUT_PORT_LINK(3),
        D     => PETD_D_LINK,
        Rt    => RT_LINK,
        Prt   => PRT_LINK
    );

    -- --------------------------------------------------------
    -- Ticket dispenser FSM + 7-segment display drivers
    -- PETD_D_LINK byte layout (set by software via PETD):
    --   [3..0] = O  (ticket option / quantity low nibble)
    --   [7..4] = D  (ticket destination / quantity high nibble)
    -- --------------------------------------------------------
    TICKET_DISP : component TICKET_DISPENSER
    port map (
        RT            => RT_LINK,
        Prt           => PRT_LINK,
        CollectTicket => CollectTicket,
        O             => PETD_D_LINK(3 downto 0),
        D             => PETD_D_LINK(7 downto 4),
        Fn            => FN_LINK,
        HEX0          => HEX0,
        HEX1          => HEX1,
        HEX2          => HEX2,
        HEX3          => HEX3,
        HEX4          => HEX4,
        HEX5          => HEX5
    );

end architecture logicFunction;