.section .bss
.align 4
isr_stack: # Final da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha
isr_stack_end: # Base da pilha das ISRs

.text
.global get_time_a
.global set_engine_a
.global set_handbrake_a
.global read_sensor_distance_a
.global get_position_a
.global get_rotation_a
.global read_sensors_a
.global write_serial_a
.global read_serial_a
.global int_handler

.text
.align 4
.set SELF_DRIVING_CAR,0xFFFF0300
.set SERIAL_PORT,0xFFFF0500
.set GPT,0xFFFF0100

int_handler:
    # Salvar o contexto
    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -64 # Aloca espaço na pilha
    sw t0, 0(sp) # Salva a0
    sw t1, 4(sp) # Salva a1
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)
    sw t5,20(sp)
    sw t6,24(sp)
    sw s1,28(sp)
    sw s2,32(sp)


    # Trata a interrupção
    li t0,10
    li t1,11
    li t2,12
    li t3,13
    li t4,15
    li t5,16
    li t6,17
    li s1,18
    li s2,20

    beq a7,t0,set_engine_a
    beq a7,t1,set_handbrake_a
    beq a7,t2,read_sensors_a
    beq a7,t3,read_sensor_distance_a
    beq a7,t4,get_position_a
    beq a7,t5,get_rotation_a
    beq a7,t6,read_serial_a
    beq a7,s1,write_serial_a
    beq a7,s2,get_time_a
    

    fim:

    csrr t0, mepc  # load j fimurn address (address of 
                    # the instruction that invoked the syscall)
    addi t0, t0, 4 # adds 4 to the j fimurn address (to j fimurn after ecall) 
    csrw mepc, t0  # stores the j fimurn address back on mepc

    
    # Recupera o contexto
    lw s2,32(sp)
    lw s1,28(sp)
    lw t6,24(sp)
    lw t5,20(sp)
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)

    addi sp, sp, 64 # Desaloca espaço da pilha
    
    csrrw sp, mscratch, sp # Troca sp com mscratch novamente


    mret           # Recover remaining context (pc <- mepc)


.globl _start
_start:

    la t0, int_handler  # Load the address of the routine that will handle interrupts
    csrw mtvec, t0      # (and syscalls) on the register MTVEC to set
                        # the interrupt array.
                        
    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0 # mscratch <= t0

    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, main # Loads the user software
    csrw mepc, t0 # entry point into mepc

    li sp,0x07FFFFFC

    mret # PC <= MEPC; mode <= MPP;


read_serial_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)
    sw t5,20(sp)


    li t1,1
    li t0,SERIAL_PORT

    mv t2,a1 # tamanho buffer
    li t3,0
    #tecnica de busy waiting
    loop_r:
        sb t1,0x02(t0)
        espera_evento_5:
            lb t5,0x02(t0)      
            li t4,0          
            bne t4,t5,espera_evento_5
        lb t4,0x03(t0)
        sb t4,0(a0)
        beqz t4,sai

        addi a0,a0,1
        addi t3,t3,1
        bne t2,t3,loop_r

    sai:
        mv a0,t3

    lw t5,20(sp)
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim


set_engine_a:

    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)

    li t0,2
    li t1,-1
    
    #verificando a vertical
    blt a0,t1,erro #se a0 é menor do a vertical
    bge a0,t0,erro #se t1 é menor que a0 ele vai para erro 

    #verificando a horizontal 
    li t0,127
    li t1,-127
    blt a1,t1,erro #se a1 é menor do a -127
    bge a1,t0,erro #se t1 é menor que a1 ele vai para erro 
    
    li t0,SELF_DRIVING_CAR
    sb a1,0x20(t0)
    sb a0,0x21(t0)
    #desempilha
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    li a0,0
    j fim

    erro:
        #desempilha
        lw t1,4(sp)
        lw t0,0(sp)
        addi sp,sp,64

        li a0,-1
        j fim

erro_brecando:
    li a0,-1
    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    addi sp,sp,64
    j fim    
    
set_handbrake_a:

    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    
    li t0,2
    bge a0,t0,erro_brecando
    blt a0,zero,erro_brecando

    li t0,SELF_DRIVING_CAR
    sb a0,0x22(t0)

    li a0,0

    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    addi sp,sp,64
    j fim


read_sensor_distance_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    li t0,SELF_DRIVING_CAR
    li t4,1
    sb t4,0x02(t0)

    espera_evento:
        lb t2,0x02(t0)      
        li t3,0           
        bne t3,t2,espera_evento 

    lw a0,0x1C(t0)

    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim

get_position_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    li t0,SELF_DRIVING_CAR
    li t4,1
    sb t4,0x00(t0)


    espera_evento_2:
        lb t2,0x00(t0)      
        li t3,0           
        bne t3,t2,espera_evento_2 



    lw t1,0x10(t0)
    lw t2,0x14(t0)
    lw t3,0x18(t0)

    sw t1,0(a0)
    sw t2,0(a1)
    sw t3,0(a2)
    
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim

get_rotation_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    li t0,SELF_DRIVING_CAR
    li t4,1
    sb t4,0x00(t0)

    espera_evento_3:
        lb t2,0x00(t0)      
        li t3,0           
        bne t3,t2,espera_evento_3 

    lw t1,0x04(t0)
    lw t2,0x08(t0)
    lw t3,0x0C(t0)

    sw t1,0(a0)
    sw t2,0(a1)
    sw t3,0(a2)

    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim

get_time_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    li t0,GPT
    li t4,1
    sb t4,0x00(t0)

    espera_evento_4:
        lb t2,0x00(t0)      
        li t3,0           
        bne t3,t2,espera_evento_4 

    lw a0,0x04(t0)
    
    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim



write_serial_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    li t1,1
    li t0,SERIAL_PORT

    mv t2,a1 #tamanho do buffer
    li t3,0
    loop_w:
        lb t4,0(a0)
        sb t4,0x01(t0)
        sb t1,0x00(t0) 
        #tecnica de busy waiting
        espera_evento_6:
            lb t3,0(t0)      
            li t4,0           
            bne t3,t4,espera_evento_6
        addi a0,a0,1
        addi t3,t3,1
        bne t3,t2,loop_w

    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim



read_sensors_a:
    addi sp,sp,-64
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t4,16(sp)

    li t0,SELF_DRIVING_CAR
    li t4,1
    sb t4,0x01(t0)

    espera_evento_7:
        lb t2,0x01(t0)      
        li t3,0           
        bne t3,t2,espera_evento_7
    
    li t4,256
    li t3,0
    addi t0,t0,0x24
    loop:
        lb t1,0(t0)
        sb t1,0(a0)
        #aumentando 1 no buffer e t2
        addi a0,a0,1
        addi t0,t0,1
        addi t3,t3,1

        bne t3,t4,loop

    lw t4,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,64

    j fim

