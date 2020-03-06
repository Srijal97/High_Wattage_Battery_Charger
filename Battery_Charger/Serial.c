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
char tx_data[] = {'<', '0', '0', '0', '-', '0', '0', '0', '0', '>'};    // Send data for SCI-A
char rx_data[] = {'<', '0', '0', '0', '-', '0', '0', '0', '0', '>'}; // Received data for SCI-A

const int MAX_TX_LENGTH = 10;

extern int serial_data_received;

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
    SciaRegs.SCIHBAUD = 0x0001;
    SciaRegs.SCILBAUD = 0x0024;


    SciaRegs.SCICTL1.all = 0x0023;  // Relinquish SCI from Reset
//    int i;
//    for(i = 0; i<2; i++)
//    {
//        tx_data[i] = i;
//    }
    //rdata_pointA = tx_data[0];


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

    static int com_started = 0;
    static int rx_index = 0;

    char data = SciaRegs.SCIRXBUF.all;

    if(data == '<' && com_started == 0 && serial_data_received == 0) {
        rx_data[0] = data;  //  data

        com_started = 1;
        rx_index++;
    }
    else if(data == '>') {
        if (com_started) {
            rx_data[rx_index] = data;  //  data

            com_started = 0;
            rx_index = 0;
            serial_data_received = 1;

            process_rx_command(rx_data);
            serial_data_received = 0;
        }
    }
    else if (com_started == 1) {
        rx_data[rx_index] = data;  // Read data
        rx_index++;
    }

    if (rx_index == MAX_TX_LENGTH) {
        rx_index = 0;
    }

    SciaRegs.SCIFFRX.bit.RXFFOVRCLR = 1;   // Clear Overflow flag
    SciaRegs.SCIFFRX.bit.RXFFINTCLR = 1;   // Clear Interrupt flag

    PieCtrlRegs.PIEACK.all |= 0x100;       // Issue PIE ack
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
    SciaRegs.SCICTL1.all = 0x0003;
    SciaRegs.SCICTL2.bit.TXINTENA = 1;
    SciaRegs.SCICTL2.bit.RXBKINTENA = 1;
    SciaRegs.SCIHBAUD = ((Uint16)SCI_PRD) >> 8;
    SciaRegs.SCILBAUD = SCI_PRD;
//    SciaRegs.SCICCR.bit.LOOPBKENA = 1;   // Enable loop back
    SciaRegs.SCIFFTX.all = 0xC022;
    SciaRegs.SCIFFRX.all = 0x0021;
    SciaRegs.SCIFFCT.all = 0x00;

    SciaRegs.SCICTL1.all = 0x0023;       // Relinquish SCI from Reset
    SciaRegs.SCIFFTX.bit.TXFIFOXRESET = 1;
    SciaRegs.SCIFFRX.bit.RXFIFORESET = 1;
}

void SCI_UpdateMonitor(char *msg)
{
    int char_index = 0;

    while(msg[char_index - 1] != '>' && char_index < 100)
    {
        scia_xmit(msg[char_index]);
        char_index++;
    }
    SciaRegs.SCIFFTX.bit.TXFFINTCLR = 1;  // Clear SCI Interrupt flag
    PieCtrlRegs.PIEACK.all |= 0x100;      // Issue PIE ACK
}

void scia_xmit(char a)
{
    while (SciaRegs.SCIFFTX.bit.TXFFST != 0) // It is in the loop till the transmit buffer gets emptied
    {

    }
    SciaRegs.SCITXBUF = a;

    //ReceivedChare = SciaRegs.SCIRXBUF.all;
}

//
// End of File
//
