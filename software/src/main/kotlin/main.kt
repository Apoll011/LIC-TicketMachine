import KBD.KACK_MASK

fun main(){
    HAL.init()
    while (true) {
        val result = HAL.readBits(0xFF)
        println(result.toString(2).padStart(8, '0'))

        val key = KBD.getKey() ?: continue

        println("Key pressed: $key")
    }
}
