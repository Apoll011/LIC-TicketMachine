import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


class App {
    var currentDestiny = 0

    fun init() {
        TUI.init()
        TicketDispenser.init()
        Stations.init()
    }

    fun start() {
        firstScreen()
        mainLoop()
    }

    fun firstScreen() {
        TUI.write(" Ticket to Ride")
        TUI.cursor(1, 0)

        val now = LocalDateTime.now()

        val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")

        TUI.write(now.format(formatter))
    }

    fun mainLoop() {
        while (true) {
            menu()
        }
    }

    fun menu(){
        val key = TUI.readKey()
        if (key != '\u0000'){
            listDestinys()
        }
    }

    fun listDestinys() {
        var chosing = true
        while (chosing) {
            printCurrentDestinyMenu()
            var key = TUI.readKey()
            when (key) {
                in '0'..'9' -> {
                    currentDestiny = key.digitToInt()
                }
                'A' -> {
                    currentDestiny = (currentDestiny - 1 + 16) % 16
                }

                // Next (wrap 15 -> 0)
                'B' -> {
                    currentDestiny = (currentDestiny + 1) % 16
                }
                '#' -> chosing = false
            }
        }
        selectDestiny()
    }

    fun selectDestiny() {

    }

    fun printCurrentDestinyMenu() {
        TUI.clear()
        val station = Stations.getStation(currentDestiny)
        if (station == null) return
        printDestiny(station, true, true, 0)
    }

    fun calcularPaddingCentralizado(tamanhoTexto: Int): Int {
        return ((16 - tamanhoTexto).coerceAtLeast(0)) / 2
    }

    fun printDestiny(station: Station, withId: Boolean, roundTrip: Boolean, avaliableCurrency: Int) {
        val l = calcularPaddingCentralizado(station.name.length)
        TUI.cursor(0, l)
        TUI.write(station.name)
        TUI.cursor(1, 0)
        
        if (withId) {
            TUI.write(String.format("%02d", station.id))
        }

        TUI.writeIcon(Icons.UPWARDS_ARROW)
        if (roundTrip) TUI.writeIcon(Icons.DOWNWARDS_ARROW)
        
        val p = (if (roundTrip) station.price * 2 else station.price) - avaliableCurrency

        val price = String.format("%.2f", p / 100.0)
        TUI.cursor(1, 11)
        TUI.write(price)
        TUI.writeIcon(Icons.EURO_SIGN)
    }
}