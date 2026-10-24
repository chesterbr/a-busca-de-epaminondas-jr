"""uso: cortar.py CAMINHO LINHAS  -> imprime os comandos do caminho depois das primeiras LINHAS linhas
(comentários e linhas vazias não contam) e, em stderr, quantos COMANDOS (sem as respostas numéricas) foram pulados."""
import sys
from pathlib import Path
linhas = [l for l in Path(sys.argv[1]).read_text().splitlines() if l.strip() and not l.startswith('#')]
k = int(sys.argv[2])
print(sum(1 for l in linhas[:k] if not l.strip().isdigit()), file=sys.stderr)
print('\n'.join(linhas[k:]))
