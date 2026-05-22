object HALTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   HAL test bench")
        HAL.init()

        val mask = TestBenchUtils.readInt("TEST: [INPUT]   Máscara para writeBits (0..65535): ", 0, 0xFFFF)
        val value = TestBenchUtils.readInt("TEST: [INPUT]   Valor para writeBits (0..65535): ", 0, 0xFFFF)
        HAL.writeBits(mask, value)
        println("TEST: [INFO]    writeBits executado.")

        val setMask = TestBenchUtils.readInt("TEST: [INPUT]   Máscara para setBits (0..65535): ", 0, 0xFFFF)
        HAL.setBits(setMask)
        println("TEST: [INFO]    setBits executado.")

        val clrMask = TestBenchUtils.readInt("TEST: [INPUT]   Máscara para clrBits (0..65535): ", 0, 0xFFFF)
        HAL.clrBits(clrMask)
        println("TEST: [INFO]    clrBits executado.")

        val readMask = TestBenchUtils.readInt("TEST: [INPUT]   Máscara para readBits/isBit (0..65535): ", 0, 0xFFFF)
        val bits = HAL.readBits(readMask)
        val bitState = HAL.isBit(readMask)

        println("TEST: [OUTPUT]  readBits(mask) = $bits (0b${bits.toString(2)})")
        println("TEST: [OUTPUT]  isBit(mask)    = $bitState")
        println("TEST: [END]     HAL test bench finalizado")
    }
}
