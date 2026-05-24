library ieee;
use ieee.std_logic_1164.all;

entity CoinAcceptor is
    port (
        Coin             : in  std_logic;
        CId              : in  std_logic_vector(2 downto 0);
        OUTPUT_PORT_LINK : in  std_logic_vector(7 downto 0);
        INPUT_PORT_LINK  : out std_logic_vector(3 downto 0);
        Accept           : out std_logic;
        Eject            : out std_logic;
        Collect          : out std_logic
    );
end entity CoinAcceptor;

architecture logicFunction of CoinAcceptor is
begin
    INPUT_PORT_LINK(3) <= Coin;
    INPUT_PORT_LINK(0) <= CId(0);
    INPUT_PORT_LINK(1) <= CId(1);
    INPUT_PORT_LINK(2) <= CId(2);

    Accept             <= OUTPUT_PORT_LINK(4);
    Eject              <= OUTPUT_PORT_LINK(5);
    Collect            <= OUTPUT_PORT_LINK(6);
end architecture logicFunction;
