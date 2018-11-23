/* 
 * File:   flex_serial.h
 * Author: jhutter2
 *
 * Created on September 28, 2017, 3:39 PM
 */
#include "types.h"
#ifndef FLEX_SERIAL_H
#define	FLEX_SERIAL_H

#ifdef	__cplusplus
extern "C" {
#endif




#ifdef	__cplusplus
}
#endif

#endif	/* FLEX_SERIAL_H */
void uart2_init(uint16_t baud);
int uart2_putc(uint8_t c);
uint8_t uart2_getc();