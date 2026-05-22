object TUITestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   TUI test bench")
        TUI.init()

        TUI.clear()
        TUI.cursor(0, 0)
        TUI.writeChar('T')
        TUI.writeChar('U')
        TUI.writeChar('I')

        val timeout = TestBenchUtils.readLong("TEST: [REQUEST] Timeout para TUI.readKey (ms): ", 1)
        val key = TUI.readKey(timeout)

        if (key == KBD.Key.KEY_NONE.char) {
            println("TEST: [OUTPUT]  TUI.readKey: sem tecla no timeout")
        } else {
            println("TEST: [OUTPUT]  TUI.readKey: tecla '$key'")
        }

        println("TEST: [INFO]    Método TUI.echo() não é executado aqui por ser loop infinito.")
        println("TEST: [END]     TUI test bench finalizado")
    }
}
