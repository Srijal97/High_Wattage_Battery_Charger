/*
ATmega16_EEPROM.c
http://www.electronicwings.com
*/ 

#define F_CPU 8000000UL						/* Define frequency here its 8MHz */
#include <avr/io.h>							/* Include avr std header file */
#include <util/delay.h>						/* Include delay header file */
#include <avr/eeprom.h>						/* Include AVR EEPROM header file */
#include <string.h>							/* Include string header file */
#include "LCD_16x2_H_file.h"				/* Include LCD header file */

int main()
{
	char R_array[15],W_array[15] = "EEPROM TEST";
	LCD_Init();
	memset(R_array,0,15);
	eeprom_busy_wait();						/* Initialize LCD */
	eeprom_write_block(W_array,0,strlen(W_array));/* Write Write_array from EEPROM address 0 */
	eeprom_read_block(R_array,0,strlen(W_array));/* Read EEPROM from address 0 */
	LCD_String(R_array);					/* Print Read_array on LCD */
	return(0);
}