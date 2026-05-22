object IconsTestBench {
    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   Icons test bench")

        for (icon in Icons.entries) {
            val valid = icon.pattern.size == 8 && icon.pattern.all { it in 0..0b11111 }
            println("TEST: [${if (valid) "PASS" else "FAIL"}]   ${icon.name} patternSize=${icon.pattern.size}")
        }

        for (rom in RomIcons.entries) {
            println("TEST: [INFO]    ${rom.name} addr=0x${rom.addr.toString(16).uppercase()}")
        }

        println("TEST: [END]     Icons test bench finalizado")
    }
}
