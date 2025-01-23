.data
# Número total de notas na música
NUM: .word 64  # Atualize este valor conforme a quantidade total de notas

# Sequência completa de notas (nota MIDI, duração em ms)
NOTAS: 
    # Introdução
    71,400, 76,400, 79,400, 78,400, 76,800,  
    71,400, 76,400, 79,400, 78,400, 76,800,  
    # Parte 1
    71,200, 73,200, 76,400, 74,400, 73,400, 
    71,400, 74,400, 76,800, 78,800,          
    # Parte 2
    79,400, 81,400, 78,400, 76,400,         
    74,400, 76,400, 78,400, 74,800,         
    # Parte 3
    76,200, 78,200, 79,400, 78,400,         
    76,400, 74,400, 73,800, 71,800,   
    
# Timer para pausa entre repetições (em milissegundos)
PAUSE_TIME: .word 5000  # 5 segundos      

.text
.globl _start
_start:
    # Inicialização
    la s0, NUM        # Carrega o endereço do número de notas
    lw s1, 0(s0)      # Lê o número total de notas
    la s0, NOTAS      # Carrega o endereço das notas
    li t0, 0          # Zera o contador de notas
    li a2, 40         # Define o instrumento MIDI (40: flauta)
    li a3, 127        # Define o volume máximo

LOOP_PLAY: 
    # Verifica se todas as notas foram tocadas
    beq t0, s1, END_PLAY  # Se t0 == s1 (fim das notas), vai para END_PLAY

    # Tocar a nota atual
    lw a0, 0(s0)        # Lê a nota MIDI atual
    lw a1, 4(s0)        # Lê a duração da nota atual
    li a7, 31           # Syscall: Tocar nota
    ecall               # Executa a syscall para tocar a nota

    # Pausa após tocar a nota
    mv a0, a1           # Passa a duração para a pausa
    li a7, 32           # Syscall: Pausa
    ecall               # Executa a syscall para pausar

    # Avança para a próxima nota
    addi s0, s0, 8      # Incrementa o endereço para o próximo par (nota/duração)
    addi t0, t0, 1      # Incrementa o contador de notas
    j LOOP_PLAY         # Volta ao início do loop para a próxima nota

END_PLAY:
    # Pausa entre as repetições
    la s0, PAUSE_TIME   # Carrega o endereço do tempo de pausa
    lw a0, 0(s0)        # Lê o tempo de pausa
    li a7, 32           # Syscall: Pausa
    ecall               # Executa a pausa

    # Reinicia o loop principal
    j _start            # Reinicia o programa para tocar a música novamente
