/*
 * uart_loopback.c — UART loopback test
 *
 * The testbench wires uart_tx -> uart_rx (loopback).
 * This test sends the string "HELLO" and reads it back,
 * verifying each received character matches what was sent.
 *
 * UART base: 0x20000000 (16550-compatible, see uart_print.c)
 */

#include <stdint.h>
#include "common/uart_print.h"

/* Characters to send/receive */
static const char TEST_STRING[] = "HELLO";
#define TEST_LEN  5

/* Receive timeout limit */
#define RX_TIMEOUT  200000

int main(void)
{
    int     i;
    char    recv;
    uint32_t poll;

    uart_init();
    uart_puts("UART loopback test start\n");

    /* Flush any stale RX data */
    while (uart_rx_ready())
        (void)uart_getchar();

    /* Send each character and immediately read it back */
    for (i = 0; i < TEST_LEN; i++) {
        uart_putchar(TEST_STRING[i]);

        /* Wait for RX data ready */
        for (poll = 0; poll < RX_TIMEOUT; poll++) {
            if (uart_rx_ready())
                break;
        }
        if (poll >= RX_TIMEOUT) {
            uart_puts("RX timeout\n");
            uart_fail();
            return 1;
        }

        recv = uart_getchar();
        if (recv != TEST_STRING[i]) {
            uart_puts("Mismatch\n");
            uart_fail();
            return 1;
        }
    }

    uart_puts("Loopback OK\n");
    uart_pass();
    return 0;
}
