object SerialEmitter {
    enum class Peripheral {LCD, TICKET}

    private const val SDX_MASK = 0b00000001 //01
    private const val SCLK_MASK= 0b00000010 //10
    private const val LCD_MASK = 0b00000100 //100
    private const val SSC_MASK = 0b00001000 //11

    fun init() {
        HAL.init()
        HAL.clrBits(SDX_MASK or SCLK_MASK or LCD_MASK or SSC_MASK)
    }

    fun send(addr: Peripheral, data: Int, size: Int) {
        var _data = data

        HAL.clrBits(SCLK_MASK)

        if (addr == Peripheral.LCD) {
            HAL.clrBits(LCD_MASK)
        } else if (addr == Peripheral.TICKET) {
            HAL.clrBits(SSC_MASK)
        }

        for (i in 0 until size) {
            HAL.writeBits(SDX_MASK, _data)

            _data = _data.shr(1)
            HAL.setBits(SCLK_MASK)
            HAL.clrBits(SCLK_MASK)
        }

        if (addr == Peripheral.LCD) {
            HAL.setBits(LCD_MASK)       // SS=1
            Thread.sleep(1)             // tempo suficiente
            HAL.setBits(SCLK_MASK)      // pulso de clock extra para HoldRegister capturar
            HAL.clrBits(SCLK_MASK)
            Thread.sleep(1)
            HAL.clrBits(LCD_MASK)  
        } else if (addr == Peripheral.TICKET) {
            HAL.setBits(SSC_MASK)
            Thread.sleep(0, 40)
            HAL.clrBits(SSC_MASK)
        }
    }
}
