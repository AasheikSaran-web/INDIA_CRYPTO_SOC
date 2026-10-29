/* crt0.S — Minimal RISC-V startup for CRIYA SoC tests
 *
 * Execution begins at _start which is placed at the start of the .text.start
 * section. The linker script maps this to the SRAM base (0x00010000).
 *
 * All tests boot from SRAM (preloaded by the testbench via $readmemh).
 */

    .section .text.start,"ax",@progbits
    .global _start
    .type   _start, @function

_start:
    /* Initialise stack pointer */
    la      sp, _stack_top

    /* Zero-init .bss section */
    la      a0, _bss_start
    la      a1, _bss_end
    bge     a0, a1, .Lbss_done
.Lbss_loop:
    sw      zero, 0(a0)
    addi    a0, a0, 4
    blt     a0, a1, .Lbss_loop
.Lbss_done:

    /* Call C main */
    call    main

    /* If main returns, spin forever */
.Lhalt:
    j       .Lhalt

    .size _start, . - _start
