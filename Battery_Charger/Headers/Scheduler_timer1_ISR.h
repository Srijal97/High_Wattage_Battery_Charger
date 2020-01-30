/*
 * Scheduler_timer1_ISR.h
 *
 *  Created on: Jan 25, 2020
 *      Author: Srijal
 */

#ifndef SCHEDULER_TIMER1_ISR_H_
#define SCHEDULER_TIMER1_ISR_H_



#include "macros.h"

void Scheduler_timer1_ISR_Init(void);
__interrupt void Scheduler_timer1_ISR(void);




#endif /* SCHEDULER_TIMER1_ISR_H_ */
