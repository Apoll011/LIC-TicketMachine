import java.io.BufferedReader
import java.io.FileReader
import java.io.PrintWriter

fun readFile(fileName: String): Array<String> {
    val reader = BufferedReader(FileReader(fileName))

    var dataArray: Array<String> = emptyArray()

    var currentLine = reader.readLine()
    while (currentLine != null) {
        dataArray += currentLine
        currentLine = reader.readLine()
    }
    
    reader.close()
    return dataArray
}

fun writeFile(fileName: String, dataArray: Array<String>) {
    val writer = PrintWriter(fileName)
    for (data in dataArray) {
        writer.println(data)
    }
    writer.close()
}
