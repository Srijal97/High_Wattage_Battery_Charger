/*
 * FLASH.h
 *
 *  Created on: 01-Jun-2019
 *      Author: Ameya
 */

#ifndef FLASH_H_
#define FLASH_H_

#include "main.h"
//
// Functions that will be run from RAM need to be assigned to
// a different section.  This section will then be mapped using
// the linker cmd file.
//
//#pragma CODE_SECTION(epwm1_timer_isr, "ramfuncs");
//#pragma CODE_SECTION(epwm2_timer_isr, "ramfuncs");

//
// These are defined by the linker (see F2808.cmd)
//
extern Uint16 RamfuncsLoadStart;
extern Uint16 RamfuncsLoadEnd;
extern Uint16 RamfuncsRunStart;
extern Uint16 RamfuncsLoadSize;


void FLASH_CONFIG(void);

#endif /* FLASH_H_ */
