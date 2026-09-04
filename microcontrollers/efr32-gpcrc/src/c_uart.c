#include "c_uart.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Initialize USART0 for UART communication
void USART0_init(void) {
  // Enable clock for GPIO and USART0
  CMU->CLKEN0 |= 1 << 26; // Enable GPIO clock
  CMU->CLKEN0 |= 1 << 9;  // Enable USART0 clock

  // Configure TX pin as output and RX pin as input
  GPIO->P[UART_PORT].MODEL &= ~(0xF << (4 * UART_TX_PIN)); // Clear existing mode for TX pin
  GPIO->P[UART_PORT].MODEL |= 0x4 << (4 * UART_TX_PIN);    // Set TX pin to push-pull output
  GPIO->P[UART_PORT].MODEL &= ~(0xF << (4 * UART_RX_PIN)); // Clear existing mode for RX pin
  GPIO->P[UART_PORT].MODEL |= 0x1 << (4 * UART_RX_PIN);    // Set RX pin to input

  // Configure USART0 for basic asynchronous operation
  USART_InitAsync_TypeDef init = USART_INITASYNC_DEFAULT;  // Default initialization structure
  init.baudrate = 115200;  // Set baud rate to 115200
  USART_InitAsync(USART0, &init);  // Initialize USART0 with the given settings

  // Route USART0 TX and RX to the defined pins
  GPIO->USARTROUTE[0].TXROUTE = (UART_PORT << _GPIO_USART_TXROUTE_PORT_SHIFT) | (UART_TX_PIN << _GPIO_USART_TXROUTE_PIN_SHIFT);
  GPIO->USARTROUTE[0].RXROUTE = (UART_PORT << _GPIO_USART_RXROUTE_PORT_SHIFT) | (UART_RX_PIN << _GPIO_USART_RXROUTE_PIN_SHIFT);
  GPIO->USARTROUTE[0].ROUTEEN = GPIO_USART_ROUTEEN_TXPEN | GPIO_USART_ROUTEEN_RXPEN;  // Enable TX and RX routing
}

// Deinitialize USART0 and release resources
void USART0_deinit(void) {
  // Disable USART0
  USART_Enable(USART0, usartDisable);

  // Disable clock for USART0
  CMU->CLKEN0 &= ~(1 << 9);  // Disable USART0 clock

  // Reset GPIO pins to default state
  GPIO->P[UART_PORT].MODEL &= ~(0xF << (4 * UART_TX_PIN));  // Disable TX pin
  GPIO->P[UART_PORT].MODEL &= ~(0xF << (4 * UART_RX_PIN));  // Disable RX pin

  // Disable pin routing for USART0 TX and RX
  GPIO->USARTROUTE[0].ROUTEEN &= ~(GPIO_USART_ROUTEEN_TXPEN | GPIO_USART_ROUTEEN_RXPEN);

  // Reset the TX and RX route registers (optional but good practice)
  GPIO->USARTROUTE[0].TXROUTE = 0;
  GPIO->USARTROUTE[0].RXROUTE = 0;
}

// Send a 32-bit unsigned integer over USART0
void USART0_Send_uint32(const uint32_t data) {
  // Send first byte (LSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));  // Wait until TX buffer is empty
  USART0->TXDATA = data & 0xFF;
  // Send second byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 8) & 0xFF;
  // Send third byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 16) & 0xFF;
  // Send fourth byte (MSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 24) & 0xFF;
}

// Send a 16-bit unsigned integer over USART0
void USART0_Send_uint16(const uint16_t data) {
  // Send first byte (LSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = data & 0xFF;
  // Send second byte (MSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 8) & 0xFF;
}

// Send an 8-bit unsigned integer over USART0
void USART0_Send_uint8(const uint8_t data) {
  // Send a single byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = data & 0xFF;
}

// Send a 32-bit signed integer over USART0
void USART0_Send_int32(const int32_t data) {
  // Send first byte (LSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = data & 0xFF;
  // Send second byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 8) & 0xFF;
  // Send third byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 16) & 0xFF;
  // Send fourth byte (MSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 24) & 0xFF;
}

// Send a 16-bit signed integer over USART0
void USART0_Send_int16(const int16_t data) {
  // Send first byte (LSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = data & 0xFF;
  // Send second byte (MSB)
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = (data >> 8) & 0xFF;
}

// Send an 8-bit signed integer over USART0
void USART0_Send_int8(const int8_t data) {
  // Send a single byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = data & 0xFF;
}

// Send a single character over USART0
void USART0_Send_char(const char data) {
  // Send a single byte
  while(!(USART0->STATUS & USART_STATUS_TXBL));
  USART0->TXDATA = data & 0xFF;
}

// Send a null-terminated string over USART0
void USART0_Send_string(const char* data) {
  // Send all bytes from the string
  for(size_t i = 0; i < strlen(data); i++) {
      while(!(USART0->STATUS & USART_STATUS_TXBL));  // Wait until TX buffer is empty
      USART0->TXDATA = *(data + i) & 0xFF;
  }
}

// Convert a 32-bit unsigned integer to a string
char* USART0_Convert_uint32(uint32_t data) {
    char buffer[20];  // Buffer to hold the string representation
    snprintf(buffer, sizeof(buffer), "%lu", (unsigned long)data);  // Convert to string
    char* result = (char*)malloc(strlen(buffer) + 1);  // Allocate memory for the string + null terminator
    if (result) {
        strcpy(result, buffer);  // Copy the string to the allocated memory
    }
    return result;
}

// Convert a 16-bit unsigned integer to a string
char* USART0_Convert_uint16(uint16_t data) {
    char buffer[10];
    snprintf(buffer, sizeof(buffer), "%u", (unsigned int)data);
    char* result = (char*)malloc(strlen(buffer) + 1);
    if (result) {
        strcpy(result, buffer);
    }
    return result;
}

// Convert an 8-bit unsigned integer to a string
char* USART0_Convert_uint8(uint8_t data) {
    char buffer[5];
    snprintf(buffer, sizeof(buffer), "%u", (unsigned int)data);
    char* result = (char*)malloc(strlen(buffer) + 1);
    if (result) {
        strcpy(result, buffer);
    }
    return result;
}

// Convert a 32-bit signed integer to a string
char* USART0_Convert_int32(int32_t data) {
    char buffer[20];
    snprintf(buffer, sizeof(buffer), "%ld", (long)data);
    char* result = (char*)malloc(strlen(buffer) + 1);
    if (result) {
        strcpy(result, buffer);
    }
    return result;
}

// Convert a 16-bit signed integer to a string
char* USART0_Convert_int16(int16_t data) {
    char buffer[10];
    snprintf(buffer, sizeof(buffer), "%d", (int)data);
    char* result = (char*)malloc(strlen(buffer) + 1);
    if (result) {
        strcpy(result, buffer);
    }
    return result;
}

// Convert an 8-bit signed integer to a string
char* USART0_Convert_int8(int8_t data) {
    char buffer[5];
    snprintf(buffer, sizeof(buffer), "%d", (int)data);
    char* result = (char*)malloc(strlen(buffer) + 1);
    if (result) {
        strcpy(result, buffer);
    }
    return result;
}

void USART0_Free(char* data) {
    free(data);
}