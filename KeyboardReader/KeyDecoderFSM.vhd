library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyDecoderFSM is
    port (
        reset        : in  std_logic;
        clk          : in  std_logic;
        Kpress, Kack : in  std_logic;
        Tdelay       : in  std_logic_vector(1 downto 0); -- 00=500ms 01=1000ms 10=1500ms 11=2000ms
        Kval, Kscan, clk_out, clk_out_rise : out std_logic
    );
end entity KeyDecoderFSM;

architecture behavioral of KeyDecoderFSM is

	component KeyDelay is
		port (
		CLK, CE, RESET			: in std_logic;
		Tdelay					: in std_logic_vector(1 downto 0);
		F							: out std_logic
      );
	end component KeyDelay;

    component CLKDIV is
        generic (
            div : natural := 50000000
        );
        port (
            clk_in  : in  std_logic;
            clk_out : out std_logic
        );
    end component CLKDIV;
	 
	 component EdgeDetect is
    port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;
        SIG_IN : in  std_logic;
        RISE   : out std_logic
    );
	 end component EdgeDetect;
	 
    type STATE_TYPE is (STANDING_BY, READING_DATA, DATA_ACCEPTED);

    signal CurrentState, NextState  : STATE_TYPE;
    signal clk_out1                 : std_logic;
    signal clk_out_prev             : std_logic := '0';
    signal clk_out_rise1            : std_logic;
	 signal CLK_Divider					: std_logic;
	 
	 signal resetdelay					: std_logic;
	 signal CEDelay						: std_logic;
	 signal delay_out						: std_logic;
	 
	 
begin

	 Clk_div : component CLKDIV
    generic map (50)
    port map (
        clk_in  => CLK,
        clk_out => CLK_Divider
    );
	 
	clk_out <= delay_out;

    -- Instantiate delay clock generator
    clkd: component KeyDelay
    port map (
		CLK 		=> CLK_Divider, 
		CE 		=> CEDelay,   				
		Tdelay	=> Tdelay, 					
		F			=> delay_out,
		RESET    => resetdelay
      );


    StateRegister: process (clk, reset) is
    begin
        if reset = '1' then
            CurrentState      <= STANDING_BY;
        elsif rising_edge(clk) then
            CurrentState      <= NextState;
        end if;
    end process StateRegister;

    GenerateNextState: process (CurrentState, Kpress, Kack, delay_out) is
    begin
        case CurrentState is

            when STANDING_BY =>
                if (Kpress = '1') then
                    NextState <= READING_DATA;
                else
                    NextState <= STANDING_BY;
                end if;

            when READING_DATA =>
                if (Kack = '1') then
                    NextState <= DATA_ACCEPTED;
                else
                    NextState <= READING_DATA;
                end if;

            when DATA_ACCEPTED =>
                if Kpress = '0' or delay_out = '1' then
                    NextState <= STANDING_BY;
                else
                    NextState <= DATA_ACCEPTED;
                end if;

        end case;
    end process GenerateNextState;

    Kscan 		<= '1' when (CurrentState = STANDING_BY)   else '0';
    Kval  		<= '1' when (CurrentState = READING_DATA)  else '0';
	 resetdelay	<= '1' when (CurrentState = STANDING_BY)   else '0';
	 CEDelay		<= '1' when	(CurrentState = DATA_ACCEPTED) else '0';
end architecture behavioral;
