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


char *msg = "";

extern int fault_condition;
extern int system_state;

extern float IP_V_DC;
extern float OP_V_DC;
extern float OP_I_DC;
extern float BAT_I_DC;


extern Uint16 batt_curr_setpoint;
extern Uint16 output_voltage_setpoint;


extern const Uint16 VOLTAGE_SENS_OFFSET_ERR;

// null command
void noOp()
{

//    msg = "<000>";
//    SCI_UpdateMonitor(msg);  // echoback for ACK
}

// commands will be given a 3 digit numeric code and followed by 4 digit corresponding data if any
// all transmission and receiving of commands and data is done through serial communication
// the data sent and received through serial interface(UART) is of the form <ccc-dddd> where c corresponds to command code digits and d corresponds to data digits


static void (*select_function[MAX_NUM_COMMANDS])() = {
    noOp,  // 0
    mainOn,  // 1
    mainOff,  // 2
    resetFault,//3
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    noOp,
    rxSetOutputVoltage,
    rxSetBatteryCurrent
};


// System state toggle if machine on button pressed on the hmi board(ATmega128)
// Note that On state can only be requested if the current state of the system is Off

void mainOn() {  // machine ON button pressed
//    msg = "<001>";
//    SCI_UpdateMonitor(msg);  // echoback for ACK
    if (system_state == 0) {  // if off then soft start
        system_state = 1;
    }

}

// System state toggle if machine off button pressed on the HMI board(ATmega128)
// Soft_Off can only be requested if the current system state is On or is in Auto_restart mode [Not implemented fully]

void mainOff() {  // machine OFF button pressed
//    msg = "<002>";
//    SCI_UpdateMonitor(msg);
    if (system_state == 2) {  // if on then soft stop
        system_state = 3;
    }

}

// All fault conditions are reset once the reset button is pressed on the HMI board(ATmega128)
void resetFault() {  // fault RESET button pressed
    msg = "<003>";
    SCI_UpdateMonitor(msg);

    fault_condition = 0;  // reset fault conditions

}


// Transmits fault occurrence and type of fault as BCD
void txFaultState() {

    char tx_str[] = {'<', '0', '0', '4', '-', '0', '0', '0', '0', '>'};

    tx_str[8] = fault_condition % 10 + 48;
    fault_condition = fault_condition/10;
    tx_str[7] = fault_condition % 10 + 48;
    fault_condition = fault_condition/10;
    tx_str[6] = fault_condition % 10 + 48;
    fault_condition = fault_condition/10;
    tx_str[5] = fault_condition % 10 + 48;
    fault_condition = fault_condition/10;


    SCI_UpdateMonitor(tx_str);
}

void txInputVoltage() {
    int ip_voltage = (float)IP_V_DC * 0.3065;

    char tx_str[] = {'<', '0', '1', '2', '-', '0', '0', '0', '0', '>'};

    tx_str[8] = ip_voltage % 10 + 48;
    ip_voltage = ip_voltage/10;
    tx_str[7] = ip_voltage % 10 + 48;
    ip_voltage = ip_voltage/10;
    tx_str[6] = ip_voltage % 10 + 48;
    ip_voltage = ip_voltage/10;
    tx_str[5] = ip_voltage % 10 + 48;
    ip_voltage = ip_voltage/10;

    SCI_UpdateMonitor(tx_str);
}

void txOutputVoltage() {
    int op_voltage = (float)OP_V_DC / 9.35;

    char tx_str[] = {'<', '0', '1', '0', '-', '0', '0', '0', '0', '>'};

    tx_str[8] = op_voltage % 10 + 48;
    op_voltage = op_voltage/10;
    tx_str[7] = op_voltage % 10 + 48;
    op_voltage = op_voltage/10;
    tx_str[6] = op_voltage % 10 + 48;
    op_voltage = op_voltage/10;
    tx_str[5] = op_voltage % 10 + 48;
    op_voltage = op_voltage/10;

    SCI_UpdateMonitor(tx_str);
}

void txOutputCurrent() {
    int op_current = (float)OP_I_DC / 11.17;   // 1117 corresponds to 10A --> 11.17 is 0.1A

    char tx_str[] = {'<', '0', '1', '3', '-', '0', '0', '0', '0', '>'};

    tx_str[8] = op_current % 10 + 48;
    op_current = op_current/10;
    tx_str[7] = op_current % 10 + 48;
    op_current = op_current/10;
    tx_str[6] = op_current % 10 + 48;
    op_current = op_current/10;
    tx_str[5] = op_current % 10 + 48;
    op_current = op_current/10;

    SCI_UpdateMonitor(tx_str);
}

void txBatteryCurrent() {
    int bat_current = (float)BAT_I_DC / 11.17;

    char tx_str[] = {'<', '0', '1', '1', '-', '0', '0', '0', '0', '>'};

    tx_str[8] = bat_current % 10 + 48;
    bat_current = bat_current/10;
    tx_str[7] = bat_current % 10 + 48;
    bat_current = bat_current/10;
    tx_str[6] = bat_current % 10 + 48;
    bat_current = bat_current/10;
    tx_str[5] = bat_current % 10 + 48;
    bat_current = bat_current/10;

    SCI_UpdateMonitor(tx_str);
}

void rxSetOutputVoltage(int rx_volt_value) {
    output_voltage_setpoint = (Uint16)((float)rx_volt_value * 9.34);

    output_voltage_setpoint -= VOLTAGE_SENS_OFFSET_ERR;

}

void rxSetBatteryCurrent(int rx_current_value) {

    batt_curr_setpoint = (Uint16)((float)rx_current_value * 98.5);
}

// Serves the received serial data by interpreting the received command code and separating the data corresponding to that command

void process_rx_command(char *rx_str) { // rx_str = "<001-xxxx>"

    int data;
    if (rx_str[0] == '<') {
        int func_index = rx_str[3]-'0'+((rx_str[2]-'0')*10)+((rx_str[1]-'0')*100);

        if(rx_str[4] == '-') {
            data = rx_str[8]-'0'+((rx_str[7]-'0')*10)
                            +((rx_str[6]-'0')*100)+((rx_str[5]-'0')*1000);
        }

        if(func_index < MAX_NUM_COMMANDS) {
            select_function[func_index](data);

        }


    }


}


