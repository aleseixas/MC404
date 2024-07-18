.set SELF_DRIVING_CAR,0xFFFF0100

 

_start:

    li a0,SELF_DRIVING_CAR

    #ativa o GPS para ler as coordenadas e a rotaÃ§Ã£o do carro.

    li a1,1

    sb a1,0x00(a0)  

 

    #desativar o freio de mÃ£o

    li a1,0

    sb a1,0x22(a0)

 

    #configurar a direÃ§Ã£o do volante para reto

    li a1,-74

    sb a1,0x20(a0)

 

    #fazer um looping para o carro andar

    li t1,10500

    li t0,0

    loop:

        bge t0,t1,end  

        li a1,1

        sb a1,0x21(a0)

        addi t0,t0,1  

        j loop          

 

    end:

    exit:

        li a0,0

        li a7, 93 #syscall exit (93) \n

        ecall

        ret

 