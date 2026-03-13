object KeyBoard {
    private const val KVAL_MASK  = 0b10000000
    private const val KCODE_MASK = 0b01111000
    private const val KACK_MASK  = 0b0000000  // outputPort(0) — escrita

    enum class Key {
        KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0,
        KEY_A, KEY_B, KEY_C, KEY_D,
        KEY_HASH, KEY_STAR,
        KEY_NONE
    }

    /**
     * Tenta ler uma tecla.
     * Retorna null se Kval não estiver activo (nada a ler ainda).
     * Retorna a Key e completa o handshake com a FSM caso contrário.
     */
    fun readKey(): Key? {
        if (!HAL.isBit(KVAL_MASK)) return null

        val code = (HAL.readBits(KCODE_MASK) shr 3) and 0xF
        val key = getKey(code)

        HAL.setBits(KACK_MASK)

        while (HAL.isBit(KVAL_MASK)) { /* aguarda */ }

        HAL.clrBits(KACK_MASK)

        return key
    }

    private fun getKey(id: Int): Key = when (id) {
        0b0000 -> Key.KEY_D
        0b0100 -> Key.KEY_4
        0b1000 -> Key.KEY_1
        0b1100 -> Key.KEY_7
        0b0001 -> Key.KEY_0
        0b0101 -> Key.KEY_6
        0b1001 -> Key.KEY_3
        0b1101 -> Key.KEY_9
        0b0010 -> Key.KEY_STAR
        0b0110 -> Key.KEY_5
        0b1010 -> Key.KEY_2
        0b1110 -> Key.KEY_8
        0b0111 -> Key.KEY_B
        0b1011 -> Key.KEY_A
        0b0011 -> Key.KEY_HASH
        0b1111 -> Key.KEY_C
        else   -> Key.KEY_NONE
    }
}