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
        val station = Stations.getStation(currentDestiny)
        if (station == null) return
        printDestiny(station, true, true, 0)
    }

    fun printDestiny(station: Station, withId: Boolean, roundTrip: Boolean, avaliableCurrency: Int) {
        TUI.write(station.name)
        TUI.cursor(1, 0)
        
        if (withId) {
            TUI.write(String.format("%02d", station))
        }

        TUI.writeIcon(Icons.UPWARDS_ARROW)
        if (roundTrip) TUI.writeIcon(Icons.UPWARDS_ARROW)
        
        val p = (if (roundTrip) station.price * 2 else station.price) - avaliableCurrency

        val price = String.format("%.2f", p / 100.0)
        TUI.cursor(1, 11)
        TUI.write(price)
        TUI.writeIcon(Icons.EURO_SIGN)
    }
}