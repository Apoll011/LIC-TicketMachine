object TUI {
    fun init() {
        HAL.init()
        KBD.init()
        LCD.init()
        LCD.clear()
    }

    fun clear() {
        LCD.clear()
    }

    fun cursor(line: Int, col: Int) {
        LCD.cursor(line, col)
    }

    fun writeChar(char: Char) {
        LCD.writeChar(char)
    }

    fun write(text: String) = LCD.write(text)

    fun writeIcon(char: Icons) = LCD.writeIcon(char)

    fun writeIcon(char: RomIcons) = LCD.writeIcon(char)

    fun deleteText(line: LCD.Line, col1: Int, col2: Int) = LCD.deleteText(line, col1, col2)

    fun readKey(timeout: Long = 5000L): Char {
        return KBD.waitKey(timeout)
    }


    fun getKey(): Char {
        return KBD.readKey().char
    }

    fun echo() {
        var line = 0
        var col = 0

        while (true) {
            val key = readKey()

            if (key == KBD.Key.KEY_NONE.char) continue

            when (key) {
                '*' -> {
                    clear()
                    line = 0
                    col = 0
                }

                '#' -> {
                    line = (line + 1) % 2
                    col = 0
                    cursor(line, col)
                }

                else -> {
                    cursor(line, col)
                    writeChar(key)
                    col++

                    if (col >= 16) {
                        col = 0
                        line = (line + 1) % 2
                    }
                }
            }
        }
    }
}