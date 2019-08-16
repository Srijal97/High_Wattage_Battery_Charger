/*
 * Serial.c
 *
 *  Created on: 23-Mar-2019
 *      Author: Ameya
 */

//
// scia_echoback_init - Test 1,SCIA  DLB, 8-bit word, baud rate 0x0103,
// default, 1 STOP bit, no parity
//
#include <Serial.h>
#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File


char msg[] = "\rTimer Period :            Phase difference:           ";

void scia_echoback_init()
{
    //
    // Note: Clocks were turned on to the SCIA peripheral
    // in the InitSysCtrl() function
    //

    //
    // 1 stop bit,  No loopback, No parity,8 char bits, async mode,
    // idle-line protocol
    //
    SciaRegs.SCICCR.all =0x0007;

    //
    // enable TX, RX, internal SCICLK, Disable RX ERR, SLEEP, TXWAKE
    //
    SciaRegs.SCICTL1.all =0x0003;

    SciaRegs.SCICTL2.bit.TXINTENA = 0;
    SciaRegs.SCICTL2.bit.RXBKINTENA = 0;

    //
    // 9600 baud @LSPCLK = 22.5MHz (90 MHz SYSCLK)
    //
    SciaRegs.SCIHBAUD    =0x0001;
    SciaRegs.SCILBAUD    =0x0024;

    SciaRegs.SCICTL1.all =0x0023;  // Relinquish SCI from Reset
}

//
// scia_xmit - Transmit a character from the SCI
//
void scia_xmit(int a)
{
    while (SciaRegs.SCIFFTX.bit.TXFFST != 0) // It is in the loop till the transmit buffer gets emptied
    {

    }
    SciaRegs.SCITXBUF=a;
}

//
// scia_msg -
//
void scia_msg(char * msg)
{
    int i;
    i = 0;
    while(msg[i] != '\0')
    {
        scia_xmit(msg[i]);
        i++;
    }
}

void scia_send(char msg[], int n)
{
    int i;
    for(i=0; i<n; i++)
    {
        scia_xmit(msg[i]);
    }
}

//
// scia_fifo_init - Initalize the SCI FIFO
//
void scia_fifo_init()
{
    SciaRegs.SCIFFTX.all=0xE040;
    SciaRegs.SCIFFRX.all=0x2044;
    SciaRegs.SCIFFCT.all=0x0;
}

void SCI_UpdateMonitor(void)
{
    static int countChar = 0;

    scia_xmit(msg[countChar]);
    countChar++;
    if(countChar == 51)
    {
        countChar = 0;
    }
}
