.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

	# Prologue
	addi sp sp -28
    sw s0 0(sp)
    sw s1 4(sp)
    sw ra 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    
    
    
    mv s0 a1 #store a1 and a2 args in s0 and s1
    mv s1 a2
    
    li s2 -1 
	
    li a1 0 #set a1 to 0 for read only
    
    jal ra fopen
    
    mv s3 a0 #store returned file descriptor in s3
    
    beq s3 s2 fopen_error #check if return value equals -1

	
    mv a0 s3 #set up arguments for first call to fread
    mv a1 s0
    li a2 4
    jal ra fread
    
    li t3 4
    
    bne a0 t3 fread_error
    
    mv a0 s3 #set up arguments for second call to fread
    mv a1 s1
    li a2 4
    jal ra fread
    
    li t3 4
    
    bne a0 t3 fread_error
    
    lw t0 0(s0)
    lw t1 0(s1)
    
    mul t4 t0 t1 #multiply amount of rows x amount of cols to get matrix size
    li t5 4
    mul s4 t4 t5 #multiply by 4 to account for bytes
    
    mv a0 s4
    jal ra malloc
    
    beq a0 x0 malloc_error
    
    mv s5 a0 #store memory pointer in s4
    
    mv a0 s3
    mv a1 s5
    mv a2 s4
    jal ra fread
    
    bne a0 s4 fread_error
    
    mv a0 s3
    jal ra fclose
    
    bne a0 x0 fclose_error
    
    
    mv a0 s5 #put memory pointer in a0
    
	





	# Epilogue
    
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw ra 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    addi sp sp 28

	ret
    
    
    fopen_error:
    li a0 27
    j exit
    
    fread_error:
    li a0 29
    j exit
    
    malloc_error:
    li a0 26
    j exit
    
    fclose_error:
    li a0 28
    j exit
