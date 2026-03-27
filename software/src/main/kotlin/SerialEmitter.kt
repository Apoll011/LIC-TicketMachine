object SerialEmitter {
    private const val LCD_MASK  = 0b00000010
    private const val SSC_MASK  = 0b00000100
    private const val SCLK_MASK = 0b00001000
    private const val SDX_MASK  = 0b00010000

    enum class Peripheral {LCD, TICKET}

    fun init() {
        HAL.setBits(LCD_MASK)
        HAL.setBits(SSC_MASK)
        HAL.setBits(SCLK_MASK)
    }

    fun send(addr: Peripheral, data: Int, size: Int) {
        var _data = data

        if (addr == Peripheral.LCD) {
            HAL.clrBits(LCD_MASK)
        } else if (addr == Peripheral.TICKET) {
            HAL.clrBits(SSC_MASK)
        }

        _data = _data.shl(SDX_MASK)
        for (i in 0 until size - 1) {
            HAL.clrBits(SCLK_MASK)
            HAL.writeBits(SDX_MASK, _data)

            _data = _data.shr(1)
            HAL.setBits(SCLK_MASK)
        }

        HAL.clrBits(SCLK_MASK)
        HAL.writeBits(SDX_MASK, 0XFF) //Writes the E
        HAL.setBits(SCLK_MASK)

        if (addr == Peripheral.LCD) {
            HAL.setBits(LCD_MASK)
        } else if (addr == Peripheral.TICKET) {
            HAL.setBits(SSC_MASK)
        }
    }

    fun isBusy(): Boolean {
        return !HAL.isBit(LCD_MASK) or !HAL.isBit(SSC_MASK)
    }

}