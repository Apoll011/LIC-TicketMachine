fun testLCD() {
    println("Testing LCD...")
    LCD.init()
    println("LCD initialized and cleared.")

    LCD.write("Hello, World!")
    println("Should see 'Hello, World!' on line 0.")

    LCD.cursor(1, 0)
    LCD.write("Testing LCD...")
    println("Should see 'Testing LCD...' on line 1.")

    Thread.sleep(2000)
    LCD.clear()
    println("LCD should be cleared.")

    LCD.cursor(0, 5)
    LCD.writeChar('X')
    println("Should see 'X' at position (0, 5).")
}

fun main() {
    testLCD()
}
