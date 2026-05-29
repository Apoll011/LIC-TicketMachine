import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

private const val STATION_COUNT = 16
private const val DIGIT_TIMEOUT_MS = 500L
private const val ABORT_DISPLAY_MS = 2000L
private const val THANK_YOU_DISPLAY_MS = 5000L
private const val DATE_FORMAT = "dd/MM/yyyy HH:mm"
private const val LCD_WIDTH = 16
private const val M_MASK = 0b01000000

private const val MAINT_SCROLL_MS = 1000L

class App {

    private var currentDestiny = 0

    fun init() {
        TUI.init()
        TicketDispenser.init()
        Stations.init()
        CoinAcceptor.init()
    }

    fun start() {
        while (true) {
            if (HAL.isBit(M_MASK)) {
                maintenanceMode()
            } else {
                showSplashScreen()
                currentDestiny = 0
                listDestinations()
            }
        }
    }

    private fun maintenanceMode() {
        val menuItems = listOf(
            "#-Print ticket",
            "A-Station Count",
            "B-Coin Count",
            "C-Sys Reset",
            "D-Shutdown"
        )
        var itemIndex = 0
        var lastScrollTime = System.currentTimeMillis()

        TUI.clear()
        TUI.cursor(0, centeredPadding("Maintenance".length))
        TUI.write("Maintenance")
        renderScrollLine(menuItems[itemIndex])

        while (HAL.isBit(M_MASK)) {
            val now = System.currentTimeMillis()
            if (now - lastScrollTime >= MAINT_SCROLL_MS) {
                itemIndex = (itemIndex + 1) % menuItems.size
                renderScrollLine(menuItems[itemIndex])
                lastScrollTime = now
            }

            when (TUI.getKey()) {
                '#' -> maintTestPrint()
                'A' -> maintStationCounters()
                'B' -> maintCoinCounters()
                'C' -> maintSystemReset()
                'D' -> maintShutdown()
            }

            TUI.cursor(0, centeredPadding("Maintenance".length))
            TUI.write("Maintenance")
        }
    }

    private fun renderScrollLine(text: String) {
        TUI.deleteText(LCD.Line.LOWER, 0, LCD_WIDTH - 1)
        TUI.cursor(1, 0)
        TUI.write(text)
    }

    private fun maintTestPrint() {
        currentDestiny = 0
        maintSelectDestinationForTest()

        // Restore maintenance header after returning
        TUI.clear()
        TUI.cursor(0, centeredPadding("Maintenance".length))
        TUI.write("Maintenance")
    }

    private fun maintSelectDestinationForTest() {
        var firstDigit: Int? = null
        var digitTime = 0L

        renderDestinationMenu()

        while (true) {
            if (firstDigit != null &&
                (System.currentTimeMillis() - digitTime > DIGIT_TIMEOUT_MS || firstDigit != 1)
            ) {
                currentDestiny = firstDigit!!
                firstDigit = null
                renderDestinationMenu()
            }

            when (val key = TUI.getKey()) {
                in '0'..'9' -> {
                    val digit = key.digitToInt()
                    if (firstDigit == null) {
                        firstDigit = digit
                        digitTime = System.currentTimeMillis()
                    } else {
                        val combined = firstDigit!! * 10 + digit
                        currentDestiny = if (combined in 0 until STATION_COUNT) combined else firstDigit!!
                        firstDigit = null
                        renderDestinationMenu()
                    }
                }
                'A' -> {
                    firstDigit = null
                    currentDestiny = (currentDestiny - 1 + STATION_COUNT) % STATION_COUNT
                    renderDestinationMenu()
                }
                'B' -> {
                    firstDigit = null
                    currentDestiny = (currentDestiny + 1) % STATION_COUNT
                    renderDestinationMenu()
                }
                '#' -> {
                    firstDigit = null
                    // Enter test-print confirmation screen
                    val station = Stations.getStation(currentDestiny) ?: return
                    maintTestPrintConfirm(station)
                    return
                }
            }
        }
    }

    private fun maintTestPrintConfirm(station: Station) {
        TUI.clear()
        TUI.cursor(0, centeredPadding(station.name.length))
        TUI.write(station.name)
        TUI.cursor(1, 0)
        TUI.write("* - to print")

        while (true) {
            when (TUI.getKey()) {
                '*' -> {
                    // Test print: skip coin collection and Stations.addTicket
                    TicketDispenser.activatePrintingTicket(false, 15, station.id)
                    TUI.clear()
                    TUI.cursor(0, 4)
                    TUI.write("Thank You!")
                    TUI.cursor(1, 0)
                    TUI.write("Have a Nice Trip!")
                    Thread.sleep(THANK_YOU_DISPLAY_MS)
                    return
                }
                '#' -> {
                    abortVending()
                    return
                }
            }
        }
    }
	
