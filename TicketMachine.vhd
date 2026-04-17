LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity TicketMachine is
    port (
        CLK             : in  std_logic;
        RESET           : in  std_logic;

        Keys_Vertical   : out std_logic_vector(3 downto 0);  -- column drives
        Keys_Horizontal : in  std_logic_vector(3 downto 0);  -- row reads

        LCD_RS          : out std_logic;                      -- register select
        LCD_EN          : out std_logic;                      -- enable strobe
        LCD_DATA        : out std_logic_vector(7 downto 0);	  -- data[7:0]
		  INPUT				: out std_logic_vector(7 downto 0)
    );
end entity TicketMachine;

architecture logicFunction of TicketMachine is
    component Key_Decode is
        port (
            Kack, RESET, CLK : in  std_logic;
            Tdelay           : in  std_logic_vector(1 downto 0);
            Kval             : out std_logic;
            K                : out std_logic_vector(3 downto 0);
            Keys_Vertical    : out std_logic_vector(3 downto 0);
            Keys_Horizontal  : in  std_logic_vector(3 downto 0)
        );
    end component Key_Decode;

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

  	signal inputPort  : std_logic_vector(7 downto 0);
    signal outputPort : std_logic_vector(7 downto 0);

    signal key_code   : std_logic_vector(3 downto 0);
    signal kval_int   : std_logic;

    signal lcd_frame  : std_logic_vector(9 downto 0);

begin

    usb: component UsbPort
    port map (
        inputPort  => inputPort,
        outputPort => outputPort
    );

    decode: component Key_Decode
    port map (
        RESET           => RESET,
        CLK             => CLK,
        Kack            => outputPort(7),    -- software sets bit7 to ack a key
        Tdelay          => "11",
        Kval            => kval_int,
        K               => key_code,
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal
    );

    inputPort(7)          <= kval_int;
    inputPort(6 downto 4) <= "000"; 
    inputPort(3 downto 0) <= key_code;

    lcd_serial: component PELCD
    port map (
        RESET => RESET,
        CLK   => outputPort(1),   -- serial clock driven by software (SCLK_MASK bit 1)
        SDX   => outputPort(0),   -- serial data  (SDX_MASK  bit 0)
        SS    => outputPort(2),   -- slave select (LCD_MASK   bit 2)
        Q     => lcd_frame
    );

    LCD_RS   <= lcd_frame(9);              -- bit 0  = RS
    LCD_DATA <= lcd_frame(8 downto 1);     -- bits 8:1 = data byte
    LCD_EN   <= lcd_frame(0);              -- bit 9  = E (enable)

	 INPUT <= outputPort;

end architecture logicFunction;
