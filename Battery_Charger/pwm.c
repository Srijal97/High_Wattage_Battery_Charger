/*
 * pwm.c
 *
 *  Created on: Feb 21, 2019
 *      Author: BEE
 */

#include <main.h>
#include <pwm.h>

extern float freq_pot_adc;
extern float pwm_pot_adc;

Uint16 phaseShiftOffset = 250;

void PWM_setup_init(void)
{
	PWM_setup_EPWM_1();
	PWM_setup_EPWM_2();
}

void PWM_setup_EPWM_1(void)
{
    EALLOW;

	EPwm1Regs.TBPRD = EPWM_1_PRD_20KHZ;                             // Period = 1800 cycles for 50KHz pwm at 90MHz clock speed

    EPwm1Regs.CMPA.half.CMPA    = EPWM_1A_DUTY_20KHZ;               // value for duty cycle
    EPwm1Regs.CMPB              = EPWM_1B_DUTY_20KHZ;               // value for duty cycle

    EPwm1Regs.TBCTR = 0;                                            // clear TB counter
    EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;                      // counter mode

    EPwm1Regs.TBCTL.bit.PHSEN = TB_DISABLE;                         // Phase loading disabled
    EPwm1Regs.TBPHS.half.TBPHS = 0;                                 // Set Phase register to zero

    EPwm1Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    EPwm1Regs.TBCTL.bit.SYNCOSEL = TB_CTR_ZERO;
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = TB_DIV1;                        // TBCLK = SYSCLKOUT
    EPwm1Regs.TBCTL.bit.CLKDIV =    TB_DIV1;

    EPwm1Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm1Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm1Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;                   // load on CTR = Zero
    EPwm1Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;                   // load on CTR = Zero

    EPwm1Regs.AQCTLA.bit.ZRO = AQ_SET;
    EPwm1Regs.AQCTLA.bit.CAU = AQ_CLEAR;
    EPwm1Regs.AQCTLB.bit.ZRO = AQ_SET;
    EPwm1Regs.AQCTLB.bit.CAU = AQ_CLEAR;

    EPwm1Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;                  // enable Dead-band module
    EPwm1Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;                       // Active Hi complementary
    EPwm1Regs.DBFED = EPWM_1_DEADBAND;                              // FED 2us
    EPwm1Regs.DBRED = EPWM_1_DEADBAND;                              // RED 2us

	EDIS;
}

void PWM_setup_EPWM_2(void)
{
    EALLOW;

	EPwm2Regs.TBPRD = EPWM_2_PRD_20KHZ;                             // Period = 1800 cycles for 50KHz pwm at 90MHz clock speed

    EPwm2Regs.CMPA.half.CMPA    = EPWM_2A_DUTY_20KHZ;               // value for duty cycle
    EPwm2Regs.CMPB              = EPWM_2B_DUTY_20KHZ;               // value for duty cycle

    EPwm2Regs.TBCTR = 0;                                            // clear TB counter
    EPwm2Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;                      // counter mode

    EPwm2Regs.TBCTL.bit.PHSEN = TB_ENABLE;                          // Phase loading disabled
    EPwm2Regs.TBPHS.half.TBPHS = 800;                               // Set Phase register to zero

    EPwm2Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    EPwm2Regs.TBCTL.bit.SYNCOSEL = TB_CTR_ZERO;
    EPwm2Regs.TBCTL.bit.HSPCLKDIV = TB_DIV1;                        // TBCLK = SYSCLKOUT
    EPwm2Regs.TBCTL.bit.CLKDIV =    TB_DIV1;

    EPwm2Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm2Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm2Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;                   // load on CTR = Zero
    EPwm2Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;                   // load on CTR = Zero

    EPwm2Regs.AQCTLA.bit.ZRO = AQ_SET;
    EPwm2Regs.AQCTLA.bit.CAU = AQ_CLEAR;
    EPwm2Regs.AQCTLB.bit.ZRO = AQ_SET;
    EPwm2Regs.AQCTLB.bit.CAU = AQ_CLEAR;

    EPwm2Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;                  // enable Dead-band module
    EPwm2Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;                       // Active Hi complementary
    EPwm2Regs.DBFED = EPWM_2_DEADBAND;                              // FED 2us
    EPwm2Regs.DBRED = EPWM_2_DEADBAND;                              // RED 2us

	EDIS;
}

void PWM_updatePhase(Uint16 phaseShift)
{
    EALLOW;

    /*The opamp used saturates at 2 volts hence instead
     * of diviing by full range 4096 we divide Voltage1
     * by (2/3.3)*4096 = 2482. Since we want the mx phase
     * to not exceed 180 deg and not go beyond 10 deg
     * we make slight adjustments*/

    //phaseShift = phaseShiftOffset + (Uint16)((Voltage1/3000)*EPWM_2A_DUTY_20KHZ);
    EPwm2Regs.TBPHS.half.TBPHS = phaseShift;

    EDIS;
}

#ifdef VAR_PWM_FREQ_ALLOW
void PWM_updateFrequency(void)
{
    int x = EPWM_1_PRD_MIN;
    int y = EPWM_2_PRD_MIN;

    //EPwm1Regs.TBPRD =   x + (Uint16)((Voltage1/4096)*(EPWM_1_PRD_MAX - EPWM_1_PRD_MIN));
    //EPwm2Regs.TBPRD =   y + (Uint16)((Voltage1/4096)*(EPWM_2_PRD_MAX - EPWM_2_PRD_MIN));
    EPwm1Regs.TBPRD =   x + (Uint16)((2048.0/4096)*(EPWM_1_PRD_MAX - EPWM_1_PRD_MIN));
    EPwm2Regs.TBPRD =   y + (Uint16)((2048.0/4096)*(EPWM_2_PRD_MAX - EPWM_2_PRD_MIN));

    float a = 0.5*EPwm1Regs.TBPRD;
    float b = 0.5*EPwm2Regs.TBPRD;

    EPwm2Regs.CMPA.half.CMPA    = (Uint16) a;
    EPwm2Regs.CMPB = (Uint16) a;
    EPwm1Regs.CMPA.half.CMPA    = (Uint16) b;
    EPwm1Regs.CMPB = (Uint16) b;
}
#endif
