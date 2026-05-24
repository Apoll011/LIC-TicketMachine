import java.lang.Thread

data class Coin(val type: Int, var currentCount: Int, val id: Int)

object CoinAcceptor {
    private const val CID_MASK  = 0b00000111
    private const val COIN_MASK = 0b00001000

    private const val COIN_EJECT_MASK   = 0b00100000
    private const val COIN_COLLECT_MASK = 0b01000000
    private const val COIN_ACCEPT_MASK  = 0b00010000

    val coinCode_List: List<Int> = listOf(5, 10, 20, 50, 100, 200, 0, 0)
    var storedCoins: MutableList<Coin> = mutableListOf()
    var insertedCoins: MutableList<Coin> = mutableListOf()

    fun init() {
        loadStoredCoins()
        ejectInsertedCoins()
        HAL.clrBits(COIN_ACCEPT_MASK)
        HAL.clrBits(COIN_EJECT_MASK)
        HAL.clrBits(COIN_COLLECT_MASK)
    }

    private fun loadStoredCoins() {
        storedCoins.clear()
        insertedCoins.clear()
        readFile("CoinDeposit.txt").forEachIndexed { index, line ->
            val (type, count) = line.split(";")
            storedCoins.add(Coin(type.toInt(), count.toInt(), index))
            insertedCoins.add(Coin(type.toInt(), 0, index))
        }
    }

    fun hasCoin(): Boolean {
        return HAL.isBit(COIN_MASK)
    }

    fun getCoinID(): Int? {
        if (hasCoin()) {
            val value = HAL.readBits(CID_MASK)

            if (value in 0 until 6) {
                return coinCode_List[value]
            }
        }

        return null
    }

    fun acceptCoin(): Boolean {
        if (hasCoin()) {
            val c = getCoinID()
            HAL.setBits(COIN_ACCEPT_MASK)

            if (c != null) add(c)
            while (hasCoin());
            
            HAL.clrBits(COIN_ACCEPT_MASK)
            return true
        }
        return false
    }

    fun ejectCoins() {
        HAL.setBits(COIN_EJECT_MASK)
        ejectInsertedCoins()
        Thread.sleep(2000L)
        HAL.clrBits(COIN_EJECT_MASK)
    }
    
    fun collectCoins() {
        HAL.setBits(COIN_COLLECT_MASK)
        collectStoredCoins()
        Thread.sleep(2000L)
        HAL.clrBits(COIN_COLLECT_MASK)
    }

    fun add(type: Int) {
        insertedCoins.find { it.type == type }?.let { it.currentCount++ }
    }

    fun collectStoredCoins() {
        storedCoins.zip(insertedCoins).forEach { (stored, inserted) ->
            stored.currentCount += inserted.currentCount
        }
    }

    fun amountInserted(): Int {
        return insertedCoins.sumOf { it.type * it.currentCount }
    }

    @Deprecated("Use amountInserted()")
    fun ammoutInserted(): Int = amountInserted()

    fun ejectInsertedCoins() {
        insertedCoins.forEach { it.currentCount = 0 }
    }

    fun resetCoinCounters() {
        storedCoins.forEach { it.currentCount = 0 }
    }

    fun writeFile() {
        val output = storedCoins.map { "${it.type};${it.currentCount}" }
        writeFile(fileName = "CoinDeposit.txt", dataArray = output.toTypedArray())
    }
}