.text
.global puts
.global gets
.global atoi
.global itoa
.global exit
.global recursive_tree_search

read:
    li a0, 0  # file descriptor = 0 (stdin)
    li a2, 1 #size 1 em 1 byte
    li a7, 63 # syscall read (63)
    ecall
    ret

recursive_tree_search:
    addi sp,sp,-4 #empilha o ra
    sw ra,0(sp)
    #caso base
    beqz a0,fim  #verifica se a raiz é nula
    #compara o valor da raiz com x
    #carrega o campo 'dado' da raiz atual
    lw t0,0(a0)
    beq t0,a1,encontrado 

    #chamada recursiva para a esquerda
    lw t3,4(a0)    #carrega o ponteiro para a subárvore esquerda
    lw t4,8(a0)     #carrega o ponteiro para a subárvore direita
    mv a0,t3

    addi sp,sp,-4 #chamando o rotulo utilizando pilha
    sw t4,0(sp)

    jal recursive_tree_search

    beqz a0,busca_filho_d
    addi a0,a0,1

    lw t4,0(sp)
    lw ra,4(sp)
    addi sp,sp,8

    ret
    
encontrado:
    li a0,1
    lw ra,0(sp)
    addi sp,sp,4
    ret

fim:
    li a0,0
    lw ra,0(sp)
    addi sp,sp,4
    ret

busca_filho_d:
    #chamada recursiva para a direita
    lw t4,0(sp)    #carrega o ponteiro para a subárvore direita
    addi sp,sp,4
    mv a0,t4

    jal recursive_tree_search

    beqz a0,fim 

    addi a0,a0,1
    
    lw ra,0(sp)
    addi sp,sp,4

    ret
    

atoi:
    li t0,0       
    li t1,10 
    li t3,-1  
    li t4,45     
    
    loop:
        lb t2,0(a0)   #carrega o caractere da string
        beq t2,t4,confere_sinal
        beqz t2,done_atoi   #se o caractere for nulo, encerra 
        addi t2,t2,-48  
        mul t0,t0,t1  
        add t0,t0,t2  
        addi a0,a0,1 
        j loop

done_atoi:
    beq t4,t3,negativo
    mv a0,t0
    ret
    negativo:
        mul t0,t4,t0
        mv a0,t0
        ret

confere_sinal:
    li t4,-1
    addi a0,a0,1 
    j loop

write:
    li a0,1            # file descriptor = 1 (stdout)
    li a7,64           # syscall writ2,zerote (64)
    ecall    
    ret

puts:
    li a2,0
    mv a1,a0
    loop_puts:
        lb t0,0(a1)  
        beqz t0,done_puts
        addi a1,a1,1
        addi a2,a2,1 #para ter o tamanho da string
        j loop_puts

done_puts:
    li t0,10
    sb t0,0(a1) #colocando \n no final da string
    addi a2,a2,1 #para o \n
    addi sp,sp,-4
    sw ra,0(sp)
    mv t0,a0
    mv a1,a0
    jal write
    lw ra,0(sp)
    addi sp,sp,4
    mv a0,t0
    ret


gets:
    mv t0,a0
    mv a1,a0 #movendo o parametro para t0

read_char:
    addi sp,sp,-4 #chamando o rotulo utilizando pilha
    sw ra,0(sp)
    jal read
    lw ra,0(sp)
    addi sp,sp,4

    lb t1,0(a1)
    beqz t1,done_g      #se for nulo, encerra a leitura
    li t2,10
    beq t1,t2,done_g  #se for \n, encerra a leitura

    addi a1,a1,1
    #volta para ler o próximo caractere
    j read_char

done_g:
    #adiciona \0 ao final da string
    mv a0,t0
    li t1,0
    sb t1,0(a1)
    ret

valor_negativo:
    li t2,-1
    mul a0,a0,t2
    mul t5,t5,t2
    li t2,45
    sb t2,0(t6)
    addi t6,t6,1
    j tamanho_int


itoa:
    li t3,0 #tamanho do int
    mv t6,a1 #string em t6
    mv t5,a0 #colocando o valor em t5
    li t1, 10      # Número 10 para verificar a base decimal

    #verificando se o valor é negativo
    blt a0,t3,valor_negativo
    tamanho_int:
        div t5,t5,t1
        addi t3,t3,1
        bnez t5,tamanho_int

    #colocando o no final da string /0
    add t6,t6,t3
    li t5,0
    sb t5,0(t6)
    addi t6,t6,-1

    beq a2,t1, decimal  # Verifica a base
    
    j hexadecimal

decimal:
    li t2,10
    beqz t3,done  # Caso especial: valor zero

    rem a3,a0,t2
    div a0,a0,t2
    addi a3,a3,48
    sb a3,0(t6)
    addi t6,t6,-1
    addi t3,t3,-1

    beqz t3, done  # Valor zero (terminado)

    j decimal

hexadecimal:
    li t2, 16
    beqz t3, done  # Caso especial: valor zero

    rem a3,a0,t2
    div a0,a0,t2
    #condições
    li t0,0
    beq a3,t0,D0

    li t0,1
    beq a3,t0,D1

    li t0,2
    beq a3,t0,D2
    
    li t0,3
    beq a3,t0,D3
    
    li t0,4
    beq a3,t0,D4

    li t0,5
    beq a3,t0,D5

    li t0,6
    beq a3,t0,D6

    li t0,7
    beq a3,t0,D7
    
    li t0,8
    beq a3,t0,D8

    li t0,9
    beq a3,t0,D9
    
    li t0,10
    beq a3,t0,DA
    
    li t0,11
    beq a3,t0,DB

    li t0,12
    beq a3,t0,DC
    
    li t0,13
    beq a3,t0,DD
    
    li t0,14
    beq a3,t0,DE

    li t0,15
    beq a3,t0,DF

    voltou:
        sb a3,0(t6)
        addi t6,t6,-1
        addi t3,t3,-1

        beqz t3, done  # Valor zero (terminado)

        j hexadecimal

done:
    # Adiciona o caractere nulo ao final da string
    mv a0,a1
    ret

D0: 
    li a3,48
    j voltou

D1:
    li a3,49
    j voltou
D2:
    li a3,50
    j voltou
D3:
    li a3,51
    j voltou
D4:
    li a3,52
    j voltou
D5:
    li a3,53
    j voltou
D6:
    li a3,54
    j voltou
D7:
    li a3,55
    j voltou
D8:
    li a3,56
    j voltou
D9:
    li a3,57
    j voltou
DA:
    li a3,65
    j voltou
DB:
    li a3,66
    j voltou
DC:
    li a3,67
    j voltou
DD:
    li a3,68
    j voltou
DE: 
    li a3,69
    j voltou
DF:
    li a3,70
    j voltou

exit:
    li a7,93 #syscall exit (93) \n
    ecall
    ret


