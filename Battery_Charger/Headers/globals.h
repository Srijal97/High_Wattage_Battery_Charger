/*
 * globals.h
 *
 *  Created on: Jul 29, 2019
 *      Author: Srijal Poojari
 */

#ifndef GLOBALS_H_
#define GLOBALS_H_

#include "macros.h"

char operation_mode = CV_MODE;

float pwm_pot_adc = 0;
float freq_pot_adc = 0;

Uint16 IP_V_DC_raw = 0;
Uint16 OP_V_DC_raw = 0;
Uint16 OP_I_DC_raw = 0;
Uint16 BAT_I_DC_raw = 0;

float IP_V_DC = 0;
float OP_V_DC = 0;
float OP_I_DC = 0;
float BAT_I_DC = 0;

const Uint16 OP_V_DC_MAX_SETPOINT = 1404;  // 150V
const Uint16 OP_V_DC_MIN_SETPOINT = 747;  // 80V

const Uint16 IP_V_DC_MAX_SETPOINT = 0;
const Uint16 IP_V_DC_MIN_SETPOINT = 0;

const Uint16 OP_I_DC_MAX_SETPOINT = 1117;  // 36A
const Uint16 BAT_I_DC_MAX_SETPOINT = 2792; // 25A


Uint16 CC_Kp_discrete = 4000;
Uint16 CC_Ki_discrete = 1000;

Uint16 CV_Kp_discrete = 4000;
Uint16 CV_Ki_discrete = 1000;


float power_out_factor = 0;


int system_state = 0;  // 0: OFF, 1: soft start, 2: ON, 3: soft stop

int fault_condition = 0;


#endif /* GLOBALS_H_ */
