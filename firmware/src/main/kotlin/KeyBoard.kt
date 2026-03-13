object KeyBoard {
    enum class Key {
        KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0,
        KEY_A, KEY_B, KEY_C, KEY_D,
        KEY_HASH, KEY_STAR,
        KEY_NONE
    }
    fun getKey(id: Int): Key {
        return when (id) {
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
            else -> Key.KEY_NONE
        }
    }

    fun testKeydecode() {
        if(HAL.isBit(0b10000000)) {
            val code = HAL.readBits(0b01111000) shr 3
            val key = getKey(code)
            println("Key: $key")
            HAL.setBits(0x01)

            while (HAL.isBit(0b10000000)) {}

            HAL.clrBits(0x01)
        } else {

        }
    }
}