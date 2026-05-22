import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


class App {
    fun init() {
        TUI.init()
        TicketDispenser.init()
    }

    fun firstScreen() {
        TUI.write(" Ticket to Ride")
        TUI.cursor(LCD.Line.LOWER, 1)

        val now = LocalDateTime.now()

        val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")

        TUI.write(now.format(formatter))
    }
}