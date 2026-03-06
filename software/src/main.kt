import isel.leic.UsbPort

fun main(){
    HAL.init()
	while (true) {
        HAL.writeBits(0xFF, HAL.readBits(0xFF))
	}
}
