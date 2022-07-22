.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

	# Prologue
    
    addi sp sp -24
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw ra 20(sp)
    
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    
    
    
    addi t1, x0, 4
    mul s3, s3, t1 #account for the fact that ints are 4 bytes when moving poiunter
    mul s4, s4, t1 #account for the fact that ints are 4 bytes when moving poiunter
    addi t2, x0, 0 #t2 will hold the value of the total sum
    addi t5, x0, 1 #setting a reg to 0 temporarily
    blt s3, t5, exception
    blt s4, t5, exception
    blt s2, t5, secondException

loop_start:
	beq s2 x0 loop_end
    lw t3 0(s0) #loads value stored in a0 pointer
    lw t4 0(s1) #loads value stored in a1 pointer
    mul t3, t3, t4 #stores the product of the two values in t3 pointer
    add t2, t2, t3 #adds that value to the sum
    addi s2, s2, -1
    add s0, s0, s3 #moves first array pointer
    add s1, s1, s4 #moves second array pointer
    jal x0 loop_start




loop_end:
	mv a0 t2
	# Epilogue
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    sw ra 20(sp)
    addi sp sp 24

	jr ra
    
exception:
	li a0 37
    j exit
secondException:
	li a0 36
    j exit
