#!/bin/bash
# uso: cenario.sh CAMINHO [SAVE LINHAS]
# Roda um arquivo de caminho no original (DOSBox-X) e compara com a reimplementação.
#   CAMINHO  arquivo em python/caminhos/ (ou outro)
#   SAVE     nome de um save de ../saves (sem .CA1) para pular o começo; LINHAS = quantas linhas
#            de comando do CAMINHO esse save já cobre (comentários não contam)
# Abre um DOSBox-X novo (e fecha o seu PID no fim). Saída: log/ (capturas), /tmp/cenario.out e o relatório.
S=$(cd "$(dirname "$0")" && pwd); cd "$S" || exit 1
CAM=$(cd "$(dirname "$1")" && pwd)/$(basename "$1"); SAVE=$2; LIN=${3:-0}
[ -f dbx.pid ] && kill $(cat dbx.pid) 2>/dev/null && sleep 2
rm -rf log; mkdir log; echo 0 > log/n
./iniciar.sh ${SAVE:+$SAVE.CA1} > /dev/null 2>&1
./k.sh "" > /dev/null
[ -n "$SAVE" ] && { ./carrega.sh "$SAVE" | tail -1; }
PULAR=$(python3 cortar.py "$CAM" $LIN 2>&1 >/tmp/cenario.cmd)
OCR=1 ./run.sh /tmp/cenario.cmd > /tmp/cenario.out 2>&1
tail -2 /tmp/cenario.out
python3 comparar.py /tmp/cenario.out "$CAM" log $PULAR
kill $(cat dbx.pid) 2>/dev/null
