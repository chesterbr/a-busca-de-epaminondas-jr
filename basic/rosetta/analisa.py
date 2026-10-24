#!/usr/bin/env python3
"""Pedra de Roseta: compila instruções do Turbo Basic e mostra o código que o compilador gera para cada uma.

Uso: analisa.py NOME.EXE NOME.TXT
  NOME.EXE  executável gerado pelo Turbo Basic (veja compila.sh e o README desta pasta; o Turbo Basic não faz parte do repositório)
  NOME.TXT  as instruções testadas, uma por linha (as mesmas usadas por gera.py)

Cada instrução foi compilada entre dois marcadores `PRINT "@@"`; o script desmonta o código do usuário
(do prólogo `INT EC B8` até `INT EC E6 / INT EC 30`) e imprime o trecho de cada instrução.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import gerar  # noqa: E402

exe = Path(sys.argv[1]).read_bytes()
img = exe[0x20:]
ini = img.rfind(b'\xcd\xec\xb8')
fim = img.rfind(b'\xcd\xec\xe6') if b'\xcd\xec\xe6' in img[ini:] else len(img)
gerar.IMG = img
ins, _ = gerar.desmonta(ini, fim + 5)
testes = [l.rstrip('\n') for l in Path(sys.argv[2]).read_text().splitlines() if l.strip()]
if '++' in testes:
    testes = testes[testes.index('++') + 1:]
if '--' in testes:
    testes = testes[:testes.index('--')]


def fmt(i):
    return '%04x  %-22s %-6s %s' % (i.a, i.raw.hex(' '), i.m, i.o)


# marcador = push de string + b8 + b2, com o mesmo descritor (mov si, X) em todos
marcas = [k for k, i in enumerate(ins) if i.m == 'mov' and i.o.startswith('si, ') and k + 3 < len(ins)
          and ins[k + 1].raw == b'\xcd\x96' and ins[k + 2].raw == b'\xcd\xb8' and ins[k + 3].raw == b'\xcd\xb2']
if marcas:
    desc = ins[marcas[0]].o
    marcas = [k for k in marcas if ins[k].o == desc]
print('%d marcadores, %d testes' % (len(marcas), len(testes)))
for n, k in enumerate(marcas[:-1]):
    nome = testes[n] if n < len(testes) else '?'
    print('\n==== %s' % nome)
    for i in ins[k + 4:marcas[n + 1]]:
        print('   ' + fmt(i))
