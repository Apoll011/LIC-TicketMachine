object LCDRamTestBench {
    private fun assertEquals(name: String, expected: Int, actual: Int) {
        val ok = expected == actual
        println("TEST: [${if (ok) "PASS" else "FAIL"}]   $name -> esperado=$expected obtido=$actual")
    }

    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   LCD slots test bench")
        for ((index, icon) in Icons.entries.withIndex()) {
            assertEquals("Slot fixo para ${icon.name}", index, icon.slot)
        }
        println("TEST: [END]     LCD slots test bench finalizado")
    }
}
