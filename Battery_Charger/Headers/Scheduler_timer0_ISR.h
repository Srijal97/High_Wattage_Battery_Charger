/*
 * Scheduler_ISR.h
 *
 *  Created on: 19-Mar-2019
 *      Author: Ameya
 */

#ifndef SCHEDULER_TIMER0_ISR_H_
#define SCHEDULER_TIMER0_ISR_H_


#include "macros.h"

void Scheduler_timer0_ISR_Init(void);
__interrupt void Scheduler_timer0_ISR(void);


void sleep_mode(void);

#endif /* SCHEDULER_TIMER0_ISR_H_ */
