import isel.leic.UsbPort;

object HAL {
	
	private var bufferWrite: Int = 0

    fun init() {
		writeBits(0xFF, 0x00)
	}

    // Retorna 'true' se o bit definido pela mask está com valor lógico '1' no UsbPort
    fun isBit(mask: Int): Boolean {
        return readBits(mask) == mask
    }

    /// Retorna os valores dos bits representados por mask presentes no UsbPort
    fun readBits(mask: Int): Int {
		return UsbPort.read() and mask
	}

    // Escreve nos bits representados por mask os valores correspondentes em value
    fun writeBits(mask: Int, value: Int) {
        UsbPort.write(value and mask)
        bufferWrite = (bufferWrite and mask.inv()) or (value and mask)
    }

    // Coloca os bits representados por mask no valor lógico '1'
    fun setBits(mask: Int) {
        writeBits(mask, 0xFF)
    }

    // Coloca os bits representados por mask no valor lógico '0'
    fun clrBits(mask: Int) {
        writeBits(mask, 0x00)
    }
}
