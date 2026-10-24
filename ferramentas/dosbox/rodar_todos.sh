#!/bin/bash
# uso: [EXE=/caminho/CA1.EXE] rodar_todos.sh PASTA_RESULTADOS [CAMINHO_A_PULAR...]
# Roda todos os caminhos de python/caminhos (ver plano_cenarios.py) com cenario.sh e guarda o relatório de cada um
# em PASTA_RESULTADOS/NOME.txt. Cada caminho abre um DOSBox-X novo; o computador fica ocupado enquanto roda.
S=$(cd "$(dirname "$0")" && pwd); OUT=$1; shift; mkdir -p "$OUT"
python3 "$S/plano_cenarios.py" | while read -r CAM SAVE LIN; do
  N=$(basename "$CAM" .txt)
  case " $* " in *" $N "*) continue;; esac
  [ -f "$OUT/$N.txt" ] && continue
  if [ "$SAVE" = "-" ]; then "$S/cenario.sh" "$CAM" > "$OUT/$N.txt" 2>&1; else "$S/cenario.sh" "$CAM" "$SAVE" "$LIN" > "$OUT/$N.txt" 2>&1; fi
  echo "$N: $(grep -c '^+++' "$OUT/$N.txt") diferenças; $(grep 'parágrafos sem' "$OUT/$N.txt")" >> "$OUT/_resumo.txt"
done
echo FIM >> "$OUT/_resumo.txt"
