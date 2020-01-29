/*
 * Scheduler_timer1_ISR.c
 *
 *  Created on: Jan 25, 2020
 *      Author: Srijal
 */

#include <adc.h>
#include <LCD.h>
#include <main.h>
#include <pwm.h>
#include <PID.h>
#include <gpio.h>
#include <Scheduler_timer1_ISR.h>
#include <Serial.h>

extern Uint16 IP_V_DC_raw;
extern Uint16 OP_V_DC_raw;
extern Uint16 OP_I_DC_raw;
extern Uint16 BAT_I_DC_raw;

extern const Uint16 IP_V_DC_MAX_SETPOINT;
extern const Uint16 IP_V_DC_MIN_SETPOINT;

extern const Uint16 OP_V_DC_MAX_SETPOINT;
extern const Uint16 OP_V_DC_MIN_SETPOINT;

extern const Uint16 OP_I_DC_MAX_SETPOINT;
extern const Uint16 BAT_I_DC_MAX_SETPOINT;

void Scheduler_timer1_ISR_Init(void)
{
    EALLOW;  // This is needed to write to EALLOW protected register
    PieVectTable.TINT1 = &Scheduler_timer1_ISR;
    EDIS;    // This is needed to disable write to EALLOW protected registers

    ConfigCpuTimer(&CpuTimer1, CPU_FREQ_VAL, SCH_T1_TICK_VAL);

    CpuTimer1Regs.TCR.all = 0x4001;

}

__interrupt void Scheduler_timer1_ISR(void)
{
    /* Tick Interval = 100us
     * taskCount is used to manage the tasks to
     *  be called by keeping a record of number of ticks.
     *  tasks will be called based on the tickCount value which
     *  reflect the time interval
     */

    static long int task_count = 0;

    task_count++;    // incrementing the counter at every tick

    /* processing the ADC values by using filters
     * this is done every tick interval */
    ADC_processVal();

//    if (OP_V_DC_raw > OP_V_DC_MAX_SETPOINT) {  // output over voltage trip
//        PWM_force_low_EPWM1();
//        PWM_force_low_EPWM2();
//    }
//    if (OP_V_DC_raw < OP_V_DC_MIN_SETPOINT) {  // output under voltage trip
//        PWM_force_low_EPWM1();
//        PWM_force_low_EPWM2();
//    }
//    if (OP_I_DC_raw > OP_I_DC_MAX_SETPOINT) {  // output over current trip
//        PWM_force_low_EPWM1();
//        PWM_force_low_EPWM2();
//    }
//    if (BAT_I_DC_raw > BAT_I_DC_MAX_SETPOINT) {  // battery over current trip
//        PWM_force_low_EPWM1();
//        PWM_force_low_EPWM2();
//    }

    if(task_count == (long int)(HEART_BEAT_LED_PRD/SCH_T1_TICK_VAL))
    {
        task_count=0;
        GpioDataRegs.GPATOGGLE.bit.GPIO13 = 1;
    }

}





