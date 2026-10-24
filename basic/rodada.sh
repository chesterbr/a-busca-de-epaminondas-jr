#!/bin/bash
# gera, compila no Turbo Basic (DOSBox-X) e compara com o CA1.EXE original
cd "$(dirname "$0")"
# PY: python com capstone (padrão: python3); TB: pasta com dosroot/ e compila.sh (ver rosetta/README.md)
PY=${PY:-python3}
T=${TB:?defina TB com a pasta do Turbo Basic (dosroot/, compila.sh)}
rm -f $T/dosroot/CA1*.BAS $T/dosroot/CA1*.INC $T/dosroot/CA1.EXE
$PY gerar.py --dividir 45000 -o $T/dosroot/CA1.BAS 2>&1 | tail -1
$PY - <<P
d=open('$T/dosroot/CA1.BAS','rb').read().replace(b'\r\n',b'\n').replace(b'\n',b'\r\n'); open('$T/dosroot/CA1.BAS','wb').write(d)
P
$T/compila.sh CA1 2>&1 | tail -1
$PY comparar.py ../original/CA1.EXE $T/dosroot/CA1.EXE -v 2>&1 | grep -v aviso > /tmp/cmp.txt; head -2 /tmp/cmp.txt
