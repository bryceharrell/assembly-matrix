.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
	addi t1 x0 1 #set temp register to 1 for error checks
	# Error checks
    blt a1 t1 exception #check if # of rows in first array is less than 1
    blt a2 t1 exception #check if # of cols in first array is less than 1
    blt a4 t1 exception #check if # of rows in second array is less than 1
    blt a5 t1 exception #check if # of cols in second array is less than 1
    bne a2 a4 exception #check if dimensions of m0 and m1 don't match
    
	# Prologue
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw ra 40(sp)
    sw s10 44(sp)
    
    
    mv s0 a1 #move a1 to saved reg to not lose value when setting up args for dot
    mv s1 a2 #move a2 to saved reg to not lose value when setting up args for dot
    mv s2 a4 #move a4 to saved reg to not lose value when setting up args for dot
    mv s3 a5 #move a5 to saved reg to not lose value when setting up args for dot
    mv s4 a0 #move a0 to saved reg to not lose value after calling dot
    mv s7 a3 #move a3 to saved reg to not lose value when setting up args for dot
    mv s10 a3 #need a3 stored in two saved vars; one to hold start of array and one to increment
    
    mv s8 t1 #set a saved register to 1 for future use
    mv s9 a6 #move a6 to saved reg
    
    
    mv a1 a3 #put pointer of m1 into a1 for dot func
    mv a2 s1 #set col # of m0 to number of elems in dot func
    mv a3 s8 #set stride of first array to 1
    mv a4 s3 #set stride of second array to # of cols in m1
    
    mv s5 s0 #set row index variable of m0 for looping
    


outer_loop_start:
	beq s5 x0 outer_loop_end #while(row_index > 0)
    
    mv s6 s3 #set column index variable of m1 for looping
	j inner_loop_start
    
    
    


    inner_loop_start:
        beq s6 x0 inner_loop_end # while (col_index > 0)
        jal ra dot
        sw a0 0(s9) #store value of dot(row(i), col(j)) in d
        addi s9 s9 4 #increment index pointer in d

        mv a0 s4 #put m0 index pointer in a0
        addi s7 s7 4 #increment index pointer of m1
        mv a1 s7 
        
        mv a2 s1 #set these vars again for calling convention
    	mv a3 s8 #set these vars again for calling convention
    	mv a4 s3 #set these vars again for calling convention
        
        addi s6 s6 -1 #decrement column index var

        j inner_loop_start




    inner_loop_end:
        addi s5 s5 -1 #decrement row index
        addi t0 x0 0
        addi t0 t0 4
        mul t0 t0 s1
        add s4 s4 t0 #increment m0 index pointer by size # of cols in m0 * 4

        mv a0 s4 #put m0 index pointer in a0
        mv a1 s10 #put m1 start of array pointer in a1
        mv s7 s10 #reset s7 to start for incrementing in next iteration

        j outer_loop_start




outer_loop_end:


	# Epilogue
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw ra 40(sp)
    lw s10 44(sp)
    addi sp sp 48
    
  

	jr ra
    
exception:
	li a0 38
    j exit
