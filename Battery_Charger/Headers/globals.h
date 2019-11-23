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

float pwm_pot_adc_old = 0;
float freq_pot_adc_old = 0;

float IP_V_DC = 0;
float OP_V_DC = 0;
float OP_I_DC = 0;

Uint16 CC_Kp_discrete = 4000;
Uint16 CC_Ki_discrete = 1000;

Uint16 CV_Kp_discrete = 4000;
Uint16 CV_Ki_discrete = 1000;


#endif /* GLOBALS_H_ */
