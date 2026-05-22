import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import kotlin.math.round


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

    fun firstScreen() {
        TUI.clear()
        TUI.write(" Ticket to Ride")
        TUI.cursor(1, 0)

        val now = LocalDateTime.now()

        val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")

        TUI.write(now.format(formatter))
        
        while (TUI.getKey() == '\u0000') {}
        listDestinys()   
    }

    fun mainLoop() {
        while (true) {
            firstScreen()
            currentDestiny = 0
        }
    }

    fun listDestinys() {
        var chosing = true
        printCurrentDestinyMenu()
        while (chosing) {
            var key = TUI.getKey()
            when (key) {
                in '0'..'9' -> {
                    currentDestiny = key.digitToInt()
                    printCurrentDestinyMenu()
                }
                'A' -> {
                    currentDestiny = (currentDestiny - 1 + 16) % 16
                    printCurrentDestinyMenu()
                }

                // Next (wrap 15 -> 0)
                'B' -> {
                    currentDestiny = (currentDestiny + 1) % 16
                    printCurrentDestinyMenu()
                }
                '#' -> chosing = false
            }
        }
        selectDestiny()
    }

    fun selectDestiny() {
        var roundTrip = false
        var chosed = true 
        
        TUI.clear()

        val station = Stations.getStation(currentDestiny)
        if (station == null) return
        
        printDestiny(station, false, roundTrip, station.price)

        while(chosed) {       
            var p = (if (roundTrip) station.price * 2 else station.price) - CoinDeposit.ammoutInserted()

            if (p <= 0) {
                TUI.deleteText(LCD.Line.LOWER, 0, 15)
                TUI.cursor(1, 3)
                TUI.write("LOADING...")
                CoinAcceptor.collectCoins()
                collectTicket(station, roundTrip)
                break
            } 

            if(CoinAcceptor.acceptCoin()) {
                printLowerLine(p, roundTrip)
            }

            var key = TUI.getKey()
            when (key) {
                '*' -> {
                    roundTrip = !roundTrip
                    p = (if (roundTrip) station.price * 2 else station.price) - CoinDeposit.ammoutInserted()
                    printLowerLine(p, roundTrip)
                }
                '#' -> {
                    TUI.clear()
                    TUI.write("VENDING ABORTED")
                    if (CoinDeposit.ammoutInserted() > 0) {
                        TUI.cursor(1, 3)
                        TUI.write("Return")
                        printLowerLine(CoinDeposit.ammoutInserted(), false)
                        CoinAcceptor.ejectCoins()
                    } 
                    chosed = false
                    Thread.sleep(2000L)
                }
            }
        }    
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

    fun collectTicket(station: Station, roundTrip : Boolean) {
        Stations.addTicket(station.id)
        TicketDispenser.activatePrintingTicket(roundTrip, station.id-1, station.id)

        TUI.clear()
        TUI.cursor(0, 4)
        TUI.write("Thank You")
        TUI.cursor(1, 1)
        TUI.write("Have a Nice Trip!")
        
        Thread.sleep(5000L)
    }

    fun printCurrentDestinyMenu() {
        TUI.clear()
        val station = Stations.getStation(currentDestiny)
        if (station == null) return
        
        printDestiny(station, true, true, station.price)
    }

    fun calcularPaddingCentralizado(tamanhoTexto: Int): Int {
        return ((16 - tamanhoTexto).coerceAtLeast(0)) / 2
    }

    fun printDestiny(station: Station, withId: Boolean, roundTrip: Boolean, currency: Int) {
        val l = calcularPaddingCentralizado(station.name.length)
        TUI.cursor(0, l)
        TUI.write(station.name)
        TUI.cursor(1, 0)
        
        if (withId) {
            TUI.write(String.format("%02d", station.id))
        }

        TUI.writeIcon(Icons.UPWARDS_ARROW)
        if (roundTrip) TUI.writeIcon(Icons.DOWNWARDS_ARROW)
        
        val price = String.format("%.2f", currency / 100.0)

        TUI.cursor(1, 11)
        TUI.write(price)
        TUI.writeIcon(Icons.EURO_SIGN)
    }

    fun writeFile() {
        CoinDeposit.writeFile()
        Stations.writeFile()
    }
}