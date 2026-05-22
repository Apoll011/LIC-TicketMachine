import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


class App {
    fun init() {
        TUI.init()
        TicketDispenser.init()
    }

    fun start() {
        firstScreen()
        menu()
    }

    fun firstScreen() {
        TUI.write(" Ticket to Ride")
        TUI.cursor(1, 0)

        val now = LocalDateTime.now()

        val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")

        TUI.write(now.format(formatter))
    }

    fun menu(){
        val key = TUI.readKey()
        if (key != '\u0000'){
            TUI.clear()
            TUI.echo()
        }
    }
}