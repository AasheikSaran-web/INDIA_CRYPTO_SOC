/*
 * aes_selftest.c — AES-CA accelerator self-test
 *
 * Test vector: AES-256 ECB encryption
 *   Key:        0x00000000_00000000_00000000_00000000
 *               0x00000000_00000000_00000000_00000000  (256-bit all-zero)
 *   Plaintext:  0x00000000_00000000_00000000_00000000  (128-bit all-zero)
 *   Ciphertext: 0xDC95C078_A2408989_AD48A214_92842087  (AES-256 standard)
 *
 * AES-CA register map (base 0x10000000):
 *   +0x00: CTRL   bit[0]=start, bit[1]=key_sel(0=256,1=128), bit[2]=decrypt
 *   +0x04: STATUS bit[0]=done
 *   +0x08: PT[0]  plaintext word 0 (bits 127:96)
 *   +0x0C: PT[1]  plaintext word 1 (bits 95:64)
 *   +0x10: PT[2]  plaintext word 2 (bits 63:32)
 *   +0x14: PT[3]  plaintext word 3 (bits 31:0)
 *   +0x20: KEY[0] key word 0 (bits 255:224)
 *   +0x24: KEY[1] key word 1 (bits 223:192)
 *   +0x28: KEY[2] ...
 *   +0x2C: KEY[3]
 *   +0x30: KEY[4]
 *   +0x34: KEY[5]
 *   +0x38: KEY[6]
 *   +0x3C: KEY[7]  key word 7 (bits 31:0)
 *   +0x40: CT[0]  ciphertext word 0 (bits 127:96)
 *   +0x44: CT[1]
 *   +0x48: CT[2]
 *   +0x4C: CT[3]  ciphertext word 3 (bits 31:0)
 */

#include <stdint.h>
#include "common/uart_print.h"

#define AES_BASE    0x10000000UL

#define AES_CTRL    (*(volatile uint32_t *)(AES_BASE + 0x00))
#define AES_STATUS  (*(volatile uint32_t *)(AES_BASE + 0x04))
#define AES_PT0     (*(volatile uint32_t *)(AES_BASE + 0x08))
#define AES_PT1     (*(volatile uint32_t *)(AES_BASE + 0x0C))
#define AES_PT2     (*(volatile uint32_t *)(AES_BASE + 0x10))
#define AES_PT3     (*(volatile uint32_t *)(AES_BASE + 0x14))
#define AES_KEY0    (*(volatile uint32_t *)(AES_BASE + 0x20))
#define AES_KEY1    (*(volatile uint32_t *)(AES_BASE + 0x24))
#define AES_KEY2    (*(volatile uint32_t *)(AES_BASE + 0x28))
#define AES_KEY3    (*(volatile uint32_t *)(AES_BASE + 0x2C))
#define AES_KEY4    (*(volatile uint32_t *)(AES_BASE + 0x30))
#define AES_KEY5    (*(volatile uint32_t *)(AES_BASE + 0x34))
#define AES_KEY6    (*(volatile uint32_t *)(AES_BASE + 0x38))
#define AES_KEY7    (*(volatile uint32_t *)(AES_BASE + 0x3C))
#define AES_CT0     (*(volatile uint32_t *)(AES_BASE + 0x40))
#define AES_CT1     (*(volatile uint32_t *)(AES_BASE + 0x44))
#define AES_CT2     (*(volatile uint32_t *)(AES_BASE + 0x48))
#define AES_CT3     (*(volatile uint32_t *)(AES_BASE + 0x4C))

#define AES_CTRL_START      (1u << 0)
#define AES_CTRL_KEY128     (1u << 1)   /* 0=AES-256, 1=AES-128 */
#define AES_CTRL_DECRYPT    (1u << 2)
#define AES_STATUS_DONE     (1u << 0)

/* Expected ciphertext for AES-256(all-zero key, all-zero plaintext) */
#define EXP_CT0  0xDC95C078UL
#define EXP_CT1  0xA2408989UL
#define EXP_CT2  0xAD48A214UL
#define EXP_CT3  0x92842087UL

/* Busy-wait limit */
#define POLL_LIMIT  100000

int main(void)
{
    uint32_t ct0, ct1, ct2, ct3;
    uint32_t poll;

    uart_init();
    uart_puts("AES-CA selftest start\n");

    /* 1. Write AES-256 all-zero key */
    AES_KEY0 = 0x00000000UL;
    AES_KEY1 = 0x00000000UL;
    AES_KEY2 = 0x00000000UL;
    AES_KEY3 = 0x00000000UL;
    AES_KEY4 = 0x00000000UL;
    AES_KEY5 = 0x00000000UL;
    AES_KEY6 = 0x00000000UL;
    AES_KEY7 = 0x00000000UL;

    /* 2. Write all-zero plaintext */
    AES_PT0 = 0x00000000UL;
    AES_PT1 = 0x00000000UL;
    AES_PT2 = 0x00000000UL;
    AES_PT3 = 0x00000000UL;

    /* 3. Trigger encryption (AES-256, encrypt mode) */
    AES_CTRL = AES_CTRL_START;   /* key_sel=0 -> AES-256, decrypt=0 -> encrypt */

    /* 4. Poll status done bit */
    for (poll = 0; poll < POLL_LIMIT; poll++) {
        if (AES_STATUS & AES_STATUS_DONE)
            break;
    }
    if (poll >= POLL_LIMIT) {
        uart_puts("AES timeout\n");
        uart_fail();
        return 1;
    }

    /* 5. Read ciphertext */
    ct0 = AES_CT0;
    ct1 = AES_CT1;
    ct2 = AES_CT2;
    ct3 = AES_CT3;

    /* 6. Compare against expected */
    if (ct0 == EXP_CT0 && ct1 == EXP_CT1 &&
        ct2 == EXP_CT2 && ct3 == EXP_CT3) {
        uart_puts("AES match OK\n");
        uart_pass();
        return 0;
    } else {
        uart_puts("AES mismatch\n");
        uart_fail();
        return 1;
    }
}
