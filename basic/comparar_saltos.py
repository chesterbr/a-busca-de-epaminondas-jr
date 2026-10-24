"""Confere se os saltos do EXE recompilado vão para a mesma instrução que no original.

A comparação de comparar.py mascara os endereços; este script confere os destinos.
uso: python3 comparar_saltos.py ORIGINAL.EXE RECOMPILADO.EXE
"""
import difflib
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import gerar  # noqa: E402


def carrega(p):
    img = Path(p).read_bytes()[0x20:]
    gerar.IMG = img
    ini = img.rfind(b'\xcd\xec\xb8')
    fim = img.rfind(b'\xcd\xec\xe6') + 5
    ins, _ = gerar.desmonta(ini, fim)
    return [i for i in ins if i.m not in ('wait', 'nop')], ini


def mk(i):
    return re.sub(r'0x[0-9a-f]+|\b\d+\b', 'N', i.m + ' ' + i.o)


a, ia = carrega(sys.argv[1])
b, ib = carrega(sys.argv[2])
sm = difflib.SequenceMatcher(None, [mk(i) for i in a], [mk(i) for i in b], autojunk=False)
mapa = {}
for tag, i1, i2, j1, j2 in sm.get_opcodes():
    if tag == 'equal':
        for k in range(i2 - i1):
            mapa[i1 + k] = j1 + k
ida = {i.a: k for k, i in enumerate(a)}
idb = {i.a: k for k, i in enumerate(b)}
n = 0
for k, x in mapa.items():
    i, j = a[k], b[x]
    if not (i.m.startswith('j') or i.m in ('call', 'loop')):
        continue
    try:
        da, db = ida.get(int(i.o, 16)), idb.get(int(j.o, 16))
    except ValueError:
        continue
    if da is None or db is None:
        continue
    if mapa.get(da) != db:
        n += 1
        print('%05x %s %s -> original #%d, recompilado #%d (esperado #%s)' % (i.a - ia, i.m, i.o, da, db, mapa.get(da)))
print('saltos diferentes:', n)
