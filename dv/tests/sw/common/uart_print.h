/*
 * uart_print.h — Declarations for UART print helpers
 */
#ifndef UART_PRINT_H
#define UART_PRINT_H

void uart_init(void);
void uart_putchar(char c);
void uart_puts(const char *s);
void uart_pass(void);
void uart_fail(void);
char uart_getchar(void);
int  uart_tx_ready(void);
int  uart_rx_ready(void);

#endif /* UART_PRINT_H */
