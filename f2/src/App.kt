import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class App {
    var currentDestiny = 0

    fun init() {
        TUI.init()
        TicketDispenser.init()
        Stations.init()
        CoinAcceptor.init()
    }

    fun start() {
        firstScreen()
        mainLoop()
    }

    // ----------------------------------------------------------------
    // Screens
    // ----------------------------------------------------------------

    fun firstScreen() {
        TUI.clear()
        TUI.write(" Ticket to Ride")
        TUI.cursor(1, 0)

        val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
        TUI.write(LocalDateTime.now().format(formatter))

        while (TUI.getKey() == '\u0000') {}
        listDestinations()
    }

    fun mainLoop() {
        while (true) {
            firstScreen()
            currentDestiny = 0
        }
    }

    // ----------------------------------------------------------------
    // Destination selection
    // ----------------------------------------------------------------

    fun listDestinations() {
        var choosing = true
        var firstDigit: Int? = null
        var digitTime: Long = 0

        printCurrentDestinyMenu()

        while (choosing) {
            // Timeout: commit single buffered digit after 500ms
            if (firstDigit != null && System.currentTimeMillis() - digitTime > 500) {
                currentDestiny = firstDigit!!
                firstDigit = null
                printCurrentDestinyMenu()
            }

            val key = TUI.getKey()
            when {
                key in '0'..'9' -> {
                    val digit = key.digitToInt()

                    if (firstDigit == null) {
                        // Buffer first digit and start timer
                        firstDigit = digit
                        digitTime = System.currentTimeMillis()
                    } else {
                        // Second digit arrived — try to combine
                        val saved = firstDigit!!
                        firstDigit = null
                        val combined = saved * 10 + digit
                        currentDestiny = if (combined in 0..15) combined else saved
                        printCurrentDestinyMenu()
                    }
                }

                key == 'A' -> {
                    firstDigit = null
                    currentDestiny = (currentDestiny - 1 + 16) % 16
                    printCurrentDestinyMenu()
                }

                key == 'B' -> {
                    firstDigit = null
                    currentDestiny = (currentDestiny + 1) % 16
                    printCurrentDestinyMenu()
                }

                key == '#' -> {
                    firstDigit = null
                    choosing = false
                }
            }
        }
        selectDestiny()
    }

    // ----------------------------------------------------------------
    // Payment flow
    // ----------------------------------------------------------------

    fun selectDestiny() {
        val station = Stations.getStation(currentDestiny) ?: return

        var roundTrip = false
        var active = true

        TUI.clear()
        printDestiny(station, false, roundTrip, currentPrice(station, roundTrip))

        while (active) {
            val remaining = currentPrice(station, roundTrip) - CoinDeposit.ammoutInserted()

            if (remaining <= 0) {
                showLoading()
                CoinAcceptor.collectCoins()
                collectTicket(station, roundTrip)
                break
            }

            if (CoinAcceptor.acceptCoin()) {
                printLowerLine(
                    currentPrice(station, roundTrip) - CoinDeposit.ammoutInserted(),
                    roundTrip
                )
            }

            when (TUI.getKey()) {
                '*' -> {
                    roundTrip = !roundTrip
                    printDestiny(station, false, roundTrip, currentPrice(station, roundTrip))
                    printLowerLine(
                        currentPrice(station, roundTrip) - CoinDeposit.ammoutInserted(),
                        roundTrip
                    )
                }
                '#' -> {
                    abortVending()
                    active = false
                }
            }
        }
    }

    private fun currentPrice(station: Station, roundTrip: Boolean): Int =
        if (roundTrip) station.price * 2 else station.price

    private fun showLoading() {
        TUI.deleteText(LCD.Line.LOWER, 0, 15)
        TUI.cursor(1, 3)
        TUI.write("LOADING...")
    }

    private fun abortVending() {
        TUI.clear()
        TUI.write("VENDING ABORTED")
        val inserted = CoinDeposit.ammoutInserted()
        if (inserted > 0) {
            TUI.cursor(1, 0)
            TUI.write("Returning ")
            TUI.write(String.format("%.2f", inserted / 100.0))
            TUI.writeIcon(Icons.EURO_SIGN)
            CoinAcceptor.ejectCoins()
        }
        Thread.sleep(2000L)
    }

    // ----------------------------------------------------------------
    // Ticket collection
    // ----------------------------------------------------------------

    fun collectTicket(station: Station, roundTrip: Boolean) {
        Stations.addTicket(station.id)
        TicketDispenser.activatePrintingTicket(roundTrip, station.id, station.id)

        TUI.clear()
        TUI.cursor(0, 4)
        TUI.write("Thank You!")
        TUI.cursor(1, 1)
        TUI.write("Have a Nice Trip!")

        Thread.sleep(5000L)
    }

    // ----------------------------------------------------------------
    // Display helpers
    // ----------------------------------------------------------------

    fun printCurrentDestinyMenu() {
        TUI.clear()
        val station = Stations.getStation(currentDestiny) ?: return
        printDestiny(station, true, false, station.price)
    }

    fun printDestiny(station: Station, withId: Boolean, roundTrip: Boolean, currency: Int) {
        val padding = centeredPadding(station.name.length)
        TUI.cursor(0, padding)
        TUI.write(station.name)

        TUI.cursor(1, 0)
        if (withId) TUI.write(String.format("%02d", station.id))

        TUI.writeIcon(Icons.UPWARDS_ARROW)
        if (roundTrip) TUI.writeIcon(Icons.DOWNWARDS_ARROW)

        TUI.cursor(1, 11)
        TUI.write(String.format("%.2f", currency / 100.0))
        TUI.writeIcon(Icons.EURO_SIGN)
    }

    fun printLowerLine(price: Int, roundTrip: Boolean) {
        TUI.cursor(1, 1)
        if (roundTrip) {
            TUI.writeIcon(Icons.DOWNWARDS_ARROW)
        } else {
            TUI.deleteText(LCD.Line.LOWER, 1, 2)
        }
        TUI.cursor(1, 11)
        TUI.write(String.format("%.2f", price / 100.0))
        TUI.writeIcon(Icons.EURO_SIGN)
    }

    private fun centeredPadding(textLength: Int): Int =
        ((16 - textLength).coerceAtLeast(0)) / 2

    fun writeFile() {
        CoinDeposit.writeFile()
        Stations.writeFile()
    }
}
