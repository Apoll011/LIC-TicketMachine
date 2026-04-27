object KBDSerial {
    private const val KVAL_MASK = 0x80
    private const val KCODE_MASK = 0x0F

    private const val KACK_MASK = 0x80

    enum class Key(val char: Char) {
        KEY_1('1'),
        KEY_2('2'),
        KEY_3('3'),
        KEY_4('4'),
        KEY_5('5'),
        KEY_6('6'),
        KEY_7('7'),
        KEY_8('8'),
        KEY_9('9'),
        KEY_0('0'),
        KEY_A('A'),
        KEY_B('B'),
        KEY_C('C'),
        KEY_D('D'),
        KEY_HASH('#'),
        KEY_STAR('*'),
        KEY_NONE('\u0000')
    }


    fun init() {
        HAL.init()
    }

    fun getKey(): Char {
        return readKey().char
    }

    fun readKey(): Key {
        if (!HAL.isBit(KVAL_MASK)) return Key.KEY_NONE

        val code = HAL.readBits(KCODE_MASK)
        HAL.setBits(KACK_MASK)

        while (HAL.isBit(KVAL_MASK)) {
            Thread.yield()
        }

        HAL.clrBits(KACK_MASK)

        return convertToKey(code)
    }

    private fun convertToKey(id: Int): Key = when (id) {
        0b0000 -> Key.KEY_D
        0b0100 -> Key.KEY_STAR
        0b1000 -> Key.KEY_0
        0b1100 -> Key.KEY_HASH
        0b0001 -> Key.KEY_1
        0b0101 -> Key.KEY_2
        0b1001 -> Key.KEY_3
        0b1101 -> Key.KEY_A
        0b0010 -> Key.KEY_4
        0b0110 -> Key.KEY_5
        0b1010 -> Key.KEY_6
        0b1110 -> Key.KEY_B
        0b0111 -> Key.KEY_8
        0b1011 -> Key.KEY_9
        0b0011 -> Key.KEY_7
        0b1111 -> Key.KEY_C
        else -> Key.KEY_NONE
    }

    fun waitKey(timeout: Long): Char {
        val endTime = System.currentTimeMillis() + timeout

        while (System.currentTimeMillis() < endTime) {
            val key = getKey()
            if (key != Key.KEY_NONE.char) return key
            Thread.sleep(1)
        }
        return Key.KEY_NONE.char
    }
}


object KBD {

    // ----------------------------------------------------------
    // Key definitions
    // Maps 4-bit hardware key codes to characters.
    //
    // Code layout from Key_Scan (col[1:0] = column, row[1:0] = row):
    //
    //        COL0   COL1   COL2   COL3
    // ROW0   0000   0100   1000   1100
    // ROW1   0001   0101   1001   1101
    // ROW2   0010   0110   1010   1110
    // ROW3   0011   0111   1011   1111
    //
    // Physical keypad layout:
    //   [ 1 ][ 2 ][ 3 ][ A ]
    //   [ 4 ][ 5 ][ 6 ][ B ]
    //   [ 7 ][ 8 ][ 9 ][ C ]
    //   [ * ][ 0 ][ # ][ D ]
    // ----------------------------------------------------------
    enum class Key(val char: Char) {
        KEY_1('1'),
        KEY_2('2'),
        KEY_3('3'),
        KEY_4('4'),
        KEY_5('5'),
        KEY_6('6'),
        KEY_7('7'),
        KEY_8('8'),
        KEY_9('9'),
        KEY_0('0'),
        KEY_A('A'),
        KEY_B('B'),
        KEY_C('C'),
        KEY_D('D'),
        KEY_HASH('#'),
        KEY_STAR('*'),
        KEY_NONE('\u0000')
    }

    private const val RXD_MASK   = 0b00000010  // input  port bit 1: TXD from hardware
    private const val RXCLK_MASK = 0b00001000  // output port bit 3: serial clock to hardware

    private const val MAX_CLOCKS = 7

    fun init() {
        HAL.clrBits(RXCLK_MASK)
    }

    fun getKey(): Char = readKey().char

    fun waitKey(timeout: Long): Char {
        val stopTime = System.currentTimeMillis() + timeout
        while (System.currentTimeMillis() < stopTime) {
            val key = getKey()
            if (key != Key.KEY_NONE.char) return key
            Thread.sleep(1)
        }
        return Key.KEY_NONE.char
    }

    fun readKey(): Key {
        var clockCounter = 0
        var rawCode = -1

        // Check INIT bit: TXD must be LOW to indicate a frame is starting
        if (!HAL.isBit(RXD_MASK)) {
            clockCycle(clockCounter++)     // Slot 0: INIT - advance past the low

            // Check START bit: TXD must be HIGH
            if (HAL.isBit(RXD_MASK)) {
                clockCycle(clockCounter++) // Slot 1: START bit confirmed
                rawCode = 0

                // Read 4 data bits, LSB first (K[0]..K[3])
                for (i in 0..3) {
                    if (HAL.isBit(RXD_MASK)) {
                        rawCode = rawCode or (1 shl i)
                    }
                    clockCycle(clockCounter++) // Slots 2..5: data bits
                }

                // Check STOP bit: TXD should be LOW
                if (!HAL.isBit(RXD_MASK)) {
                    clockCycle(clockCounter++) // Slot 6: STOP bit
                }
            }

            // Drain remaining clocks so KeyTransmitter finishes cleanly
            while (clockCounter < MAX_CLOCKS) {
                clockCycle(clockCounter++)
            }
        }

        return if (rawCode != -1 && rawCode in 0..15)
            convertToKey(rawCode)
        else
            Key.KEY_NONE
    }
    
    private fun clockCycle(count: Int) {
        HAL.setBits(RXCLK_MASK)
        HAL.clrBits(RXCLK_MASK)
    }

    private fun convertToKey(code: Int): Key = when (code) {
        0b0000 -> Key.KEY_1
        0b0100 -> Key.KEY_2
        0b1000 -> Key.KEY_3
        0b1100 -> Key.KEY_A
        0b0001 -> Key.KEY_4
        0b0101 -> Key.KEY_5
        0b1001 -> Key.KEY_6
        0b1101 -> Key.KEY_B
        0b0010 -> Key.KEY_7
        0b0110 -> Key.KEY_8
        0b1010 -> Key.KEY_9
        0b1110 -> Key.KEY_C
        0b0011 -> Key.KEY_STAR
        0b0111 -> Key.KEY_0
        0b1011 -> Key.KEY_HASH
        0b1111 -> Key.KEY_D
        else   -> Key.KEY_NONE
    }
}