/*
 * commands.c
 *
 *  Created on: Jan 10, 2020
 *      Author: Mr.Yash
 */

#include <Serial.h>
#include <commands.h>
#include <stdio.h>
#include "string.h"
char *msg="";
extern int system_state;
    //commands will be given a 3 digit numeric code and followed by corresponding data if any
    //Commands-
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

    static void (*func[100])() = {
    noOp,mainOn,mainOff,resetFault,readVolt,readAmp
    };

void noOp()
{

}

void mainOn()
{
    msg = "<001>-System is Turning On";
    SCI_UpdateMonitor(msg);
    if (system_state == 0) {  // if off then soft start
        system_state = 1;
    }

}

void mainOff()
{
    msg = "<002>";
    SCI_UpdateMonitor(msg);
    if (system_state == 2) {  // if on then soft stop
        system_state = 3;
    }

}

void resetFault()
{
    msg = "<003>";
    SCI_UpdateMonitor(msg);

}

void readVolt()
{
    double voltVal = 36.5;
    sprintf(msg,"<004-%f>",voltVal);
    SCI_UpdateMonitor(msg);
}

void readAmp()
{
    double ampVal = 43.2;
    sprintf(msg,"<005-%f>",ampVal);
    SCI_UpdateMonitor(msg);
}


void recOp(char * rec)
{
    char cmd[3]={'0','0','0'};
    int icmd = 0;
    int i;
    //char rec[5];
    char chk;
//    for(i=0;i<5;i++)
//    {
//        chk=scia_rec();
//        if(chk=='<')
//        {
//            i=0;//j++;
//        }
//        rec[i] = chk;
//    }




    for(i=1;i<4;i++)
    {
       cmd[i-1] = rec[i];
    }

    icmd = cmd[2]-'0'+((cmd[1]-'0')*10)+((cmd[0]-'0')*100);
    func[icmd]();

}

