/*
PORTE.5 == KEYPAD 2
PORTE.7 == KEYPAD 1
PORTD.2 == KEYPAD 4
PORTB.3 == KEYPAD 3
*/



#include <mega128.h>
#include <stdint.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <Math.h>
//#include <twix.h>
#include <String.h>
#include <io.h>
#include "commands.c"
//#include "24c_eeprom.c"
//#include "i2cmaster.c"


// I2C Bus functions
#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#include "EEPROM.C"

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif


// Standard Input/Output functions
#include <stdio.h>

#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)


//int data_received = 0;

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 32
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0,rx_rd_index0=0;
#else
unsigned int rx_wr_index0=0,rx_rd_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif



// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;



// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data; 
     if(data == '<') {
        comStart = 1;
        i = 0;
       
    }
    else if(data == '>') {   
            *(rdataA+i) = data;  
            comStart = 0;
            i = 0;
            comDecode(rdataA);
    }
    if (comStart == 1) {
            *(rdataA+i) = data;  // Read data
            i++;
            if(i==9){i=0;}
    }
     

//#if RX_BUFFER_SIZE0 == 256
//   // special case for receiver buffer size=256
//   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
//#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
//#endif
   }//data_received = 1; 
}

#ifndef _DEBUG_TERMINAL_IO_



// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 64
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0=0,tx_rd_index0=0;
#else
unsigned int tx_wr_index0=0,tx_rd_index0=0;
#endif

#if TX_BUFFER_SIZE0 < 256
unsigned char tx_counter0=0;
#else
unsigned int tx_counter0=0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}



#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif

int on_pressed = 0;
int off_pressed = 0;
int reset_pressed = 0;
short int on_button_state = 0x0000;
short int off_button_state = 0x0000;
short int reset_button_state = 0x0000;

// Timer3 overflow interrupt service routine
interrupt[TIM3_OVF] void timer3_ovf_isr(void) {

    // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF   
        
    // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-software-debouncers
    // 16 bit shifts = approx 130msec debounce delay    
on_button_state = (0x8000 | !PINE.4) | (on_button_state << 1);  
    if(on_button_state == 0xC000) {     
       on_pressed = 1; 
       
    }    
    
    off_button_state = (0x8000 | !PINE.6) | (off_button_state << 1);       
    if(off_button_state == 0xC000 ) {         
        off_pressed = 1;
    } 
    
    reset_button_state = (0x8000 | !PIND.4) | (reset_button_state << 1);       
    if(reset_button_state == 0xC000 ) {         
        reset_pressed = 1; 
    } 
    
}    


// SPI functions
#include <spi.h>
//---------------THERMOCOUPLE------------
#include "Thermocouple.c"
//---------------Variables---------------
#include <variables.h>
//-------------Display Functions---------
#include "Display_functions.c"
//----Input and val change functions-----
#include "Change.c"
#include "Inputs.c"



 
void Screen1()
{
    //Screen = 1;
    Pointer_horiz = 0;
    Pointer_vert = 0;
    lcd_clear();
    lcd_gotoxy(0,1);
    lcd_puts("  HIGH WATTAGE  ");
    lcd_gotoxy(0,2);
    lcd_puts(" BATTERY CHARGER");
    delay_ms(1000);              
    
    
    // default current and voltage value sent to DSP at start
    set_voltage = 110;
    xmitString("<014-0110");
    
    set_current = 10;    
    xmitString("<015-0010");
    
    Screen = 2;    
    Current_Screen = 1; 
    main_screen_trigger = 1;
    current_mainscreen_flag = 1; 
    lcd_clear();
}

void Screen2()
{
    lcd_clear();
    //Screen = 2;
    Pointer_vert = 0;
    Pointer_horiz= 0;

        lcd_gotoxy(1,0);
        lcd_putsf("Set Parameters");
        lcd_gotoxy(1,1);
        lcd_putsf("Set Time/Date");
        lcd_gotoxy(1,2);
        lcd_putsf("Display Time");
        
          
        n = 3;
        Current_Screen = 2;
}



void Screen30()
{
    lcd_clear();
    lcd_gotoxy(3,3);
    lcd_putsf("PARAMETERS");   
    lcd_gotoxy(1,0);
    lcd_putsf("Voltage (VOLTS)");
    lcd_gotoxy(1,1);
    lcd_putsf("Current (AMPS)");
    n = 2;
    Current_Screen = 30;     
}

void Screen300()      //SET VOLTAGE
{
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Set voltage:");
    show_volt();
    while(flag != 11)
    {
        input_volt(3);
    } 
    flag = 0;
    Current_Screen = 300;
}

void Screen301()     //SET CURRENT
{

    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Set current:");
    show_current();  
    while(flag != 11)
    {
        input_current(2);
    }                   
    flag = 0;
    Current_Screen = 301;
}

