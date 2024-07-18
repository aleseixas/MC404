.global _system_time
.global _start
.global play_note

.section .bss
.align 4
isr_stack: # Final da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha
isr_stack_end: # Base da pilha das ISRs


.section .data
_system_time: .word 0x0

.section .text
.align 2
.set MIDI_BASE_ADDR,0xFFFF0300
.set GPT_BASE_ADDR,0xFFFF0100


play_note:
    addi sp,sp,-16
    sw s1,0(sp)

    li s1,0xFFFF0300
    sb a0,0x00(s1)  
    sh a1,0x02(s1)
    sb a2,0x04(s1)
    sb a3,0x05(s1)
    sh a4,0x06(s1)

    lw s1,0(sp)
    addi sp,sp,16

    ret


main_isr:
    # Salvar o contexto
    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -64 # Aloca espaço na pilha da ISR
    sw s2,0(sp) 
    sw t0,4(sp)
    sw t1,8(sp)
    sw t2,12(sp)
    sw t3,16(sp)
    sw s3,20(sp)


   # Trata a interrupção

    li s2, 0xFFFF0100
    li t0,1
    sb t0,0x00(s2)
    espera_evento:
        lb t2,0x00(s2)      
        li t3,0           
        bne t3,t2,espera_evento
    
    li t1,100
    sw t1,0x08(s2)
    lw t1,0x04(s2)
    la s3,_system_time
    sw t1,0(s3)

    # Recupera o contexto
    lw s3,20(sp) 
    lw t3,16(sp)
    lw t2,12(sp)
    lw t1,8(sp)
    lw t0,4(sp)
    lw s2,0(sp)
    addi sp, sp, 64 # Desaloca espaço da pilha da ISR

    csrrw sp, mscratch, sp # Troca sp com mscratch novamente
    mret # Retorna da interrupção

_start:
    la t0, main_isr # Carrega o endereço da main_isr
    csrw mtvec, t0 # em mtvec

    la t0, isr_stack_end # t0 <= base da pilha
    csrw mscratch, t0 # mscratch <= t0

    # Habilita Interrupções Externas
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1

    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 3 (MIE)
    ori t1, t1, 0x8 # do registrador mstatus
    csrw mstatus, t1

    #habilitando gpt
    li s2,0xFFFF0100
    li t1,100
    sw t1,0x08(s2)

    jal main


