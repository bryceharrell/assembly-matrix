.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	li t0 5#check for arg line commands
    bne t0 a0 wrong_args#check for arg line commands equivilant to 5
	addi sp sp -56
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
    sw s10 40(sp)
    sw s11 44(sp)
    sw ra 48(sp)
    
    mv s0 a1
    
    #lw s0 4(a1) #load a1[1] into s0
    #lw s1 8(a1) #load a1[2] into s1
    #lw s2 12(a1) #load a1[3] into s2
	#lw s8 16(a1) #load a1[4] into s8
    mv s11 a2 #store print mode in s9
    
    
    sw s11 52(sp)
    
    

	# Read pretrained m0
    li a0 4 #set up a0 for malloc call(rows)
    jal ra malloc # get the malloc call(rows)
    beq a0 x0 malloc_error
    mv s1 a0 # save this block when calling read matrix(rows)
    li a0 4 #set up a0 for malloc call(columns)
    jal ra malloc # get the malloc call(columns)
    beq a0 x0 malloc_error
	mv s2 a0 # save this block when calling read matrix(columns)
	#mv a0 s0 #get file path for m0
    lw a0 4(s0)
    mv a1 s1 #load row pointer for m0
    mv a2 s2 #load column pointer for m0
    jal ra read_matrix
    mv s4 a0 #store the matrix m0 in s4
   
    
    
    #free both mallocs
    #mv a0 s3 #set up to free s3
   	#jal ra free
   # mv a0 s9 #set up to free s9
    #jal ra free
    
    
	# Read pretrained m1
    li a0 4 #set up a0 for malloc call(rows)
    jal ra malloc # get the malloc call(rows)
    beq a0 x0 malloc_error
    mv s3 a0 # save this block when calling read matrix(rows)
    li a0 4 #set up a0 for malloc call(columns)
    jal ra malloc # get the malloc call(columns)
    beq a0 x0 malloc_error
	mv s7 a0 # save this block when calling read matrix(columns)
	#mv a0 s1 #get file path for m1
    lw a0 8(s0)
    mv a1 s3 #load row pointer for m1
    mv a2 s7 #load column pointer for m1
    jal ra read_matrix
    mv s5 a0 #store the matrix m1 in s5
    
    #free both mallocs
    #mv a0 s3 #set up to free s3
   	#jal ra free
    #mv a0 s9 #set up to free s9
    #jal ra free

	# Read input matrix
    li a0 4 #set up a0 for malloc call(rows)
    jal ra malloc # get the malloc call(rows)
    beq a0 x0 malloc_error
    mv s8 a0 # save this block when calling read matrix(rows)
    li a0 4 #set up a0 for malloc call(columns)
    jal ra malloc # get the malloc call(columns)
    beq a0 x0 malloc_error
	mv s9 a0 # save this block when calling read matrix(columns)
	#mv a0 s2 #get file path for m2
    lw a0 12(s0)
    mv a1 s8 #load row pointer for m2
    mv a2 s9 #load column pointer for m2
    jal ra read_matrix
    mv s6 a0 #store the matrix input in s6
    
    #free both mallocs
    #mv a0 s3 #set up to free s3
   	#jal ra free
    #mv a0 s9 #set up to free s9
    #jal ra free


	# Compute h = matmul(m0, input)
    #malloc everything
    lw t1 0(s1) #number of rows in m0
    lw t2 0(s9) #number of columns in input
    mul t3 t1 t2 #num elements
    #mv s7 t3 #store number of elements in array in s7
    addi t0, x0, 4
    mul a0 t3 t0 
    jal ra malloc
    beq a0 x0 malloc_error #return malloc error if malloc returns 0
    #set up all the a registers for matmul
    mv a6 a0 #the matrix where it will be stored
    mv s10 a0 #store matrix pointer in s10 for future use. stores h
    mv a0 s4 #where matrix m0 was stored
    lw a1 0(s1) #s1 holds row # of m0. load as a1 arg
    lw a2 0(s2) #s2 holds col # of m0. load as a2 arg
    #addi a0 s4 8 #s4 + 8 bytes to point to the start of the array (first 8 bytes hold row # and col #)
    mv a3 s6
    lw a4 0(s8) #s8 holds row # of input. load as a4 arg
    lw a5 0(s9) #s9 holds col # of input. load as a5 arg
    #addi a3 s6 8
    jal ra matmul
    #do 


	# Compute h = relu(h)
    # set up the arguments for relu. a0 is already saved.
    # change a1 to number of integers
    mv a0 s10 #move h into a0
    lw t1 0(s1) #number of rows in m0
    lw t2 0(s9) #number of columns in input
    mul t3 t1 t2 #num elements
    mv a1 t3 
    jal ra relu
    
    #mv s0 a0 #save h in s0 because we don't need the old s0 value anymore


	# Compute o = matmul(m1, h)
    
    #malloc everything
    lw t1 0(s3) #number of rows of m1
    lw t2 0(s9) #number of columns of h(number of cols of input)
    mul t3 t1 t2 #num elements
    #mv s8 a0 #store number of elements in array in s7
    addi t0, x0, 4
    mul a0 t3 t0 
    jal ra malloc
    beq a0 x0 malloc_error #return malloc error if malloc returns 0
    
    # set up all the registers for matmul
    mv a6 a0 #set up the the a6 register to hold pointer of returned matrix
    mv s11 a0 #store matrix pointer in s11 for future use (s11 == o)
    #addi a0 s5 8
    mv a0 s5 #where matrix m1 was stored
    lw a1 0(s3) #s3 holds row # for m1. load as a1 arg
    lw a2 0(s7) #s7 holds col # for m1. load as a2 arg
    #mv a3 s5
    mv a3 s10
    lw a4 0(s1) #rows of m0 = h rows. load as a4 arg
    lw a5 0(s9) #cols of input = h cols. load as a5 arg
    jal ra matmul


	# Write output matrix o
    mv a1 s11 #store matrix o inside a1 register
    #mv a0 s8 #store file name into a0
    lw a0 16(s0)
    #matrix o has m1 rows and input cols
    lw a2 0(s3) #load row # in m1. load as a1 arg
    lw a3 0(s9) #load col # of input which is = to col # of h. load as a3 arg
    jal ra write_matrix

	# Compute and return argmax(o)
    mv a0 s11 #move matrix pointer from s11 to a0
    
    
    
    
    #need to find number of ints in o
    lw t0 0(s3) #load row # in m1. load as t0 arg
    lw t1 0(s9) #load col # of input which is = to col # of h. load as t1 arg
    
    mul a1 t0 t1 #set number of elements as o rows multiplied by 0 columns
    jal ra argmax
    mv s0 a0 #save argmax(o) in s0
    
    mv a0 s11 #set up to free s11
    jal ra free
    
    #load print value from s11 because we don't need old value anymore
    lw s11 52(sp)


	# If enabled, print argmax(o) and newline
    bne s11 x0 freeing #make sure to skip printing if print arg(s11) is not 0
    mv a0 s0
    jal ra print_int
    li a0 '\n'
    jal ra print_char
    
    freeing:
    mv a0 s1 #set up to free s1
    jal ra free
    mv a0 s2 #set up to free s2
    jal ra free
    mv a0 s3 #set up to free s3
    jal ra free
    mv a0 s4 #set up to free s4
    jal ra free
    mv a0 s5 #set up to free s5
    jal ra free
    mv a0 s6 #set up to free s6
    jal ra free
    mv a0 s7 #set up to free s7
    jal ra free
    mv a0 s8 #set up to free s8
    jal ra free
    mv a0 s9 #set up to free s9
    jal ra free
    mv a0 s10 #set up to free s10
    jal ra free
    
   
    
	
    mv a0 s0#last line is to store argmax(o) in a0
    
    #epilogue
    
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
    lw s10 40(sp)
    lw s11 44(sp)
    lw ra 48(sp)
    addi sp sp 56
   
    
	jr ra
    
    malloc_error:
    li a0 26
    j exit
    
    wrong_args:
    li a0 31
    j exit
