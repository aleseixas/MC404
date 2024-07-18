.globl head_node
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
    la a1, input_address             # buffer
    li a2, 20          # size
    li a7, 64           # syscall writ2,zerote (64)
    ecall    
    ret


    
exit:
    li a0, 0 #return code \n
    li a7, 93 #syscall exit (93) \n
    ecall
    ret

converte_int:
    li s5,0 #ENTRADA
    li t0,0
    li t1,0
    li t2,0
    li t3,0
    li t4,0
    li t5,0
    #pegando os valores e passando para o s
    #multiplos e valor de "-" na tabela ascii
    li a2,10000
    li a3,1000
    li a4,100
    li a5,10
    li a6,45
    #capturando os valores 
    lb t0,0(a1)
    lb t1,1(a1)
    lb t2,2(a1)
    lb t3,3(a1)
    lb t4,4(a1) 
    lb t5,5(a1)
    lb t6,6(a1)
    #verificando sinal
    beq a6,t0,negativo
    #numero de digitos
    beq a5,t1,D_1
    beq a5,t2,D_2
    beq a5,t3,D_3
    beq a5,t4,D_4
    beq a5,t5,D_5
    D_1:
        addi t0,t0,-48
        add s5,t0,zero
        ret
    D_2:
        addi t0,t0,-48
        addi t1,t1,-48
        mul t0,t0,a5
        add s5,t0,t1
        ret
    D_3:
        addi t0,t0,-48
        addi t1,t1,-48
        addi t2,t2,-48
        mul t0,t0,a4
        mul t1,t1,a5
        add s5,t0,t1
        add s5,s5,t2
        ret
    D_4:  
        addi t0,t0,-48
        addi t1,t1,-48
        addi t2,t2,-48
        addi t3,t3,-48
        mul t0,t0,a3
        mul t1,t1,a4
        mul t2,t2,a5
        add s5,t0,t1
        add s5,s5,t2
        add s5,s5,t3
        ret
    D_5:
        addi t0,t0,-48
        addi t1,t1,-48
        addi t2,t2,-48
        addi t3,t3,-48
        addi t4,t4,-48
        mul t0,t0,a2
        mul t1,t1,a3
        mul t2,t2,a4
        mul t3,t3,a5
        add s5,t0,t1
        add s5,s5,t2
        add s5,s5,t3
        add s5,s5,t4
        ret

negativo:
    beq a5,t2,DN_1
    beq a5,t3,DN_2
    beq a5,t4,DN_3
    beq a5,t5,DN_4
    beq a5,t6,DN_5
    DN_1:
        addi t1,t1,-48
        add s5,t1,zero
        li s10,-1
        mul s5,s5,s10
        ret
    DN_2:
        addi t2,t2,-48
        addi t1,t1,-48
        mul t1,t1,a5
        add s5,t1,t2
        li s10,-1
        mul s5,s5,s10
        ret
    DN_3:
        addi t3,t3,-48
        addi t1,t1,-48
        addi t2,t2,-48
        mul t1,t1,a4
        mul t2,t2,a5
        add s5,t1,t2
        add s5,s5,t3
        li s10,-1
        mul s5,s5,s10
        ret

    DN_4:  
        addi t4,t4,-48
        addi t1,t1,-48
        addi t2,t2,-48
        addi t3,t3,-48
        mul t1,t1,a3
        mul t2,t2,a4
        mul t3,t3,a5
        add s5,t1,t2
        add s5,s5,t3
        add s5,s5,t4
        li s10,-1
        mul s5,s5,s10
        ret
    DN_5:
        addi t5,t5,-48
        addi t1,t1,-48
        addi t2,t2,-48
        addi t3,t3,-48
        addi t4,t4,-48
        mul t1,t1,a2
        mul t2,t2,a3
        mul t3,t3,a4
        mul t4,t4,a5
        add s5,t1,t2
        add s5,s5,t3
        add s5,s5,t4
        add s5,s5,t5
        li s10,-1
        mul s5,s5,s10
        ret
    

voltando_str:
    li s1,0
    li s2,-1
    li t1,0
    li t2,0
    li t3,0
    li a3,10
    li a4,100
    li a5,0
    #verificando se achou o valor
    beq s0,s2,n_achou
    j achou
    achou:
    #verificando o numero de digitos
    li s2,10
    blt s0,s2,digito_1
    j continua_2
    continua_2:
    li s2,100
    blt s0,s2,digito_2
    j continua_3
    continua_3:
    #pegando o 100
    div t1,s0,a4
    #pegando o 010
    div t2,s0,a3
    rem t2,t2,a3
    #pegando o 001
    rem t3,s0,a3
    #transformando cada valor em string
    addi t1,t1,48
    addi t2,t2,48
    addi t3,t3,48
    #substituindo os valores de a1 pelo resultado
    sb t1,0(a1)
    sb t2,1(a1)
    sb t3,2(a1)
    sb a3,3(a1)
    sb a5,4(a1)
    sb a5,5(a1)
    ret


n_achou:
    li t1,45
    li t2,49
    sb t1,0(a1)
    sb t2,1(a1)
    sb a3,2(a1)
    sb a5,3(a1)
    sb a5,4(a1)
    sb a5,5(a1)
    ret
    #j acabou

digito_2:
    #pegando o 010
    div t2,s0,a3
    #pegando o 001
    rem t1,s0,a3
    addi t1,t1,48
    addi t2,t2,48
    sb t2,0(a1)
    sb t1,1(a1)
    sb a3,2(a1)
    sb a5,4(a1)
    sb a5,5(a1)
    sb a5,6(a1)
    ret
    #j acabou

digito_1: 
    rem t1,s0,a3
    addi t1,t1,48
    sb t1,0(a1)
    sb a3,1(a1)
    sb a5,2(a1)
    sb a5,3(a1)
    sb a5,4(a1)
    ret
    #j acabou

loop:
    beqz s1,fim
    lw t1,0(s1)
    lw t2,4(s1)
    lw s1,8(s1)
    addi s4,s4,1
    add s3,t2,t1#valor a ser comparado
    beq s3,s5,existe
    j loop

fim:
    li s0,-1
    ret

existe:
    addi s4,s4,-1
    mv s0,s4
    ret

_start:
    la s1,head_node
    jal read
    jal converte_int
    li s0,0
    li s4,0
    jal loop
    jal voltando_str
    jal write
    jal exit