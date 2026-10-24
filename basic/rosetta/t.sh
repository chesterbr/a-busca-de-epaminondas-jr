#!/bin/bash
# uso: t.sh codigo... (keycodes do macOS; "shot" captura)
HERE=$(cd "$(dirname "$0")" && pwd); D=$HERE/../../ferramentas/dosbox/dbx
PID=$(cat $HERE/dbx.pid); W=$($D win $PID) || exit 9
osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" >/dev/null; sleep 0.5
for c in "$@"; do
  case $c in shot) sleep 0.8; screencapture -x -o -l $W $HERE/shot.png; sips -Z 900 $HERE/shot.png >/dev/null;;
  sleep*) sleep ${c#sleep};;
  *) $D key $PID $c || exit 9; sleep 0.25;; esac
done
