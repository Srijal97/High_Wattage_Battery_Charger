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
extern void scia_echoback_init(void);
extern void scia_fifo_init(void);
extern void scia_xmit(int a);
extern void scia_msg(char *msg);
extern void scia_send(char * msg, int n);
void SCI_UpdateMonitor(void);


#endif /* SERIAL_H_ */
