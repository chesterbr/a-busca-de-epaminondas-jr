#!/usr/bin/env python3
"""Roda tudo o que dá para testar sem o jogo original: `python3 testar.py`.

1. Cada roteiro de `caminhos/NN_nome.txt` é executado no `epa.py --sem-wrap` (sem a quebra de linha em 58 colunas,
   que deixaria os diffs ilegíveis) e a saída é comparada com `esperado/NN_nome.out`; as saídas esperadas foram
   conferidas contra o original no DOSBox-X, ver `caminhos/LEIA.md`. Os roteiros de `COM_QUEBRA` também rodam com a
   quebra, contra `esperado/NN_nome.quebra.out`.
2. `testar_textos.py` confere o texto do fonte contra o `AVENTURA.MSG`.

`--atualizar` regrava as saídas esperadas (use quando uma mudança de comportamento for de propósito e confira o diff).
"""
import difflib
import subprocess
import sys
import tempfile
from pathlib import Path

AQUI = Path(__file__).resolve().parent
CAMINHOS = AQUI / 'caminhos'
ESPERADO = AQUI / 'esperado'
COM_QUEBRA = ['00_caminho_feliz', '19_elevadores']  # o 19 tem a PLACA, que só fica certa com a quebra


def rodar(*args):
    return subprocess.run([sys.executable, *map(str, args)], capture_output=True, encoding='utf-8', cwd=AQUI)


def main():
    atualizar = '--atualizar' in sys.argv
    ESPERADO.mkdir(exist_ok=True)
    falhas = 0
    for caminho in sorted(CAMINHOS.glob('[0-9][0-9]_*.txt')):
        execucoes = [('.out', ['--sem-wrap'])]
        if caminho.stem in COM_QUEBRA:
            execucoes.append(('.quebra.out', []))
        for sufixo, opcoes in execucoes:
            r = rodar(AQUI / 'epa.py', *opcoes, caminho)
            arq = ESPERADO / (caminho.stem + sufixo)
            nome = caminho.stem + sufixo
            if r.returncode:
                print('ERRO  %s\n%s' % (nome, r.stderr))
                falhas += 1
            elif atualizar:
                arq.write_text(r.stdout, encoding='utf-8')
                print('grava %s' % arq.name)
            elif not arq.exists():
                print('FALTA %s (rode com --atualizar)' % arq.name)
                falhas += 1
            elif r.stdout != arq.read_text(encoding='utf-8'):
                print('FALHA %s' % nome)
                sys.stdout.writelines(list(difflib.unified_diff(arq.read_text(encoding='utf-8').splitlines(True),
                                                                r.stdout.splitlines(True), 'esperado', 'obtido'))[:40])
                falhas += 1
            else:
                print('ok    %s' % nome)
    # o original apagava as letras acentuadas dos comandos; aqui os acentos são ignorados
    with tempfile.NamedTemporaryFile('w', suffix='.txt', encoding='utf-8') as t:
        t.write('INVENTÁRIO\n')
        t.flush()
        r = rodar(AQUI / 'epa.py', '--sem-wrap', t.name)
    if 'Objetos: GRANA, FOSFOROS' in r.stdout:
        print('ok    comando com acento')
    else:
        print('FALHA comando com acento\n' + r.stdout[-300:])
        falhas += 1
    with tempfile.NamedTemporaryFile('w', suffix='.txt', encoding='utf-8') as t:
        t.write('AJUDA\n?\n')
        t.flush()
        r = rodar(AQUI / 'epa.py', '--sem-wrap', t.name)
    if r.stdout.count('Digite comandos com um verbo') == 2:
        print('ok    AJUDA e ?')
    else:
        print('FALHA AJUDA e ?\n' + r.stdout[-300:])
        falhas += 1
    r = rodar(AQUI / 'testar_textos.py')
    print(r.stdout.rstrip())
    if r.returncode:
        print('FALHA testar_textos.py\n' + r.stderr)
        falhas += 1
    print('\n%s' % ('%d falha(s)' % falhas if falhas else 'tudo certo'))
    return 1 if falhas else 0


if __name__ == '__main__':
    sys.exit(main())
