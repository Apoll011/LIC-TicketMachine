fun testKBD() {
    println("Testing KBD...")
    KBD.init()
    println("KBD initialized.")

    println("Press any key on the simulator/keyboard...")
    val keyChar = KBD.getKey()
    if (keyChar != KBD.Key.KEY_NONE.char) {
        println("Key pressed: $keyChar")
    } else {
        println("No key currently pressed.")
    }

    println("Waiting up to 5 seconds for a key press...")
    val waitedKey = KBD.waitKey(5000)
    if (waitedKey != KBD.Key.KEY_NONE.char) {
        println("Waited and got key: $waitedKey")
    } else {
        println("Timeout: no key pressed.")
    }
}

fun main() {
    testKBD()
}
