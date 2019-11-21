.data
# -9999 marks end of the list
firstList: .word 8, 3, 2, 1, -9999

secondList: .word 8, 9, 6, 10, 13, 7, 4, 5, -9999


# assertEquals data
failf: .asciiz " failed\n"
passf: .asciiz " passed\n"
containsf: .asciiz " Already in the tree\n"
asertNumber: .word 0

.text
main:
	
    la $a0, firstList #load list to a0

    jal build #create root store address at a1
    
    addi $sp,$sp,-4
	addi $t0,$ra,20 # send ra to 5 lines below
	sw $t0,4($sp)
	
	la $t0, ($a0)
    jal whileloop
	
	
    li $v0, 10
    syscall

whileloop:
	
	addi $t0,$t0,4
	lw $t1,0($t0)


	beq $t1, -9999, out
	la $t9, ($a1) #load t9 with root address
	jal insert
	j whileloop

out:
	lw $ra,4($sp)
	addi $sp,$sp,4
	jr $ra
build:

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

insert:

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
	addi $t9,$t9,4
	bne $t3,$zero,insert
	addi $t9,$t9,-4
	
	la $t7, ($a0)
	li $a0 16 #enough space for four integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	move $a0,$t7
	move $t7,$v0

	sw $t1,0($t7) #put the first number in the list to the tree
	sw $zero, 4($t7) # make parent and child nodes with 0
	sw $zero, 8($t7)
	sw $t2, 12($t7)
	sw $t7, 4($t9)
	
	jr $ra
	
insert_right:

	
	lw $t3,8($t9)
	
	bne $t3,$zero,insert
	
	la $t7, ($a0)
	li $a0 16 #enough space for four integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	move $a0,$t7
	move $t2,$v0

	sw $t4,0($t2) #put the first number in the list to the tree
	sw $zero, 4($t2) # make paren and child nodes with 0
	sw $zero, 8($t2)
	sw $t9, 12($t2)
	sw $t2, 8($t9)
	
	la $a1, ($t4)
	
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