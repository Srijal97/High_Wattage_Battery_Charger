/*
 * LCD.h
 *
 *  Created on: 08-Apr-2019
 *      Author: Ameya
 */

#ifndef LCD_H_
#define LCD_H_

#include "main.h"

#define LCD_D4  0x00080000
#define LCD_D5  0x00100000
#define LCD_D6  0x00200000
#define LCD_D7  0x00400000

#define LCD_DATABUS LCD_D4|LCD_D5|LCD_D6|LCD_D7

#define LCD_RS  0x00008000
#define LCD_E   0x00010000
#define LCD_BT  0x00004000
#define LCD_LED 0x00000080 // GPIO39 on portB


void delay_ms(Uint16 j);
void LCD_INIT(void);
void LCD_CMD(char command);
void LCD_CHAR (char msg);
void LCD_STRING (char* msg);

#endif /* LCD_H_ */
