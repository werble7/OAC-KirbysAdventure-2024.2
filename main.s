.text
.globl _start
.globl tocar_musica  # Declare a função 'tocar_musica' como global para que o linker saiba que existe

.include "helpers/music.s"  # Incluir o arquivo music.s

_start:
    # Chama a função que toca a música
    jal tocar_musica  # Chama a função 'tocar_musica' que está no music.s

    # Finaliza o programa (caso o loop termine)
    li a7, 10          # Syscall para encerrar o programa
    ecall              # Executa a syscall para finalizar
