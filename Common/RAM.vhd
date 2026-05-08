library ieee;
use ieee.std_logic_1164.all;

entity RAM is
    port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;
        address : in  std_logic_vector(3 downto 0);
        wr      : in  std_logic;
        din     : in  std_logic_vector(3 downto 0);
        dout    : out std_logic_vector(3 downto 0)
    );
end entity RAM;

architecture structural of RAM is
component DecoderBuffer is
        port (S : in  std_logic_vector(3 downto 0);
              C : out std_logic_vector(15 downto 0));
    end component;

    component Reg is
        port (CLK   : in  std_logic;
              RESET : in  std_logic;
              D     : in  std_logic_vector(3 downto 0);
              EN    : in  std_logic;
              Q     : out std_logic_vector(3 downto 0));
    end component;

    component MUX4 is
        port (A, B : in  std_logic_vector(3 downto 0);
              OP   : in  std_logic;
              F    : out std_logic_vector(3 downto 0));
    end component;

    -- Decoder one-hot output
    signal dec_out : std_logic_vector(15 downto 0);

    signal en0, en1, en2,  en3,  en4,  en5,  en6,  en7  : std_logic;
    signal en8, en9, en10, en11, en12, en13, en14, en15  : std_logic;

    signal q0,  q1,  q2,  q3  : std_logic_vector(3 downto 0);
    signal q4,  q5,  q6,  q7  : std_logic_vector(3 downto 0);
    signal q8,  q9,  q10, q11 : std_logic_vector(3 downto 0);
    signal q12, q13, q14, q15 : std_logic_vector(3 downto 0);

    signal m0_0, m0_1, m0_2, m0_3 : std_logic_vector(3 downto 0);
    signal m0_4, m0_5, m0_6, m0_7 : std_logic_vector(3 downto 0);

    signal m1_0, m1_1, m1_2, m1_3 : std_logic_vector(3 downto 0);

    signal m2_0, m2_1 : std_logic_vector(3 downto 0);

    signal m3_0 : std_logic_vector(3 downto 0);

begin

    --  Address decoder
    U_DEC : DecoderBuffer
        port map (S => address, C => dec_out);

    en0  <= dec_out(0)  and wr;
    en1  <= dec_out(1)  and wr;
    en2  <= dec_out(2)  and wr;
    en3  <= dec_out(3)  and wr;
    en4  <= dec_out(4)  and wr;
    en5  <= dec_out(5)  and wr;
    en6  <= dec_out(6)  and wr;
    en7  <= dec_out(7)  and wr;
    en8  <= dec_out(8)  and wr;
    en9  <= dec_out(9)  and wr;
    en10 <= dec_out(10) and wr;
    en11 <= dec_out(11) and wr;
    en12 <= dec_out(12) and wr;
    en13 <= dec_out(13) and wr;
    en14 <= dec_out(14) and wr;
    en15 <= dec_out(15) and wr;

    --  Register bank  (16 x Reg)
    U_REG0  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en0,  Q => q0);
    U_REG1  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en1,  Q => q1);
    U_REG2  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en2,  Q => q2);
    U_REG3  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en3,  Q => q3);
    U_REG4  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en4,  Q => q4);
    U_REG5  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en5,  Q => q5);
    U_REG6  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en6,  Q => q6);
    U_REG7  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en7,  Q => q7);
    U_REG8  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en8,  Q => q8);
    U_REG9  : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en9,  Q => q9);
    U_REG10 : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en10, Q => q10);
    U_REG11 : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en11, Q => q11);
    U_REG12 : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en12, Q => q12);
    U_REG13 : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en13, Q => q13);
    U_REG14 : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en14, Q => q14);
    U_REG15 : Reg port map (CLK => CLK, RESET => RESET, D => din, EN => en15, Q => q15);

    MUX_L0_0 : MUX4 port map (A => q0,  B => q1,  OP => address(0), F => m0_0);
    MUX_L0_1 : MUX4 port map (A => q2,  B => q3,  OP => address(0), F => m0_1);
    MUX_L0_2 : MUX4 port map (A => q4,  B => q5,  OP => address(0), F => m0_2);
    MUX_L0_3 : MUX4 port map (A => q6,  B => q7,  OP => address(0), F => m0_3);
    MUX_L0_4 : MUX4 port map (A => q8,  B => q9,  OP => address(0), F => m0_4);
    MUX_L0_5 : MUX4 port map (A => q10, B => q11, OP => address(0), F => m0_5);
    MUX_L0_6 : MUX4 port map (A => q12, B => q13, OP => address(0), F => m0_6);
    MUX_L0_7 : MUX4 port map (A => q14, B => q15, OP => address(0), F => m0_7);

    MUX_L1_0 : MUX4 port map (A => m0_0, B => m0_1, OP => address(1), F => m1_0);
    MUX_L1_1 : MUX4 port map (A => m0_2, B => m0_3, OP => address(1), F => m1_1);
    MUX_L1_2 : MUX4 port map (A => m0_4, B => m0_5, OP => address(1), F => m1_2);
    MUX_L1_3 : MUX4 port map (A => m0_6, B => m0_7, OP => address(1), F => m1_3);

    MUX_L2_0 : MUX4 port map (A => m1_0, B => m1_1, OP => address(2), F => m2_0);
    MUX_L2_1 : MUX4 port map (A => m1_2, B => m1_3, OP => address(2), F => m2_1);

    MUX_L3_0 : MUX4 port map (A => m2_0, B => m2_1, OP => address(3), F => m3_0);

    dout <= m3_0;

end architecture structural;