"""Plano para rodar todos os caminhos de python/caminhos no jogo: imprime "CAMINHO SAVE LINHAS" (SAVE '-' se parte do zero).

Cada caminho parte do maior save cujo prefixo (em linhas de comando) é igual ao começo do caminho. Os saves cobrem a
parte do caminho feliz derivada (F2=15, P17=30, F3=42, F4=77, REC=78, F5=105 linhas). Ordem: do mais curto ao mais longo.
"""
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2] / 'python' / 'caminhos'
SAVES = [('F2', 15), ('P17', 30), ('F3', 42), ('F4', 77), ('REC', 78), ('F5', 105)]


def comandos(f):
    return [l.strip() for l in f.read_text().splitlines() if l.strip() and not l.startswith('#')]


def prefixo(a, b):
    n = 0
    for x, y in zip(a, b):
        if x != y:
            break
        n += 1
    return n


caminhos = {f: comandos(f) for f in sorted(RAIZ.glob('*.txt'))}
ref = caminhos[RAIZ / '20_bairro_pior_leste.txt']
plano = []
for f, c in caminhos.items():
    k = 0 if f.name.startswith('00_') else prefixo(c, ref)
    s = max(((n, l) for n, l in SAVES if l <= k), key=lambda x: x[1], default=None)
    plano.append((len(c) - (s[1] if s else 0), f, s))
for resto, f, s in sorted(plano, key=lambda x: (x[0], x[1].name)):
    print(f, s[0] if s else '-', s[1] if s else 0)
