#!/bin/bash
# uso: compila.sh NOME   (compila dosroot/NOME.BAS para dosroot/NOME.EXE no Turbo Basic dentro do DOSBox-X)
HERE=$(cd "$(dirname "$0")" && pwd); N=$1
[ -f $HERE/dbx.pid ] && kill $(cat $HERE/dbx.pid) 2>/dev/null; sleep 1
rm -f $HERE/dosroot/$N.EXE
cd $HERE; (nohup dosbox-x -conf tb.conf -nopromptfolder -fastlaunch -c "mount c dosroot" -c "c:" -c "tb $N.bas" > dbx.log 2>&1 & echo $! > dbx.pid)
sleep 7
$HERE/t.sh 109 124 124 124 36 sleep4 shot || exit 9
for i in $(seq 1 40); do [ -f $HERE/dosroot/$N.EXE ] && break; sleep 1; done
kill $(cat $HERE/dbx.pid) 2>/dev/null
ls -la $HERE/dosroot/$N.EXE
