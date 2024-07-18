.global _start
.data
input_file: .asciz "image.pgm"
outro_file: .skip 262159


.text
read:
    la a1, outro_file #  buffer to write the data
    li a2, 262159  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret

percorre_matriz:
    bge s3, s4, fim 
    #renicia as contagens da coluna
    li s1, 0         
    j loop_colunas       

loop_colunas:
    bge s1, s2, adiciona_s3     
    
    #alterando o a2
    mv a0, s1
    mv a1, s3

    #CASOS DE bordas pretas
    beq s1,zero,preto
    beq s1,s6,preto
    beq s3,zero,preto
    beq s3,s6,preto

    #pegando as valores em cada parte da matriz
    addi s11,s10,-11 #00
    lbu t0,0(s11)
    addi s11,s10,-10 #01
    lbu t1,0(s11)
    addi s11,s10,-9 #02
    lbu t2,0(s11)
    addi s11,s10,-1 #10
    lbu t3,0(s11)
    addi s11,s10,1 #12
    lbu t4,0(s11)
    addi s11,s10,9 #21
    lbu t5,0(s11)
    addi s11,s10,10 #21
    lbu t6,0(s11)
    addi s11,s10,11 #22
    lbu s7,0(s11)

    lbu s8,0(s10)#11

    #sabemos que o s10 é 0 valor central 11
    li s5,8
    mul s8,s8,s5

    #alterando o a2
    li a2, 0
    sub a2,a2,t0
    sub a2,a2,t1
    sub a2,a2,t2
    sub a2,a2,t3
    sub a2,a2,t4
    sub a2,a2,t5
    sub a2,a2,t6
    sub a2,a2,s7
    add a2,a2,s8

    #alterando fazendo a filtragem
    li t1,255
    li t2,0
    bge a2,t1,branco
    blt a2,t2,preto

    #fazendo o outline
    continua:
        mv t0, a2
        li a2, 255
        slli t0, t0, 8
        or a2, a2, t0
        slli t0, t0, 8
        or a2, a2, t0
        slli t0, t0, 8
        or a2, a2, t0
        li a7, 2200             
        ecall

    #adicionando os valores
    addi s1, s1, 1    #avança uma coluna
    addi s11,s11,1  #avança o mout
    addi s10, s10, 1   #avança a mint

    j loop_colunas           

adiciona_s3:
    addi s3, s3, 1         #avança uma linha
    j percorre_matriz     

fim:
    ret

preto:
    li a2,0
    j continua

branco:
    li a2,255
    j continua

setCanvasSize:
    lbu t0,3(s10) #colunas
    lbu t1,4(s10)
    lbu t2,6(s10)#linhas
    lbu t3,7(s10)
    #tornando em int
    addi t0,t0,-48
    addi t1,t1,-48
    addi t2,t2,-48
    addi t3,t3,-48
    #multiplicando os valores
    li s9,10
    mul t0,t0,s9
    mul t2,t2,s9
    add t4,t0,t1 #colunas
    add t5,t2,t3 #linhas
    mv a0,t4
    mv a1,t5
    li a7,2201
    ecall
    ret

_start:
    jal open
    jal read
    la s10,outro_file #será o m out
    mv s11,s10
    jal setCanvasSize

    #valores para o for duplo
    li s1,0 #for para a coluna
    li s2,10
    mv s2,t4
    li s3,0 #for para linha
    mv s4,t5

    addi s10,s10,13

    addi s6, s4, -1
    jal percorre_matriz