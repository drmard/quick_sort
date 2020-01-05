    .text
    .align     2
    .global    qsort_ins
    .type      qsort_ins, %function
    
insertion_sort:
    stmdb  sp!,  {r3-r11,lr}
    mov    r10,r0                   @address of data[0]
    mov    r2, #0                   @r2 - key
    mov    r3, #0                   @i 
    mov    r4, #1                   @j

cicle_for:
    cmp    r4, r1                   @check of size
    bge    finn                     @goto end
    ldr    r2, [r10,r4, lsl #2]     @save key
    sub    r3, r4, #1

cont1:
    cmp    r3, #0                   @first cond. of cycle
    addlt  r4, r4, #1               @j++
    blt    cicle_for                @

    ldr    r6, [r10,r3, lsl #2]     @

    cmp    r2, r6                   @second cond. of cycle
    addge  r4, r4, #1               @j++
    bge    cicle_for                @
 
    add    r9, r3, #1               @i++ -> r9
    str    r6, [r10,r9, lsl #2]     @data[i + 1] = data[i]
    sub    r3, r3, #1               @i = i - 1
    mov    r9, r3                   @i
    add    r9, r9, #1               @i++
    str    r2, [r10,r9, lsl #2]     @data[i + 1] = key
    b      cont1                    @continue cycle
    
finn:
    mov    r0, r10
    ldmia  sp!, {r3-r11,pc}         @end of insertion_sort PROC

qsort_ins:
    push   {r4,ip,lr}
    mov    r3, r0 
    bl     insertion_sort

    @restore r0
    mov    r0, r3
    pop    {r4,ip,pc}
