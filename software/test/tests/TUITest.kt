fun testTUI() {
    println("Testing TUI...")
    TUI.init()
    println("TUI initialized.")

    println("Writing 'TUI Test'...")
    TUI.cursor(0, 0)
    TUI.writeChar('T')
    TUI.writeChar('U')
    TUI.writeChar('I')
    TUI.writeChar(' ')
    TUI.writeChar('T')
    TUI.writeChar('e')
    TUI.writeChar('s')
    TUI.writeChar('t')

    println("Clearing screen in 2 seconds...")
    Thread.sleep(2000)
    TUI.clear()

    println("TUI testing echo mode. Press '*' to clear, '#' for next line, or any key to write.")
    println("Echo mode is infinite, manual stop required.")
    TUI.echo()
}

fun main() {
    testTUI()
}
