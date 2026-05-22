object LCDRamTestBench {
    private fun assertEquals(name: String, expected: Int, actual: Int) {
        val ok = expected == actual
        println("TEST: [${if (ok) "PASS" else "FAIL"}]   $name -> esperado=$expected obtido=$actual")
    }

    @JvmStatic
    fun main(args: Array<String>) {
        println("TEST: [START]   LCDRam test bench")

        LCDRam.clear()
        val allIcons = Icons.entries

        for (i in 0 until 8) {
            val slot = LCDRam.slotFor(allIcons[i])
            assertEquals("Slot sequencial #$i", i, slot)
        }

        val reused = LCDRam.slotFor(allIcons[0])
        assertEquals("Reutilização de ícone já carregado", 0, reused)

        val ninthSlot = LCDRam.slotFor(allIcons[8])
        println("TEST: [INFO]    Slot atribuído ao 9º ícone (substituição LRU): $ninthSlot")

        println("TEST: [END]     LCDRam test bench finalizado")
    }
}
