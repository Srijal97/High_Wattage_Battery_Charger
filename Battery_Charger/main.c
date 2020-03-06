//###########################################################################
//
// FILE:        main.c
//
// TITLE:       FIRMWARE FOR CONTROL SIGNAL GENERATION
//              FOR DC-DC CHARGER
//
//###########################################################################

//
// Included Files
//
#include <adc.h>
#include <FLASH.h>
#include <globals.h>
#include <gpio.h>
#include <LCD.h>
#include <macros.h>
#include <main.h>               // Project header file
#include <pwm.h>
#include <Serial.h>
#include "Scheduler_timer0_ISR.h"
#include "Scheduler_timer1_ISR.h"
#include "string.h"
#include "commands.h"

//
// Main
//
void main(void)
{
    //
    // Step 1. Initialize System Control:
    // PLL, WatchDog, enable Peripheral Clocks
    // This example function is found in the F2806x_SysCtrl.c file.
    //
    InitSysCtrl();

    //
    // Step 2. Initialize GPIO:
    // This example function is found in the F2806x_Gpio.c file and
    // illustrates how to set the GPIO to it's default state.
    //
    // InitGpio();  // Skipped for this example

    //
    // Step 3. Clear all interrupts and initialize PIE vector table:
    // Disable CPU interrupts
    //
    DINT;

    //
    // Initialize the PIE control registers to their default state.
    // The default state is all PIE interrupts disabled and flags
    // are cleared.
    // This function is found in the F2806x_PieCtrl.c file.
    //
    InitPieCtrl();

    //
    // Disable CPU interrupts and clear all CPU interrupt flags:
    //
    IER = 0x0000;
    IFR = 0x0000;

    //
    // Initialize the PIE vector table with pointers to the shell Interrupt
    // Service Routines (ISR).
    // This will populate the entire table, even if the interrupt
    // is not used in this example.  This is useful for debug purposes.
    // The shell ISR routines are found in F2806x_DefaultIsr.c.
    // This function is found in F2806x_PieVect.c.
    //
    InitPieVectTable();

    /*
     * This functions configures the flash memory for use
     */
    FLASH_CONFIG();


    //
    // Interrupts that are used in this example are re-mapped to
    // ISR functions found within this file.
    //


    EALLOW;  // This is needed to write to EALLOW protected registers
    PieVectTable.SCIRXINTA = &sciaRxFifoIsr;
    EDIS;   // This is needed to disable write to EALLOW protected registers

    GPIO_setup_init();

    InitSciaGpio();
    InitAdc();
    AdcOffsetSelfCal();

    scia_fifo_init();      // Initialize the SCI FIFO
    SerialInit();// Initialize the SCI FIFO
    //scia_echoback_init();  // Initalize SCI for echoback


    PieCtrlRegs.PIECTRL.bit.ENPIE = 1;   // Enable the PIE block
    PieCtrlRegs.PIEIER9.bit.INTx1=1;     // PIE Group 9, INT1

    //.PieCtrlRegs.PIEIER9.bit.INTx2=1;     // PIE Group 9, INT2
    IER |= 0x100;                         // Enable CPU INT
    EINT;


    ADC_setup();

    PWM_force_low_EPWM1();
    PWM_force_low_EPWM2();

    PWM_setup_init();

    InitCpuTimers();
    Scheduler_timer0_ISR_Init();
    Scheduler_timer1_ISR_Init();


    IER |= M_INT1;                     // Enable CPU Interrupt 1
    IER |= M_INT13;
    EINT;                              // Enable Global interrupt INTM
    ERTM;                              // Enable Global realtime interrupt DBGM


    //
    // Reset the watchdog counter
    //
    ServiceDog();

    //
    // Enable the watchdog
    //
    EALLOW;
    SysCtrlRegs.WDCR = 0x0028;
    EDIS;


    while(1)
    {
        /*processor goes to sleep while
         * all the peripherals are running*/
        //sleep_mode();

        static Uint32 txValuesTime = 0;
        //static int i = 0;
        if (delay_count_timer0 - txValuesTime > 5000) {

            txInputVoltage();
            txOutputVoltage();
            txOutputCurrent();
            txBatteryCurrent();
            //i++;
            //if(i%80 == 0)
            txFaultState();

            txValuesTime = delay_count_timer0;
        }

    }
}

//
// End of File
//
