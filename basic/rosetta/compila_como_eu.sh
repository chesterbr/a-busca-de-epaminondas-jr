#!/bin/bash
# uso: compila_como_eu.sh NOME   (dosroot/NOME.BAS -> dosroot/NOME.EXE, como eu gerava o CA1.EXE)
#
# O Turbo Basic copia para o EXE a imagem do programa que está na memória do editor. Sem FPU, o runtime
# troca cada `cd 3d` (FWAIT do emulador de 8087) por `nop nop` na primeira vez que o trecho roda. Eu rodava o
# jogo no editor antes de compilar; os trechos que usei (a tela inicial, o menu Ajuda e o menu Notas, sem digitar
# nenhum comando) saíram corrigidos. Este script faz o mesmo: roda o programa (F10 > Run), passa a introdução, abre
# Ajuda e Notas, sai pelo menu (Fim, S) e só então compila (F10 > Compile). Com a FPU do DOSBox-X desligada
# (tb_sem_fpu.conf) o código sai idêntico, byte a byte, ao do CA1.EXE original.
# Só serve para programas que se comportam como o jogo (precisa de AVENTURA.MSG em dosroot/).
HERE=$(cd "$(dirname "$0")" && pwd); N=$1
[ -f $HERE/dbx.pid ] && kill $(cat $HERE/dbx.pid) 2>/dev/null; sleep 1
rm -f $HERE/dosroot/$N.EXE
cd $HERE; (nohup dosbox-x -conf tb_sem_fpu.conf -nopromptfolder -fastlaunch -c "mount c dosroot" -c "c:" -c "tb $N.bas" > dbx.log 2>&1 & echo $! > dbx.pid)
sleep 10
ENTER="36 sleep0.6"
# F10 > Run; espera o jogo carregar; introdução (qualquer tecla; Enter vazio no prompt é ignorado)
$HERE/t.sh 109 124 124 36 sleep35 $ENTER $ENTER $ENTER $ENTER $ENTER sleep1 || exit 9
# ESC > Ajuda (A): uma tela e ESC para voltar
$HERE/t.sh 53 sleep1 0 sleep2 $ENTER 53 sleep2 || exit 9
# ESC > Notas (N): as telas passam com qualquer tecla
$HERE/t.sh 53 sleep1 45 sleep2 $ENTER $ENTER $ENTER $ENTER $ENTER $ENTER $ENTER $ENTER sleep1 || exit 9
# ESC > Fim (F) > S; qualquer tecla volta ao editor; F10 > Compile
$HERE/t.sh 53 sleep1 3 sleep1 1 sleep3 49 sleep2 124 36 sleep3 shot || exit 9
for i in $(seq 1 60); do [ -f $HERE/dosroot/$N.EXE ] && break; sleep 2; done
sleep 6
kill $(cat $HERE/dbx.pid) 2>/dev/null
ls -la $HERE/dosroot/$N.EXE
