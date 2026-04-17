import isel.leic.UsbPort

object HAL {
    private var bufferWrite = 0

    fun init() {
        UsbPort.write(bufferWrite)
    }

    fun isBit(mask: Int): Boolean {
        return (UsbPort.read() and mask) != 0
    }

    fun readBits(mask: Int): Int {
        return UsbPort.read() and mask
    }

    fun writeBits(mask: Int, value: Int) {
        bufferWrite = (bufferWrite and mask.inv()) or (value and mask)
        UsbPort.write(bufferWrite)
    }

    fun setBits(mask: Int) {
        bufferWrite = bufferWrite or mask
        UsbPort.write(bufferWrite)
    }

    fun clrBits(mask: Int) {
        bufferWrite = bufferWrite and mask.inv()
        UsbPort.write(bufferWrite)
    }
}