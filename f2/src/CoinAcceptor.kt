import java.lang.Thread

object CoinAcceptor {
    private const val CID_MASK  = 0b00000111
    private const val COIN_MASK = 0b00001000

    private const val COIN_EJECT_MASK   = 0b00100000
    private const val COIN_COLLECT_MASK = 0b01000000
    private const val COIN_ACCEPT_MASK  = 0b00010000

    val coinCode_List: List<Int> = listOf(5, 10, 20, 50, 100, 200, 0, 0)

    fun init() {
        CoinDeposit.init()
        HAL.clrBits(COIN_ACCEPT_MASK)
        HAL.clrBits(COIN_EJECT_MASK)
        HAL.clrBits(COIN_COLLECT_MASK)
    }

    fun hasCoin(): Boolean {
        return HAL.isBit(COIN_MASK)
    }

    fun getCoinID(): Int? {
        if (hasCoin()) {
            val value = HAL.readBits(CID_MASK).shr(2)

            if (value in 0 until 6) {
                return coinCode_List[value]
            }
        }

        return null
    }

    fun acceptCoin() {
        if (hasCoin()) {
            HAL.setBits(COIN_ACCEPT_MASK)
            CoinDeposit.add(getCoinID()!!)
            while (hasCoin());
            
            HAL.clrBits(COIN_ACCEPT_MASK)
        }
    }

    fun ejectCoins() {
        HAL.setBits(COIN_EJECT_MASK)
        CoinDeposit.ejectInsertedCoins()
        Thread.sleep(2000L)
        HAL.clrBits(COIN_EJECT_MASK)
    }
    
    fun collectCoins() {
        HAL.setBits(COIN_COLLECT_MASK)
        CoinDeposit.collectStoredCoins()
        Thread.sleep(2000L)
        HAL.clrBits(COIN_COLLECT_MASK)
    }
}