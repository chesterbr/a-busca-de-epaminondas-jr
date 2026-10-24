#!/bin/bash
# uso: carrega.sh NOME   (ESC > Carregar > NOME)
S=$(cd "$(dirname "$0")" && pwd); PID=$(cat $S/dbx.pid)
$S/k.sh "" >/dev/null   # espera o prompt (o jogo pode estar numa pausa)
osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" >/dev/null; sleep 0.4
$S/dbx key $PID 53 || exit 9; sleep 0.8       # ESC
$S/dbx key $PID 125 || exit 9; sleep 0.5      # seta para baixo: Carregar
$S/dbx key $PID 36 || exit 9; sleep 0.8
$S/dbx type $PID "$1" || exit 9; $S/dbx key $PID 36; sleep 1.5
$S/k.sh "" >/dev/null; echo carregado
