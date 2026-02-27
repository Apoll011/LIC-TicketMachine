library IEEE;
use IEEE.std_logic_1164.all;

entity MUX4 is
port (
	A, B: in std_logic_vector(3 downto 0);
	OP: in std_logic;
	F: out std_logic_vector(3 downto 0)
);
end MUX4;

architecture logicfunction of MUX4 is

component MUX1 port (
		A :in std_logic;
		B :in std_logic;
		OP:in std_logic;
		F :out std_logic
		);
end component;

signal Opin: std_logic_vector(3 downto 0);

begin

u1: MUX1 port map (A => A(0), B => B(0), Op => Opin(0), F => F(0));
u2: MUX1 port map (A => A(1), B => B(1), Op => Opin(1), F => F(1));
u3: MUX1 port map (A => A(2), B => B(2), Op => Opin(2), F => F(2));
u4: MUX1 port map (A => A(3), B => B(3), Op => Opin(3), F => F(3));
Opin <= (others => Op);


end logicfunction;