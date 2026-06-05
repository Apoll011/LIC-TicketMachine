object KBDTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        HAL.init()
        KBD.init()

        var total = 0
        //val timeout = TestBenchUtils.readLong("TEST: [REQUEST] Timeout (ms): ", 1)
/*
        while (true) {
            println("TEST: [START]   KBD test bench")
            println("TEST: [INFO]    A aguardar tecla...")

            val key = KBD.waitKey(timeout)
            if (key != KBD.Key.KEY_NONE.char) {
                println("TEST: [OUTPUT]  Tecla recebida: $key")
            } else {
                println("TEST: [OUTPUT]  Nenhuma tecla no timeout")
            }

            if (!TestBenchUtils.readYesNo("TEST: [REQUEST] Repetir teste? (sim/nao): ")) break
            println()
        }*/
        while (true) {


            val key = KBD.getKey()
            if (key != KBD.Key.KEY_NONE.char) {
                total++
                println( key)
            } else {
                //println(total)

            }

        }

    }
}
