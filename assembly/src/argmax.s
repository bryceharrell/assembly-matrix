.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue
    addi t1, a1, 0 #storing the number of elements in t1 register
    mv t2 a0 #stores the pointer to starting array
    addi t4, x0, 1 #check for exception
    
    blt a1, t4, exception


loop_start:
	lw t3 0(t2) #loads value stored in t2 pointer(gonna hold maximum value
    addi t4, x0, 0 #set t4 to indicate the index containing largest value)
    addi t5, x0, 0 #set t5 to index value 0
    addi t2 t2 4 #go to next thing in array
    addi t1, t1, -1
	
loop_continue:
	beq t1 x0 loop_end
    addi t5, t5, 1 #increments index value
    lw t6 0(t2) #loads value stored in t2 pointer
    blt t3 t6 change
    addi t2 t2 4
    addi t1, t1, -1
    jal x0 loop_continue

change:
	mv t3 t6 
    mv t4 t5
    addi t2 t2 4
    addi t1, t1, -1
    jal x0 loop_continue
	
loop_end:
	mv a0 t4
	# Epilogue

	ret
    
exception:
	li a0 36
    j exit
