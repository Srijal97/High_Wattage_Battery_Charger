/*
 * globals.h
 *
 *  Created on: Jul 29, 2019
 *      Author: Srijal Poojari
 */

#ifndef GLOBALS_H_
#define GLOBALS_H_

#include "macros.h"


const Uint16 VOLTAGE_SENS_OFFSET_ERR = 12;   // voltage sensing has an offset error of about 3V, corresponding to 28 counts

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
const Uint16 OP_V_DC_MIN_SETPOINT = 373;  // 50V

const Uint16 IP_V_DC_MAX_SETPOINT = 0;
const Uint16 IP_V_DC_MIN_SETPOINT = 0;

const Uint16 OP_I_DC_MAX_SETPOINT = 4050;  // roughly 40A
const Uint16 BAT_I_DC_MAX_SETPOINT = 4050; // roughly 40A


Uint16 CC_Kp_discrete = 4000;
Uint16 CC_Ki_discrete = 1000;

Uint16 CV_Kp_discrete = 4000;
Uint16 CV_Ki_discrete = 1000;

Uint16 batt_curr_setpoint = 985;  // default set to 10A
Uint16 output_voltage_setpoint = 1027;  // default set to 110V


float power_out_factor = 0;


int system_state = 0;  // 0: OFF, 1: soft start, 2: ON, 3: soft stop

int fault_condition = 0x00; // bit 0: output under voltage
                            // bit 1: output over voltage
                            // bit 2: input under voltage
                            // bit 3: input over voltage
                            // bit 4: output over current
                            // bit 5: battery over current


int serial_data_received = 0;

Uint32 delay_count_timer1 = 0;
Uint32 delay_count_timer0 = 0;


#endif /* GLOBALS_H_ */
