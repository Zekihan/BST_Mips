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

	jal create_root # create root
    jal build # build the tree
    
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

	addi $sp,$sp,-4 # save ra
	sw $ra,4($sp)
	
	la $t0, ($a0) # load list to t0
    jal whileloop # start loop


create_root:

	
	la $t0, ($a0) # temporaryly move a0 to t0
	li $a0 16 # enough space for four integers
	li $v0 9 # syscall 9 (sbrk)
	syscall
	
	move $a0,$t0
	move $t1,$v0 # load new address to t1

	lw $t2,0($a0) # get first element from list
	sw $t2,0($t1) # put the first number in the list to the tree
	sw $zero, 4($t1) # make parent and child nodes with 0
	sw $zero, 8($t1) 
	sw $zero, 12($t1)
	
	la $a1, ($t1) # load a1 with root address
	la $s0, ($t1) # load s0 with root address

	jr $ra

whileloop:
	
	addi $t0,$t0,4 # do while? starts with index 1 and ++. t0 is list address
	lw $a0,0($t0) # load item to a0


	beq $a0, -9999, out # if -9999 breakout from loop
	jal insert
	j whileloop

out:
	lw $ra,4($sp) # get ra saved from the start of build
	addi $sp,$sp,4
	jr $ra


insert:

	lw $t2,0($a1) # load with root value

	beq $a0,$t2, contains # if its same, print contains
	slt $t3,$a0,$t2
	beq $t3, 1, insert_left # branch if lesser
	sgt $t3,$a0,$t2
	beq $t3, 1, insert_right # branch if greater
	
	jr $ra


contains:
	
	move $t6,$a0 # temporaryly move a0 to t0
	la $a0, containsf # print containsf
    li $v0, 4
    syscall
    move $a0,$t6
    jr $ra	

insert_left:
	
	la $t8,($a1) # temporaryly move t9(current root address) to t8
	lw $a1,4($a1) # take left child address or 0
	bne $a1,$zero,insert # if not zero use that address as new root 
	la $a1,($t8) # if zero use old one as root
	
	la $t7, ($a0) # temporaryly move a0 to t7
	li $a0 16 # enough space for four integers
	li $v0 9 # syscall 9 (sbrk)
	syscall
	
	move $a0,$t7
	move $t7,$v0 # move new address to t7

	sw $a0,0($t7) # the argument first address
	sw $zero, 4($t7) # make children nodes with 0
	sw $zero, 8($t7)
	sw $a1, 12($t7) # make parent node as current node
	sw $t7, 4($a1) # go parents left node make new address
	
	la $a1,($s0) # load original root to a1
	jr $ra
	
insert_right:

	la $t8,($a1) # temporaryly move t9(current root address) to t8
	lw $a1,8($a1) # take left child address or 0
	bne $a1,$zero,insert # if not zero use that address as new root 
	la $a1,($t8) # if zero use old one as root
	
	la $t7, ($a0) # temporaryly move a0 to t7
	li $a0 16 #enough space for four integers
	li $v0 9 #syscall 9 (sbrk)
	syscall
	
	move $a0,$t7
	move $t7,$v0 # move new address to t7

	sw $a0,0($t7) # the argument first address
	sw $zero, 4($t7) # make children nodes with 0
	sw $zero, 8($t7)
	sw $a1, 12($t7) # make parent node as current node
	sw $t7, 8($a1) # go parents left node make new address

	la $a1,($s0) # load original root to a1	
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
