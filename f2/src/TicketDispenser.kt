object TicketDispenser{
    private const val FN_MASK = 0b00010000

    fun init( ){

    }

    fun activatePrintingTicket ( roundTrip : Boolean , origin : Int , destination : Int ) {
        val rt  = if (roundTrip) 1 else 0

        val org = (origin and 0xF)      shl 1   // bits 1..4
        val dst = (destination and 0xF) shl 5   // bits 5..8
        val prt = 1 shl 9                       // bit 9

        val frame = rt or org or dst or prt

        SerialEmitter.send(SerialEmitter.Peripheral.TICKET, frame, 10)

        while (!HAL.isBit(FN_MASK)) {
            Thread.sleep(10)
        }
    }
}