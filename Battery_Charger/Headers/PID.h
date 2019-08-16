/*
 * PID.h
 *
 *  Created on: 02-Apr-2019
 *      Author: Ameya
 */

#ifndef PID_H_
#define PID_H_

#include "main.h"

void PID_update(void);

Uint16 PID(float process_variable, float setpoint, float Kp, float Ki, float Kd);
Uint16 CC_PI_discrete(Uint16 Setpoint, Uint16 PV, Uint16 Kpd, Uint16 Kid);
Uint16 CV_PI_discrete(Uint16 Setpoint, Uint16 PV, Uint16 Kpd, Uint16 Kid);

#endif /* PID_H_ */
