object TestBenchUtils {
    fun readInt(prompt: String, min: Int? = null, max: Int? = null): Int {
        while (true) {
            print(prompt)
            val value = readlnOrNull()?.trim()?.toIntOrNull()
            if (value != null && (min == null || value >= min) && (max == null || value <= max)) return value
            println("TEST: [ERROR]   Valor inválido.")
        }
    }

    fun readLong(prompt: String, min: Long? = null): Long {
        while (true) {
            print(prompt)
            val value = readlnOrNull()?.trim()?.toLongOrNull()
            if (value != null && (min == null || value >= min)) return value
            println("TEST: [ERROR]   Valor inválido.")
        }
    }

    fun readYesNo(prompt: String): Boolean {
        while (true) {
            print(prompt)
            when (readlnOrNull()?.trim()?.lowercase()) {
                "s", "sim", "y", "yes" -> return true
                "n", "nao", "não", "no" -> return false
            }
            println("TEST: [ERROR]   Responda com sim/nao.")
        }
    }
}
