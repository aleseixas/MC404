.global _start

input_address: .skip 0x14  # buffer

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 31  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret


write:
    li a0, 1            # file descriptor = 1 (stdout)
    mv a1, s0      # buffer
    li a2, 31          # size
    li a7, 64           # syscall writ2,zerote (64)
    ecall    
    ret
    
exit:
    li a0, 0 #return code \n
    li a7, 93 #syscall exit (93) \n
    ecall
    ret

converte_int:
    li s0,0 #Yb
    li s1,0 #Xc
    li s2,0 #TA
    li s3,0 #TB
    li s4,0 #TC
    li s5,0 #TR
    #pegando os valores e passando para o s

    #multiplos e valor de "-" na tabela ascii
    li a0,1000
    li a4,100
    li a2,10
    li a3,45
    #capturando os valores Yb
    lb t0,0(a1)
    lb t1,1(a1)
    lb t2,2(a1)
    lb t3,3(a1)
    lb t4,4(a1) 
    #convertendo para int
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    addi t4,t4,-48
    mul t1,t1,a0
    mul t2,t2,a4
    mul t3,t3,a2
    add s0,t1,t2
    add s0,s0,t3
    add s0,s0,t4
    #verificando o sinal
    beq a3,t0,negativo_y
    volta_1:
    #capturando os valores Xc
    lb t0,6(a1)
    lb t1,7(a1)
    lb t2,8(a1)
    lb t3,9(a1)
    lb t4,10(a1) 
    #convertendo para int
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    addi t4,t4,-48
    mul t1,t1,a0
    mul t2,t2,a4
    mul t3,t3,a2
    add s1,t1,t2
    add s1,s1,t3
    add s1,s1,t4
    #verificando o sinal
    beq a3,t0,negativo_x
    volta_2:

    #capturando os valores TA
    lb t1,12(a1)
    lb t2,13(a1)
    lb t3,14(a1)
    lb t4,15(a1) 
    #convertendo para int
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    addi t4,t4,-48
    mul t1,t1,a0
    mul t2,t2,a4
    mul t3,t3,a2
    add s2,t1,t2
    add s2,s2,t3
    add s2,s2,t4
    

    #capturando os valores TB
    lb t1,17(a1)
    lb t2,18(a1)
    lb t3,19(a1)
    lb t4,20(a1) 
    #convertendo para int
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    addi t4,t4,-48
    mul t1,t1,a0
    mul t2,t2,a4
    mul t3,t3,a2
    add s3,t1,t2
    add s3,s3,t3
    add s3,s3,t4
    
    #capturando os valores TC
    lb t1,22(a1)
    lb t2,23(a1)
    lb t3,24(a1)
    lb t4,25(a1) 
    #convertendo para int
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    addi t4,t4,-48
    mul t1,t1,a0
    mul t2,t2,a4
    mul t3,t3,a2
    add s4,t1,t2
    add s4,s4,t3
    add s4,s4,t4

    #capturando os valores TR
    lb t1,27(a1)
    lb t2,28(a1)
    lb t3,29(a1)
    lb t4,30(a1) 
    #convertendo para int
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    addi t4,t4,-48
    mul t1,t1,a0
    mul t2,t2,a4
    mul t3,t3,a2
    add s5,t1,t2
    add s5,s5,t3
    add s5,s5,t4
    ret

negativo_y:
    li s10,-1
    mul s0,s0,s10
    j volta_1
    
negativo_x:
    li s10,-1
    mul s1,s1,s10
    j volta_2

distancias:
    #descobrindo os deltas t
    sub s2,s5,s2 #DELTA A
    sub s3,s5,s3 #DELTA B
    sub s4,s5,s4 #DELTA C
    #descobrindo a distancias DA,DB,DC
    #inserindo 3 e 10
    li a0,3
    li a4,10
    #DA
    mul s2,s2,a0
    div s2,s2,a4
    #DB
    mul s3,s3,a0
    div s3,s3,a4
    #DC
    mul s4,s4,a0
    div s4,s4,a4
    ret

