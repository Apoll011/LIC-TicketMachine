
fun main(){
    HAL.init()
    while (true) {
        val key = KBD.getKey() ?: continue
        println("Key pressed: $key")
    }
}
