"""Compara os valores imediatos (constantes, bases de arrays) das instrucoes que o comparar.py considera iguais.
uso: python3 comparar_valores.py ORIGINAL.EXE RECOMPILADO.EXE"""
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


a, ia = carrega(sys.argv[1])
b, ib = carrega(sys.argv[2])


def mk(i):
    return re.sub(r'0x[0-9a-f]+|\b\d+\b', 'N', i.m + ' ' + i.o)


sm = difflib.SequenceMatcher(None, [mk(i) for i in a], [mk(i) for i in b], autojunk=False)
n = 0
for tag, i1, i2, j1, j2 in sm.get_opcodes():
    if tag != 'equal':
        continue
    for x, y in zip(a[i1:i2], b[j1:j2]):
        if x.o != y.o and 'ptr [' not in x.o and x.m in ('mov', 'push', 'cmp', 'add', 'sub'):
            n += 1
            print('%05x %s %s | %s' % (x.a - ia, x.m, x.o, y.o))
print('diferencas de valor:', n)
