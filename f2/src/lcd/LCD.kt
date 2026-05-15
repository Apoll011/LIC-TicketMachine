object LCD {
    private const val RS_MASK = 0x1
    private const val E_MASK = 0x200

    private val commands = mapOf<String, Int>(
        "init_mode_error"   to 0x30, 
        "init_mode"         to 0x38, 
        "display_off"       to 0x08,
        "display_on"        to 0x0c,
        "clear"             to 0x01,
        "entry_mode"        to 0x06,
        "cursor_on"         to 0x0F,
        "cursor_off"        to 0x0C
    )

    private const val CGRAM_BASE_ADDR = 0x40
    private const val CGRAM_CELL_SIZE = 8

    enum class Line { UPPER, LOWER }


    private fun writeByteSerial(rs: Boolean, data: Int) {
        var frame = (data and 0xFF) shl 1
        if (rs) frame = frame or RS_MASK

        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frame, 10)
        Thread.sleep(1)
        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frame or E_MASK, 10)
        Thread.sleep(1)
        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frame, 10)
    }

    private fun writeByte(rs: Boolean, data: Int) {
        writeByteSerial(rs, data)
    }

    private fun writeCMD(data: Int) {
        writeByte(false, data)

        if (data == 0b00000001) Thread.sleep(3L)
        else Thread.sleep(1L)
    }

    private fun writeData(data: Int) {
        writeByte(true, data)
        Thread.sleep(2L)
    }


    fun init() {
        SerialEmitter.init()
        Thread.sleep(50)

        initSequence()

        initCommands()
    }

    fun initSequence() {
        repeat(3) {
            writeByte(false, 0x30) // 0x30 para que ocorra um erro de 8 bits
            Thread.sleep(5)
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

    fun writeChar(c: Char) = writeData(c.code)

    fun write(text: String) = text.forEach { writeChar(it) }

    fun cursor(line: Int, column: Int) {
        var data = column.or(0x80)
        if (line == Line.LOWER.ordinal) data = data.or(0x40)
        writeCMD(data)
    }

    fun clear() = writeCMD(commands["clear"]!!)


    // Helpers

    fun loadIcon(char: Icons, slot: Int) {
        val cgramAddr = CGRAM_BASE_ADDR + slot * CGRAM_CELL_SIZE
        writeCMD(cgramAddr)
        for (p in char.pattern) writeData(p)
        cursor(0, 0)
    }

    fun writeIcon(char: Icons) {
        val slot = LCDRam.slotFor(char)
        println(slot)
        loadIcon(char, slot)
        writeData(slot)
    }

    fun writeIcon(char: RomIcons) {
        writeData(char.addr)
    }

    fun enableCursor(status: Boolean) = writeCMD(if (status) commands["cursor_on"]!! else commands["cursor_off"]!!)

    private fun enableDisplay(status: Boolean) = writeCMD(if (status) commands["display_on"]!! else commands["display_off"]!!)

    fun moveCursorToLineStart(line: Line) = cursor(line.ordinal, 0)

    fun deleteText(line: Line, col1: Int, col2: Int) {
        val str = " ".repeat(col2 - col1 + 1)
        cursor(line.ordinal, col1)
        write(str)
    }
}