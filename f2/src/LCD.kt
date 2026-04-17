object LCD {
    private const val LINES = 2
    private const val COLS = 16

    private const val RS_MASK = 0x1
    private const val E_MASK = 0x200

    private fun writeByteSerial(rs: Boolean, data: Int) {
        var frame = (data and 0xFF) shl 1
        if (rs) frame = frame or RS_MASK
        println(data)
        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frame, 10)
        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frame or E_MASK, 10)
        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frame, 10)
    }

    private fun writeByte(rs: Boolean, data: Int) {
        writeByteSerial(rs, data)
    }

    private fun writeCMD(data: Int) {
        writeByte(false, data)

        if (data == 0b00000001) Thread.sleep(2L)
        else Thread.sleep(1L)
    }

    private fun writeDATA(data: Int) {
        writeByte(true, data)
        Thread.sleep(1L)
    }

    fun init() {
        SerialEmitter.init()
        Thread.sleep(20)

        initSequence()

        initCommands()
    }

    fun initSequence() {
        repeat(3) {
            writeByte(false, 0x30) // 0x30 para que ocorra um erro de 8 bits
            Thread.sleep(1)
        }
    }

    fun initCommands() {
        writeCMD(0x38) // 8 bits
        writeCMD(0x08) // display off
        writeCMD(0x01) // clear
        Thread.sleep(5)
        writeCMD(0x06) // entry mode set
        writeCMD(0x0C) // display on
    }

    fun writeChar(c: Char) {
        if (c != '\u0000') writeDATA(c.code)
    }

    fun write(text: String) {
        for (char in text) {
            writeChar(char)
        }
    }

    fun cursor(line: Int, column: Int) {
        val l = line.coerceIn(0, LINES - 1)
        val c = column.coerceIn(0, COLS - 1)
        val address = if (l == 0) c else 0x40 + c
        writeCMD(0x80 or address)
    }

    fun clear() {
        writeCMD(0x01)
    }
}