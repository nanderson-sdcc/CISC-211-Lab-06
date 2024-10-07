/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* First, we store the values from the registers into memory for dividend and divisor */
    LDR r2, =dividend     
    LDR r3, =divisor       
    STR r0, [r2]           
    STR r1, [r3]          

    /* Initialize quotient and remainder to 0 */
    LDR r2, =quotient      
    LDR r3, =mod           
    MOV r10, 0           
    STR r10, [r2]          
    STR r10, [r3]          

    /* Check for errors: either dividend or divisor being 0 */
    CMP r0, 0             
    BEQ error              
    CMP r1, 0             
    BEQ error         

    /* Division by subtraction method prep*/
    MOV r5, 0 @Initialize quotient counter (r5 = 0)
    
division_algorithm_loop:
    CMP r0, r1             @ Compare dividend with divisor
    BCC store_results      @ If dividend < divisor, go to store_results

    SUBS r0, r0, r1        @ Subtract divisor from dividend
    ADD r5, r5, 1         @ Increment quotient counter
    B division_algorithm_loop

store_results:
    /* Store the final results */
    LDR r2, =quotient      @ Get address of quotient
    STR r5, [r2]           @ Store quotient in memory
    LDR r3, =mod           @ Get address of mod (remainder)
    STR r0, [r3]           @ Store remaining dividend as remainder

    /* Document no error */
    LDR r6, =we_have_a_problem 
    MOV r10, 0          
    STR r10, [r6]
    
    /* Store address of quotient in r0 */
    LDR r0, =quotient
    
    B done

error:
    /* Handle the case where dividend or divisor is 0 */
    LDR r6, =we_have_a_problem @ Get address of we_have_a_problem
    MOV r10, 1            @ Set we_have_a_problem to 1 (error)
    STR r10, [r6]          @ Store 1 in we_have_a_problem

    /* Return the address of quotient in r0 */
    LDR r0, =quotient      @ Load address of quotient into r0
    B done                 @ Branch to done
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




