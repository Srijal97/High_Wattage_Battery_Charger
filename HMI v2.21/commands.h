
#ifndef _COMMANDS_INCLUDED_
#define _COMMANDS_INCLUDED_




#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#ifndef UPE
#define UPE 2
#endif


#ifndef DOR
#define DOR 3
#endif


/*void xmitString(flash char * xmitMsg);
   
void noOp(void);
void mainOn();

void mainOff();

void resetFault();

void readVolt();
    

void readAmp();


void rnoOp();


void rmainOn();


void rmainOff();

void rresetFault();


void rreadVolt();

void rreadAmp();




void recOp();



char getchar(void);



// Write a character to the USART1 Transmitter

void putchar(char c);
*/
void comDecode(char * rec);


#endif /* HEADERS_COMMANDS_H_ */