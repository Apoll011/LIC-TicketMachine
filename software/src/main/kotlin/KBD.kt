object KBD {
    private const val KVAL_MASK = 0x80
    private const val KCODE_MASK = 0x0F

    private const val KACK_MASK = 0x80

    enum class Key(val char: Char) {
        KEY_1('1'),
        KEY_2('2'),
        KEY_3('3'),
        KEY_4('4'),
        KEY_5('5'),
        KEY_6('6'),
        KEY_7('7'),
        KEY_8('8'),
        KEY_9('9'),
        KEY_0('0'),
        KEY_A('A'),
        KEY_B('B'),
        KEY_C('C'),
        KEY_D('D'),
        KEY_HASH('#'),
        KEY_STAR('*'),
        KEY_NONE('\u0000')
    }


    fun init() {
        HAL.init()
    }

    fun getKey(): Char {
        return readKey().char
    }

    fun readKey(): Key {
        if (!HAL.isBit(KVAL_MASK)) return Key.KEY_NONE

        val code = HAL.readBits(KCODE_MASK)
        HAL.setBits(KACK_MASK)

        while (HAL.isBit(KVAL_MASK)) {
            Thread.yield()
        }

        HAL.clrBits(KACK_MASK)

        return convertToKey(code)
    }

    private fun convertToKey(id: Int): Key = when (id) {
        0b0000 -> Key.KEY_1
        0b0100 -> Key.KEY_2
        0b1000 -> Key.KEY_3
        0b1100 -> Key.KEY_A
        0b0001 -> Key.KEY_4
        0b0101 -> Key.KEY_5
        0b1001 -> Key.KEY_6
        0b1101 -> Key.KEY_B
        0b0010 -> Key.KEY_7
        0b0110 -> Key.KEY_8
        0b1010 -> Key.KEY_9
        0b1110 -> Key.KEY_C
        0b0111 -> Key.KEY_STAR
        0b1011 -> Key.KEY_HASH
        0b0011 -> Key.KEY_0
        0b1111 -> Key.KEY_D
        else -> Key.KEY_NONE
    }

    fun waitKey(timeout: Long): Char {
        val endTime = System.currentTimeMillis() + timeout

        while (System.currentTimeMillis() < endTime) {
            val key = getKey()
            if (key != Key.KEY_NONE.char) return key
            Thread.sleep(1)
        }
        return Key.KEY_NONE.char
    }
}