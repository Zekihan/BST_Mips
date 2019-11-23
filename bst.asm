.data
# -9999 marks end of the list
firstList: .word 8, 3, 6, 10, 13, 7, 4, 5, -9999

# assertEquals data
containsf: .asciiz "Already in the tree\n"
insertf:    .asciiz "Please enter the number to be inserted: "
insertf2:    .asciiz "New node added with address of \""
insertf3:    .asciiz "\" \n"
findf:    .asciiz "Please enter the number to be find: "
findf2:    .asciiz "Node find in address \""
findf3:    .asciiz "\" \n"
findMinMaxf:    .asciiz "Please enter the number 0 for min 1 for max: "
findMinMaxf2:    .asciiz "Max value is \""
findMinMaxf3:    .asciiz "Min value is \""
findMinMaxf4:    .asciiz "\" with address \""
findMinMaxf5:    .asciiz "\" \n"
printf:    .asciiz "Tree :\n"
notfoundf:    .asciiz "Value is not found\n"
menuf:      .asciiz "Please choose a procedure:\n\t1)Insert\n\t2)Find\n\t3)FindMinMax\n\t4)Print\nEnter the number you choose: "
asertNumber: .word 0

.text
main:
	
    la $a0, firstList # load list to a0

	jal create_root # create root
    jal build # build the tree
    
    jal menu
    
	li $v0, 10
    syscall
   
print:
    
    jr $ra

menu:

	li $v0, 4     #command for printing a string
    la $a0, menuf #loading the string to print into the argument to enable printing
    syscall
    
    #the next block of code is for reading the first number provided by the user
    li $v0, 5    #command for reading an integer
    syscall      #executing the command for reading an integer
    move $t0, $v0     #moving the number read from the user input into the temporary register $t0
    
    beq $t0,1,get_insert_input
    beq $t0,2,get_find_input
    beq $t0,3,get_findMinMax_input
    beq $t0,4,get_print
    
    li $v0, 10
    syscall
get_print:
	li $v0, 4     #command for printing a string
    la $a0, printf #loading the string to print into the argument to enable printing
    jal print
    syscall
    
    j menu
get_findMinMax_input:
	li $v0, 4     #command for printing a string
    la $a0, findMinMaxf #loading the string to print into the argument to enable printing
    syscall
    
    #the next block of code is for reading the first number provided by the user
    li $v0, 5    #command for reading an integer
    syscall      #executing the command for reading an integer
    move $a1, $v0
    
    move $a0, $s0
    jal findMinMax
    
    move $t0,$v0
    move $t1,$v1
    
    beqz $a0,min_print
    
    li $v0, 4     #command for printing a string
    la $a0, findMinMaxf2 #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 1    #command for printing a string
    la $a0, ($t0) #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 4     #command for printing a string
    la $a0, findMinMaxf4 #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 1    #command for printing a string
    la $a0, ($t1) #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 4     #command for printing a string
    la $a0, findMinMaxf5 #loading the string to print into the argument to enable printing
    syscall
    
    j menu
min_print:
	li $v0, 4     #command for printing a string
    la $a0, findMinMaxf3 #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 1    #command for printing a string
    la $a0, ($t0) #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 4     #command for printing a string
    la $a0, findMinMaxf4 #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 1    #command for printing a string
    la $a0, ($t1) #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 4     #command for printing a string
    la $a0, findMinMaxf5 #loading the string to print into the argument to enable printing
    syscall
    
    j menu
get_find_input:

	li $t0,0
	li $v1,0
	
	li $v0, 4     #command for printing a string
    la $a0, findf #loading the string to print into the argument to enable printing
    syscall
    
    #the next block of code is for reading the first number provided by the user
    li $v0, 5    #command for reading an integer
    syscall      #executing the command for reading an integer
    move $a1, $v0
    
    move $a0, $s0
    jal find
    
    move $t0,$v1
    
    beqz $t0,menu
    
    li $v0, 4     #command for printing a string
    la $a0, findf2 #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 1    #command for printing a string
    la $a0, ($t0) #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 4     #command for printing a string
    la $a0, findf3 #loading the string to print into the argument to enable printing
    syscall
    
    j menu
   
get_insert_input:
	li $v0, 4     #command for printing a string
    la $a0, insertf #loading the string to print into the argument to enable printing
    syscall
    
    #the next block of code is for reading the first number provided by the user
    li $v0, 5    #command for reading an integer
    syscall      #executing the command for reading an integer
    move $a0, $v0
    
    move $a1, $s0
    jal insert
    
    move $t0,$v0
    
    beqz $t0,menu
    
    li $v0, 4     #command for printing a string
    la $a0, insertf2 #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 1    #command for printing a string
    la $a0, ($t0) #loading the string to print into the argument to enable printing
    syscall
    
    li $v0, 4     #command for printing a string
    la $a0, insertf3 #loading the string to print into the argument to enable printing
    syscall
    
    j menu
		
findMinMax:
	
	lw $v0,($a0) # load root value to v0
	la $v1,($a0) # load root address to v1
	
	beq $a1,$zero,find_min # if a1 is 0 find min
	beq $a1,1,find_max # if a1 iz 1 find max
find_min:
	beq $zero,$a0, reached # check if reached a 0 value
	lw $v0,($a0) # load node value to v0
	la $v1,($a0) # load node address to v1
	lw $a0,4($a0) # load left node
	
	j find_min
find_max:
	beq $zero,$a0, reached # check if reached a 0 value
	lw $v0,($a0) # load node value to v0
	la $v1,($a0) # load node address to v1
	lw $a0,8($a0) # load right node
	
	j find_max
reached:
	jr $ra
find:
	lw $t2,0($a0) # load with root value

	beq $zero,$t2, notfound # if root is empty not found
	beq $a1,$t2, found # if its same, print contains
	slt $t3,$a1,$t2
	beq $t3, 1, find_left # branch if lesser
	sgt $t3,$a1,$t2
	beq $t3, 1, find_right # branch if greater
	
	jr $ra

find_left:
	lw $a0,4($a0) # make left child current root
	beq $a0,$zero,notfound # if zero not found
	lw $t7,0($a0) # take roots value
	j find

find_right:
	lw $a0,8($a0) # make right child current root
	beq $a0,$zero,notfound
	lw $t7,0($a0) # take roots value
	j find 

found:
	li $v0,1 # make return v0 1
	la $v1,($a0) # make return v1 the address of node
	jr $ra
notfound:

    li $v0, 4     #command for printing a string
    la $a0, notfoundf #loading the string to print into the argument to enable printing
    syscall
    
	li $v0,0 # make return v0 0
	jr $ra
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
    la $a1,($s0)
    li $v0,0
    jr $ra	

insert_left:
	
	la $t8,($a1) # temporaryly move current root address to t8
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

	la $t8,($a1) # temporaryly move current root address to t8
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