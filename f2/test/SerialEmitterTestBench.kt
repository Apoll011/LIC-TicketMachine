object SerialEmitterTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   SerialEmitter test bench")
        SerialEmitter.init()

        while (true) {
            val peripheral = when (TestBenchUtils.readInt("TEST: [REQUEST] Periférico (1=LCD, 2=TICKET): ", 1, 2)) {
                1 -> SerialEmitter.Peripheral.LCD
                else -> SerialEmitter.Peripheral.TICKET
            }

            val data = TestBenchUtils.readInt("TEST: [REQUEST] Data (0..65535): ", 0, 0xFFFF)
            val size = TestBenchUtils.readInt("TEST: [REQUEST] Size em bits (1..16): ", 1, 16)

            SerialEmitter.send(peripheral, data, size)
            println("TEST: [OUTPUT]  Frame enviado para $peripheral")

            if (!TestBenchUtils.readYesNo("TEST: [REQUEST] Enviar novo frame? (sim/nao): ")) break
            println()
        }

        println("TEST: [END]     SerialEmitter test bench finalizado")
    }
}
