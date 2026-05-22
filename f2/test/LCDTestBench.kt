object LCDTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   LCD test bench")
        LCD.init()
        LCD.clear()

        LCD.write("LCD OK")
        Thread.sleep(500)

        LCD.cursor(1, 0)
        LCD.write("Linha 2")
        Thread.sleep(500)

        LCD.enableCursor(true)
        Thread.sleep(500)
        LCD.enableCursor(false)

        LCD.writeIcon(RomIcons.LEFT_ARROW)
        LCD.writeIcon(RomIcons.RIGHT_ARROW)
        LCD.writeIcon(Icons.EURO_SIGN)

        LCD.deleteText(LCD.Line.UPPER, 0, 2)
        LCD.moveCursorToLineStart(LCD.Line.LOWER)

        println("TEST: [OUTPUT]  Sequência de operações LCD executada.")
        println("TEST: [END]     LCD test bench finalizado")
    }
}
