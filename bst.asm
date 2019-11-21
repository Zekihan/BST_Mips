.data
# -9999 marks end of the list
firstList: .word 8, 3, 6, 10, 13, 7, 4, 5, -9999

# other examples for testing your code
secondList: .word 8, 3, 6, 6, 10, 13, 7, 4, 5, -9999
thirdList: .word 8, 3, 6, -9999, 10, 13, 7, 4, 5, -9999
fourthList: .word 8, 3, -3, 6, -10, 13, -7, 4, 5, -9999

# assertEquals data
failf: .asciiz " failed\n"
passf: .asciiz " passed\n"
asertNumber: .word 0

.text
main:
    la $a0, firstList 
    # create root node here and load its address to $a1 and $s0
    jal build

    lw $t0, 4($s0) # real address of the left child of the root
    lw $a0, 0($t0) # real value of the left child of the root
    li $a1, 3 # expected value of the left child of the root
    # if left child != 3 then print failed 
    jal assertEquals

    li $a0, 11
    move $a1, $s0
    jal insert
    lw $a1, 0($v0)
    # if returned address's value != 11 print failed 
    jal assertEquals

    move $a0, $s0
    li $a1, 11
    jal find
    # if returned address's value != 11 print failed 
    lw $a0, 0($v1)
    jal assertEquals

    move $a0, $s0
    li $a1, 44
    jal find
    # if returned value of $v0 != 0 print failed
    move $a0, $v0
    li $a1, 0
    jal assertEquals

    # this test only works with the first 3 lists. 
    # if 4th list is used change the value of $a1 to -10 from 3 before calling last assertEquals
    move $a0, $s0
    li $a1, 0
    jal findMinMax
    # if returned address's value != returned value fail
    lw $a0,0($v1)
    move $a1, $v0
    jal assertEquals
    # if returned address's value != expected value of min node
    lw $a0,0($v1)
    li $a1, 3
    jal assertEquals

    move $a0, $s0
    li $a1, 1
    # if returned address's value != returned value fail
    jal findMinMax
    lw $a0,0($v1)
    move $a1, $v0
    jal assertEquals
    # if returned address's value != expected value of max node
    lw $a0,0($v1)
    li $a1, 13
    jal assertEquals

    move $a0, $s0
    jal print

    li $v0, 10
    syscall

assertEquals:
    move $t2, $a0
    # increment count of total assertions.
    la $t0, asertNumber
    lw $t1, 0($t0)
    addi $t1, $t1, 1
    sw $t1, 0($t0) 
    add $a0, $t1, $zero
    li $v0, 1
    syscall

    # print passed or failed.
    beq $t2, $a1, passed
    la $a0, failf
    li $v0, 4
    syscall
    j $ra
passed:
    la $a0, passf
    li $v0, 4
    syscall
    j $ra


build:
    j $ra


insert:
    j $ra


find:
    j $ra


findMinMax:
    j $ra


print:
    j $ra