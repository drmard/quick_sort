    .text
    .align     2
    .global    _qsort
    .type      _qsort, %function

recurs_sort:
    stmdb  sp!,  {r4-r11,lr}
    mov    r4, r1                   @size
    mov    r10,r0                   @
    mov    r3, r1, lsr #1           @r3 - index of mid
    mov    r5, #0                   @r5 - i
    mov    r6, r4
    sub    r6, r6, #1               @r6 - j
    ldr    r11,[r10,r3, lsl #2]     @r11 - mid item

first_cmp:                          @do{

@left side
i_loop:
    ldr    r8, [r10,r5, lsl #2]     @r8 = mas[i]
    cmp    r8, r11                  @(r8 < mid)
    bge    j_loop                   @
    add    r5, r5, #1               @i++
    b      i_loop
@right side
j_loop:
    ldr    r9, [r10,r6, lsl #2]
    cmp    r11,r9                   @r9 = mas[j]
    bge    cmp_f                    @
    sub    r6, r6, #1               @j--
    b      j_loop
cmp_f:
    cmp    r5, r6                   @if(i <= j)
    bgt    mid_cmp
    ldr    r9, [r10, r5, lsl #2]
    ldr    r8, [r10, r6, lsl #2]
    str    r9, [r10, r6, lsl #2]
    str    r8, [r10, r5, lsl #2]
    add    r5, r5, #1
    sub    r6, r6, #1
mid_cmp:
    cmp    r5, r6                   @
    ble    first_cmp

check_one:
    cmp    r6, #0                   @if(j > 0)
    ble    check_two
    mov    r0, r10
    add    r6, r6, #1
    mov    r1, r6
    bl     recurs_sort
check_two:
    cmp    r5, r4
    bge    en_pr
    mov    r7, #4                   @
    mla    r10,r5, r7, r0           @
    mov    r0, r10                  @
    sub    r4, r4, r5
    mov    r1, r4
    bl     recurs_sort

en_pr:
    ldmia  sp!, {r4-r11,pc}         @end of PROC

_qsort:
    push   {r4,ip,lr}
    mov    r10,#0
    mov    r2, r0 
    bl     recurs_sort
    @execute
    mov    r0, r2
    pop    {r4,ip,pc}               @end of main
