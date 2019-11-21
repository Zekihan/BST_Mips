.data
# -9999 marks end of the list
firstList: .word 8, 3, 6, 10, 13, 7, 4, 5, -9999

secondList: .word 8, 9, 6, 10, 13, 7, 4, 5, -9999


# assertEquals data
failf: .asciiz " failed\n"
passf: .asciiz " passed\n"
containsf: .asciiz " Already in the tree\n"
asertNumber: .word 0

.text
main:
	
    la $a0, firstList # load list to a0

	jal create_root
    jal build #build the tree
    
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
	
    li $v0, 10
    syscall

build:
	addi $sp,$sp,-4
	addi $t0,$ra,0 # send ra to 5 lines below
	sw $t0,4($sp)
	
	la $t0, ($a0)
    jal whileloop


create_root:

	#temporaryly move a0 to t0
	la $t0, ($a0)
	li $a0 16 #enough space for four integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	move $a0,$t0
	move $t1,$v0 #load new address to t1

	lw $t2,0($a0) #get first element from list
	sw $t2,0($t1) #put the first number in the list to the tree
	sw $zero, 4($t1) # make parent and child nodes with 0
	sw $zero, 8($t1)
	sw $zero, 12($t1)
	
	la $a1, ($t1) #load a1 with root address
	la $s0, ($t1) #load a1 with root address

	jr $ra
whileloop:
	
	addi $t0,$t0,4
	lw $t1,0($t0)


	beq $t1, -9999, out
	la $t9, ($a1) #load t9 with root address
	jal insert_helper
	j whileloop

out:
	lw $ra,4($sp)
	addi $sp,$sp,4
	jr $ra

insert:
	move $t1,$a0
	jal insert_helper

insert_helper:

	lw $t2,0($t9) # load with root value

	beq $t1,$t2, contains # if its same, print contains
	slt $t3,$t1,$t2
	beq $t3, 1, insert_left # branch if lesser
	sgt $t3,$t1,$t2
	beq $t3, 1, insert_right # branch if greater
	
	jr $ra


contains:
	
	la $a0, containsf
    li $v0, 4
    syscall
    
    jr $ra	

insert_left:
	
	lw $t3,4($t9)
	la $t8,($t9)
	lw $t9,4($t9)
	bne $t3,$zero,insert_helper
	la $t9,($t8)
	
	la $t7, ($a0)
	li $a0 16 #enough space for four integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	move $a0,$t7
	move $t7,$v0

	sw $t1,0($t7) #put the first number in the list to the tree
	sw $zero, 4($t7) # make parent and child nodes with 0
	sw $zero, 8($t7)
	sw $t9, 12($t7)
	sw $t7, 4($t9)
	
	jr $ra
	
insert_right:

	
	lw $t3,8($t9)
	la $t8,($t9)
	lw $t9,8($t9)
	bne $t3,$zero,insert_helper
	la $t9,($t8)
	
	la $t7, ($a0)
	li $a0 16 #enough space for four integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	move $a0,$t7
	move $t7,$v0

	sw $t1,0($t7) #put the first number in the list to the tree
	sw $zero, 4($t7) # make parent and child nodes with 0
	sw $zero, 8($t7)
	sw $t9, 12($t7)
	sw $t7, 8($t9)
	
	jr $ra
		
	
	
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
    jr $ra
passed:
    la $a0, passf
    li $v0, 4
    syscall
    jr $ra
