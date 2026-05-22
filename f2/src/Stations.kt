data class Station(val price: Int, var currentTicketCount: Int, val name: String, val id: Int)

object Stations {

    var stationsInfo: MutableList<Station> = mutableListOf()

    fun init() {
        loadStationsInfo()
    }

    private fun loadStationsInfo() {
        stationsInfo = readFile("stations.txt")
            .mapIndexed { index, line ->
                val (price, count, name) = line.split(";")
                Station(price.toInt(), count.toInt(), name, index)
            }.toMutableList()
    }

    fun getStation(stationID: Int): Station? = stationsInfo.find { it.id == stationID }
    

    fun addTicket(stationID: Int) {
        stationsInfo.find { it.id == stationID }?.let { it.currentTicketCount++ }
    }

    fun resetTicketCounters() {
        stationsInfo.forEach { it.currentTicketCount = 0 }
    }

    fun writeFile() {
        val output = stationsInfo.map { "${it.price};${it.currentTicketCount};${it.name}" }
        writeFile(fileName = "stations.txt", dataArray = output.toTypedArray())
    }
}