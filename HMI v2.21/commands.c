/*
 * commands.c
 *
 *  Created on: Jan 10, 2020
 *      Author: Mr.Yash
 */

//#include <Serial.h>
#include <commands.h>
//#include <alcd.h>
#include <ver1.h>

flash char *msg; 
flash char *xmitMsg; 
flash char *rec;
flash char *rdata;

//char sdataA[20];    // Send data for SCI-A
char rdataA[20]; // Received data for SCI-A
int comStart;
int i = 0;

    //commands will be given a 3 digit numeric code based on the button pressed;
    //Stored values for the particular option-    
    
    //    000-  noOp
    //    001-  mainOn
    //    002-  mainOff
    //    003-  resetFault
    //    004-  faultDetect
    //    005-  
    //    006-
    //    007-
    //    008-
    //    009-
    //    010-  
    //    011-  readVolt
    //    012-  readAmp
    //    013-
    //    014-
    //    015-
    //    016-
    //    017-
    //    018-
    //    019-
    //    020-
    //    021-
    //    022-
    //    023-
    //    024-
    //    025-
    //    026-
    //    027-
    //    028-
    //    029-
    //    030-
    //    031-
    //    032-
    //    033-
    //    034-
    //    035-
    //    036-
    //    037-
    //    038-
    //    039-

void xmitString(flash char * xmitMsg)
{
    int i =0;
    for(i = 0;*(xmitMsg+i)!= '\0';i++)
    {
         putchar(xmitMsg[i]);
            
    }

}
   
void noOp()
{

}

void mainOn()
{
    //lcd_clear();
    //lcd_putsf("Entering Soft-Start"); 
    xmitMsg ="<001>"; 
    xmitString(xmitMsg);
    //delay_ms(500);

   // lcd_clear();                        
    
    
}

void mainOff()
{
   // lcd_clear();
    //lcd_putsf("Entering Soft-Stop");       
    xmitMsg = "<002>";
    xmitString(xmitMsg);
    //delay_ms(500);
   // lcd_clear();
}

void resetFault()
{
    //lcd_putsf("Resetting Faults");       
    xmitMsg = "<003>";
    xmitString(xmitMsg);
    
}

void readVolt()
{    
    xmitMsg = "<004>";
    xmitString(xmitMsg);
    //voltVal = recVolt();
    //msg = sprintf("\nVoltage is: %d",voltVal);
    //lcd_putsf(msg);
    
}

void readAmp()
{
    xmitMsg = "<005>";
    xmitString(xmitMsg);
    //ampVal = recAmp();
    //msg = sprintf("\nCurrent is: %d",ampVal);
    //lcd_putsf(msg);
}


//On receiving response from the TMS, further actions are taken by recFunc array
void rxnoOp()
{

}


void rxmainOn()
{
    PORTC.3 = 0; 
    //flash char*msg ="The System has turned on";       
     //PORTF &= ~0x40;
    //putchar('r');                              
    //xmitMsg = "on button pressed acknowledged by the dsp";
    //xmitString(xmitMsg);
   // lcd_putsf(msg);                            //function to display message on the lcd
    
}

void rxmainOff()
{

    PORTC.3 = 1; 
//    putchar('s');
//    xmitMsg = "off button pressed acknowledged by the dsp";
//    xmitString(xmitMsg);
//    msg = "The System has turned off";
    //lcd_putsf(msg);      

}

void rxresetFault()
{
    //msg = "Faults have been reset";
   // lcd_putsf(msg);       
    
}

void rxfaultDetect(char *data)
{
    int i = 0,j,k=0;
    int fault = 0, cpyFault;
    int fltBit[8], tmpBit[8]; 
    fault = data[2]-'0'+((data[1]-'0')*10)+((data[0]-'0')*100);       
    cpyFault = fault;
    
  
    // counter for binary array  
    while (cpyFault > 0) { 
      
        tmpBit[i] = cpyFault % 2; 
        cpyFault = cpyFault / 2; 
        i++; 
    } 

    for (j = i - 1; j >= 0; j--,k++){ 
        fltBit[k] = tmpBit[j];
    } 
    for (j=k;j<8;j++)
    {
        fltBit[j] = 0;
    }
    
    if(fltBit[0] == 1)PORTF != ~0x40;
    if(fltBit[1] == 1);
    if(fltBit[2] == 1)PORTF != ~0x80; 
    if(fltBit[3] == 1)  ;
    if(fltBit[4] == 1)   ;
    if(fltBit[5] == 1)    ;
    if(fltBit[6] == 1)     ;
    if(fltBit[7] == 1)      ;
    
            
         
    
    
    
    
 
    if(fault!=0)
    {
        PORTD.3=0;
    }


}

void rxreadVolt()
{   
    int i = 0;
    for(i = 0;i<4;i++)
    {
        
    }
    
    msg = rdata;
    //lcd_putsf(msg);
    
}

void rxreadAmp()
{  
    int i;flash char *tempRdata; 
    for(i=5;*(rec+i-1)!='\0';i++)
    {
        tempRdata= (rec+i);
        if(i==5)  rdata = tempRdata;
        tempRdata++;
    }
    msg = rdata;
    //lcd_putsf(msg);
    
}


void recOp() { 
    
    
    char data = getchar();
    
    PORTF |= 0x80;
    
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
}


void comDecode(char * rec)
{
    
    char cmd[3] = {'0','0','0'};   
    char data[4] = {'0','0','0','0'};
    int icmd = 0;       
    int idata = 0;
    int i;          

    for(i = 1; i < 4; i++)
    {
       cmd[i-1] = rec[i];
    }
    
    for(i = 5; i < 9; i++)                                                                          
    {
       data[i-5] = rec[i];
    } 
     
     
    icmd = (cmd[2]-'0') + ((cmd[1] - '0')*10) + ((cmd[0]-'0')*100);  
    idata = (data[3]-'0') + ((data[2] - '0')*10) + ((data[1]-'0')*100) + ((data[0]-'0')*1000);   
    
    if (icmd == 1) {  // <001>
        rxmainOn();     
    } 
    else if (icmd == 2) {
        rxmainOff(); 
    }  
    else if (icmd == 4 ) {    
        if (idata != 0) {
           PORTD.3 = 0; 
           PORTC.3 = 1;
        } 
        else {
           PORTD.3 = 1;
        }
        
    
    }
    

}