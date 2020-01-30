/*
 * adc.c
 *
 *  Created on: Feb 21, 2019
 *      Author: BEE
 */

#include <adc.h>
#include <main.h>


extern float pwm_pot_adc;
extern float freq_pot_adc;

extern float IP_V_DC;  // connected to ADC INA2
extern float OP_V_DC;  // connected to ADC INA5
extern float OP_I_DC;  // connected to ADC INA6
extern float BAT_I_DC; // connected to ADC INB1

extern Uint16 IP_V_DC_raw;
extern Uint16 OP_V_DC_raw;
extern Uint16 OP_I_DC_raw;
extern Uint16 BAT_I_DC_raw;

Uint16 ReceivedChar;
extern char msg[];

char num[] = {'0','1','2','3','4','5','6','7','8','9'};

float pwm_pot_adc_old = 0;
float freq_pot_adc_old = 0;

float IP_V_DC_old = 0;
float OP_V_DC_old = 0;
float OP_I_DC_old = 0;
float BAT_I_DC_old = 0;

void ADC_setup(void)
{
    EALLOW;

    AdcRegs.ADCCTL2.bit.ADCNONOVERLAP = 1;  // Enable non-overlap mode

    AdcRegs.ADCSOC0CTL.bit.CHSEL  = 0;  // Set SOC0 channel select to ADCINA0
    AdcRegs.ADCSOC0CTL.bit.TRIGSEL = 0; // set the trigger to software trigger

    AdcRegs.ADCSOC1CTL.bit.CHSEL  = 1;  // Set SOC1 channel select to ADCINA1
    AdcRegs.ADCSOC1CTL.bit.TRIGSEL = 0; // set the trigger to software only

    AdcRegs.ADCSOC2CTL.bit.CHSEL  = 2;  // Set SOC1 channel select to ADCINA1
    AdcRegs.ADCSOC2CTL.bit.TRIGSEL = 0; // set the trigger to software only

    AdcRegs.ADCSOC5CTL.bit.CHSEL  = 5;  // Set SOC1 channel select to ADCINA1
    AdcRegs.ADCSOC5CTL.bit.TRIGSEL = 0; // set the trigger to software only

    AdcRegs.ADCSOC6CTL.bit.CHSEL  = 6;  // Set SOC1 channel select to ADCINA1
    AdcRegs.ADCSOC6CTL.bit.TRIGSEL = 0; // set the trigger to software only

    AdcRegs.ADCSOC7CTL.bit.CHSEL  = 9;  // Set SOC7 channel select to ADCINB1
    AdcRegs.ADCSOC7CTL.bit.TRIGSEL = 0; // set the trigger to software only


    /* Set SOC0 and SOC1 acquisition
     * period to 26 ADCCLK*/

    AdcRegs.ADCSOC0CTL.bit.ACQPS  = 25;
    AdcRegs.ADCSOC1CTL.bit.ACQPS  = 25;
    AdcRegs.ADCSOC2CTL.bit.ACQPS  = 25;
    AdcRegs.ADCSOC5CTL.bit.ACQPS  = 25;
    AdcRegs.ADCSOC6CTL.bit.ACQPS  = 25;
    AdcRegs.ADCSOC7CTL.bit.ACQPS  = 25;

    AdcRegs.INTSEL1N2.bit.INT1SEL = 6;  // Connect ADCINT1 to EOC1
    AdcRegs.INTSEL1N2.bit.INT1E   = 1;  // Enable ADCINT1

    EDIS;
}

void ADC_intToString(void)
{
    /* this function converts the
     * integer value of voltages into
     * strings for printing on Serial Monitor*/
//
//    int i = 14;
//    int timerPeriod = EPwm1Regs.TBPRD;
//    int timerPhase  = EPwm2Regs.TBPHS.half.TBPHS;
//
//    for(i=25;i>18;i--)
//    {
//        msg[i] = num[timerPeriod%10];
//        timerPeriod = timerPeriod/10;
//    }
//
//    for(i=50;i>45;i--)
//    {
//        msg[i] = num[timerPhase%10];
//        timerPhase = timerPhase/10;
//    }
}

void ADC_processVal(void)
{
    EALLOW;

    /* ADC conversion is started */
    AdcRegs.ADCSOCFRC1.bit.SOC0 = 1;
    AdcRegs.ADCSOCFRC1.bit.SOC1 = 1;
    AdcRegs.ADCSOCFRC1.bit.SOC2 = 1;
    AdcRegs.ADCSOCFRC1.bit.SOC5 = 1;
    AdcRegs.ADCSOCFRC1.bit.SOC6 = 1;
    AdcRegs.ADCSOCFRC1.bit.SOC7 = 1;

    while(AdcRegs.ADCINTFLG.bit.ADCINT1 == 0); // wait till conversion is complete
    AdcRegs.ADCINTFLGCLR.bit.ADCINT1 = 1;      // clear the flag



    pwm_pot_adc_old = pwm_pot_adc;
    freq_pot_adc_old = freq_pot_adc;

    IP_V_DC_old = IP_V_DC;
    OP_V_DC_old = OP_V_DC;
    OP_I_DC_old = OP_I_DC;
    BAT_I_DC_old = BAT_I_DC;


    /* result is copied to voltage
     * variables from the registers*/
    pwm_pot_adc = AdcResult.ADCRESULT0;
    freq_pot_adc = AdcResult.ADCRESULT1;

    IP_V_DC_raw = AdcResult.ADCRESULT2;
    OP_V_DC_raw = AdcResult.ADCRESULT5;
    OP_I_DC_raw = AdcResult.ADCRESULT6;
    BAT_I_DC_raw = AdcResult.ADCRESULT7;

    EDIS;


    IP_V_DC = IP_V_DC_raw;
    OP_V_DC = OP_V_DC_raw;
    OP_I_DC = OP_I_DC_raw;
    BAT_I_DC = BAT_I_DC_raw;

    ADC_filter();
    //ADC_intToString();
}

void ADC_filter(void)
{
    /* Noise filtering is implemented*/

    pwm_pot_adc = pwm_pot_adc_old + 0.1*(pwm_pot_adc - pwm_pot_adc_old);
    freq_pot_adc = freq_pot_adc_old + 0.1*(freq_pot_adc - freq_pot_adc_old);

    IP_V_DC = IP_V_DC_old + 0.1*(IP_V_DC - IP_V_DC_old);
    OP_V_DC = OP_V_DC_old + 0.1*(OP_V_DC - OP_V_DC_old);

    OP_I_DC = OP_I_DC_old + 0.1*(OP_I_DC - OP_I_DC_old);
    BAT_I_DC = BAT_I_DC_old + 0.1*(BAT_I_DC - BAT_I_DC_old);
}
