.global _start

input_address: .skip 0x14  # buffer

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, input_address       # buffer
    li a2, 20          # size
    li a7, 64           # syscall writ2,zerote (64)
    ecall    
    ret

    
exit:
    li a7, 93 #syscall exit (93) \n
    ecall
    ret


le_numero:
    lb t0,0(a1)
    lb t1,1(a1)
    lb t2,2(a1)
    lb t3,3(a1)
    #transformando para int
    addi t0,t0,-48
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    #transformando em numero
    li a3,10
    li a4,100
    li a5,1000
    mul t0,t0,a5
    mul t1,t1,a4
    mul t2,t2,a3
    add t6,t1,t0
    add t6,t6,t2
    add t6,t6,t3
    ret


raiz_quadrada:
    bge t4,t5,continua
    #dividindo y/k
    div s2,t6,s1
    #somando y/k + k
    add s1,s2,s1
    #dividi por 2
    div s1,s1,s0
    #somando o valor em t4
    addi t4,t4,1
    j raiz_quadrada

continua:
    ret

transforma_em_string:
    li t0,0
    li t1,0
    li t2,0
    li t3,0
    li a3,10
    li a4,100
    li a5,1000
    #pegando 1000
    div t0,s1,a5
    #pegando o 0100
    div t1,s1,a4
    rem t1,t1,a3
    #pegando o 0010
    div t2,s1,a3
    rem t2,t2,a3
    #pegando o 0001
    rem t3,s1,a3
    #transformando cada valor em string
    addi t0,t0,48
    addi t1,t1,48
    addi t2,t2,48
    addi t3,t3,48
    #substituindo os valores de a1 pelo resultado
    sb t0,0(a1)
    sb t1,1(a1)
    sb t2,2(a1)
    sb t3,3(a1)
    ret


_start:
    jal read
    #inicializando 
    li t4,0
    li t5,10
    jal le_numero
    #pegando o k
    li s0, 2
    li s1,0
    div s1, t6, s0
    #executando o resto
    jal raiz_quadrada
    jal transforma_em_string
    addi a1,a1,5
    #inicializando 
    li t4,0
    li t5,10
    jal le_numero
    #pegando o k
    li s0, 2
    li s1,0
    div s1, t6, s0
    #executando o resto
    jal raiz_quadrada
    jal transforma_em_string
    addi a1,a1,5
    #inicializando 
    li t4,0
    li t5,10
    jal le_numero
    #pegando o k
    li s0, 2
    li s1,0
    div s1, t6, s0
    #executando o resto
    jal raiz_quadrada
    jal transforma_em_string
    addi a1,a1,5
    #inicializando 
    li t4,0
    li t5,10
    jal le_numero
    #pegando o k
    li s0, 2
    li s1,0
    div s1, t6, s0
    #executando o resto
    jal raiz_quadrada
    jal transforma_em_string
    jal write
    jal exit 
