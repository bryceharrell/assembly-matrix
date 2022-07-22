.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue
	addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw ra 16(sp)
    sw s4 20(sp)
    
    mv s0 a0 #put pointer to filename string in s0
    mv s1 a1 #put pointer to matrix in memory in s1
    mv s2 a2 #put number of rows in s2
    mv s3 a3 #put number of cols in s3
    
    #set up arguments for fopen call
    mv a0 s0
    li a1 1
    
    jal ra fopen
    
    li t0 -1
    
    beq a0 t0 fopen_error
    
    mv s4 a0 #put returned file descriptor in s4
    
    
    sw s2 24(sp) #put number of rows on stack for fwrite call
    
    #set up args for rows fwrite call
    mv a0 s4
    addi t0 sp 24
    mv a1 t0
    li a2 1
    li a3 4
    
    jal ra fwrite
    
    li t1 1
    
    bne a0 t1 fwrite_error
    
    
    
    
    
    sw s3 28(sp) #put number of cols on stack for fwrite call
    
    #set up args for cols fwrite call
    mv a0 s4
    addi t0 sp 28
    mv a1 t0
    li a2 1
    li a3 4
    
    jal ra fwrite
    
    li t1 1
    
    bne a0 t1 fwrite_error
    
    
    lw s2 24(sp)
    lw s3 28(sp)
    
    
    #set up args for matrix fwrite call
    mv a0 s4
    mv a1 s1
    mul t0 s2 s3 #determine number of elements to write by finding size of matrix
    mv a2 t0
    li a3 4
    
    jal ra fwrite
    
    mul t0 s2 s3
    
    bne a0 t0 fwrite_error #check that return value equals the size of the matrix
    
    #set up args for fclose call
    mv a0 s4
    
    jal ra fclose
    
    bne a0 x0 fclose_error
    



	# Epilogue

	
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw ra 16(sp)
    lw s4 20(sp)
    addi sp sp 32
	

	ret


fopen_error:
	li a0 27
    j exit
   
fwrite_error:
	li a0 30
    j exit

fclose_error:
	li a0 28
    j exit