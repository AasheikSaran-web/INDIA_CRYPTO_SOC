/*
 * trng_health.c — ROSC TRNG health test
 *
 * TRNG register map (base 0x10010000):
 *   +0x00: STATUS  bit[0]=data_ready, bit[1]=rct_pass, bit[2]=apt_pass
 *   +0x04: DATA    random word output (read clears data_ready)
 *
 * Test plan:
 *   1. Wait for data_ready and verify health bits (rct_pass=1, apt_pass=1)
 *   2. Read 8 random words
 *   3. Verify none equal 0x00000000 or 0xFFFFFFFF
 *   4. uart_pass() if all checks pass, uart_fail() otherwise
 */

#include <stdint.h>
#include "common/uart_print.h"

#define TRNG_BASE       0x10010000UL
#define TRNG_STATUS     (*(volatile uint32_t *)(TRNG_BASE + 0x00))
#define TRNG_DATA       (*(volatile uint32_t *)(TRNG_BASE + 0x04))

#define TRNG_DATA_READY (1u << 0)
#define TRNG_RCT_PASS   (1u << 1)
#define TRNG_APT_PASS   (1u << 2)

#define NUM_SAMPLES     8
#define POLL_LIMIT      500000

int main(void)
{
    uint32_t samples[NUM_SAMPLES];
    uint32_t status;
    uint32_t poll;
    int      i;

    uart_init();
    uart_puts("TRNG health test start\n");

    /* 1. Check health test status */
    for (poll = 0; poll < POLL_LIMIT; poll++) {
        status = TRNG_STATUS;
        if (status & TRNG_DATA_READY)
            break;
    }
    if (poll >= POLL_LIMIT) {
        uart_puts("TRNG timeout waiting for data_ready\n");
        uart_fail();
        return 1;
    }

    if (!(status & TRNG_RCT_PASS)) {
        uart_puts("TRNG RCT FAIL\n");
        uart_fail();
        return 1;
    }
    if (!(status & TRNG_APT_PASS)) {
        uart_puts("TRNG APT FAIL\n");
        uart_fail();
        return 1;
    }

    /* 2. Read 8 random words */
    for (i = 0; i < NUM_SAMPLES; i++) {
        /* Wait for data_ready between samples */
        for (poll = 0; poll < POLL_LIMIT; poll++) {
            if (TRNG_STATUS & TRNG_DATA_READY)
                break;
        }
        if (poll >= POLL_LIMIT) {
            uart_puts("TRNG sample timeout\n");
            uart_fail();
            return 1;
        }
        samples[i] = TRNG_DATA;
    }

    /* 3. Trivial quality check: no stuck-at-0 or stuck-at-1 */
    for (i = 0; i < NUM_SAMPLES; i++) {
        if (samples[i] == 0x00000000UL) {
            uart_puts("TRNG: sample is all-zero\n");
            uart_fail();
            return 1;
        }
        if (samples[i] == 0xFFFFFFFFUL) {
            uart_puts("TRNG: sample is all-ones\n");
            uart_fail();
            return 1;
        }
    }

    uart_puts("TRNG all checks OK\n");
    uart_pass();
    return 0;
}
