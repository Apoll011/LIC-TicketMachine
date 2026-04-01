fun testSerialEmitter() {
    println("Testing SerialEmitter...")
    SerialEmitter.init()
    println("SerialEmitter initialized.")

    println("Sending 0x55 to LCD (10 bits)...")
    SerialEmitter.send(SerialEmitter.Peripheral.LCD, 0x55, 10)
    println("Done.")

    println("Sending 0xAA to TICKET (10 bits)...")
    SerialEmitter.send(SerialEmitter.Peripheral.TICKET, 0xAA, 10)
    println("Done.")
}

fun main() {
    testSerialEmitter()
}