void Screen31()  //Set Time and Date 
{
    lcd_clear();
    Pointer_vert = 0;
    Pointer_horiz= 0;
    
    lcd_gotoxy(1,0);
    lcd_putsf("Set Time");
    lcd_gotoxy(1,1);
    lcd_putsf("Set Date");
    lcd_gotoxy(2,3);
    lcd_putsf("TIME AND DATE");
    
    n = 2;
    Current_Screen = 31;
}

void Screen310()
{
    lcd_clear();
    temp_hour = 0;
    temp_minute = 0;
    temp_second = 0;
    Pointer_horiz = 1;
    lcd_gotoxy(6,0);
    lcd_putsf("TIME");
    show_time();
    while(flag != 1)
    {
        input_time();
    }        
    flag = 0;
    Current_Screen = 310;
}

void Screen311()
{
    lcd_clear();
    temp_date = 0;
    temp_month = 0;
    temp_year = 20;
    Pointer_horiz = 1;
    lcd_gotoxy(6,0);
    lcd_putsf("DATE");
    show_date();
    while(flag != 1)
    {
        input_date();
    } 
    flag = 0;
    Current_Screen = 311;
}

void Screen32()
{
    lcd_clear();
    Pointer_vert = 0;
    Pointer_horiz= 0;
    
    while(PIND.2 != 0)
    {
    rtc_get_time(&hour,&minute,&second);
    lcd_gotoxy(0,0);
    lcd_puts("Time:");
    sprintf(disp_time,"%02d:%02d:%02d",hour,minute,second);
    lcd_gotoxy(6,0);
    lcd_puts(disp_time);

    rtc_get_date(&date,&month,&year);
    lcd_gotoxy(0,2);
    lcd_puts("Date:");
    sprintf(disp_date,"%02d/%02d/%02d",date,month,year);
    lcd_gotoxy(6,2);
    lcd_puts(disp_date);    
    }
    
    Current_Screen = 32;
    Screen = 2;
}

void Main_Screen()
{
    lcd_clear(); 

    lcd_gotoxy(0,0);
    lcd_putsf("SV:");
    
    lcd_gotoxy(8,0);
    lcd_putsf("SBC:");

    lcd_gotoxy(0,1);
    lcd_putsf("AV:");

    lcd_gotoxy(8,1);
    lcd_putsf("ABC:");
       
    lcd_gotoxy(0,2);
    lcd_putsf("AIV:");
      
    lcd_gotoxy(8,2);
    lcd_putsf("AOC:");
     
    lcd_gotoxy(3,0);
    sprintf(disp_set_voltage,"%03d",set_voltage);    
    lcd_puts(disp_set_voltage); 
       
    lcd_gotoxy(12,0);
    sprintf(disp_set_btcurrent,"%03d",set_current);                           //12220
    // sprintf(disp_set_btcurrent,"%03d",set_current);
    lcd_puts(disp_set_btcurrent);
     
   // current_mainscreen_flag = 0;
    
    
   
 
}

void Screen_sel()
{
  
    if (Screen == 1)
    {
        Screen1();
    }
    if (Screen == 2)
    {
        Screen2();
    }
    if (Screen == 30)
    {
        Screen30();
    }
    if (Screen == 300)
    {
        Screen300();
    }
    if (Screen == 301)
    {
        Screen301();
    }  
    if (Screen == 31)
    {
        Screen31();
    }
    if (Screen == 310)
    {
        Screen310();
    }               
    if (Screen == 311)
    {
        Screen311();
    }
    if (Screen == 32)
    {
        Screen32();
    }
}

void machine_state()
{
     if(fault_flag == 1)
     {
        mainOff();
        on_pressed = 0;
     }  
     else
     {   
        PORTF |= 0x40;
             
        if(on_pressed == 1)
        {
            mainOn();
            on_pressed = 0;
            //status = 1;
        }       
        else if(off_pressed == 1)
        {
            mainOff();
            off_pressed = 0;
            //status = 0;
        }
     }
    
//    if(data_received == 1)
//    {
//        recOp(); 
//        data_received = 0;
//        ms_update_flag = 1;
//        //current_mainscreen_flag = 0;
//    }
    if(reset_pressed == 1)
    {   
        resetFault();
        reset_pressed = 0;
    }   
    
    
}