achando_posicao:
    #posicao y, salvarei no registrador s6
    #potencias
    mul s2,s2,s2
    mul s3,s3,s3
    mul s0,s0,s0
    # s6 = Yb+DA - DB
    add s6,s2,s0
    sub s6,s6,s3
    # s6 = s6 / 2Yb
    li a0,2
    mul t0,s0,a0
    div s6,s6,t0
    #achamos o Y ,agora procuraremos o x armazenaremos em s7
    #fazendo a operacao de subtracao
    mul t0,s6,s6
    sub s7,s2,t0
    #definindo alguns valores
    li t4,0
    li t5,21
    li t2,2
    div t1,s7,t2 #primeiro k
    #fazendo a raiz quadrada
    j raiz_quadrada
    volta_3:
    mv s7,t1
    #armazenando em s8 o valor negativo
    mv s8,s7
    li a0,-1
    mul s8,s8,a0
    #conferindo qual é o valor correto
    #pegando o Dc^2
    li t0,0
    mul t0,s4,s4
    #calculando caso de X positivo
    sub t1,s7,s1 #(x - xc)
    mul t1,t1,t1
    mul t2,s6,s6
    add t3,t2,t1
    #calculando caso de X negativo 
    sub t1,s8,s1 #(x - xc)
    mul t1,t1,t1
    mul t2,s6,s6
    add t4,t2,t1
    #comparando que valor é mais perto de Dc
    sub t3,t3,t0 #positivo
    sub t4,t4,t0 #negativo
    blt t4,t3,t4_menor
    ret

raiz_quadrada:
    bge t4,t5,continua
    #dividindo y/k
    div t3,s7,t1
    #somando y/k + k
    add t1,t1,t3
    #dividi por 2
    div t1,t1,t2
    #somando o valor em t4
    addi t4,t4,1
    j raiz_quadrada

continua:
    j volta_3

t4_menor:
    mv s7,s8
    ret

voltando_str:
    li s0,0
    li s1,0
    li t0,0
    li t1,0
    li t2,0
    li t3,0
    li t4,32
    li t5,43
    li a3,10
    li a4,100
    li a5,1000
    #vendo se o numero é negativo ou positivo
    blt s6,zero,negativo_s6
    teste:
    #pegando 1000
    div t0,s6,a5
    #pegando o 0100
    div t1,s6,a4
    rem t1,t1,a3
    #pegando o 0010
    div t2,s6,a3
    rem t2,t2,a3
    #pegando o 0001
    rem t3,s6,a3
    #transformando cada valor em string
    addi t0,t0,48
    addi t1,t1,48
    addi t2,t2,48
    addi t3,t3,48
    #substituindo os valores de a1 pelo resultado
    sb t5,0(s0)
    sb t0,1(s0)
    sb t1,2(s0)
    sb t2,3(s0)
    sb t3,4(s0)

    #vendo se o numero é negativo ou positivo
    blt s7,zero,negativo_s7
    teste2:
    #pegando 1000
    div t0,s7,a5
    #pegando o 0100
    div t1,s7,a4
    rem t1,t1,a3
    #pegando o 0010
    div t2,s7,a3
    rem t2,t2,a3
    #pegando o 0001
    rem t3,s7,a3
    #transformando cada valor em string
    addi t0,t0,48
    addi t1,t1,48
    addi t2,t2,48
    addi t3,t3,48
    #substituindo os valores de a1 pelo resultado
    sb t4,5(s0)
    sb t5,6(s0)
    sb t0,7(s0)
    sb t1,8(s0)
    sb t2,9(s0)
    sb t3,10(s0)
    sb a3,11(s0)
    ret

negativo_s6:
    li t5,45
    li s1,-1
    mul s6,s6,s1
    j teste


negativo_s7:
    li t5,45
    li s1,-1
    mul s7,s7,s1
    j teste2

_start:
    jal read
    jal converte_int
    jal distancias
    jal achando_posicao
    jal voltando_str
    jal write
    jal exit