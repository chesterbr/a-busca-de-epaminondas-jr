#!/usr/bin/env python3
"""Compara o código de usuário de dois executáveis do Turbo Basic (o original e o recompilado).

Uso: comparar.py ORIGINAL.EXE RECOMPILADO.EXE [-v]
Os endereços e as constantes do segmento de dados mudam de um para o outro, então a comparação é pela sequência de
instruções com os operandos numéricos mascarados; `-v` mostra as diferenças.
"""
import difflib
import re
import sys
from pathlib import Path

import gerar


def codigo(caminho):
    img = Path(caminho).read_bytes()[0x20:]
    ini = img.rfind(b'\xcd\xec\xb8')
    fim = img.rfind(b'\xcd\xec\xe6') + 5
    gerar.IMG = img
    ins, _ = gerar.desmonta(ini, fim)
    return ini, fim, ins


def mascara(i):
    o = re.sub(r'0x[0-9a-f]+|\b\d+\b', 'N', i.o)
    if i.m == 'on':
        return 'on'
    return ('%s %s' % (i.m, o)).strip()


a = codigo(sys.argv[1])
b = codigo(sys.argv[2])
print('código: %d bytes, %d instruções (original)  x  %d bytes, %d instruções (recompilado)' % (a[1] - a[0], len(a[2]), b[1] - b[0], len(b[2])))
ia = [i for i in a[2] if i.m not in ('wait', 'nop')]
ib = [i for i in b[2] if i.m not in ('wait', 'nop')]
sa = [mascara(i) for i in ia]
sb = [mascara(i) for i in ib]
sm = difflib.SequenceMatcher(None, sa, sb, autojunk=False)
print('semelhança da sequência de instruções: %.1f%%' % (100 * sm.ratio()))
if '-v' in sys.argv:
    # endereço do original -> linha de BAS gerada (o gerador guarda o endereço de cada linha)
    gerar.IMG = Path(sys.argv[1]).read_bytes()[0x20:]
    ins, tab = gerar.desmonta(0x82c0, 0x10dae)
    t, traduzido = gerar.traduz_com_for(ins, tab, gerar.rotinas().keys())
    linhas = gerar.limpa_rotulos(gerar.comenta_blocos(gerar.junta_linhas(gerar.estrutura_if(gerar.estrutura_blocos(gerar.insere_data(gerar.reconstroi_for(traduzido)))))))
    enderecos = [a for a, _ in linhas]
    import bisect
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != 'equal':
            ad = ia[min(i1, len(ia) - 1)].a
            k = max(0, bisect.bisect_right(enderecos, ad) - 1)
            print('%05x %s %s -> %s\n         BAS: %s' % (ad, tag, sa[i1:i2][:8], sb[j1:j2][:8], re.sub(r'<<L[0-9A-F]+>>', 'L', linhas[k][1])[:130]))
