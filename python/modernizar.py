"""Do texto do jogo original (CP437, aspas simples, espaço antes de ? e !) para o texto moderno da reimplementação.

Os textos originais ficam em AVENTURA.MSG e nos dumps; nada aqui os altera. O `epa.py` traz o texto já
modernizado no fonte (e passa por `moderniza` o que lê dos dumps); `testar_textos.py` confere uma coisa
contra a outra, e o gerador do .BAS vai ler sempre os textos originais.

Transformações, nesta ordem:
  1. erratas: erros do original que não são limitação do CP437 (ERRATAS) e palavras em maiúsculas com
     letra minúscula acentuada (`óBVIO`, `ARTIFíCIO`) ou sem o acento que o CP437 não tinha (`VOCE`);
  2. `ä ö Ä Ö` (o jogo mostra como `ã õ Ã Õ`) e `Å` (o `Á` que faltava na fonte);
  3. aspas simples viram aspas curvas (abre ou fecha pela posição);
  4. sem espaço antes de `?` e `!`.
"""
import re

# trecho original -> trecho corrigido (erros de digitação do original)
ERRATAS = {
    "E' realmente": 'É realmente',
    'maös': 'mãos',
    '¿ Como te chamas': '¿Como te chamas',
}

# palavras em maiúsculas que o CP437 não deixava acentuar (o contexto de cada uma foi conferido)
MAIUSCULAS = {'VOCE': 'VOCÊ'}

TROCAS = str.maketrans({'ä': 'ã', 'ö': 'õ', 'Ä': 'Ã', 'Ö': 'Õ', 'Å': 'Á'})
MINUSCULA_ACENTUADA = 'áéíóúâêô'


def _palavra_maiuscula(m):
    p = m.group(0)
    p = MAIUSCULAS.get(p, p)
    letras = [c for c in p if c.isalpha()]
    sobra = [c for c in letras if c.islower() and c not in MINUSCULA_ACENTUADA]
    # `óBVIO`, `NóS`, `ARTIFíCIO`, `ôNIBUS`: acento minúsculo no meio de maiúsculas
    if not sobra and any(c in MINUSCULA_ACENTUADA for c in letras) and sum(c.isupper() for c in letras) >= 2:
        return p.upper()
    return p


def aspas(s, borda=False):
    """Aspas simples -> curvas. Com `borda`, o começo e o fim da string valem como fim e começo de palavra
    de um trecho maior (os textos são quebrados em pedaços no fonte)."""
    saida = []
    for i, c in enumerate(s):
        if c != "'":
            saida.append(c)
            continue
        antes = s[i - 1] if i else ' '
        depois = s[i + 1] if i + 1 < len(s) else ' '
        abre = antes in ' \n(-"“' and depois not in ' \n'
        fecha = antes not in ' \n(' and (depois in ' \n.,;:!?)-' or i + 1 == len(s))
        if abre == fecha:
            if not borda:
                raise ValueError('aspa ambígua em %r' % s[max(0, i - 20):i + 20])
            abre = (i + 1 == len(s))  # no fim do pedaço, depois de espaço: abre; no começo, antes de espaço: fecha
        saida.append('“' if abre else '”')
    return ''.join(saida)


def moderniza(s, borda=False):
    for velho, novo in ERRATAS.items():
        s = s.replace(velho, novo)
    s = re.sub(r"[A-Za-zÇÉÜÑÄÖÅáéíóúâêôç]+", _palavra_maiuscula, s)
    s = s.translate(TROCAS)
    s = aspas(s, borda)
    s = re.sub(r' +([?!])', r'\1', s)
    return s
