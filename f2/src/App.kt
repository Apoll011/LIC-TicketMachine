import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

private const val STATION_COUNT = 16
private const val DIGIT_TIMEOUT_MS = 500L
private const val ABORT_DISPLAY_MS = 2000L
private const val THANK_YOU_DISPLAY_MS = 5000L
private const val DATE_FORMAT = "dd/MM/yyyy HH:mm"
private const val LCD_WIDTH = 16
private const val M_MASK = 0b01000000

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
            if (HAL.isBit(M_MASK)){
                //maintenance
            }
            else{
                showSplashScreen()
                currentDestiny = 0
                listDestinations()
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
                currentDestiny = firstDigit
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
        //TUI.write("LOADING...")
		val start =centeredPadding(size+2)
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
