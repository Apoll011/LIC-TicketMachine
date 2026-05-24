library ieee;
use ieee.std_logic_1164.all;

entity TICKET_DISPENSER_tb is
end entity TICKET_DISPENSER_tb;

architecture behavioral of TICKET_DISPENSER_tb is

    component TICKET_DISPENSER is
        port (
            RT, Prt, CollectTicket             : in  STD_LOGIC;
            O, D                               : in  STD_LOGIC_VECTOR(3 downto 0);
            Fn                                 : out STD_LOGIC;
            HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component TICKET_DISPENSER;

    signal RT_tb            : std_logic;
    signal Prt_tb           : std_logic;
    signal CollectTicket_tb : std_logic;
    signal O_tb             : std_logic_vector(3 downto 0);
    signal D_tb             : std_logic_vector(3 downto 0);
    signal Fn_tb            : std_logic;
    signal HEX0_tb          : std_logic_vector(7 downto 0);
    signal HEX1_tb          : std_logic_vector(7 downto 0);
    signal HEX2_tb          : std_logic_vector(7 downto 0);
    signal HEX3_tb          : std_logic_vector(7 downto 0);
    signal HEX4_tb          : std_logic_vector(7 downto 0);
    signal HEX5_tb          : std_logic_vector(7 downto 0);

begin

    UUT: component TICKET_DISPENSER
    port map (
        RT            => RT_tb,
        Prt           => Prt_tb,
        CollectTicket => CollectTicket_tb,
        O             => O_tb,
        D             => D_tb,
        Fn            => Fn_tb,
        HEX0          => HEX0_tb,
        HEX1          => HEX1_tb,
        HEX2          => HEX2_tb,
        HEX3          => HEX3_tb,
        HEX4          => HEX4_tb,
        HEX5          => HEX5_tb
    );

    stimulus: process
    begin
        RT_tb <= '0';
        Prt_tb <= '0';
        CollectTicket_tb <= '0';
        O_tb <= "0000";
        D_tb <= "0000";
        wait for 40 ns;

        Prt_tb <= '1';
        RT_tb <= '1';
        O_tb <= "0011";
        D_tb <= "1001";
        wait for 40 ns;

        CollectTicket_tb <= '1';
        wait for 20 ns;
        CollectTicket_tb <= '0';
        wait for 20 ns;

        RT_tb <= '0';
        O_tb <= "0101";
        D_tb <= "1110";
        wait for 40 ns;

        Prt_tb <= '0';
        wait for 40 ns;

        Prt_tb <= '1';
        RT_tb <= '1';
        O_tb <= "0001";
        D_tb <= "0100";
        wait for 40 ns;

        wait;
    end process stimulus;

end architecture behavioral;
