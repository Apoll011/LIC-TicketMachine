// Escreve no LCD usando a interface a 8 bits .

object LCD {
    // Dimensao do display .
    const val LINES = 2
    const val COLS = 16

    // Escreve um byte de comando / dados no LCD em serie
    private fun writeByteSerial ( rs : Boolean , data : Int ) {
        val rsBit = if (rs) 1 else 0
        val packet = (rsBit shl 8) or (data and 0xFF)

        while(SerialEmitter.isBusy()) { }

        SerialEmitter.send(Peripheral.LCD, (packet shl 1) or 1, 10)
    }

    // Escreve um byte de comando / dados no LCD
    private fun writeByte ( rs : Boolean , data : Int ) {
        writeByteSerial(rs, data)
    }

    // Escreve um comando no LCD
    private fun writeCMD(data : Int ) {
        writeByte(true, data)
    }

    // Escreve um dado no LCD
    private fun writeDATA(data : Int ) {
        writeByte(false, data)
    }

    // Envia a sequencia de iniciacao para comunicacao a 8 bits .
    fun init () {
        SerialEmitter.init()
    }

    // Escreve um carater na posicao corrente
    fun write (c : Char) {
        writeChar(c)
    }

    // Escreve uma string na posicao corrente .
    fun write(text: String) {
        val chars = text.toList()

        for (c in chars) {
            writeChar(c)
        }
    }

    fun writeChar(c: Char) {
        //Use writeData, ANd I think writeCmd some command to write maybe?
        var bit = c.toInt()

        writeDATA(bit)
        println(bit)
    }

    // Envia comando para posicionar cursor ( ’ line ’:0.. LINES -1 , ’ column ’:0.. COLS -1)
    fun cursor (line: Int, column: Int) {
        if (line == 1){
            writeCMD(0b10000000 + column & 3F)//linha1
        } else if (line == 0) {
            writeCMD(0b11000000 + column & 3F)//linha2
        }
    }

    // Envia comando para limpar o ecra e posicionar o cursor em (0 ,0)
    fun clear () {
        writeCMD(0b00000001)
    }
}