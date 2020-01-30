/*
 * pwm.h
 *
 */

#ifndef PWM_H_
#define PWM_H_

#include "main.h"

/*
#define EPWM_1_PRD_MAX      9000                // Base frequency 10KHz frequency
#define EPWM_1_PRD_MIN      3000                // Epwm 1 max frequency 30KHz
#define EPWM_2_PRD_MAX      9000                // epwm 2 uncomment for period of 15KHz frequency
#define EPWM_2_PRD_MIN      3000                // epwm 2 uncomment for period of 20KHz frequency
*/

#define EPWM_1_PRD_20KHZ    4500                // PWM PERIOD REGISTER VALUE FOR 20KHz
#define EPWM_2_PRD_20KHZ    4500                // PWM PERIOD REGISTER VALUE FOR 20KHz

#define EPWM_1A_DUTY_20KHZ  2250				// Epwm1 duty cycle 50% of 10KHz
#define EPWM_1B_DUTY_20KHZ  2250				// Epwm1 duty cycle 50% of 10KHz

#define EPWM_2A_DUTY_20KHZ  2250                // epwm 2A uncomment for Duty Cycle 50% of 15KHz
#define EPWM_2B_DUTY_20KHZ  2250                // epwm 2A uncomment for Duty Cycle 50% of 15KHz

#define EPWM_1_DEADBAND	    0                 // dead band clock cycle count
#define EPWM_2_DEADBAND     0                 // dead band clock cycle count


void PWM_setup_init(void);

void PWM_setup_EPWM_1(void);
void PWM_setup_EPWM_2(void);

void PWM_updatePhase(Uint16 phaseShift);

void PWM_force_high_EPWM1();
void PWM_force_low_EPWM1();
void PWM_disable_force_EPWM1();

void PWM_force_high_EPWM2();
void PWM_force_low_EPWM2();
void PWM_disable_force_EPWM2();

#ifdef VAR_PWM_FREQ_ALLOW
void PWM_updateFrequency(void);
#endif

#endif /* PWM_H_ */
