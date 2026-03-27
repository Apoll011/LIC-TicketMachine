
fun main(){
    HAL.init()
    while (true) {
        val key = KBD.waitKey()
        println("Key pressed: $key")
    }
}
