/*
 * macros.h
 *
 *  Created on: Jul 29, 2019
 *      Author: Srijal Poojari
 */

#ifndef MACROS_H_
#define MACROS_H_


#define CC_MODE  (char)0
#define CV_MODE  (char)1

#define SATURATE(x, min, max)       if(x < min) (x = min); \
                                    if(x > max) (x = max)

#endif /* MACROS_H_ */
