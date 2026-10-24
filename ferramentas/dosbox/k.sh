#!/bin/bash
# uso: k.sh "comando"  (sem argumento: so espera o prompt, dispensando pausas)
# Teclas SO via dbx (CGEventPostToPid no PID do jogo, com trava de foco). Aborta tudo se o dbx falhar.
S=$(cd "$(dirname "$0")" && pwd)
PID=$(cat $S/dbx.pid); W=$($S/dbx win $PID) || { echo "SEM JANELA"; exit 9; }
ativa() { osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" >/dev/null; sleep 0.4; }
tecla() { $S/dbx key $PID $1 || { echo "ABORTADO"; exit 9; }; }
cap() {
  n=$(( $(cat $S/log/n) + 1 )); echo $n > $S/log/n; f=$(printf "%s/log/%04d" $S $n)
  screencapture -x -o -l $W $f.png; sips -s format bmp $f.png --out $S/cap.bmp >/dev/null
  [ -n "$OCR" ] && $S/ocr $f.png > $f.txt
  sips -Z 720 $f.png >/dev/null; cp $f.png $S/cur.png
  ST=$(python3 -I $S/estado.py $S/cap.bmp | cut -d' ' -f1)
}
espera() { o=0; for i in $(seq 1 25); do sleep 0.7; cap; case $ST in PROMPT) return;; PAUSA) ativa; tecla 36;; OUTRO) o=$((o+1)); [ $o -ge 3 ] && return;; esac; done; }
espera
IDX0=$(cat $S/log/n)
if [ -n "$1" ]; then
  ativa
  $S/dbx type $PID "$1" || { echo "ABORTADO"; exit 9; }
  tecla 36
  espera
fi
echo "$ST $((IDX0+1)) $(cat $S/log/n)"