    private fun maintStationCounters() {
        var idx = 0
        renderStationCounterScreen(idx)

        while (true) {
            when (TUI.getKey()) {
                'A' -> {
                    idx = (idx - 1 + STATION_COUNT) % STATION_COUNT
                    renderStationCounterScreen(idx)
                }
                'B' -> {
                    idx = (idx + 1) % STATION_COUNT
                    renderStationCounterScreen(idx)
                }
                '#' -> return
            }
        }
    }

    private fun renderStationCounterScreen(idx: Int) {
        val station = Stations.getStation(idx) ?: return
        TUI.clear()
        // Line 0: station name centered
        TUI.cursor(0, centeredPadding(station.name.length))
        TUI.write(station.name)
        // Line 1: station id (left, 2 digits) + ticket count (right)
        TUI.cursor(1, 0)
        TUI.write(String.format("%02d", station.id))
        val countStr = station.currentTicketCount.toString()
        TUI.cursor(1, LCD_WIDTH - countStr.length)
        TUI.write(countStr)
    }

    private val coinValues = listOf(5, 10, 20, 50, 100, 200)

    private fun maintCoinCounters() {
        var idx = 0
        renderCoinCounterScreen(idx)

        while (true) {
            when (TUI.getKey()) {
                'A' -> {
                    idx = (idx - 1 + coinValues.size) % coinValues.size
                    renderCoinCounterScreen(idx)
                }
                'B' -> {
                    idx = (idx + 1) % coinValues.size
                    renderCoinCounterScreen(idx)
                }
                '#' -> return
            }
        }
    }

    private fun renderCoinCounterScreen(idx: Int) {
        val coinCents = coinValues[idx]
        val label = "${formatCurrency(coinCents)} \u20AC"   // e.g. "0.05 €"
        val coin = CoinDeposit.storedCoins.getOrNull(idx)
        val count = coin?.currentCount ?: 0

        TUI.clear()
        // Line 0: coin value centered
        TUI.cursor(0, centeredPadding(label.length))
        TUI.write(label)
        // Line 1: index (2 digits, left) + count (right)
        TUI.cursor(1, 0)
        TUI.write(String.format("%02d", idx))
        val countStr = count.toString()
        TUI.cursor(1, LCD_WIDTH - countStr.length)
        TUI.write(countStr)
    }

    private fun maintSystemReset() {
        TUI.clear()
        TUI.cursor(0, centeredPadding("Reset System".length))
        TUI.write("Reset System")
        TUI.cursor(1, 0)
        TUI.write("* - Yes  Other-No")

        when (TUI.getKey()) {
            '*' -> {
                TUI.deleteText(LCD.Line.LOWER, 0, LCD_WIDTH - 1)
                TUI.cursor(1, 0)
                TUI.write("Resetting...")
                reset()
                Thread.sleep(1500)
            }
        }
    }

    private fun maintShutdown() {
        TUI.clear()
        TUI.cursor(0, centeredPadding("Shutdown?".length))
        TUI.write("Shutdown?")
        TUI.cursor(1, 0)
        TUI.write("* - Yes  Other-No")

        when (TUI.getKey()) {
            '*' -> {
                writeFile()
                TUI.deleteText(LCD.Line.LOWER, 0, LCD_WIDTH - 1)
                TUI.cursor(1, 0)
                TUI.write("Shutting down...")
                Thread.sleep(1500)
                TUI.clear()
                kotlin.system.exitProcess(0)
            }
        }
    }

    private fun showSplashScreen() {
        TUI.clear()
        TUI.write(" Ticket to Ride")
        TUI.cursor(1, 0)
        TUI.write(LocalDateTime.now().format(DateTimeFormatter.ofPattern(DATE_FORMAT)))
        while (TUI.getKey() == '\u0000') {}
    }

    private fun listDestinations() {
        var firstDigit: Int? = null
        var digitTime = 0L

        renderDestinationMenu()

        while (true) {
            if (firstDigit != null && System.currentTimeMillis() - digitTime > DIGIT_TIMEOUT_MS || firstDigit != null && firstDigit != 1) {
                currentDestiny = firstDigit!!
                firstDigit = null
                renderDestinationMenu()
            }

            when (val key = TUI.getKey()) {
                in '0'..'9' -> {
                    val digit = key.digitToInt()
                    if (firstDigit == null) {
                        firstDigit = digit
                        digitTime = System.currentTimeMillis()
                    } else {
                        val combined = firstDigit!! * 10 + digit
                        currentDestiny = if (combined in 0 until STATION_COUNT) combined else firstDigit!!
                        firstDigit = null
                        renderDestinationMenu()
                    }
                }
                'A' -> {
                    firstDigit = null
                    currentDestiny = (currentDestiny - 1 + STATION_COUNT) % STATION_COUNT
                    renderDestinationMenu()
                }
                'B' -> {
                    firstDigit = null
                    currentDestiny = (currentDestiny + 1) % STATION_COUNT
                    renderDestinationMenu()
                }
                '#' -> {
                    firstDigit = null
                    selectDestiny()
                    return
                }
            }
        }
    }

