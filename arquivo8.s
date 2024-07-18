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

    lbu t0, 0(s10)
    
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
    addi s10, s10, 1   #avança a mint

    j loop_colunas           

adiciona_s3:
    addi s3, s3, 1         #avança uma linha
    j percorre_matriz     

fim:
    ret

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
    la s11,outro_file #será o m out
    la s10,outro_file #sera o input
    jal setCanvasSize

    #valores para o for duplo
    li s1,0 #for para a coluna
    mv s2,t4
    li s3,0 #for para linha
    mv s4,t5

    addi s10,s10,13

    jal percorre_matriz