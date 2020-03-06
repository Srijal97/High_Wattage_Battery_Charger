/*
 * Scheduler_timer1_ISR.c
 *
 *  Created on: Jan 25, 2020
 *      Author: Srijal
 */

#include <Scheduler_timer1_ISR.h>

extern Uint32 delay_count_timer1;


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
    /* Tick Interval = 25us
     * taskCount is used to manage the tasks to
     *  be called by keeping a record of number of ticks.
     *  tasks will be called based on the tickCount value which
     *  reflect the time interval
     */

    delay_count_timer1++;    // incrementing the counter at every tick

    /* processing the ADC values by using filters
     * this is done every tick interval */
    ADC_processVal();

   // fault_condition ==> 0x00  // bit 0: output under voltage
                                // bit 1: output over voltage
                                // bit 2: input under voltage
                                // bit 3: input over voltage
                                // bit 4: output over current
                                // bit 5: battery over current

    if (OP_I_DC > OP_I_DC_MAX_SETPOINT) {  // output over current trip
        PWM_force_low_EPWM1();
        PWM_force_low_EPWM2();

        power_out_factor = 0;
        system_state = 0;

        fault_condition |= 0x10;
    }

    if (BAT_I_DC > BAT_I_DC_MAX_SETPOINT) {  // battery over current trip
        PWM_force_low_EPWM1();
        PWM_force_low_EPWM2();

        power_out_factor = 0;

        system_state = 0;
        fault_condition |= 0x20;
    }
    if (OP_V_DC > OP_V_DC_MAX_SETPOINT) {  // output over voltage trip if voltage high
        PWM_force_low_EPWM1();
        PWM_force_low_EPWM2();

        power_out_factor = 0;
        system_state = 0;

        fault_condition |= 0x02;
    }

    if ( system_state == 2 && OP_V_DC < OP_V_DC_MIN_SETPOINT) {  // output under voltage trip if voltage low and MACHINE on
        PWM_force_low_EPWM1();
        PWM_force_low_EPWM2();

        power_out_factor = 0;
        system_state = 0;

        fault_condition |= 0x01;
    }



    if(delay_count_timer1 % (long int)(HEART_BEAT_LED_PRD/SCH_T1_TICK_VAL) == 0) {
        GpioDataRegs.GPATOGGLE.bit.GPIO13 = 1;
    }

    ServiceDog();

}

int delay_n_10us (Uint32 n) {

    Uint32 start_count = delay_count_timer1;

    while(delay_count_timer1 - start_count < n);

    return 1;
}




