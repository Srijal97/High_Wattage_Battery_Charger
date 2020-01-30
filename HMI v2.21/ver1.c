
#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <Math.h>
#include "commands.c"
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

// External Interrupt 4 service routine
interrupt [EXT_INT4] void ext_int4_isr(void)
{


}

// External Interrupt 5 service routine
interrupt [EXT_INT5] void ext_int5_isr(void)
{
// Place your code here

}

// External Interrupt 6 service routine
interrupt [EXT_INT6] void ext_int6_isr(void)                                                                                        
{
// Place your code here

}

// External Interrupt 7 service routine
interrupt [EXT_INT7] void ext_int7_isr(void)
{
// Place your code here

}

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



// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 64
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


int on_pressed = 0;
int off_pressed = 0;

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
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
   }//recOp();
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



short int on_button_state = 0x0000;
short int off_button_state = 0x0000;


// Timer3 overflow interrupt service routine
interrupt[TIM3_OVF] void timer3_ovf_isr(void) {

    // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF   
        
    // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-software-debouncers
    // 16 bit shifts = approx 130msec debounce delay    
on_button_state = (0x8000 | !PINE.4) | (on_button_state << 1);  
    if(on_button_state == 0xC000) {     
       PORTC.3 = 0;
       on_pressed = 1;
       
    }    
    
    off_button_state = (0x8000 | !PINE.5) | (off_button_state << 1);       
    if(off_button_state == 0xC000 ) {         
        PORTC.3 = 1;
       off_pressed = 1;
    } 
    
    
}    


#define ADC_VREF_TYPE 0x00
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
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
    Screen = 1;
    Pointer_horiz = 0;
    Pointer_vert = 0;
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Welcome to HMI");

    delay_ms(1000);  
  
    Screen = 2;
}

void Screen2()
{
    lcd_clear();
    
    Screen = 2;
    Pointer_vert = 0;
    Pointer_horiz= 0;
    while(Screen == 2)
    {
    
       
        lcd_gotoxy(1,0);
        lcd_putsf("Set Parameters");  
        lcd_gotoxy(1,1) ;
        lcd_putsf("Sensor Values");
        
        input(2);
    }

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
    
    while(Screen == 30)
    {
        input(2);  
        
    if (PINE.1 == 0)                                            //ESCAPE Pressed 4
       {
        while(PINE.1 == 0);                               
        Screen = 2;
       }
    } 
   
     
}

void Screen300()      //SET VOLTAGE
{
    while(Screen == 300)
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
    }
}
void Screen301()     //SET CURRENT
{
    while (Screen == 301)
    {
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Set current:");
    show_current();  
    while(flag != 11)
    {
        input_current(3);
    }                   
    flag = 0;
    }
}


void Screen31()
{
    lcd_clear();
    Pointer_vert = 0;
    lcd_gotoxy(4,3);
    lcd_putsf("SENSORS");   
    lcd_gotoxy(1,0);
    lcd_putsf("Analog");
    lcd_gotoxy(1,1);
    lcd_putsf("Digital");
    lcd_gotoxy(1,2);
    lcd_putsf("Thermocouple");
    
    while(Screen == 31)
    {
        input(3);
    }
}

void Screen310()  // Analog Values
{
    lcd_gotoxy(0,0);
    lcd_putsf("No functions          added yet");   
    delay_ms(1000);
    Screen = 31;
}

void Screen311()        // Digital Values
{
    int x = 0;           
    char disp_ch[3];
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Ch0:");   
    lcd_gotoxy(0,1);
    lcd_putsf("Ch1:");   
    lcd_gotoxy(0,2);
    lcd_putsf("Ch2:");   
    lcd_gotoxy(0,3);
    lcd_putsf("Ch3:");   
    lcd_gotoxy(9,0);
    lcd_putsf("Ch4:");   
    lcd_gotoxy(9,1);
    lcd_putsf("Ch5:");   
    lcd_gotoxy(9,2);
    lcd_putsf("Ch6:");   
    lcd_gotoxy(9,3);
    lcd_putsf("Ch7:");   
    
    while (PINE.1 != 0)
    {
        x = read_adc(0x00)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(4,0);
        lcd_puts(disp_ch);
        x = read_adc(0x01)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(4,1);
        lcd_puts(disp_ch);
        x = read_adc(0x02)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(4,2);
        lcd_puts(disp_ch);
        x = read_adc(0x03)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(4,3);
        lcd_puts(disp_ch);
        x = read_adc(0x04)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(13,0);
        lcd_puts(disp_ch);
        x = read_adc(0x05)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(13,1);
        lcd_puts(disp_ch);
        x = read_adc(0x06)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(13,2);
        lcd_puts(disp_ch);
        x = read_adc(0x07)/4;
        sprintf(disp_ch,"%03d",x);
        lcd_gotoxy(13,3);
        lcd_puts(disp_ch);
        delay_ms(1000);        
    }                  
    Screen = 31;
}


void Screen_sel()
{
    switch(Screen)
    {
        case 1:
            Screen1();
        break;
        case 2:
            Screen2();
        break;  
        
        case 30:                           //Ports
            Screen30();
        break; 
        
        case 300:  
            Screen300();                   //Set Voltage
        break;   
        case 301:
            Screen301();
        break;
        
        case 31:                           
            Screen31();
        break;
        case 310:                           //Analog
            Screen310();
        break;
        case 311:                           //Digital
            Screen311();
        break;                                       
        
        default:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Error.");
            lcd_gotoxy(0,1);
            lcd_puts("Restarting in 5 seconds."); 
            delay_ms(2000);
            Screen = 1;
        break;
    }
}

void main(void)
{


PORTA=0x00;
DDRA=0x00;


PORTB=0x00;
DDRB=0x07;


PORTC=0x08;
DDRC=0x08;


PORTD=0xC0;
DDRD=0x00;



PORTE=0xFF;
DDRE=0x00;



PORTF=0x00;
DDRF=0x00;


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
EICRA=0x00;
EICRB=0xAA;
EIMSK=0xF0;
EIFR=0xF0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x04;

// USART0 initialization
/*
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x67;
*/
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

// USART1 initialization
UCSR1A=0x00;
UCSR1B=0x18;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x67;

// Analog Comparator initialization
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
SPCR=0x50;
SPSR=0x00;

// TWI initializatioN
TWCR=0x00;

// I2C Bus initialization
i2c_init();

// DS1307 Real Time Clock initialization
rtc_init(0,0,0);


lcd_init(16);

// Global enable interrupts
#asm("sei")

                                                    
while(1)
{
       if(on_pressed == 1)
        {
            mainOn();
            on_pressed = 0;
        }
        else if(off_pressed == 1)
        {
            mainOff();
            off_pressed = 0;
                
        }
    //Screen_sel();
    
} 

}