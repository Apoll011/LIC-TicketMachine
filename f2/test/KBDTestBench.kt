object KBDTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        HAL.init()
        KBD.init()

        while (true) {
            println("TEST: [START]   KBD test bench")
            val timeout = TestBenchUtils.readLong("TEST: [REQUEST] Timeout (ms): ", 1)
            println("TEST: [INFO]    A aguardar tecla...")

            val key = KBD.waitKey(timeout)
            if (key != KBD.Key.KEY_NONE.char) {
                println("TEST: [OUTPUT]  Tecla recebida: $key")
            } else {
                println("TEST: [OUTPUT]  Nenhuma tecla no timeout")
            }

            if (!TestBenchUtils.readYesNo("TEST: [REQUEST] Repetir teste? (sim/nao): ")) break
            println()
        }

        println("TEST: [END]     KBD test bench finalizado")
    }
}
