import isel.leic.UsbPort;

object HAL {
	
	private var bufferWrite: Int = 0

    fun init() {
		UsbPort.init()
		writeBits(0xFF, 0x00)
	}

    // Retorna 'true' se o bit definido pela mask está com valor lógico '1' no UsbPort
    fun isBit(mask: Int): Boolean {
        ...
    }

    // Retorna os valores dos bits representados por mask presentes no UsbPort
    fun readBits(mask: Int): Int {
		UsbPort.read() and mask
	}

    // Escreve nos bits representados por mask os valores correspondentes em value
    fun writeBits(mask: Int, value: Int) {
        UsbPort.write(value and mask)
		
	}

    // Coloca os bits representados por mask no valor lógico '1'
    fun setBits(mask: Int) {
        UsbPort.write(0xFF and mask)
    }

    // Coloca os bits representados por mask no valor lógico '0'
    fun clrBits(mask: Int) {
        
    }
}
