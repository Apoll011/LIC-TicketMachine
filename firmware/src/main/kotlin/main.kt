import KBD.KACK_MASK

fun main(){
    HAL.init()
    while (true) {
        val key = HAL.readBits(0b00000111)
        println("Key pressed: $key")
    }
}