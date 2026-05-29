fun sleep (ms : Int, ns : Int = 0) {
    val ms = ms * 100000

    val target = System.nanoTime() + ms + ns

    while (System.nanoTime() < target) {}
}

fun sleep(ms: Long) {
    sleep(ms.toInt())
}