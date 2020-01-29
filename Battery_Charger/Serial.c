/*
 * Serial.c
 *
 *  Created on: 23-Mar-2019
 *      Author: Mr.Yash
 */


//
//
#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include <Serial.h>
#include <commands.h>
//
// Defines
//
#define CPU_FREQ    90E6
#define LSPCLK_FREQ (CPU_FREQ/4)
#define SCI_FREQ    100E3
#define SCI_PRD     ((LSPCLK_FREQ/(SCI_FREQ*8))-1)

//
// Function Prototypes
//
//__interrupt void sciaTxFifoIsr(void);
__interrupt void sciaRxFifoIsr(void);
//__interrupt void scibTxFifoIsr(void);
//__interrupt void scibRxFifoIsr(void);
void scia_fifo_init(void);
//void scib_fifo_init(void);
void error(void);

//
// Globals
//
char sdataA[5];    // Send data for SCI-A
char rdataA[4]; // Received data for SCI-A
char data;
int comStart;
int i = 0;

void SerialInit() {
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

    PieVectTable.SCIRXINTA = &sciaRxFifoIsr;
    //    PieVectTable.SCITXINTA = &sciaTxFifoIsr;
    //
    // 9600 baud @LSPCLK = 22.5MHz (90 MHz SYSCLK)
    //
    SciaRegs.SCIHBAUD    =0x0001;
    SciaRegs.SCILBAUD    =0x0024;

    SciaRegs.SCICTL1.all =0x0023;  // Relinquish SCI from Reset
    int i;
    for(i = 0; i<2; i++)
    {
        sdataA[i] = i;
    }
    //rdata_pointA = sdataA[0];


}

//
// error -
//
void
error(void)
{
   __asm("     ESTOP0"); // Test failed!! Stop!
    for (;;);
}

__interrupt void sciaRxFifoIsr(void)
{

    data = SciaRegs.SCIRXBUF.all;
    if(data=='<') {
        comStart = 1;
        i=0;
    }
    else if(data =='>') {
        comStart = 0;
        i=0;recOp(rdataA);
    }
    if (comStart == 1) {
        *(rdataA+i)=data;  // Read data
        i++;if(i==5){i=0;}
    }

    SciaRegs.SCIFFRX.bit.RXFFOVRCLR=1;   // Clear Overflow flag
    SciaRegs.SCIFFRX.bit.RXFFINTCLR=1;   // Clear Interrupt flag

    PieCtrlRegs.PIEACK.all|=0x100;       // Issue PIE ack
}

//
// scia_fifo_init -
//
void scia_fifo_init()
{
    //
    // 1 stop bit,  No loopback, No parity,8 char bits, async mode,
    // idle-line protocol
    //
    SciaRegs.SCICCR.all =0x0007;

    //
    // enable TX, RX, internal SCICLK, Disable RX ERR, SLEEP, TXWAKE
    //
    SciaRegs.SCICTL1.all =0x0003;
    SciaRegs.SCICTL2.bit.TXINTENA =1;
    SciaRegs.SCICTL2.bit.RXBKINTENA =1;
    SciaRegs.SCIHBAUD = ((Uint16)SCI_PRD) >> 8;
    SciaRegs.SCILBAUD = SCI_PRD;
//    SciaRegs.SCICCR.bit.LOOPBKENA =1;   // Enable loop back
    SciaRegs.SCIFFTX.all=0xC022;
    SciaRegs.SCIFFRX.all=0x0021;
    SciaRegs.SCIFFCT.all=0x00;

    SciaRegs.SCICTL1.all =0x0023;       // Relinquish SCI from Reset
    SciaRegs.SCIFFTX.bit.TXFIFOXRESET=1;
    SciaRegs.SCIFFRX.bit.RXFIFORESET=1;
}

void SCI_UpdateMonitor(char * msg)
{
    int countChar = 0;

    while(msg[countChar]!='\0')
    {
        scia_xmit(msg[countChar]);
        countChar++;
    }
    SciaRegs.SCIFFTX.bit.TXFFINTCLR=1;  // Clear SCI Interrupt flag
        PieCtrlRegs.PIEACK.all|=0x100;      // Issue PIE ACK
}

void scia_xmit(int a)
{
    while (SciaRegs.SCIFFTX.bit.TXFFST != 0) // It is in the loop till the transmit buffer gets emptied
    {

    }
    SciaRegs.SCITXBUF=a;

    //ReceivedChare = SciaRegs.SCIRXBUF.all;
}

//
// End of File
//
