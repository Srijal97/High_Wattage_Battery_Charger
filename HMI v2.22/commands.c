/*
 * commands.c
 *
 *  Created on: Jan 10, 2020
 *      Author: Mr.Yash
 */

//#include <Serial.h>
#include <commands.h>
#include <alcd.h>
#include <ver1.h> 
//#include <variables.h>
 
int Screen = 1;
int Current_Screen = 0;
int Pointer_horiz = 0, Pointer_vert = 0, Pt;

int temp_voltage = 0;
int temp_current = 0;
long set_voltage = 0;
long set_current = 0;
//float set_current = 00.0;                        //12/2/20
static int actual_voltage = 0;
static int actual_btcurrentdp = 0;
static int actual_btcurrentip = 0;
static int actual_ipvoltage = 0;
static int actual_opcurrentdp = 0;
static int actual_opcurrentip = 0;

int set_flag=0;
int flag = 0;
 
int n=0;                    //Input function parameter in screen functions
int main_screen_trigger;  //to return to main screen
int ms_update_flag = 0;
int current_mainscreen_flag = 0;
int status = 0;
int fault_flag = 0;
int rtc_display_counter = 0;

//flash char* txVoltCom;
//flash char* txAmpCom;

unsigned char hour;
unsigned char minute;
unsigned char second;
unsigned char date;
unsigned char month;
unsigned char year;
char disp_time[];
char disp_date[];
unsigned char temp_hour;
unsigned char temp_minute;
unsigned char temp_second;
char disp_temp_time[];
unsigned char temp_date;
unsigned char temp_month;
unsigned char temp_year;
char disp_temp_date[];

unsigned char dataByte;
unsigned char dataArr[] = {'I','a','m','a','B','o','i','e','\0'};
unsigned char *data_ptr = dataArr;
unsigned char rddataArr[] = {'0','0','0','0','0','0','0','0','\0'};
unsigned char *rddata_ptr;
int address;
//unsigned char addressH = 00;
//unsigned char addressL = 00;
unsigned short read_data;
unsigned char disp_eeprom_write[];
unsigned char disp_eeprom_read[];



char fltArray[9] = {'0','0','0','0','0','0','0','0','\0'};
char disp_volt[3];
char disp_current[3];
char disp_set_voltage[3];
char disp_set_btcurrent[4];
char disp_actual_voltage[3];
char disp_actual_btcurrent[4];
char disp_actual_ipvoltage[3];
char disp_actual_opcurrent[4];
//char disp_fault[];
//flash char *msg; 
flash char *xmitMsg; 
//flash char *rec;
//flash char *rdata;
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
    //    005-  txSetVoltage
    //    006-  txSetCurrent
    //    007-
    //    008-
    //    009-
    //    010-  read output voltage
    //    011-  read battery current
    //    012-  read input voltage
    //    013-  read output current
    //    014-  set output voltage
    //    015-  set battery current
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

void xmitStringnf(char * xmitMsgnf)
{
    int i =0;
    for(i = 0;*(xmitMsgnf+i)!= '\0';i++)
    {
         putchar(xmitMsgnf[i]);
            
    }
    
   
   
}
   
void noOp()
{

}

void mainOn()
{

    xmitMsg ="<001>"; 
    xmitString(xmitMsg);
    
}

void mainOff()
{
       
    xmitMsg = "<002>";
    xmitString(xmitMsg);
    
}

void resetFault()
{
    xmitMsg = "<003>";
    xmitString(xmitMsg);
}

void readOutputVolt()
{    
    xmitMsg = "<010>";
    xmitString(xmitMsg);
    
}

void readBatteryAmp()
{
    xmitMsg = "<011>";
    xmitString(xmitMsg);
    
}

void txSetVoltage(int setVoltVal)
{
    int cpyVolt = setVoltVal;
    char* msg1 = "";
    sprintf(msg1,"<014-%04d>",cpyVolt);
    xmitStringnf(msg1); 
}

void txSetCurrent(int setAmpVal)
{
    int cpyAmp = setAmpVal;
    char*msg1 = "";
    sprintf(msg1,"<015-%04d>",cpyAmp);
    xmitStringnf(msg1); 

}

/*static void (*tx_function[100])() = {
    noOp,  // 0
    mainOn,  // 1
    mainOff,  // 2
    resetFault,  // 3
    faultDetect, //4
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    readOutputVolt,//10
    readBatteryAmp,//11
    //readInputVolt,//12
    //xreadOutputCurrent,//13
};*/





//On receiving response from the TMS, further actions are taken by recFunc array




