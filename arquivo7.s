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

decod:
    #os 7 bits que serão manipulados
    li t0,0
    li t1,0
    lb t2,0(a1)
    li t3,0
    lb t4,1(a1)
    lb t5,2(a1)
    lb t6,3(a1)
    # subtraindo o -48
    addi t2,t2,-48
    addi t5,t5,-48
    addi t4,t4,-48
    addi t6,t6,-48
    #verificando se t0,t1 e t3 é 1  0
    xor t0,t2,t4
    xor t0,t0,t6
    #verificando t1
    xor t1,t2,t5
    xor t1,t1,t6
    #verificando em t3
    xor t3,t4,t5
    xor t3,t3,t6
    #voltando para o valor ascii
    addi t0,t0,48
    addi t1,t1,48
    addi t3,t3,48
    addi t2,t2,48
    addi t5,t5,48
    addi t4,t4,48
    addi t6,t6,48
    #escrevendo o valor final em s0
    sb t0,0(s0)
    sb t1,1(s0)
    sb t2,2(s0)
    sb t3,3(s0)
    sb t4,4(s0)
    sb t5,5(s0)
    sb t6,6(s0)
    li s1,10
    sb s1,7(s0)
    ret

processo_inverso:
    li s1,10
    sb s1,12(s0)
    #colocando os novos valores em s0
    lb t0,7(a1)
    lb t1,9(a1)
    lb t2,10(a1)
    lb t3,11(a1)
    sb t0,8(s0)
    sb t1,9(s0)
    sb t2,10(s0)
    sb t3,11(s0)
    ret

verificador:
    xor t4,t1,t2
    xor t4,t4,t3
    bne t0,t4,excecao
    ret
excecao:
    li a0,1
    ret

    
_start:
    #primeira parte
    jal read
    jal decod 
    jal processo_inverso
    li a0, 0
    addi a1, a1, 5
    lb t0,0(a1)#p1
    lb t1,2(a1)#d1
    lb t2,4(a1)#d2
    lb t3,6(a1)#d4
    #mudando para int
    addi t0,t0,-48#p1
    addi t1,t1,-48#d1
    addi t2,t2,-48#d2
    addi t3,t3,-48#d4
    jal verificador
    lb t0, 1(a1)#p2
    lb t2,5(a1)#d3
    #mudando para int
    addi t0,t0,-48
    addi t2,t2,-48
    jal verificador
    lb t0,3(a1)
    lb t1,4(a1)
    #mudando para int
    addi t0,t0,-48
    addi t1,t1,-48
    jal verificador
    #colocando a paridade
    addi a0,a0,48
    li s1,10
    sb a0,13(s0)
    sb s1,14(s0)
    jal write
    jal exit