.equ Mode_USR,        0x10
.equ Mode_FIQ,        0x11
.equ Mode_IRQ,        0x12
.equ Mode_SVC,        0x13
.equ Mode_ABT,        0x17
.equ Mode_UND,        0x1B
.equ Mode_SYS,        0x1F

.section ".text.boot"
/* entry */
.globl _start
_start:
/* Check for HYP mode */
    mrs r0, cpsr_all
    and r0, r0, #0x1F
    mov r8, #0x1A
    cmp r0, r8
    beq overHyped
    b continue

overHyped: /* Get out of HYP mode */
    adr r1, continue
    msr ELR_hyp, r1
    mrs r1, cpsr_all
    and r1, r1, #0x1f    ;@ CPSR_MODE_MASK
    orr r1, r1, #0x13    ;@ CPSR_MODE_SUPERVISOR
    msr SPSR_hyp, r1
    eret

continue:
    /* Suspend the other cpu cores */
    mrc p15, 0, r0, c0, c0, 5
    ands r0, #3
    bne _halt

    /* set the cpu to SVC32 mode and disable interrupt */
    cps #Mode_SVC

    /* disable the data alignment check */
    mrc p15, 0, r1, c1, c0, 0
    bic r1, #(1<<1)
    mcr p15, 0, r1, c1, c0, 0

    /* set stack before our code */
    ldr sp, =_start

    /* clear .bss */
    mov     r0,#0                   /* get a zero                       */
    ldr     r1,=__bss_start         /* bss start                        */
    ldr     r2,=__bss_end           /* bss end                          */

bss_loop:
    cmp     r1,r2                   /* check if data to clear           */
    strlo   r0,[r1],#4              /* clear 4 bytes                    */
    blo     bss_loop                /* loop until done                  */

    /* jump to C code, should not return */
    ldr     pc, _main
    b _halt

_main:
    .word main

_halt:
    wfe
    b _halt
