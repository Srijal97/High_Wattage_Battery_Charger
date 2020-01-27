/*
 * commands.h
 *
 *  Created on: Jan 10, 2020
 *      Author: Mr.Yash
 */

#ifndef HEADERS_COMMANDS_H_
#define HEADERS_COMMANDS_H_


void command(void);
void noOp(void);
void mainOn(void);
void mainOff(void);
void resetFault(void);
void readVolt(void);
void readAmp(void);
static void (*func[100])();
void recOp(char*rec);


#endif /* HEADERS_COMMANDS_H_ */
