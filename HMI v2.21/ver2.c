/*****************************************************
Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <Math.h>

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
// Place your code here

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

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// Get a character from the USART1 Receiver
#pragma used+
char getchar1(void)
{
char status,data;
while (1)
      {
      while (((status=UCSR1A) & RX_COMPLETE)==0);
      data=UDR1;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      }
}
#pragma used-

// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-

// Standard Input/Output functions
#include <stdio.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here

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



/*
void PASSWORD_CHK()
{
    lcd_gotoxy(0,0);
    lcd_puts("ENTER PASSWORD:");
    lcd_gotoxy(0,1);
    lcd_puts("0000");   
    while ((temp_pass != password) && (flag == 0))
    {
        input_pass(4);
    }                
}
 */   
 
 
void Screen1()
{
    Screen = 1;
    Pointer_horiz = 0;
    Pointer_vert = 0;
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Welcome to HMI");
    /*lcd_gotoxy(0,1);
    lcd_puts("Welcome to HMI");
    lcd_gotoxy(0,2);
    lcd_puts("Welcome to HMI");
    lcd_gotoxy(0,3);
    lcd_puts("Welcome to HMI");  */
    delay_ms(1000);  
  
 /*  lcd_clear(); 
   PASSWORD_CHK();                  
    
    lcd_clear();                     
    lcd_gotoxy(0,0);
    lcd_puts("PASSWORD CORRECT");   
    delay_ms(3000);
 */   
    Screen = 2;
}

void Screen2()
{
    //int flag1 = 0;
    lcd_clear();
    Screen = 2;
    Pointer_vert = 0;
    Pointer_horiz= 0;
    lcd_gotoxy(1,0);
    lcd_putsf("Password Rst");   
    lcd_gotoxy(1,1);
    lcd_putsf("Timer");
    lcd_gotoxy(1,2);
    lcd_putsf("Sensor Values");
    lcd_gotoxy(1,3);
    lcd_putsf("Set Parameters");
    while(Screen == 2)
    {
        input(4);
    }
    //return(Screen); 
    //delay_ms(3000);
}

/*
void Screen30()
{
    lcd_clear();
    Pointer_vert = 0;
    lcd_gotoxy(3,3);
    lcd_putsf("MOTOR MODE");   
    lcd_gotoxy(1,0);
    lcd_putsf("BLDC");
    lcd_gotoxy(1,1);
    lcd_putsf("PMSM");
    lcd_gotoxy(1,2);
    lcd_putsf("IM");   
    while(Screen == 30)
    {
        input(3);
    }
}
*/

void Screen31()
{
    //TIMER  
    lcd_clear();
    Pointer_vert = 0;
    lcd_gotoxy(6,3);
    lcd_putsf("TIME");   
    /*
       rtc_get_time(&hr1,&min1,&sec1);
       rtc_get_date(&dd1,&mm1,&yy1);
              
       lcd_gotoxy(0,0);
       
       sprintf(disptime1,"TIME:%02d:%02d:%02d",hr1,min1,sec1);
       lcd_puts(disptime1);
       
       lcd_gotoxy(0,1);
       sprintf(dispdate1,"DATE:%02d/%02d/%04d",dd1,mm1,2000+yy1); 
       lcd_puts(dispdate1);
    */
    lcd_gotoxy(1,0);
    lcd_putsf("Set Date / Time");
    lcd_gotoxy(1,1);
    lcd_putsf("Alarm Mode");
    lcd_gotoxy(1,2);
    lcd_putsf("Countdown Timer");
    while(Screen == 31)
    {
        input(3);
    }
}

void Screen310()
{
    //Set Date and time.                
    lcd_clear();
    rtc_get_time(&hr1,&min1,&sec1);
    rtc_get_date(&dd1,&mm1,&yy1);
    
    lcd_gotoxy(0,0);
    lcd_putsf("Date: ");
    lcd_gotoxy(0,2);
    lcd_putsf("Time: ");
    while(Screen == 310)
    {input_RTC();}
}