    private fun selectDestiny() {
        val station = Stations.getStation(currentDestiny) ?: return

        var roundTrip = false
        renderFullDestinationScreen(station, roundTrip)

        while (true) {
            val remaining = priceFor(station, roundTrip) - CoinDeposit.ammoutInserted()

            if (remaining <= 0) {
                dispenseTicket(station, roundTrip)
                return
            }

            if (CoinAcceptor.acceptCoin()) {
                if (priceFor(station, roundTrip) - CoinDeposit.ammoutInserted() < 0) continue
                renderRemainingAmount(priceFor(station, roundTrip) - CoinDeposit.ammoutInserted(), roundTrip, 0)
            }
            val f = TUI.getKey()
            when (f) {
                '*' -> {
                    roundTrip = !roundTrip
                    renderRemainingAmount(priceFor(station, roundTrip) - CoinDeposit.ammoutInserted(), roundTrip, 0)
                }
                '#' -> {
                    abortVending()
                    return
                }
            }
        }
    }

    private fun dispenseTicket(station: Station, roundTrip: Boolean) {
        showLoading(2, 0)
        sleep(1500)
        showLoading(2, 1)
        CoinAcceptor.collectCoins()
        showLoading(2, 2)
        sleep(1500)
        showCollectTicket()
        collectTicket(station, roundTrip)
    }

    private fun collectTicket(station: Station, roundTrip: Boolean) {
        Stations.addTicket(station.id)
        TicketDispenser.activatePrintingTicket(roundTrip, 15, station.id)

        TUI.clear()
        TUI.cursor(0, 4)
        TUI.write("Thank You!")
        TUI.cursor(1, 0)
        TUI.write("Have a Nice Trip!")

        Thread.sleep(THANK_YOU_DISPLAY_MS)
    }

    private fun abortVending() {
        TUI.clear()
        TUI.write("VENDING ABORTED")

        val inserted = CoinDeposit.ammoutInserted()
        if (inserted > 0) {
            TUI.cursor(1, 0)
            TUI.write("Returning ")
            TUI.write(formatCurrency(inserted))
            TUI.writeIcon(Icons.EURO_SIGN)
            CoinAcceptor.ejectCoins()
        }

        Thread.sleep(ABORT_DISPLAY_MS)
    }

    private fun showLoading(size: Int, completed: Int) {
        TUI.deleteText(LCD.Line.LOWER, 0, LCD_WIDTH - 1)
        val start = centeredPadding(size + 2)
        TUI.cursor(1, start)
        TUI.writeIcon(Icons.LEFT_PROGRESSBAR_ICON)
        repeat(completed) {
            TUI.writeIcon(Icons.MIDDLE_FULL_PROGRESSBAR_ICON)
        }
        repeat(size - completed) {
            TUI.writeIcon(Icons.MIDDLE_EMPTY_PROGRESSBAR_ICON)
        }
        TUI.writeIcon(Icons.RIGHT_PROGRESSBAR_ICON)
    }

    private fun showCollectTicket() {
        TUI.deleteText(LCD.Line.LOWER, 0, 15)
        TUI.cursor(1, 1)
        TUI.write("Collect Ticket")
    }

    private fun renderDestinationMenu() {
        val station = Stations.getStation(currentDestiny) ?: return
        TUI.clear()
        renderDestinationRow(station, showId = true)
        renderRemainingAmount(priceFor(station, false), true, 2)
    }

    private fun renderFullDestinationScreen(station: Station, roundTrip: Boolean) {
        TUI.clear()
        renderDestinationRow(station, showId = false)
        renderRemainingAmount(priceFor(station, roundTrip) - CoinDeposit.ammoutInserted(), roundTrip, 0)
    }

    private fun renderDestinationRow(station: Station, showId: Boolean) {
        TUI.cursor(0, centeredPadding(station.name.length))
        TUI.write(station.name)

        TUI.cursor(1, 0)
        if (showId) TUI.write(String.format("%02d", station.id))
    }

    private fun renderRemainingAmount(remaining: Int, roundTrip: Boolean, startC: Int = 1) {
        TUI.cursor(1, startC)
        TUI.writeIcon(Icons.UPWARDS_ARROW)
        if (roundTrip) {
            TUI.writeIcon(Icons.DOWNWARDS_ARROW)
        } else {
            TUI.deleteText(LCD.Line.LOWER, 1, 2)
        }
        TUI.cursor(1, 11)
        TUI.write(formatCurrency(remaining))
        TUI.writeIcon(Icons.EURO_SIGN)
    }

    private fun priceFor(station: Station, roundTrip: Boolean): Int =
        if (roundTrip) station.price * 2 else station.price

    private fun centeredPadding(textLength: Int): Int =
        (LCD_WIDTH - textLength).coerceAtLeast(0) / 2

    private fun formatCurrency(cents: Int): String =
        String.format("%.2f", cents / 100.0)

    fun writeFile() {
        CoinDeposit.writeFile()
        Stations.writeFile()
    }

    fun reset() {
        Stations.resetTicketCounters()
        CoinDeposit.resetCoinCounters()
        CoinDeposit.resetCoinDeposit()
    }
}
