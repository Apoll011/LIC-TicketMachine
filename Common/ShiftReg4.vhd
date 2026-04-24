library IEEE;
use IEEE.std_logic_1164.all;

-- ShiftReg4 com porta EN: só avança (ou carrega) quando EN='1'
entity ShiftReg4 is
    port (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        LOAD  : in  std_logic;
        EN    : in  std_logic;                     -- clock enable
        D     : in  std_logic_vector(3 downto 0);  -- entrada paralela
        Q_out : out std_logic                      -- saída série (MSB)
    );
end entity ShiftReg4;

architecture logicFunction of ShiftReg4 is

    component FFD is
        port (
            CLK   : in  std_logic;
            RESET : in  std_logic;
            SET   : in  std_logic;
            D     : in  std_logic;
            EN    : in  std_logic;
            Q     : out std_logic
        );
    end component FFD;

    component MUX1 is
        port (
            A  : in  std_logic;
            B  : in  std_logic;
            OP : in  std_logic;
            F  : out std_logic
        );
    end component MUX1;

    signal q     : std_logic_vector(3 downto 0);
    signal d_ff  : std_logic_vector(3 downto 0);

begin
    -- Quando LOAD='1': carrega D; quando LOAD='0': desloca (q(n) <- q(n-1))
    MUX3: component MUX1 port map (A => q(2), B => D(3), OP => LOAD, F => d_ff(3));
    MUX2: component MUX1 port map (A => q(1), B => D(2), OP => LOAD, F => d_ff(2));
    MUX1i:component MUX1 port map (A => q(0), B => D(1), OP => LOAD, F => d_ff(1));
    MUX0: component MUX1 port map (A => '0',  B => D(0), OP => LOAD, F => d_ff(0));

    -- EN ligado ao mesmo EN dos FFDs: o registo só actualiza quando EN='1'
    FF3: component FFD port map (CLK=>CLK, RESET=>RESET, SET=>'0', D=>d_ff(3), EN=>EN, Q=>q(3));
    FF2: component FFD port map (CLK=>CLK, RESET=>RESET, SET=>'0', D=>d_ff(2), EN=>EN, Q=>q(2));
    FF1: component FFD port map (CLK=>CLK, RESET=>RESET, SET=>'0', D=>d_ff(1), EN=>EN, Q=>q(1));
    FF0: component FFD port map (CLK=>CLK, RESET=>RESET, SET=>'0', D=>d_ff(0), EN=>EN, Q=>q(0));

    Q_out <= q(3);

end architecture logicFunction;