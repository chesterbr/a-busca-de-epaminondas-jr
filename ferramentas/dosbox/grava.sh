#!/bin/bash
# uso: grava.sh NOME   (ESC > Gravar > NOME.CA1 na pasta jogo/). Chamar com o jogo no prompt de comando.
S=$(cd "$(dirname "$0")" && pwd); PID=$(cat $S/dbx.pid)
osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" >/dev/null; sleep 0.4
$S/dbx key $PID 53 || exit 9; sleep 0.8       # ESC
$S/dbx key $PID 36 || exit 9; sleep 0.8       # Gravar
$S/dbx type $PID "$1" || exit 9; $S/dbx key $PID 36; sleep 1.5
$S/k.sh "" >/dev/null; ls -la $S/jogo/$(echo "$1" | tr a-z A-Z).CA1
