library ieee;
use ieee.std_logic_1164.all;

entity CoinAcceptor is
    port (
        Coin            : in  std_logic;
        CId             : in  std_logic_vector(2 downto 0);
        CoinInputBits   : out std_logic_vector(3 downto 0);
        AcceptCmd       : in  std_logic;
        EjectCmd        : in  std_logic;
        CollectCmd      : in  std_logic;
        Accept          : out std_logic;
        Eject           : out std_logic;
        Collect         : out std_logic
    );
end entity CoinAcceptor;

architecture logicFunction of CoinAcceptor is
begin
    CoinInputBits(3) <= Coin;
    CoinInputBits(0) <= CId(0);
    CoinInputBits(1) <= CId(1);
    CoinInputBits(2) <= CId(2);

    Accept           <= AcceptCmd;
    Eject            <= EjectCmd;
    Collect          <= CollectCmd;
end architecture logicFunction;