void main(void)
{
PORTA=0x00;
DDRA=0x00;

PORTB=0x08;
DDRB=0x00;

PORTC=0x08;
DDRC=0x08;

PORTD=0xDC;    
DDRD=0x08;

PORTE=0xFF;
DDRE=0x00;

PORTF=0xFF;
DDRF=0xFF;

PORTG=0x00;
DDRG=0x00;

TCCR3A=0x00;
TCCR3B=0x09;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0xFF;
OCR3AL=0xFF;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
//EICRA=0x00;
//EICRB=0xAA;
//EIMSK=0xF0;
//EIFR=0xF0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x04;


// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x33;

// I2C Bus initialization
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

lcd_init(16);

// Global enable interrupts
#asm("sei")
 


//address = 0x0000;
//dataByte = 20;              
//
//while(1){
//if(PINE.5 == 0){
//while (PINE.5 == 0)
//writeByte(address,dataByte);
//lcd_clear();
//sprintf(disp_eeprom_write,"Data %d is written to address %04d",dataByte,address);
//lcd_gotoxy(0,0);
//lcd_puts(disp_eeprom_write);
//dataByte++;
//}
//
//if(PINE.7 == 0){
//while (PINE.7 == 0)
//read_data = readByte(address);
//lcd_clear();
//lcd_gotoxy(0,0);
//lcd_puts("read data is:");
//lcd_gotoxy(0,1);
//sprintf(disp_eeprom_read,"%d",read_data);
//lcd_puts(disp_eeprom_read);
//}
//
//
//if(PINB.3 == 0){
//while(PINB.3 == 0)
//writePage(address,data_ptr,8);
//lcd_clear();
//lcd_gotoxy(0,0);
//lcd_puts(dataArr);
//
//
//}    
//
//if(PIND.2 == 0){
//while(PIND.2 == 0)
//
//readData(address,rddata_ptr,8);
////read_data = readByte(0x0002);
//lcd_clear();
//lcd_gotoxy(0,0);
////sprintf(disp_eeprom_read,"%d",read_data);
////lcd_puts(disp_eeprom_read);
//lcd_puts(rddataArr);
//}    
//
//}





    while(1)
        {   
            if(fault_flag == 1)
            {     
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("Fault ID:");
                lcd_gotoxy(4,2);
                
                
                lcd_puts(fltArray);
                 
                while(fault_flag == 1)
                machine_state();
            } 
            
            if (Screen == 1)        //runs only at start
            {Screen1();}
            
            while(rtc_display_counter != 300){
                
                rtc_get_time(&hour,&minute,&second);
                lcd_gotoxy(0,0);
                lcd_puts("Time:");
                sprintf(disp_time,"%02d:%02d:%02d",hour,minute,second);
                lcd_gotoxy(6,0);
                lcd_puts(disp_time);

                rtc_get_date(&date,&month,&year);
                lcd_gotoxy(0,2);
                lcd_puts("Date:");
                sprintf(disp_date,"%02d/%02d/%02d",date,month,year);
                lcd_gotoxy(6,2);
                lcd_puts(disp_date);

                rtc_display_counter++;
            }
            
            
            
            if (main_screen_trigger == 1) //| ms_update_flag == 1)
            {   
                if(current_mainscreen_flag == 1)
                {Main_Screen();}      //Function to display all values
                
                lcd_gotoxy(3,1);
                sprintf(disp_actual_voltage,"%03d",actual_voltage);
                lcd_puts("000"); 
                lcd_gotoxy(3,1);
                lcd_puts(disp_actual_voltage); 
                        
                lcd_gotoxy(12,1);
                sprintf(disp_actual_btcurrent,"%02d.%01d",actual_btcurrentip,actual_btcurrentdp);
                lcd_puts("000"); 
                lcd_gotoxy(12,1);
                lcd_puts(disp_actual_btcurrent);    
                  
                lcd_gotoxy(4,2);
                sprintf(disp_actual_ipvoltage,"%03d",actual_ipvoltage);
                lcd_puts("000"); 
                lcd_gotoxy(4,2);
                lcd_puts(disp_actual_ipvoltage); 
                         
                lcd_gotoxy(12,2);
                sprintf(disp_actual_opcurrent,"%02d.%01d",actual_opcurrentip,actual_opcurrentdp);
                lcd_puts("000"); 
                lcd_gotoxy(12,2);
                lcd_puts(disp_actual_opcurrent);
                if (status == 1)
                {   
                lcd_gotoxy(1,3);
                lcd_putsf("Machine : ON ");
                }                
                else if (status == 0)
                {
                    lcd_gotoxy(1,3);
                    lcd_putsf("Machine : OFF"); 
                }
                ms_update_flag = 0;
                //main_screen_trigger = 0;
                current_mainscreen_flag = 0;
            } 
             
            machine_state();    //Check for ON,OFF,reset  button press 
            
            if (PIND.2 == 0)    //When 4 pressed
            {   
                main_screen_trigger = 0; 
                while(set_flag != 1)
                {
                while(Screen != Current_Screen)
                {
                    Screen_sel();       //Screen selection
                }
                input(n);
                machine_state();
                }
                set_flag = 0; 
                Screen = 2;
                lcd_clear();
            }   
                                                                                                  
             
        } 

}    