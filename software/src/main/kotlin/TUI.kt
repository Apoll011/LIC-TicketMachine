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

    fun readKey(timeout: Long = 5000L): Char {
        return KBD.waitKey(timeout)
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