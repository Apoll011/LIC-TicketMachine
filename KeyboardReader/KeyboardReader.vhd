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
        TXD      , clk_out, clk_out_rise       : out STD_LOGIC
    );
end entity KeyboardReader;

architecture logicFunction of KeyboardReader is
    component Key_Decode is
        port (
            Kack, RESET, CLK : in  STD_LOGIC;
            Tdelay           : in  STD_LOGIC_VECTOR(1 downto 0);
            Kval           , clk_out, clk_out_rise  : out STD_LOGIC;
            K                : out STD_LOGIC_VECTOR(3 downto 0);
            Keys_Vertical    : out STD_LOGIC_VECTOR(3 downto 0);
            Keys_Horizontal  : in  STD_LOGIC_VECTOR(3 downto 0)
        );
    end component Key_Decode;

    component RingBuffer is
        port (
			  CLK   		: in  std_logic;
			  RESET 		: in  std_logic;
			  CTS 		: in  std_logic;
			  DAV 		: in  std_logic;
			  D	      : in std_logic_vector(3 downto 0);
			  Q	      : out std_logic_vector(3 downto 0);
			  Wreg	   : out  std_logic;
			  DAC		   : out  std_logic
        );
    end component RingBuffer;

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


    signal KEY_CODE_LINK, KEY_VALUE : STD_LOGIC_VECTOR(3 downto 0);
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
        Keys_Horizontal => Keys_Horizontal,
		  clk_out => clk_out, 
		  clk_out_rise => clk_out_rise 
    );

    buff: component RingBuffer
    port map (
        CLK    => CLK,
        RESET  => RESET,
        CTS		=> KBFREE_LINK,
		  DAV		=> KVAL_LINK,
		  D		=> KEY_CODE_LINK,
		  Q		=> KEY_VALUE,
		  Wreg	=> LOAD_LINK,
		  DAC 	=> KACK_LINK
    );

   TRANSMITTER : component KeyTransmitter
    port map (
        CLK    => CLK,
        RESET  => RESET,
        DataIn => KEY_VALUE,
        Load   => LOAD_LINK,
        KBfree => KBFREE_LINK,
        TXclk  => TXclk,
        TXD    => TXD
    );

end architecture logicFunction;