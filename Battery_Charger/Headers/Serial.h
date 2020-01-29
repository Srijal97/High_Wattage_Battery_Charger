/*
 * Serial.h
 *
 *  Created on: 23-Mar-2019
 *      Author: Ameya
 */

#ifndef SERIAL_H_
#define SERIAL_H_

#include "DSP28x_Project.h"

//
// Function Prototypes
//
extern void SerialInit(void);
extern void scia_fifo_init(void);
extern void scia_xmit(int a);
void SCI_UpdateMonitor(char *msg);
//char scia_rec(void);
__interrupt void sciaRxFifoIsr(void);
#endif /* SERIAL_H_ */
