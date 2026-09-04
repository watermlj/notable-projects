#ifndef UART_H_
#define UART_H_

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "em_cmu.h"
#include "em_gpio.h"
#include "em_usart.h"

// UART Pins for EFR32xG24
#define UART_PORT gpioPortA  // Define the GPIO port for UART
#define UART_TX_PIN 5        // Define the TX pin number
#define UART_RX_PIN 6        // Define the RX pin number

// Function prototypes

// Initialize USART0 for UART communication
void USART0_init(void);

// Deinitialize USART0 and release resources
void USART0_deinit(void);

// Send functions for different data types
void USART0_Send_uint32(const uint32_t data);  // Send a 32-bit unsigned integer
void USART0_Send_uint16(const uint16_t data);  // Send a 16-bit unsigned integer
void USART0_Send_uint8(const uint8_t data);    // Send an 8-bit unsigned integer
void USART0_Send_int32(const int32_t data);    // Send a 32-bit signed integer
void USART0_Send_int16(const int16_t data);    // Send a 16-bit signed integer
void USART0_Send_int8(const int8_t data);      // Send an 8-bit signed integer

// Send a single character
void USART0_Send_char(const char data);

// Send a null-terminated string
void USART0_Send_string(const char* data);

// Conversion functions to convert numeric data types to strings
// Intended to have output put into USART0_Free after use
char* USART0_Convert_uint32(const uint32_t data);  // Convert uint32_t to string
char* USART0_Convert_uint16(const uint16_t data);  // Convert uint16_t to string
char* USART0_Convert_uint8(const uint8_t data);    // Convert uint8_t to string
char* USART0_Convert_int32(const int32_t data);    // Convert int32_t to string
char* USART0_Convert_int16(const int16_t data);    // Convert int16_t to string
char* USART0_Convert_int8(const int8_t data);      // Convert int8_t to string

void USART0_Free(char* data); // Frees the char*

#endif /* UART_H_ */
