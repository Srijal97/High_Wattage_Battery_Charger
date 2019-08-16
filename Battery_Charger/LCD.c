/*
 * LCD.c
 *
 *  Created on: 08-Apr-2019
 *      Author: Ameya
 */

#include <LCD.h>
#include <main.h>

void delay_ms(Uint16 j) /* Function for delay in milliseconds */
{
    Uint16 x,i;
    for(i=0;i<j;i++)
    {
    for(x=0; x<6000; x++);    /* loop to generate 1 millisecond delay with Cclk = 60MHz */
    }
}

void LCD_INIT(void)
{
    GpioDataRegs.GPASET.all = LCD_BT;
    delay_ms(20);
    LCD_CMD(0x02);  /* Initialize lcd in 4-bit mode */
    delay_ms(20);
    LCD_CMD(0x28);  /* 2 lines */
    delay_ms(20);
    LCD_CMD(0x0C);   /* Display on cursor off */
    delay_ms(20);
    LCD_CMD(0x06);  /* Auto increment cursor */
    delay_ms(20);
    LCD_CMD(0x01);   /* Display clear */
    delay_ms(20);
    LCD_CMD(0x80);  /* First line first position */
}

void LCD_CMD(char cmd)
{
    Uint32 command = (Uint32)cmd;
    GpioDataRegs.GPADAT.all = ( (GpioDataRegs.GPADAT.all & (~LCD_DATABUS)) | ((command & 0x00F0)<<14) ); /* Upper nibble of command */
    GpioDataRegs.GPASET.all = LCD_E; /* EN = 1 */
    GpioDataRegs.GPACLEAR.all = LCD_RS; /* RS = 0, RW = 0 */
    delay_ms(5);
    GpioDataRegs.GPACLEAR.all = LCD_E; /* EN = 0, RS and RW unchanged(i.e. RS = RW = 0)    */
    delay_ms(5);
    GpioDataRegs.GPADAT.all = ( (GpioDataRegs.GPADAT.all & (~LCD_DATABUS)) | ((command & 0x000F)<<18) ); /* Lower nibble of command */
    GpioDataRegs.GPASET.all = LCD_E; /* EN = 1 */
    GpioDataRegs.GPACLEAR.all = LCD_RS; /* RS = 0, RW = 0 */
    delay_ms(5);
    GpioDataRegs.GPACLEAR.all = LCD_E; /* EN = 0, RS and RW unchanged(i.e. RS = RW = 0)    */
    delay_ms(5);
}

void LCD_CHAR (char message)
{
    Uint32 msg = (Uint32)message;
    GpioDataRegs.GPADAT.all = ( (GpioDataRegs.GPADAT.all & (~LCD_DATABUS)) | ((msg & 0x00F0)<<14) ); /* Upper nibble of command */
    GpioDataRegs.GPASET.all = (LCD_E | LCD_RS); /* RS = 1, EN = 1 */
    delay_ms(2);
    GpioDataRegs.GPACLEAR.all = LCD_E; /* EN = 0, RS and RW unchanged(i.e. RS = 1, RW = 0) */
    delay_ms(5);
    GpioDataRegs.GPADAT.all = ( (GpioDataRegs.GPADAT.all & (~LCD_DATABUS)) | ((msg & 0x000F)<<18) ); /* Upper nibble of command */
    GpioDataRegs.GPASET.all = (LCD_E | LCD_RS); /* RS = 1, EN = 1 */
    delay_ms(2);
    GpioDataRegs.GPACLEAR.all = LCD_E; /* EN = 0, RS and RW unchanged(i.e. RS = 1, RW = 0) */
    delay_ms(5);
}

void LCD_STRING (char* msg)
{
    Uint8 i=0;
    while(msg[i]!='\0')
    {
        LCD_CHAR(msg[i]);
        delay_ms(20);
        i++;
    }
}
