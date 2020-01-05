    .text
    .align      4
    .global     qsort_ins
    .type       qsort_ins, %function

qsort_ins:
    stp     x29, x30, [sp, -16]!
    add     x29, sp, #0

    sub     x9,  x9, x9
    mov     x10, x0
    mov     w2,  #0
    mov     w3,  #0
    mov     w4,  #0
cycle_for:
    add     w4,  w4, 1
    cmp     w4,  w1
    bge     finn
    lsl     x14, x4, 3
    ldr     w2,  [x10, x14]
    sub     w3,  w4, 0x1
cont1:
    cmp     w3,  0
    b.lt    cycle_for

    lsl     x13, x3, 3
    ldr     w6,  [x10, x13]

    cmp     w2,  w6
    b.ge    cycle_for

    add     w9,  w3, 0x1
    sub     x13, x13, x13
    lsl     x13, x9, 3
    str     w6,  [x10, x13]
    sub     w3,  w3, 1
    mov     w9,  w3
    add     w9,  w9, 1
    lsl     x15, x9, 3
    str     w2,  [x10, x15]
    b       cont1

finn:
    mov     x0,  x10
    ldp     x29, x30, [sp], #16
    ret
