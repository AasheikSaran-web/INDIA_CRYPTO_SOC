/*
 * uart_print.c — Polled UART print helpers for CRIYA SoC bare-metal tests
 *
 * UART peripheral: PULP APB UART wrapped at AXI-Lite address 0x20000000
 * Register layout (16550-compatible, word-addressed):
 *   0x00  THR  (TX Holding Register, write) / RBR (RX Buffer, read)
 *   0x04  IER  (Interrupt Enable)
 *   0x08  FCR  (FIFO Control, write) / IIR (Interrupt ID, read)
 *   0x0C  LCR  (Line Control)
 *   0x10  MCR  (Modem Control)
 *   0x14  LSR  (Line Status)  — bit 5 = THRE (TX empty/ready)
 *   0x18  MSR  (Modem Status)
 *   0x1C  SCR  (Scratch)
 *   Divisor latch: DLL at 0x00, DLM at 0x04 when LCR bit 7 (DLAB) = 1
 */

#include <stdint.h>

#define UART_BASE       0x20000000UL

#define UART_THR        (*(volatile uint32_t *)(UART_BASE + 0x00))
#define UART_RBR        (*(volatile uint32_t *)(UART_BASE + 0x00))
#define UART_IER        (*(volatile uint32_t *)(UART_BASE + 0x04))
#define UART_FCR        (*(volatile uint32_t *)(UART_BASE + 0x08))
#define UART_LCR        (*(volatile uint32_t *)(UART_BASE + 0x0C))
#define UART_LSR        (*(volatile uint32_t *)(UART_BASE + 0x14))

/* LSR bits */
#define LSR_DR          (1u << 0)   /* Data Ready (RX) */
#define LSR_THRE        (1u << 5)   /* TX Holding Register Empty */

/* LCR bits */
#define LCR_DLAB        (1u << 7)   /* Divisor Latch Access Bit */
#define LCR_8N1         (0x03u)     /* 8-bit, no parity, 1 stop bit */

/*
 * uart_init - configure 115200 8N1 at 100 MHz sim clock
 *
 * divisor = clk_hz / (16 * baud)
 * At 100 MHz sim: divisor = 100_000_000 / (16 * 115200) = ~54
 */
void uart_init(void)
{
    /* Enable DLAB, set divisor */
    UART_LCR = LCR_DLAB;
    /* DLL = 0x36 (54), DLM = 0 */
    UART_THR = 0x36;        /* DLL */
    UART_IER = 0x00;        /* DLM */
    /* 8N1, clear DLAB */
    UART_LCR = LCR_8N1;
    /* Enable and clear FIFOs */
    UART_FCR = 0x07;
    /* Disable interrupts */
    UART_IER = 0x00;
}

/*
 * uart_putchar - poll LSR THRE bit then write one character
 */
void uart_putchar(char c)
{
    /* Wait until TX holding register is empty */
    while (!(UART_LSR & LSR_THRE))
        ;
    UART_THR = (uint32_t)(unsigned char)c;
}

/*
 * uart_puts - transmit a NUL-terminated string
 */
void uart_puts(const char *s)
{
    while (*s)
        uart_putchar(*s++);
}

/*
 * uart_pass - signal test success to the testbench
 */
void uart_pass(void)
{
    uart_puts("PASS\n");
}

/*
 * uart_fail - signal test failure to the testbench
 */
void uart_fail(void)
{
    uart_puts("FAIL\n");
}

/*
 * uart_getchar - blocking receive
 */
char uart_getchar(void)
{
    while (!(UART_LSR & LSR_DR))
        ;
    return (char)(UART_RBR & 0xFF);
}

/*
 * uart_tx_ready - non-blocking TX ready poll
 */
int uart_tx_ready(void)
{
    return (UART_LSR & LSR_THRE) ? 1 : 0;
}

/*
 * uart_rx_ready - non-blocking RX data poll
 */
int uart_rx_ready(void)
{
    return (UART_LSR & LSR_DR) ? 1 : 0;
}