void Screen311()
{
    //Alarm Mode
    lcd_clear();
    rtc_get_time(&hr2,&min2,&sec2);
    rtc_get_date(&dd2,&mm2,&yy2);
    lcd_gotoxy(0,0);
    lcd_putsf("New T:");
    lcd_gotoxy(0,2);
    lcd_putsf("New D:");
    while(Screen == 311)
    {input_RTC();
     
    } 
    
}
  
void Screen312()
{
    //Countdown timer. using input time.    
    lcd_clear();              
    lcd_gotoxy(0,0);
    lcd_putsf("countdowntimer");
    delay_ms(1000);       
    if(PINE.1 == 0)                  //ESCAPE -- 4
    {
        while(PINE.1 == 0)
        {
            Screen = 31;
        }
    } 
    
}


void Screen32()
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
    
    while(Screen == 32)
    {
        input(3);
    }
}

void Screen320()  // Analog Values
{
    lcd_gotoxy(0,0);
    lcd_putsf("No functions          added yet");   
    delay_ms(1000);
    Screen = 32;
}

void Screen321()        // Digital Values
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
    Screen = 32;
}

void Screen322()                            //Thermocouple Reading function
{
    char ThermVal[16];
    int x = ThermoReadC();
    while(Screen == 322)
    {
        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(ThermVal,"Temp:%04d",x);
        lcd_puts(ThermVal);
       // delay_ms(1500);  
       if (PINE.1 == 0)                                            //ESCAPE Pressed 4
       {
        while(PINE.1 == 0);                               
        Screen = 32;
        //flag = 1;
       }
    }
    
    
            
}

void Screen33()
{
    lcd_clear();
    Pointer_vert = 0;
    lcd_gotoxy(3,3);
    lcd_putsf("PARAMETERS");   
    lcd_gotoxy(1,0);
    lcd_putsf("Voltage (VOLTS)");
    lcd_gotoxy(1,1);
    lcd_putsf("Current (AMPS)");
    
    while(Screen == 33)
    {
        input(2);  
        
    if (PINE.1 == 0)                                            //ESCAPE Pressed 4
       {
        while(PINE.1 == 0);                               
        Screen = 2;
       }
    } 
   // Screen = 33;
     
}

void Screen330()      //SET VOLTAGE
{
    while(Screen == 330)
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
void Screen331()     //SET CURRENT
{
    while (Screen == 331)
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
        //case 30:
            //Screen30();
       
      
        
        case 31:                            //Timer
            Screen31();
        break;
        case 310:                           //Set date time. 
            Screen310();
        break;
        case 311:                           //Alarm Mode
            Screen311();
        break;
        case 312:                           //Countdown timer
            Screen312();
        break;
        
        case 32:                           
            Screen32();
        break;
        case 320:                           //Analog
            Screen320();
        break;
        case 321:                           //Digital
            Screen321();
        break;                                       
        case 322:                           //Thermocouple
            Screen322();
        break;
        
        case 33:                           //Ports
            Screen33();
        break; 
        
        case 330:  
            Screen330();                   //Set Voltage
        break;   
        case 331:
            Screen331();
        break;
        default:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Error.");
            lcd_gotoxy(0,1);
            lcd_puts("Restarting in 5 seconds."); 
            delay_ms(5000);
            Screen = 1;
        break;
    }
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x07;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: On
// INT4 Mode: Falling Edge
// INT5: On
// INT5 Mode: Falling Edge
// INT6: On
// INT6 Mode: Falling Edge
// INT7: On
// INT7 Mode: Falling Edge
EICRA=0x00;
EICRB=0xAA;
EIMSK=0xF0;
EIFR=0xF0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x05;

ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x67;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 9600
UCSR1A=0x00;
UCSR1B=0x18;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 4000.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x50;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// I2C Bus initialization
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

 
// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

PORTE=0x0F;
DDRE=0x00;

password = 1234;


while(1)
{
    Screen_sel();
}
}
