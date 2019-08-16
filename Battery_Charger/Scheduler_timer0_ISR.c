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

extern float pwm_pot_adc_old;

extern float IP_V_DC;
extern float OP_V_DC;
extern float OP_I_DC;

extern char operation_mode;

extern float CC_Kp;
extern float CC_Ki;
extern float CC_Kd;

extern float CV_Kp;
extern float CV_Ki;
extern float CV_Kd;

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
    /* Tick Interval = 10 ms
     * taskCount is used to manage the tasks to
     *  be called by keeping a record of number of ticks.
     *  tasks will be called based on the tickCount value which
     *  reflect the time interval*/

    static int taskCount = 0;

    taskCount++;    // incrementing the counter at every tick

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

    // Cascaded PI controller with Inner Voltage and Outer Current Loop

    Uint16 I_PID_output = CC_PI_discrete(560, (Uint16)OP_I_DC, CC_Kp_discrete, CC_Ki_discrete);

    Uint16 Vref = (Uint16)(((float)(I_PID_output)/4095)*2000);

    Uint16 V_PID_output = CV_PI_discrete(Vref, (Uint16)OP_V_DC, CV_Kp_discrete, CV_Kp_discrete);

    PWM_updatePhase(V_PID_output / 2);


//    if (operation_mode == CV_MODE) {
////        Uint16 PID_output = PID(OP_V_DC, (float)560, CV_Kp, CV_Ki, CV_Kd);
////
////        PWM_updatePhase(PID_output / 2);
//
//        PWM_updatePhase(2250);
//
//        if (OP_I_DC > 560) {   // 560 corresponds to roughly 5A
//            operation_mode = CC_MODE;
//        }
//    }
//    else if (operation_mode == CC_MODE) {
//        Uint16 PID_output = PID(OP_I_DC, (float)560, CC_Kp, CC_Ki, CC_Kd);
//
//        PWM_updatePhase(PID_output / 2);
//
//        if (OP_I_DC < 450) {   // 560 corresponds to roughly 5A
//            operation_mode = CV_MODE;
//        }
//    }



#ifdef VAR_PWM_FREQ_ALLOW
    PWM_updateFrequency();
#endif

    /* Call the serial monitor update function
     * every ___ seconds*/
    if(taskCount%10 == 0)
    {
        //SCI_UpdateMonitor();
    }

    if(taskCount == (int)(HEART_BEAT_LED_PRD/SCH_TICK_VAL))
    {
        GpioDataRegs.GPATOGGLE.bit.GPIO13 = 1;
        taskCount=0;
    }

    //GpioDataRegs.GPADAT.all =   ((GpioDataRegs.GPADAT.all) & (~LCD_DATABUS)) | (data<<18);
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
