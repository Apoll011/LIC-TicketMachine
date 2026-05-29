data class Coin(val type: Int, var currentCount: Int, val id: Int)

object CoinDeposit {

    var storedCoins: MutableList<Coin> = mutableListOf()
    var insertedCoins: MutableList<Coin> = mutableListOf()


    fun init() {
        loadStoredCoins()
        ejectInsertedCoins()
    }

    private fun loadStoredCoins() {
        readFile("CoinDeposit.txt").forEachIndexed { index, line ->
            val (type, count) = line.split(";")
            storedCoins.add(Coin(type.toInt(), count.toInt(), index))
            insertedCoins.add(Coin(type.toInt(), 0, index))
        }
    }

    fun add(type: Int) {
        insertedCoins.find { it.type == type }?.let { it.currentCount++ }
    }

    fun collectStoredCoins() {
        storedCoins.zip(insertedCoins).forEach { (stored, inserted) ->
            stored.currentCount += inserted.currentCount
        }

        resetCoinCounters()
        println(storedCoins)
        println(insertedCoins)
    }

    fun ammoutInserted(): Int {
        return insertedCoins.sumOf { it.type * it.currentCount }
    }

    fun ejectInsertedCoins() {
        insertedCoins.forEach { it.currentCount = 0 }
    }

    fun resetCoinCounters() {
        insertedCoins.forEach { it.currentCount = 0 }
    }

    fun writeFile() {
        val output = storedCoins.map { "${it.type};${it.currentCount}" }
        writeFile(fileName = "CoinDeposit.txt", dataArray = output.toTypedArray())
    }
}