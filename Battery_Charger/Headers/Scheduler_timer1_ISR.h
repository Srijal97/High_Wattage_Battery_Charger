/*
 * Scheduler_timer1_ISR.h
 *
 *  Created on: Jan 25, 2020
 *      Author: Srijal
 */

#ifndef SCHEDULER_TIMER1_ISR_H_
#define SCHEDULER_TIMER1_ISR_H_

#include "macros.h"
#include <adc.h>
#include <main.h>
#include <pwm.h>
#include <gpio.h>


extern Uint16 IP_V_DC_raw;
extern Uint16 OP_V_DC_raw;
extern Uint16 OP_I_DC_raw;
extern Uint16 BAT_I_DC_raw;

extern float OP_V_DC;

extern const Uint16 IP_V_DC_MAX_SETPOINT;
extern const Uint16 IP_V_DC_MIN_SETPOINT;

extern const Uint16 OP_V_DC_MAX_SETPOINT;
extern const Uint16 OP_V_DC_MIN_SETPOINT;

extern const Uint16 OP_I_DC_MAX_SETPOINT;
extern const Uint16 BAT_I_DC_MAX_SETPOINT;

extern float power_out_factor;

extern int system_state;
extern int fault_condition;



void Scheduler_timer1_ISR_Init(void);
__interrupt void Scheduler_timer1_ISR(void);

int delay_n_10us (Uint32 n);


#endif /* SCHEDULER_TIMER1_ISR_H_ */
