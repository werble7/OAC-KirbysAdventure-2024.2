.data
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

NUM_NOTAS: .word 64  # Número total de notas na sequência

.text
# Definição da função para tocar a música
tocar_musica:
    # Carrega o número total de notas
    la s0, NUM_NOTAS  # Carrega o endereço de NUM_NOTAS
    lw s1, 0(s0)      # Lê o número total de notas
    la s0, NOTAS      # Carrega o endereço de NOTAS
    li t0, 0          # Inicializa o contador de notas
    li a2, 40         # Define o instrumento MIDI (40: flauta)
    li a3, 127        # Define o volume máximo

LOOP_PLAY: 
    # Verifica se todas as notas foram tocadas
    beq t0, s1, FIM_PLAY  # Se t0 == s1 (fim das notas), vai para FIM_PLAY

     # Tocar a nota atual
    lw a0, 0(s0)        # Lê a nota MIDI atual
    lw a1, 4(s0)        # Lê a duração da nota atual
    li a7, 31           # Syscall: Tocar nota
    ecall               # Executa a syscall para tocar a nota

    # Pausa após tocar a nota
    mv a0, a1           # Passa a duração para a pausa
    li a7, 32           # Syscall: Pausa (simula uma pausa)
    ecall               # Executa a syscall para pausar

    # Avança para a próxima nota
    addi s0, s0, 8      # Incrementa o endereço para o próximo par (nota/duração)
    addi t0, t0, 1      # Incrementa o contador de notas
    j LOOP_PLAY         # Volta ao início do loop para a próxima nota

FIM_PLAY:
    # Pausa entre as repetições
    li a0, 5000         # Tempo de pausa (5 segundos)
    li a7, 32           # Syscall: Pausa
    ecall               # Executa a pausa

    # Reinicia o loop para tocar a música novamente
    j tocar_musica      # Reinicia a execução da música
