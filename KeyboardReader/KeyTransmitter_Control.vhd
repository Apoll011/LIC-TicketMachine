library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- KeyTransmitter_Control
--
-- FSM that controls the serial transmission of a 4-bit key code.
--
-- States:
--   STATE_IDLE : Waiting for a valid key (DAV = '1')
--   STATE_ACK  : Acknowledges the key to Key Decode, latches data
--   STATE_SEND : Clocks out the serial frame until CFlag = '1'
--
-- Outputs:
--   ENR      : Enable Register (latch DataIn into Reg)
--   RESET_C  : Reset the bit counter (active HIGH)
--   ENC      : Enable bit counter
--   DAC      : Data Acknowledged (fed back to Key Decode as KBfree)
--   TXD_INIT : '1' = line idle/high, '0' = frame in progress
-- ============================================================

entity KeyTransmitter_Control is

    port (
        CLK      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;
        DAV      : in  STD_LOGIC;  -- Data Available (Load from Key Decode)
        CFlag    : in  STD_LOGIC;  -- Terminal count flag (frame complete)

        ENR      : out STD_LOGIC;  -- Enable data register
        RESET_C  : out STD_LOGIC;  -- Reset bit counter
        ENC      : out STD_LOGIC;  -- Enable bit counter
        DAC      : out STD_LOGIC;  -- Data Acknowledged
        TXD_INIT : out STD_LOGIC   -- TXD line value ('1'=idle, '0'=sending)
    );

end entity KeyTransmitter_Control;

architecture behavioral of KeyTransmitter_Control is

    type STATE_TYPE is (STATE_IDLE, STATE_ACK, STATE_SEND);
    signal CurrentState, NextState : STATE_TYPE;

begin

    -- --------------------------------------------------------
    -- State register
    -- --------------------------------------------------------
    StateRegister : process (CLK, RESET) is
    begin
        if RESET = '1' then
            CurrentState <= STATE_IDLE;
        elsif rising_edge(CLK) then
            CurrentState <= NextState;
        end if;
    end process StateRegister;

    -- --------------------------------------------------------
    -- Next-state logic
    -- --------------------------------------------------------
    GenerateNextState : process (CurrentState, DAV, CFlag) is
    begin
        case CurrentState is

            -- Wait for Key Decode to signal a valid key
            when STATE_IDLE =>
                if DAV = '1' then
                    NextState <= STATE_ACK;
                else
                    NextState <= STATE_IDLE;
                end if;

            -- Latch data and acknowledge; wait for DAV to drop
            when STATE_ACK =>
                if DAV = '0' then
                    NextState <= STATE_SEND;
                else
                    NextState <= STATE_ACK;
                end if;

            -- Transmit serial frame; leave when counter reaches terminal count
            when STATE_SEND =>
                if CFlag = '1' then
                    NextState <= STATE_IDLE;
                else
                    NextState <= STATE_SEND;
                end if;

        end case;
    end process GenerateNextState;

    -- --------------------------------------------------------
    -- Output logic (Moore)
    -- --------------------------------------------------------

    -- Latch DataIn into the Reg while acknowledging the key
    ENR      <= '1' when CurrentState = STATE_ACK  else '0';

    -- Hold counter in reset outside of the SEND state
    RESET_C  <= '1' when CurrentState = STATE_IDLE else '0';

    -- Inform Key Decode the key has been accepted
    DAC      <= '1' when CurrentState = STATE_ACK or CurrentState = STATE_SEND else '0';

    -- Pull TXD low while the frame is being transmitted
    TXD_INIT <= '0' when CurrentState = STATE_SEND else '1';

    -- Run the bit counter only while sending
    ENC      <= '1' when CurrentState = STATE_SEND else '0';

end architecture behavioral;