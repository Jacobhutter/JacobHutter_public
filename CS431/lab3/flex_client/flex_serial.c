#include "lcd.h"

void uart2_init(uint16_t baud){
    CLEARBIT(U2MODEbits.UARTEN);

    /*Disable Interrupts */
    IEC1bits.U2RXIE = 0;
    IEC1bits.U2TXIE = 0;

    /* Clear Interrupt flag bits */
    IFS1bits.U2RXIF = 0;
    IFS1bits.U2TXIF = 0;

    /*Set IO pins */
    TRISFbits.TRISF4 = 1;       //set as input UART2 RX pin
    TRISFbits.TRISF5 = 0;       // set as output UART2 TX pin

    /* baud rate*/
    // following equation for baud rate
    U2MODEbits.BRGH = 0;
    U2BRG = (uint32_t)800000 / baud -1;

    /* Operation  settings and start port*/
    U2MODE = 0;             // 8-bit, no parity and 1 stop bit
    U2MODEbits.RTSMD = 0;   //select simplex mode
    U2MODEbits.UEN = 0;     //select simplex mode
    U2MODE |= 0x00;

    U2MODEbits.UARTEN = 1;   //enable UART
    U2STA = 0;
    U2STAbits.UTXEN = 1;     //enable UART TX


}
int uart2_putc(uint8_t c){

    while (U2STAbits.UTXBF);
    U2TXREG = c;
    while(!U2STAbits.TRMT);

}

uint8_t uart2_getc(uint8_t *c){
    uint8_t rec = 0;

    if (U2STAbits.OERR) {
        U2STAbits.OERR = 0;
    }

    if (U2STAbits.URXDA) {
        *c = U2RXREG & 0x00FF;
        rec = 1;
    }
    return rec;

}