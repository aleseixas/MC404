.section .bss
.align 4
isr_stack: # Final da pilha das ISRs
.skip 1024 # Aloca 1024 bytes para a pilha
isr_stack_end: # Base da pilha das ISRs

.text
.align 4
.set SELF_DRIVING_CAR,0xFFFF0100

int_handler:
    # Salvar o contexto
    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -64 # Aloca espaço na pilha
    sw a0, 0(sp) # Salva a0
    sw a1, 4(sp) # Salva a1

    # Trata a interrupção
    li t0,10
    li t1,11
    beq a7,t1,Syscall_set_handbrake
    done:
    beq a7,t0,Syscall_set_engine_and_steering
    done_2:

    # Recupera o contexto
    lw a1, 4(sp) # Recupera a1
    lw a0, 0(sp) # Recupera a0

    addi sp, sp, 64 # Desaloca espaço da pilha
    
    csrrw sp, mscratch, sp # Troca sp com mscratch novamente

    csrr t0, mepc  # load return address (address of 
                    # the instruction that invoked the syscall)
    addi t0, t0, 4 # adds 4 to the return address (to return after ecall) 
    csrw mepc, t0  # stores the return address back on mepc
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
    la t0, user_main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;

.globl control_logic


Syscall_set_engine_and_steering:
    #Sets the engine direction. e steering
    li s1,SELF_DRIVING_CAR
    li a0,1
    li a1,-120
    sb a1,0x20(s1)
    #fazer um looping para o carro andar
    li t1,1050
    li t0,0
    loop:
        bge t0,t1,end  
        sb a0,0x21(s1) 
        addi t0,t0,1  
        j loop   
    end:
    j done_2


Syscall_set_handbrake:
    #sets the hand break
    li s1,SELF_DRIVING_CAR
    li a0,0
    sb a0,0x22(s1)
    j done

control_logic:
    # implement your control logic here, using only the defined syscalls
    li a7,11
    ecall

    li a7,10
    ecall

    ret

