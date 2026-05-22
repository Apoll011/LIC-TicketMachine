object TicketDispenserTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   TicketDispenser test bench")
        HAL.init()
        SerialEmitter.init()
        TicketDispenser.init()

        while (true) {
            val roundTrip = TestBenchUtils.readYesNo("TEST: [REQUEST] Viagem ida e volta? (sim/nao): ")
            val origin = TestBenchUtils.readInt("TEST: [REQUEST] Origem (0..15): ", 0, 15)
            val destination = TestBenchUtils.readInt("TEST: [REQUEST] Destino (0..15): ", 0, 15)
            val joinMs = TestBenchUtils.readLong("TEST: [REQUEST] Timeout de espera FN (ms): ", 1)

            val worker = Thread {
                try {
                    TicketDispenser.activatePrintingTicket(roundTrip, origin, destination)
                } catch (_: InterruptedException) {
                    // intentionally interrupted by test timeout
                }
            }

            worker.start()
            worker.join(joinMs)

            if (worker.isAlive) {
                worker.interrupt()
                println("TEST: [WARN]    Timeout de confirmação FN. Verifique hardware/sinal FN.")
            } else {
                println("TEST: [OUTPUT]  Bilhete enviado e confirmado pelo FN.")
            }

            if (!TestBenchUtils.readYesNo("TEST: [REQUEST] Repetir teste? (sim/nao): ")) break
            println()
        }

        println("TEST: [END]     TicketDispenser test bench finalizado")
    }
}
