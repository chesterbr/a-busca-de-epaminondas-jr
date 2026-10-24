"""Confere os textos do epa.py contra os originais (AVENTURA.MSG) passados por moderniza().

uso: python3 testar_textos.py [-v]
  1. nenhuma literal do fonte pode ter sobra do texto original (ä ö Ä Ö Å, aspa simples dentro de texto, espaço antes
     de ? ou !);
  2. cada mensagem do AVENTURA.MSG, modernizada, tem de aparecer inteira no fonte (como literal, ou como início de
     literal quando o resto vem de um dump, ou dentro de uma literal maior); as que não aparecem são listadas
     (código morto do original, textos lidos do dump na hora, ou texto que a reimplementação escreve de outro jeito).
"""
import ast
import re
import sys
from pathlib import Path

from modernizar import moderniza

AQUI = Path(__file__).resolve().parent
RAIZ = AQUI.parent
msgs = [m.decode('cp850') for m in (RAIZ / 'original' / 'AVENTURA.MSG').read_bytes().split(b'\r\n')]
arvore = ast.parse((AQUI / 'epa.py').read_text(encoding='utf-8'))
literais = [n.value for n in ast.walk(arvore) if isinstance(n, ast.Constant) and isinstance(n.value, str)]
ruim = 0

for s in literais:
    if re.search(r"[äöÄÖÅ]| [?!]", s) or (len(s) > 12 and "'" in s):
        print('sobra do original na literal:', repr(s))
        ruim += 1

junto = '\n'.join(literais)
faltam = []
for i, m in enumerate(msgs):
    t = moderniza(m)
    if t and t not in junto:
        faltam.append((i, t))
print('%d mensagens, %d achadas inteiras no fonte, %d fora' % (len(msgs), len(msgs) - len(faltam), len(faltam)))
if '-v' in sys.argv:
    for i, t in faltam:
        print('  %3d %s' % (i, t[:100]))
sys.exit(1 if ruim else 0)
