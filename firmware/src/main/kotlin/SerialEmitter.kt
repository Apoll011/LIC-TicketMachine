object SerialEmitter {

enum class Peripheral {LCD, TICKET}

fun init() {}

fun send(addr: Peripheral, data: Int, size: Int) {}

fun isBusy(): Boolean {}

}