/*
 * main.h
 *
 *  Created on: Feb 21, 2019
 *      Author: BEE
 */

#ifndef MAIN_H_
#define MAIN_H_

#include "DSP28x_Project.h"

/* uncomment the VAR_PWM_FREQ_ALLOW to
 * access the functionality of change in
 * frequency. further changes need to be done
 * to ensure proper functionality after uncommenting*/

//#define VAR_PWM_FREQ_ALLOW 1

#define INT_OSC_1_FREQ 10//MHz

/* The following macro generates the clock frequency number which can be used
 * system wide for calculations*/
#define CPU_FREQ_VAL        (int)((INT_OSC_1_FREQ*DSP28_PLLCR)/DSP28_DIVSEL)//MHz

/* The following define the Scheduler Tick Value in Micro-Seconds*/
#define SCH_TICK_VAL        (int)100//uSec

#define HEART_BEAT_LED_PRD  (Uint32)1000000//usec

#endif /* MAIN_H_ */
