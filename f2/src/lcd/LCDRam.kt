object LCDRam {
    private const val MAX_SLOTS = 8

    private val cache = LinkedHashMap<Icons, Int>(MAX_SLOTS, 0.75f, true)

    fun slotFor(char: Icons): Int {
        cache[char]?.let { return it }

        val slot = if (cache.size < MAX_SLOTS) {
            cache.size
        } else {
            val lruChar = cache.keys.first()
            cache.remove(lruChar)!!
        }

        cache[char] = slot
        return slot
    }

    fun clear() = cache.clear()
}