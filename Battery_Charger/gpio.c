/*
 * gpio.c
 *
 *  Created on: Feb 21, 2019
 *      Author: BEE
 */

#include <gpio.h>
#include <LCD.h>
#include <main.h>

void GPIO_setup_init(void)
{
	GPIO_enable_PWM();
	GPIO_setupLedPins();
	GPIO_setupLCDPins();


	// config reset switch on GPIO 34
	EALLOW;
	GpioCtrlRegs.GPBPUD.bit.GPIO34 = 0;   // enable pullup
	GpioCtrlRegs.GPBMUX1.bit.GPIO34 = 0;  // general purpose I/O
	GpioCtrlRegs.GPBDIR.bit.GPIO34 = 0;  // direction input

    EDIS;

}

void GPIO_setupLedPins(void)
{
	EALLOW;
	GpioCtrlRegs.GPAPUD.bit.GPIO13 = 0;
	GpioCtrlRegs.GPAMUX1.bit.GPIO13 = 0;
	GpioCtrlRegs.GPADIR.bit.GPIO13 = 1;
	EDIS;
}

void GPIO_enable_PWM(void)
{
	EALLOW;

    GpioCtrlRegs.GPAPUD.all     &= 0xFFFFFFF0; // enable pullup
    GpioCtrlRegs.GPADIR.all     |= 0x0000000F;
    GpioCtrlRegs.GPAMUX1.all    |= 0x00000055; // set as PWM


	EDIS;
}


void GPIO_disable_PWM(void) {
    EALLOW;

    GpioCtrlRegs.GPAPUD.all     &= 0xFFFFFFF0; // enable pullup
    GpioCtrlRegs.GPADIR.all     |= 0x0000000F;
    GpioCtrlRegs.GPAMUX1.all    &= 0xFFFFFF00; // set as GPIO
    GpioDataRegs.GPACLEAR.all   =  0x0000000F;

    EDIS;

}

void GPIO_setupLCDPins(void)
{
    EALLOW;
    GpioCtrlRegs.GPBPUD.all     =   (GpioCtrlRegs.GPAPUD.all | LCD_LED);
    GpioCtrlRegs.GPBDIR.all     =   (GpioCtrlRegs.GPADIR.all | LCD_LED);
    GpioCtrlRegs.GPBMUX1.all    =   (GpioCtrlRegs.GPBMUX1.all & (~LCD_LED));

    GpioCtrlRegs.GPAPUD.all     =   (GpioCtrlRegs.GPAPUD.all) & (~LCD_DATABUS);
    GpioCtrlRegs.GPADIR.all     =   (GpioCtrlRegs.GPADIR.all) | (LCD_DATABUS);
    GpioCtrlRegs.GPAMUX1.all    =   (GpioCtrlRegs.GPAMUX1.all)& (~LCD_DATABUS);
    EDIS;
}
