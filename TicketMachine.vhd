library ieee;
use ieee.std_logic_1164.all;

entity TicketMachine is
    port (
        CLK             : in  std_logic;
        RESET           : in  std_logic;

        Keys_Vertical   : out std_logic_vector(3 downto 0); -- column drives
        Keys_Horizontal : in  std_logic_vector(3 downto 0); -- row reads

        LCD_RS          : out std_logic; -- register select
        LCD_EN          : out std_logic; -- enable strobe
        LCD_DATA        : out std_logic_vector(7 downto 0); -- data[7:0]
        INPUT           : out std_logic_vector(7 downto 0);
		  CollectTicket	: in std_logic;
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out STD_LOGIC_VECTOR(7 downto 0)

		  
    );
end entity TicketMachine;

architecture logicFunction of TicketMachine is
    component Key_Decode is
        port (
            Kack, RESET, CLK : in  std_logic;
            Tdelay           : in  std_logic_vector(1 downto 0);
            Kval			     : out std_logic;
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

    component PETD is
        port (
            SDX, CLK, SS, RESET : in  std_logic;
            D                   : out std_logic_vector(7 downto 0);
				Prt,Rt 				  : out std_logic
        );
    end component PETD;
	 
	 component TICKET_DISPENSER 
    port (
        RT, Prt, CollectTicket             : in  STD_LOGIC;
        O, D                               : in  STD_LOGIC_VECTOR(3 downto 0);
        Fn                                 : out STD_LOGIC;
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out STD_LOGIC_VECTOR(7 downto 0)
    );
	 end component TICKET_DISPENSER;

    signal inputPort  : std_logic_vector(7 downto 0);
    signal outputPort : std_logic_vector(7 downto 0);

    signal key_code   : std_logic_vector(3 downto 0);
    signal kval_int   : std_logic;

    signal lcd_frame  : std_logic_vector(9 downto 0);
	 signal clko_1		 : std_logic;
	 
	 signal PETD_D 	 : std_logic_vector(7 downto 0);
	 signal Prt_out	 : std_logic;
	 signal Rt_out		 : std_logic;

begin

    usb: component UsbPort
    port map (
        inputPort       => inputPort,
        outputPort      => outputPort
    );

    decode: component Key_Decode
    port map (
        RESET           => RESET,
        CLK             => CLK,
        Kack            => outputPort(7),  -- software sets bit7 to ack a key
        Tdelay          => "11",
        Kval            => kval_int,
        K               => key_code,
        Keys_Vertical   => Keys_Vertical,
        Keys_Horizontal => Keys_Horizontal
    );

    inputPort(7)          <= kval_int;
    inputPort(6 downto 5) <= "00";
    inputPort(3 downto 0) <= key_code;

    lcd_serial: component PELCD
    port map (
        RESET           => RESET,
        CLK             => outputPort(1),  -- serial clock driven by software (SCLK_MASK bit 1)
        SDX             => outputPort(0),  -- serial data  (SDX_MASK  bit 0)
        SS              => outputPort(2),  -- slave select (LCD_MASK   bit 2)
        Q               => lcd_frame
    );
    ticket_serial: component PETD
    port map (
        RESET => RESET,
        CLK   => outputPort(1),   
        SDX   => outputPort(0),   
        SS    => outputPort(2),
        D     => PETD_D,
  		  Rt	  => Rt_out,
  		  Prt	  => Prt_out
      );
	 
 	 ticketdispenser: component TICKET_DISPENSER
	 port map(
		 RT				=> Rt_out, 
		 Prt 				=> Prt_out, 
		 CollectTicket => CollectTicket,
		 O 				=> PETD_D(3 downto 0), 
		 D					=> PETD_D(7 downto 4),
		 Fn 				=> inputPort(4),
		 HEX0 			=> HEX0, 
		 HEX1 			=> HEX1, 
		 HEX2				=> HEX2, 
		 HEX3 			=> HEX3, 
		 HEX4 			=> HEX4, 
		 HEX5 			=> HEX5);
		 
    LCD_RS                <= lcd_frame(9); -- bit 0  = RS
    LCD_DATA(0)           <= lcd_frame(8); -- bits 8:1 = data byte
    LCD_DATA(1)           <= lcd_frame(7);
    LCD_DATA(2)           <= lcd_frame(6);
    LCD_DATA(3)           <= lcd_frame(5);
    LCD_DATA(4)           <= lcd_frame(4);
    LCD_DATA(5)           <= lcd_frame(3);
    LCD_DATA(6)           <= lcd_frame(2);
    LCD_DATA(7)           <= lcd_frame(1);
    LCD_EN                <= lcd_frame(0); -- bit 9  = E (enable)


end architecture logicFunction;
