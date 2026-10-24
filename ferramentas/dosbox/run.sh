#!/bin/bash
# uso: run.sh arquivo (um comando por linha; linhas vazias e as que começam com # são ignoradas). Para na primeira falha.
S=$(cd "$(dirname "$0")" && pwd)
while IFS= read -r l; do case "$l" in ""|"#"*) continue;; esac; r=$($S/k.sh "$l"); echo "$l -> $r"; case "$r" in *ABORTADO*|*SEM*) exit 9;; esac; done < "$1"
