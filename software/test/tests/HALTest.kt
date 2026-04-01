fun testHAL() {
    println("Testing HAL...")
    HAL.init()
    println("HAL initialized.")

    println("Writing 0xAA...")
    HAL.writeBits(0xFF, 0xAA)
    println("Check hardware: UsbPort should have 0xAA.")

    println("Setting bit 0x01...")
    HAL.setBits(0x01)
    println("Check hardware: UsbPort should have 0xAB.")

    println("Clearing bit 0x02...")
    HAL.clrBits(0x02)
    println("Check hardware: UsbPort should have 0xA9.")

    val bits = HAL.readBits(0xFF)
    println("Read bits: 0x${bits.toString(16).uppercase()}")
}

fun main() {
    testHAL()
}
