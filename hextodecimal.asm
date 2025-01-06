    .data 
        prompt_msg: .asciiz "Enter a hexadecimal value.\n" 
        result_msg: .asciiz "The hexadecimal number entered is the decimal value: "
        length_err: .asciiz "More than 8 hex digits entered.\n"
        digit_err: .asciiz "Invalid hex digit: "
        buffer: .space 9  # For user input (8 chars max + null terminator)
    .text
    .globl main

main:
    # Promp the user for an input
    la $a0, prompt_msg          
    li $v0, 4               
    syscall  

    # Read the user input and load into the buffer
    li $v0, 8   
    la $a0, buffer
    li $a1, 9           
    syscall                

    # Initialize temp variables
    li $t0, 0                     # $t0 = i (index) for iterating over buffer
    li $t1, 0                     # $t1 = decimalValue 

check_length:
    # Iterate over the buffer until we hit the null byte then jump to check the index/length
    la $a0, buffer                
    li $t2, 0                     # $t2 = input length
length_loop:
    lb $t3, 0($a0)
    beqz $t3, check_length_done 
    addi $t2, $t2, 1
    addi $a0, $a0, 1
    j length_loop    
check_length_done:
    # If counter is over 8 then jump to invalid length handler
    li $t4, 8
    bgt $t2, $t4, invalid_length

conversion_loop:
    # Iterate over the buffer converting each character to decimal if its valid
    la $a0, buffer
    add $a0, $a0, $t0       # Get the current position in buffer using index "i"
    lb $t5, 0($a0)
    beqz $t5, end_conversion

    # Check if the current character is between '0'-'9', if so convert the ascii value to decimal and store in $t8
    # ('1'-'9' = 48-57)
    li $t6, 48      # ascii '0'
    li $t7, 57      # ascii '9'
    blt $t5, $t6, check_alpha
    bgt $t5, $t7, check_alpha
    sub $t8, $t5, $t6
    j update_decimal

check_alpha:
    # Check if this character is between 'a'-'f', if so convert and store value in $t8
    # ('a'-'f' = 97-102) so 'a' = (97-97+10) = 10, 'b' = (98-97+10) = 11, 'c' = (99-97+10) = 12  etc..
    li $t6, 97      # ascii 'a'
    li $t7, 102     # ascii 'f'
    blt $t5, $t6, invalid_digit
    bgt $t5, $t7, invalid_digit
    sub $t8, $t5, $t6
    addi $t8, $t8, 10  

update_decimal:
    # We now have the character's decimal value (in $t8) which we must add to the total 
    # decimalValue[$t1] = decimalValue[$t1] *16 + characterValue[$t8]
    li $t9, 16
    mul $t1, $t1, $t9
    add $t1, $t1, $t8

    # Increment the buffers index here and go back to the top of the loop
    addi $t0, $t0, 1
    j conversion_loop

invalid_length:
    # Print out the length_err and jump to end of program
    li $v0, 4
    la $a0, length_err
    syscall
    j end_program

invalid_digit:
    # Print out the digit_err
    li $v0, 4
    la $a0, digit_err
    syscall

    # Print out the digit that was bad using the index and then jump to end of program
    move $a0, $t5
    li $v0, 11
    syscall

    j end_program

end_conversion:
    # Happy path after conversion_loop, print result message and total decimal value ($t1) calculated
    li $v0, 4
    la $a0, result_msg
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

end_program:
    li $v0, 10              # Load syscall code 10 to exit
    syscall


