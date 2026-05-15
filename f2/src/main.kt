fun main() {
    TUI.init()
    //TicketDispenser.activatePrintingTicket(false , 5,4)
    LCD.enableCursor(true)
    LCD.writeIcon(RomIcons.LEFT_ARROW)
    LCD.writeIcon(RomIcons.RIGHT_ARROW)
    LCD.writeIcon(RomIcons.LEFT_PARANTHESIS)
    LCD.writeIcon(RomIcons.RIGHT_PARANTHESIS)
    LCD.writeIcon(Icons.EURO_SIGN)







    TUI.echo()
}