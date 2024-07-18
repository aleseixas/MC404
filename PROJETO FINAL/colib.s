.text
.globl gets
.globl puts
.globl atoi
.globl itoa
.globl set_engine
.globl set_handbrake
.globl read_sensor_distance
.globl get_position
.globl get_rotation
.globl get_time
.globl strlen_custom
.globl approx_sqrt
.globl get_distance
.globl fill_and_pop


set_engine:
    addi sp,sp,-64
    sw a7,0(sp)
    sw ra,4(sp)

    li a7,10
    ecall

    lw ra,4(sp)
    lw a7,0(sp)
    addi sp,sp,64
    ret

set_handbrake:
    addi sp,sp,-64
    sw a7,0(sp)
    sw ra,4(sp)

    li  a7,11
    ecall

    lw ra,4(sp)
    lw a7,0(sp)
    addi sp,sp,64
    ret

read_sensor_distance:
    addi sp,sp,-64
    sw a7,0(sp)
    sw ra,4(sp)

    li a7,13
    ecall

    lw ra,4(sp)
    lw a7,0(sp)
    addi sp,sp,64
    ret

get_position:
    addi sp,sp,-64
    sw a7,0(sp)
    sw ra,4(sp)

    li a7,15
    ecall

    lw ra,4(sp)
    lw a7,0(sp)
    addi sp,sp,64
    ret

get_rotation:
    addi sp,sp,-64
    sw a7,0(sp)
    sw ra,4(sp)

    li a7,16
    ecall

    lw ra,4(sp)
    lw a7,0(sp)
    addi sp,sp,64
    ret

get_time:
    addi sp,sp,-64
    sw a7,0(sp)
    sw ra,4(sp)

    li a7,20
    ecall

    lw ra,4(sp)
    lw a7,0(sp)
    addi sp,sp,64
    ret


atoi:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

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

    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    ret

    negativo:
        mul t0,t4,t0
        mv a0,t0

        lw t4,16(sp)
        lw t3,12(sp)
        lw t2,8(sp)
        lw t1,4(sp)
        lw t0,0(sp)
        addi sp,sp,64
        ret

confere_sinal:
    li t4,-1
    addi a0,a0,1 
    j loop


puts:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)
    sw a2,20(sp)
    sw a1,24(sp)
    sw a7,28(sp)
    sw ra,32(sp)

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
    mv a1,a2

    li a7,18
    ecall
    
    lw ra,32(sp)
    lw a7,28(sp)
    lw a1,24(sp)
    lw a2,20(sp)
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64
    
    ret


gets:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)
    sw a1,20(sp)
    sw a7,24(sp)
    sw a0,28(sp)
    sw ra,32(sp)

    mv t0,a0
    mv t3,a0 #movendo o parametro para t0

read_char:
    li a1,1
    mv a0,t3
    li a7,17
    ecall

    lb t1,0(t3)
    li t2,10
    beqz t1,done_g      #se for nulo, encerra a leitura
    beq t1,t2,done_g  #se for \n, encerra a leitura

    addi t3,t3,1
    addi a0,a0,1
    #volta para ler o próximo caractere
    j read_char

done_g:
    #adiciona \0 ao final da string
    mv a0,t0
    li t1,0
    sb t1,0(t3)

    lw ra,32(sp)
    lw a0,28(sp)
    lw a7,24(sp)
    lw a1,20(sp)
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64
    
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
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t5,8(sp)
    sw t3,12(sp)
    sw t6,16(sp)
    sw t2,20(sp)

    li t0,0
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
    addi t0,t0,1

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

    addi t0,t0,1

    beqz t3, done  # Valor zero (terminado)

    voltou:
        sb a3,0(t6)
        addi t6,t6,-1
        addi t3,t3,-1

        beqz t3, done  # Valor zero (terminado)

        j hexadecimal
tira_do_str:
    addi a1,a1,1
    j volta_itoa

done:   
    # Adiciona o caractere nulo ao final da string
    lb t0,0(a1)
    li t1,48
    beq t0,t1,tira_do_str
    volta_itoa:

    mv a0,a1

    lw t2,20(sp)
    lw t6,16(sp)
    lw t3,12(sp)
    lw t5,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

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
    li a3,97
    j voltou
DB:
    li a3,98
    j voltou
DC:
    li a3,99
    j voltou
DD:
    li a3,100
    j voltou
DE: 
    li a3,101
    j voltou
DF:
    li a3,102
    j voltou


strlen_custom:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
  
    li t0,0
    li t1,0
    while_len:
        lb t2,0(a0)
        beq t2,t1,tamanho_str 
        addi a0,a0,1
        addi t0,t0,1
        j while_len

    tamanho_str:
        mv a0,t0

    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64
    ret

approx_sqrt:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)
    sw t5,20(sp)

    mv t0,a0
    li t1,2
    li t2,0
    mv t3,a1
    #valor de k
    div t4,t0,t1

    raiz_quadrada:
        bge t2,t3,continua
        #dividindo y/k
        div t5,t0,t4
        #somando y/k + k
        add t4,t5,t4
        #dividi por 2
        div t4,t4,t1
        #adiciona em t2
        addi t2,t2,1
        j raiz_quadrada

    continua:
        mv a0,t4

    lw t5,20(sp)
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    ret

get_distance:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)
    sw t5,20(sp)
    sw ra,24(sp)
    
    mv t0,a0
    mv t1,a1
    mv t2,a2

    mv t3,a3
    mv t4,a4
    mv t5,a5

    sub t0,t0,t3 #A
    sub t1,t1,t4 #B
    sub t2,t2,t5 #C

    mul t0,t0,t0
    mul t1,t1,t1
    mul t2,t2,t2

    add t0,t0,t1 # SOMA A + B
    add t0,t0,t2 # SOMA (A + B) + C

    mv a0,t0
    li a1,15

    jal approx_sqrt
    
    lw ra,24(sp)
    lw t5,20(sp)
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    ret

fill_and_pop:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    #x
    lw t0, 0(a0)        
    sw t0, 0(a1)   
    #y
    lw t1,4(a0)
    sw t1,4(a1)
    #z
    lw t0, 8(a0)        
    sw t0, 8(a1)   
    #ax
    lw t1,12(a0)
    sw t1,12(a1)
    #ay
    lw t0, 16(a0)        
    sw t0, 16(a1) 
    #az
    lw t1,20(a0)
    sw t1,20(a1)
    #action
    lw t0, 24(a0)        
    sw t0, 24(a1)   
    #no
    lw t1,28(a0)
    sw t1,28(a1)

    mv a0,t1 #retorno 

    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    ret