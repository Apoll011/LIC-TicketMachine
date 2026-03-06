fun main(){
	HAL.init()
	while (true) {
		println(HAL.readBits(0xFF))
	}
}
