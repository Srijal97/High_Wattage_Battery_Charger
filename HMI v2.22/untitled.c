
/*
 * commands.c
 *
 *  Created on: Jan 10, 2020
 *      Author: Mr.Yash
 */

//#include <Serial.h>

#include <alcd.h>
#include <stdio.h>
#include "string.h"
//#include "ver1.c"
flash char *msg;
flash char *xmitMsg;
flash char *rec;
flash char *rdata;

int functn = 0;

    //commands will be given a 3 digit numeric code based on the button pressed;
    //Stored values for the particular option-    
   
    //    000-  noOp
    //    001-  mainOn
    //    002-  mainOff
    //    003-  resetFault
    //    004-  readVolt
    //    005-  readAmp
    //    006-
    //    007-
    //    008-
    //    009-
    //    010-
    //    011-
    //    012-
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
         putchar1(xmitMsg[i]);
           
    }
   
   
   
}
   
void noOp()
{

}

void mainOn()
{
   
    lcd_putsf("The System is turning on");                            //function to display message on the lcd
    xmitMsg ="<001>";
    xmitString(xmitMsg);
}

void mainOff()
{
   
    lcd_putsf("The System is turning off");      
    xmitMsg = "<002>";
    xmitString(xmitMsg);

}

void resetFault()
{
    lcd_putsf("Resetting Faults");      
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

static void (*xmitFunc[100])() = {
    noOp,mainOn,mainOff,resetFault,readVolt,readAmp
    };




//On receiving response from the TMS, further actions are taken by recFunc array
void rnoOp()
{

}


void rmainOn()
{
    flash char*msg ="The System has turned on";
    lcd_putsf(msg);                            //function to display message on the lcd
   
}

void rmainOff()
{
    msg = "The System has turned off";
    lcd_putsf(msg);      
   
}

void rresetFault()
{
    msg = "Faults have been reset";
    lcd_putsf(msg);      
   
}

void rreadVolt()
{  
    int i;flash char *tempRdata;
    for(i=5;*(rec+i-1)!='\0';i++)
    {
        tempRdata= (rec+i);
        if(i==5)  rdata = tempRdata;
        tempRdata++;
    }
   
    msg = rdata;
    lcd_putsf(msg);
   
}

void rreadAmp()
{  
    int i;flash char *tempRdata;
    for(i=5;*(rec+i-1)!='\0';i++)
    {
        tempRdata= (rec+i);
        if(i==5)  rdata = tempRdata;
        tempRdata++;
    }
    msg = rdata;
    lcd_putsf(msg);
   
}


static void (*recFunc[100])() = {rnoOp,rmainOn,rmainOff,rresetFault,rreadVolt,rreadAmp
    };


void recOp()
{    
    char recArray[100];
    char cmd[3]={'','',''};
    int icmd = 0;
    int i = 0;
    //char tempRec[100];
    do
    {
        recArray[i++] = getchar1();
         
    }while(recArray[i]!='\0');  
//    char *rec = "<001-anyData>";
    for(i=1;i<4;i++)
    {
       cmd[i-1] = *(recArray+i);
    }

    icmd = cmd[2]-'0'+((cmd[1]-'0')*10)+((cmd[0]-'0')*100);
    recFunc[icmd]();
}