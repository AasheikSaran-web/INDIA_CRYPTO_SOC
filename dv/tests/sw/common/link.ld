/* link.ld — Linker script for CRIYA SoC bare-metal tests
 *
 * Places code and data in the SRAM region at 0x00010000 (16K×32 = 64 KiB).
 * Stack grows downward from the top of SRAM.
 *
 * Usage:
 *   riscv32-unknown-elf-gcc -T tests/sw/common/link.ld ...
 */

MEMORY {
    SRAM (rwx) : ORIGIN = 0x00010000, LENGTH = 64K
}

/* Entry point */
ENTRY(_start)

SECTIONS {
    /* --------------------------------------------------------
     * Startup code first, then remaining text
     * -------------------------------------------------------- */
    .text : {
        KEEP(*(.text.start))    /* crt0.S _start */
        *(.text .text.*)
        *(.rodata .rodata.*)
        . = ALIGN(4);
    } > SRAM

    /* --------------------------------------------------------
     * Initialised data
     * -------------------------------------------------------- */
    .data : {
        . = ALIGN(4);
        *(.data .data.*)
        . = ALIGN(4);
    } > SRAM

    /* --------------------------------------------------------
     * Zero-initialised data
     * -------------------------------------------------------- */
    .bss : {
        . = ALIGN(4);
        _bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > SRAM

    /* --------------------------------------------------------
     * Stack at the top of SRAM (grows downward)
     * -------------------------------------------------------- */
    . = ALIGN(16);
    _stack_top = ORIGIN(SRAM) + LENGTH(SRAM);

    /* --------------------------------------------------------
     * Discard unwanted sections
     * -------------------------------------------------------- */
    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}
