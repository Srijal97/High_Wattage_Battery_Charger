/*
 * commands.h
 *
 *  Created on: Jan 10, 2020
 *      Author: Mr.Yash
 */

#ifndef HEADERS_COMMANDS_H_
#define HEADERS_COMMANDS_H_

#define MAX_NUM_COMMANDS  4

void command(void);
void noOp(void);
void mainOn(void);
void mainOff(void);
void resetFault(void);
void txFaultState(void);
void txInputVoltage(void);
void txOutputVoltage(void);
void txOutputCurrent(void);
void txBatteryCurrent(void);
static void (*select_function[MAX_NUM_COMMANDS])();
void process_rx_command(char*rec);


#endif /* HEADERS_COMMANDS_H_ */
