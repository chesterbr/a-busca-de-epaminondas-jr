#!/usr/bin/env python3
"""Monta o site (original.html e python.html) em _site/, a partir do que já está no repositório.

Uso: python3 web/montar.py [pasta_de_saida]   (padrão: _site); para ver: python3 -m http.server -d _site

O site tem duas páginas e nenhum arquivo do jogo duplicado no repositório: o original.jsdos (um zip para o js-dos) e
a árvore que o Pyodide recria (app/) são montados na hora.
"""
import json
import shutil
import sys
import zipfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
WEB = RAIZ / 'web'

# o que o epa.py precisa no Pyodide, na mesma posição relativa do repositório (ele acha os dados a partir dali)
PARA_O_PYODIDE = ['python/epa.py', 'python/modernizar.py',
                  'analise/dumps/G1.BIN', 'analise/dumps/E1.BIN', 'analise/dumps/E2.BIN',
                  'analise/extracted/rooms_table.txt',
                  'web/jogo_web.py']
PAGINAS = ['original.html', 'python.html', 'estilo.css']
# o que vai no original.jsdos: o jogo de 1992, como nos arquivos de original/
DO_ORIGINAL = ['CA1.EXE', 'CHESTER.EXE', 'AVENTURA.MSG', 'AVENTURA.BAT']
DOSBOX_CONF = '''[autoexec]
@echo off
mount c .
c:
aventura.bat
'''


def main():
    saida = Path(sys.argv[1]) if len(sys.argv) > 1 else RAIZ / '_site'
    if saida.exists():
        shutil.rmtree(saida)
    saida.mkdir(parents=True)
    for pagina in PAGINAS:
        shutil.copy(WEB / pagina, saida / pagina)
    for caminho in PARA_O_PYODIDE:
        destino = saida / 'app' / caminho
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(RAIZ / caminho, destino)
    (saida / 'manifest.json').write_text(json.dumps({'arquivos': PARA_O_PYODIDE}, indent=1) + '\n')
    with zipfile.ZipFile(saida / 'original.jsdos', 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('.jsdos/dosbox.conf', DOSBOX_CONF)
        for nome in DO_ORIGINAL:
            z.write(RAIZ / 'original' / nome, nome)
    (saida / '.nojekyll').write_text('')
    print('site montado em %s (%d arquivos)' % (saida, sum(1 for p in saida.rglob('*') if p.is_file())))


if __name__ == '__main__':
    main()
