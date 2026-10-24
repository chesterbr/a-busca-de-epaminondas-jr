#!/bin/bash
# Compila as ferramentas (se preciso), copia CA1.EXE e AVENTURA.MSG para ferramentas/dosbox/jogo/
# (a variável EXE escolhe o executável; padrão: o original. Para o recompilado: EXE=../../basic/teste/CA1.EXE)
# e abre o DOSBox-X nessa pasta. O PID fica em dbx.pid (so esse processo e controlado pelos scripts).
# Saves do jogo (.CA1) gravados la ficam em jogo/; copie os que valem a pena para ../saves/.
cd "$(dirname "$0")" || exit 1
[ -x dbx ] || swiftc -O dbx.swift -o dbx
[ -x ocr ] || swiftc -O ocr.swift -o ocr
mkdir -p jogo log && echo 0 > log/n
cp "${EXE:-../../original/CA1.EXE}" jogo/CA1.EXE && cp ../../original/AVENTURA.MSG jogo/
[ -n "$1" ] && cp "../saves/$1" jogo/
cd jogo && (nohup dosbox-x -conf ../teste.conf -nopromptfolder -fastlaunch -defaultdir "$PWD" \
  -c "mount c ." -c "c:" -c "ca1.exe" > ../dbx.log 2>&1 & echo $! > ../dbx.pid)
sleep 6; echo "DOSBox-X PID $(cat ../dbx.pid)"
