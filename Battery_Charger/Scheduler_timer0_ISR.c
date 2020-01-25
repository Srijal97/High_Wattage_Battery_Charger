/*
 * Scheduler_ISR.c
 *
 *  Created on: 19-Mar-2019
 *      Author: Ameya
 */

#include <adc.h>
#include <LCD.h>
#include <main.h>
#include <pwm.h>
#include <PID.h>
#include <gpio.h>
#include <Scheduler_timer0_ISR.h>
#include <Serial.h>

extern float pwm_pot_adc;
extern float freq_pot_adc;

extern float IP_V_DC;
extern float OP_V_DC;
extern float OP_I_DC;
extern float BAT_I_DC;

extern char operation_mode;

extern Uint16 CC_Kp_discrete;
extern Uint16 CC_Ki_discrete;

extern Uint16 CV_Kp_discrete;
extern Uint16 CV_Ki_discrete;


long map(long x, long in_min, long in_max, long out_min, long out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}



void Scheduler_timer0_ISR_Init(void)
{
    EALLOW;  // This is needed to write to EALLOW protected register
    PieVectTable.TINT0 = &Scheduler_timer0_ISR;
    EDIS;    // This is needed to disable write to EALLOW protected registers

    InitCpuTimers();

    ConfigCpuTimer(&CpuTimer0, CPU_FREQ_VAL, SCH_TICK_VAL);

    CpuTimer0Regs.TCR.all = 0x4001;

    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;
}

__interrupt void Scheduler_timer0_ISR(void)
{
    /* Tick Interval = 100us
     * taskCount is used to manage the tasks to
     *  be called by keeping a record of number of ticks.
     *  tasks will be called based on the tickCount value which
     *  reflect the time interval
     */

    static long int task_count = 0;

    task_count++;    // incrementing the counter at every tick

    /* clear the PIE flags and clear the timer flags*/
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;
    CpuTimer0Regs.TCR.bit.TIF = 1;


    /* processing the ADC values by using filters
     * this is done every tick interval */
    ADC_processVal();


    //PWM_updatePhase(pwm_pot_adc*2250/2800);

//    if(OP_I_DC > 1000) {
//        GPIO_disable_PWM();
//    }

    //OP_I_DC = pwm_pot_adc;

    // voltage sensing has a gain of 0.0157 V/V for R33 at 10k
    // at R33 = 4.7k, 120V -> 1121, 135V -> 1367, 150V -> 1404
    static const Uint16 voltage_setpoint = 1121;  //map(pwm_pot_adc, 0, 2700, 2000, 2500);

    // current setpoint of 1117 corresponds to 10A
    static const Uint16 total_curr_setpoint = 2234;  //1117;
    static const Uint16 batt_curr_setpoint = 1117;


    //SATURATE(voltage_setpoint, 2000, 2500);

    // Cascaded PI controller with Inner Voltage and Outer Current Loop

    Uint16 I1_PID_output = CC_PI_discrete1(total_curr_setpoint, (Uint16)OP_I_DC, CC_Kp_discrete, CC_Ki_discrete);
    Uint16 I2_PID_output = CC_PI_discrete2(batt_curr_setpoint, (Uint16)BAT_I_DC, CC_Kp_discrete, CC_Ki_discrete);

    Uint16 Vref = (Uint16)(((float)(I1_PID_output)/4095) * ((float)(I2_PID_output)/4095) * voltage_setpoint);

    Uint16 V_PID_output = CV_PI_discrete(Vref, (Uint16)OP_V_DC, CV_Kp_discrete, CV_Kp_discrete);

    PWM_updatePhase(V_PID_output / 2);


#ifdef VAR_PWM_FREQ_ALLOW
    PWM_updateFrequency();
#endif

    /* Call the serial monitor update function
     * every ___ seconds*/
//    if(taskCount%10 == 0)
//    {
//        SCI_UpdateMonitor();
//    }


    if(task_count == (long int)(HEART_BEAT_LED_PRD/SCH_TICK_VAL))
    {
        GpioDataRegs.GPATOGGLE.bit.GPIO13 = 1;
        task_count=0;
    }

}

void sleep_mode(void)
{
    EALLOW;
    /*only enter LPM if PLL is not in limp mode*/
    if(SysCtrlRegs.PLLSTS.bit.MCLKSTS != 1)
    {
        SysCtrlRegs.LPMCR0.bit.LPM = 0x0000; // idle mode
    }

    __asm(" IDLE");
    EDIS;
}
