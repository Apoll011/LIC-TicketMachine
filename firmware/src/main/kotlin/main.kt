import KeyBoard.testKeydecode

fun main(){
    HAL.init()
    while (true) {
        val key = KeyBoard.readKey() ?: continue
        println("Key pressed: $key")
    }
}