void rxnoOp()
{
}


void rxmainOn()
{
    current_mainscreen_flag = 1;
    PORTC.3 = 0;
    status = 1;                                                            
}

void rxmainOff()
{
    current_mainscreen_flag = 1;
    status = 0;       
    PORTC.3 = 1;
    
}

void rxresetFault()
{      
   fault_flag = 0;    
   current_mainscreen_flag = 1;
   status = 0; 
}

void rxfaultDetect(int val)
{
    int i = 0;//,j,k=0;
    int fault = 0;// cpyFault;
    //int fltBit[8],tmpBit[8];
    fault = val;
    
    if(fault!=0)
    {   
        PORTF &= ~0x40;
        fault_flag = 1;
       // mainOff();
        
    }
    for(i=0;i<8;i++)
    {
        fltArray[7-i] = fault%2 + 48;
        fault = fault >> 1; 
    
    }     
    
//    numFlt = fltBit[0]+(fltBit[1]*10)+(fltBit[2]*100)
//    +(fltBit[3]*1000)+(fltBit[4]*10000)+(fltBit[5]*100000)+(fltBit[1]*1000000)+(fltBit[1]*10000000);
    
//    if(fltBit[0] == 1)PORTC.3 = 0;
//    if(fltBit[1] == 1)PORTC.3 = 1;
//    if(fltBit[2] == 1)PORTF &= ~0x80;; 
//    if(fltBit[3] == 1)PORTC.3 = 1  ;
//    if(fltBit[4] == 1)PORTC.3 = 1   ;
//    if(fltBit[5] == 1)PORTC.3 = 1    ;
//    if(fltBit[6] == 1)PORTC.3 = 1     ;
//    if(fltBit[7] == 1)PORTC.3 = 1      ;
//    
                                                                                                                                                              
   

}

void rxreadOutputVolt(int val)
{   
    actual_voltage = val;  
}



void rxreadBatteryAmp(int val)
{  
    int decimalPart;
    int integerPart;
    decimalPart = val%10;
    integerPart = val/10;
    actual_btcurrentdp = decimalPart;
    actual_btcurrentip = integerPart;      
}

void rxreadInputVolt(int val)
{
    actual_ipvoltage = val;
}

void rxreadOutputCurrent(int val)
{
    int decimalPart;
    int integerPart;
    decimalPart = val%10;
    integerPart = val/10;
    actual_opcurrentdp = decimalPart;
    actual_opcurrentip = integerPart;
}


/*static void (*rx_function[100])() = {
    rxnoOp,  // 0
    rxmainOn,  // 1
    rxmainOff,  // 2
    rxresetFault,  // 3
    rxfaultDetect, //4
    rxnoOp,
    rxnoOp,
    rxnoOp,
    rxnoOp,
    rxnoOp,
    rxreadOutputVolt,//10
    rxreadBatteryAmp,//11
    rxreadInputVolt,//12
    rexreadOutputCurrent,//13
};*/



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
 
   //rx_function[icmd](); 
   switch(icmd)
   {    
        case 0:  noOp();                    break;   
        case 1:  rxmainOn();                break;
        case 2:  rxmainOff();               break;
        case 3:  rxresetFault();            break;    
        case 4:  rxfaultDetect(idata);      break;
        case 5:  noOp();                    break;
        case 6:  noOp();                    break;
        case 7:  noOp();                    break;
        case 8:  noOp();                    break;
        case 9:  noOp();                    break;
        case 10: rxreadOutputVolt(idata);   break;
        case 11: rxreadBatteryAmp(idata);   break;
        case 12: rxreadInputVolt(idata);    break;
        case 13: rxreadOutputCurrent(idata);break;
        case 14: noOp();                    break;
        case 15: noOp();                    break;
        case 16: noOp();                    break;
        case 17: noOp();                    break;
        default: ;
   }
   
//    if (icmd == 1) {  // <001>
//        rxmainOn();     
//    } 
//    else if (icmd == 2) {
//        rxmainOff(); 
//    }  
//    else if (icmd == 3 ) { 
//        rxresetFault();        
//    
//    }   
//    else if (icmd == 4) {
//       rxfaultDetect(idata);
//    }
//    
//    else if (icmd == 10 ){
//        rxreadOutputVolt(idata);
//    
//    }
//    else if (icmd == 11 ){
//        rxreadBatteryAmp(idata);
//    }
//    else if (icmd == 12 ){
//        rxreadInputVolt(idata);
//    }
//    else if (icmd == 13 ){
//        rxreadOutputCurrent(idata);
//    }
    

}