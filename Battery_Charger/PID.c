/*
 * PID.c
 *
 *  Created on: 02-Apr-2019
 *      Author: Ameya
 */

#include <main.h>
#include <PID.h>
#include "macros.h"

extern float pwm_pot_adc;
extern float freq_pot_adc;

extern float pwm_pot_adc_old;
extern float freq_pot_adc_old;

float pidOutput1 = 0;
float pidOutput2 = 0;

float pidOutput1_old = 0;
float pidOutput2_old = 0;


//void PID_update(void)
//{
//    /* This function calculates the output
//     * of PID control block using old and
//     * new values of voltages*/
//
//    pidOutput1 = Kp*Voltage1 + pidOutput1_old + Ki*Ts*0.5*(Voltage1 + Voltage1_old);
//    pidOutput2 = Kp*Voltage2 + pidOutput2_old + Ki*Ts*0.5*(Voltage2 + Voltage2_old);
//}


Uint16 PID(float setpoint, float process_variable, float Kp, float Ki, float Kd){

    //static float lastInput = 0;
    static float cumulative_error = 0;

    float SampleTimeInSec = ((float)1)/1000;

    Kd = Kd / SampleTimeInSec;

    float error = setpoint - process_variable;
    //float dInput = (process_variable - lastInput);
    float output = 0;

    cumulative_error += error * SampleTimeInSec;

      /*Compute Rest of PID Output*/
    output = (Kp * error) + (Ki * cumulative_error); //- (Kd * dInput);

       /*Remember some variables for next time*/
    //lastInput = process_variable;

    if(output > 4095) {
        output = 4095;
    }
    else if(output < 0) {
        output = 0;
    }

    return (Uint16)output;

}


Uint16 CC_PI_discrete(Uint16 Setpoint, Uint16 PV, Uint16 Kpd, Uint16 Kid)
{
    volatile int16 Ek  = 0;

    volatile int16 P_Term  = 0;
    volatile int16 I_Term  = 0;
    volatile int16 delPV   = 0;
    volatile Uint16 PID_out = 0;

    static int16 Ck     = 0;
    static Uint16 PVk_1  = 0;

    Ek     = (int16) (Setpoint - PV);

    delPV  = (int16) (PV - PVk_1);
    P_Term = (int16) ((Kpd * (int32)delPV) >> 12);   // Kp = 4096  then Kpd = Kp/4096
    I_Term = (int16) ((Kid * (int32)Ek   ) >> 16);   // Ki = 65535 then Kid = Ki/65535

    Ck = (int16) (Ck - P_Term + I_Term);
    SATURATE(Ck, -2048, 2047);

    PVk_1   = PV; // Apply the History

    PID_out = (Uint16) (2048 + Ck);

    return PID_out;  // The return value will be 0 to 4095
}

Uint16 CV_PI_discrete(Uint16 Setpoint, Uint16 PV, Uint16 Kpd, Uint16 Kid)
{
    volatile int16 Ek  = 0;

    volatile int16 P_Term  = 0;
    volatile int16 I_Term  = 0;
    volatile int16 delPV   = 0;
    volatile Uint16 PID_out = 0;

    static int16 Ck     = 0;
    static Uint16 PVk_1  = 0;

    Ek     = (int16) (Setpoint - PV);

    delPV  = (int16) (PV - PVk_1);
    P_Term = (int16) ((Kpd * (int32)delPV) >> 12);   // Kp = 4096  then Kpd = Kp/4096
    I_Term = (int16) ((Kid * (int32)Ek   ) >> 16);   // Ki = 65535 then Kid = Ki/65535

    Ck = (int16) (Ck - P_Term + I_Term);
    SATURATE(Ck, -2048, 2047);

    PVk_1   = PV; // Apply the History

    PID_out = (Uint16) (2048 + Ck);

    return PID_out;  // The return value will be 0 to 4095
}

