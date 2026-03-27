import KBD.KACK_MASK

fun main(){
    HAL.init()
    while (true) {
        val key = KBD.getKey() ?: continue

        println("Key pressed: $key")
    }
}
