/*
 * gpio_test.c — GPIO peripheral test
 *
 * GPIO register map (base 0x40000000):
 *   +0x00: DATA    (gpio_in sample, read-only)
 *   +0x04: DIR     (gpio_dir: bit=1 -> output)
 *   +0x08: OUT     (gpio_out write value)
 *
 * The testbench drives gpio_in = 32'hDEAD_BEEF.
 *
 * Test plan:
 *   1. Read gpio_in and verify == 0xDEADBEEF
 *   2. Set gpio_dir = 0xFFFFFFFF (all outputs)
 *   3. Write 0xA5A5A5A5 to gpio_out
 *   4. Read back gpio_out register and verify == 0xA5A5A5A5
 *   5. Restore gpio_dir = 0 (all inputs) for cleanliness
 *   6. uart_pass() on success
 */

#include <stdint.h>
#include "common/uart_print.h"

#define GPIO_BASE   0x40000000UL
#define GPIO_DATA   (*(volatile uint32_t *)(GPIO_BASE + 0x00))
#define GPIO_DIR    (*(volatile uint32_t *)(GPIO_BASE + 0x04))
#define GPIO_OUT    (*(volatile uint32_t *)(GPIO_BASE + 0x08))

#define EXPECTED_IN     0xDEADBEEFUL
#define TEST_PATTERN    0xA5A5A5A5UL

int main(void)
{
    uint32_t val;

    uart_init();
    uart_puts("GPIO test start\n");

    /* 1. Read gpio_in */
    val = GPIO_DATA;
    if (val != EXPECTED_IN) {
        uart_puts("gpio_in mismatch\n");
        uart_fail();
        return 1;
    }
    uart_puts("gpio_in OK\n");

    /* 2. Set all outputs */
    GPIO_DIR = 0xFFFFFFFFUL;

    /* 3. Write pattern to gpio_out */
    GPIO_OUT = TEST_PATTERN;

    /* 4. Read back gpio_out */
    val = GPIO_OUT;
    if (val != TEST_PATTERN) {
        uart_puts("gpio_out readback mismatch\n");
        uart_fail();
        return 1;
    }
    uart_puts("gpio_out OK\n");

    /* 5. Restore direction to all inputs */
    GPIO_DIR = 0x00000000UL;

    uart_puts("GPIO all checks OK\n");
    uart_pass();
    return 0;
}
