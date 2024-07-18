.section .data
buffer: .skip 200  # buffer

.section .text
.set base,0xFFFF0300


read:
    li t1,1
    li t0,base
    sb t1,0x02(t0)
    #tecnica de busy waiting
    espera_evento:
        lb t2,0x02(t0)      
        li t3,0           
        bne t3,t2,espera_evento 
    lb t0,0x03(t0)
    ret

write:
    li t1,1
    li t0,base
    sb t2,0x01(t0) #print do byte do a2
    sb t1,0x00(t0)
    #tecnica de busy waiting
    
    espera_evento_2:
        lb t3,0(t0)      
        li t4,0           
        bne t3,t4,espera_evento_2 
    ret

atoi:
    li s0,0       
    li s1,10 
    li s3,-1  
    li s4,45     
    
    loop:
        lb s2,0(a0)   #carrega o caractere da string
        beq s2,s4,confere_sinal
        beqz s2,done_atoi   #se o caractere for nulo, encerra 
        addi s2,s2,-48  
        mul s0,s0,s1  
        add s0,s0,s2  
        addi a0,a0,1 
        j loop

done_atoi:
    beq s4,s3,negativo
    mv a0,s0
    ret
    negativo:
        mul s0,s4,s0
        mv a0,s0
        ret

confere_sinal:
    li s4,-1
    addi a0,a0,1 
    j loop

puts:
    li a2,0
    mv a1,a0
    loop_puts:
        lb t2,0(a1)  
        beqz t2,done_puts

        addi sp,sp,-4
        sw ra,0(sp)
        mv t2,a0
        mv a1,a0
        jal write
        lw ra,0(sp)
        addi sp,sp,4

        addi a1,a1,1
        addi a2,a2,1 #para ter o tamanho da string
        j loop_puts

done_puts:
    li t2,10
    sb t2,0(a1) #colocando \n no final da string
    addi a2,a2,1 #para o \n
    mv a0,t2
    ret


gets:
    mv s0,a0
    mv a1,a0 #movendo o parametro para s0

read_char:
    addi sp,sp,-4 #chamando o rotulo utilizando pilha
    sw ra,0(sp)
    jal read
    lw ra,0(sp)
    addi sp,sp,4

    beqz t0,done_g      #se for nulo, encerra a leitura
    li s2,10
    beq t0,s2,done_g  #se for \n, encerra a leitura

    addi a1,a1,1
    #volta para ler o próximo caractere
    j read_char

done_g:
    #adiciona \0 ao final da string
    mv a0,s0
    li t0,0
    sb t0,0(a1)
    ret

valor_negativo:
    li s2,-1
    mul a0,a0,s2
    mul s5,s5,s2
    li s2,45
    sb s2,0(s6)
    addi s6,s6,1
    j tamanho_int



itoa:
    li s3,0 #tamanho do int
    mv t6,a1 #string em t6
    mv t5,a0 #colocando o valor em t5
    li s1, 10      # Número 10 para verificar a base decimal

    #verificando se o valor é negativo
    blt a0,s3,valor_negativo
    tamanho_int:
        div t5,t5,s1
        addi s3,s3,1
        bnez t5,tamanho_int

    #colocando o no final da string /0
    add t6,t6,s3
    li t5,0
    sb t5,0(t6)
    addi t6,t6,-1

    beq a2,s1, decimal  # Verifica a base
    
    j hexadecimal

decimal:
    li s2,10
    beqz s3,done  # Caso especial: valor zero

    rem a3,a0,s2
    div a0,a0,s2
    addi a3,a3,48
    sb a3,0(t6)
    addi t6,t6,-1
    addi s3,s3,-1

    beqz s3, done  # Valor zero (terminado)

    j decimal

hexadecimal:
    li s2, 16
    beqz s3, done  # Caso especial: valor zero

    rem a3,a0,s2
    div a0,a0,s2
    #condições
    li s0,0
    beq a3,s0,D0

    li s0,1
    beq a3,s0,D1

    li s0,2
    beq a3,s0,D2
    
    li s0,3
    beq a3,s0,D3
    
    li s0,4
    beq a3,s0,D4

    li s0,5
    beq a3,s0,D5

    li s0,6
    beq a3,s0,D6

    li s0,7
    beq a3,s0,D7
    
    li s0,8
    beq a3,s0,D8

    li s0,9
    beq a3,s0,D9
    
    li s0,10
    beq a3,s0,DA
    
    li s0,11
    beq a3,s0,DB

    li s0,12
    beq a3,s0,DC
    
    li s0,13
    beq a3,s0,DD
    
    li s0,14
    beq a3,s0,DE

    li s0,15
    beq a3,s0,DF

    voltou:
        sb a3,0(t6)
        addi t6,t6,-1
        addi s3,s3,-1

        beqz s3, done  # Valor zero (terminado)

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

reverse_string:
    ret
calculate_expression:
    ret

_start:
    la a0,buffer
    jal gets
    jal gets
    jal write

    #passsou, agora são as condições
    li s7,49 #1
    li s8,50 #2
    li s9,51 #3
    li s10,52 #4

    # lb s11,0(a0) #carregando o valor de a0

    # beq s7,s11,operation_1
    # beq s8,s11,operation_2
    # beq s9,s11,operation_3
    # beq s10,s11,operation_4

    # operation_1:
    #     jal gets
    #     jal puts
    #     ret

    # operation_2:
    #     jal gets
    #     jal reverse_string
    #     jal puts

    #     ret

    # operation_3:
    #     jal gets
    #     jal atoi
    #     la a1,buffer
    #     li a2,16

    #     jal itoa
    #     jal puts

    #     ret

    # operation_4:
    #     jal gets
    #     jal calculate_expression
    #     jal puts
        
    #     ret
    jal exit

