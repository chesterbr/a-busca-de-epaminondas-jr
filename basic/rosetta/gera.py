#!/usr/bin/env python3
"""Gera NOME.BAS (Turbo Basic) com as instruções de NOME.TXT, cada uma entre marcadores `PRINT "@@"`.
Uso: gera.py NOME.TXT DESTINO.BAS"""
import sys
from pathlib import Path

linhas = [l.rstrip('\n') for l in Path(sys.argv[1]).read_text().splitlines() if l.strip()]
cabeca = []
if '++' in linhas:                    # antes de `++`: linhas do começo do programa (metastatements como REM $DYNAMIC)
    k = linhas.index('++')
    cabeca, linhas = linhas[:k], linhas[k + 1:]
cauda = []
if '--' in linhas:                    # depois de `--`: linhas soltas (rótulos de GOSUB etc.) depois do END
    k = linhas.index('--')
    linhas, cauda = linhas[:k], linhas[k + 1:]
out = cabeca + ['PRINT "@@"']
for l in linhas:
    out += [l, 'PRINT "@@"']
if cauda:
    out += ['END'] + cauda
Path(sys.argv[2]).write_bytes(('\r\n'.join(out) + '\r\n').encode('cp850'))
