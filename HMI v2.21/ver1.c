
#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <Math.h>
#include "commands.c"

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
#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)


// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 64
    char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
    unsigned char rx_wr_index0 = 0, rx_rd_index0 = 0;
#else
    unsigned int rx_wr_index0=0, rx_rd_index0 = 0;
#endif

#if RX_BUFFER_SIZE0 < 256
    unsigned char rx_counter0 = 0;
#else
    unsigned int rx_counter0 = 0;
#endif


int on_pressed = 0;
int off_pressed = 0;
int data_received = 0;
int reset_pressed = 0;
// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;


// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
    char status, data;
    status = UCSR0A;
    data = UDR0; 
    
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))== 0) {
       rx_buffer0[rx_wr_index0++] = data;
    #if RX_BUFFER_SIZE0 == 256
       // special case for receiver buffer size=256
       if (++rx_counter0 == 0) 
            rx_buffer_overflow0 = 1;
    #else
       if (rx_wr_index0 == RX_BUFFER_SIZE0) 
            rx_wr_index0=0; 
       
       if (++rx_counter0 == RX_BUFFER_SIZE0){
            rx_counter0=0;
            rx_buffer_overflow0=1;
       }
    #endif
       
    }    
    
    data_received = 1; 
}

#ifndef _DEBUG_TERMINAL_IO_



// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
    char data;     
    
    while (rx_counter0 == 0); 
    
    data = rx_buffer0[rx_rd_index0++];   
    
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
    unsigned char tx_wr_index0 = 0, tx_rd_index0=0;
#else
    unsigned int tx_wr_index0 = 0, tx_rd_index0=0;
#endif

#if TX_BUFFER_SIZE0 < 256
    unsigned char tx_counter0 = 0;
#else
    unsigned int tx_counter0 = 0;
#endif



// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
    if (tx_counter0) {
       --tx_counter0;
       UDR0 = tx_buffer0[tx_rd_index0++];  
       
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
short int reset_button_state = 0x0000;

// Timer3 overflow interrupt service routine
interrupt[TIM3_OVF] void timer3_ovf_isr(void) {

    // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF   
        
    // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-software-debouncers
    // 16 bit shifts = approx 130msec debounce delay    
    on_button_state = (0x8000 | !PINE.4) | (on_button_state << 1);  
    if(on_button_state == 0xC000) {     
       //PORTC.3 = 0;  
       //PORTF &= ~0x40; 
       on_pressed = 1;
     
    }    
    
    off_button_state = (0x8000 | !PINE.5) | (off_button_state << 1);       
    if(off_button_state == 0xC000 ) {         
      //PORTC.3 = 1;
       off_pressed = 1;
     
    }    
    
    reset_button_state = (0x8000 | !PINE.6) | (reset_button_state << 1);  
    if(reset_button_state == 0xC000) {     
       

       PORTD.3 = 1;
       reset_pressed = 1;
     
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


    PORTD=0xC8;
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

    //// External Interrupt(s) initialization
    //EICRA=0x00;
    //EICRB=0xAA;
    //EIMSK=0xF0;
    //EIFR=0xF0;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;
    ETIMSK=0x04;

    // USART0 initialization
//
//    UCSR0A=0x00;
//    UCSR0B=0x18;
//    UCSR0C=0x06;
//    UBRR0H=0x00;
//    UBRR0L=0x67;

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

    PORTF &= ~0x80;
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
            if(data_received == 1)
            {
                recOp();
                data_received = 0;
            }
            if(reset_pressed == 1)
            {
                resetFault();
                reset_pressed = 0;
            }  
        //Screen_sel();
        
    } 

}