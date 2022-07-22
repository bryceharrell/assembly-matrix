.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue
    addi t1, a1, 0
    mv t2 a0
    addi t4, x0, 1
    
    blt a1, t4, exception


loop_start:
	beq t1 x0 loop_end
    lw t3 0(t2)
    blt t3 x0 loop_continue
    addi t2 t2 4
    addi t1, t1, -1
    jal x0 loop_start

loop_continue:
	sw x0 0(t2)
    addi t2 t2 4
    addi t1, t1, -1
    jal x0 loop_start


loop_end:
	mv a0 t2

	# Epilogue

	ret
    
exception:
	li a0 36
    j exit


