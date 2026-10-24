"""Acabamento do LEGIVEL.BAS: nomes que dizem o que a rotina faz, 80 colunas, sem endereços, Unicode.

Recebe as linhas que o gerador produz com --nomeados --mensagens-inline (texto como o jogo o grava: `ä` por `ã`, ver
_PARA_UNICODE) e devolve o texto para leitura. Só mexe na apresentação; o CA1.BAS não passa por aqui.
"""
import re
import unicodedata

LARGURA = 80
FIEL = [False]          # compila para o mesmo código do CA1.BAS: IF de uma linha e textos inteiros (linhas estouram)

# Rotinas fixas: nome do gerador -> nome legível
ROTINAS = {'EscolheSala': 'DescreveSala', 'ObjetosDaSala': 'MostraObjetosDaSala',
           'PainelObjetos': 'AtualizaPainelObjetos', 'PainelDirecoes': 'AtualizaPainelDirecoes',
           'Aviso': 'MostraAviso', 'Mensagem': 'MostraMensagem', 'RolaJanela': 'RolaJanelaDeMensagens',
           'DesenhaTela': 'DesenhaTelaInicial', 'LoopPrincipalX1': 'LeProximoComando',
           'SubF94A': 'GravaJogo', 'SubF94AX1': 'ErroDeDisco', 'SubF94AX2': 'CancelaOperacaoDeDisco',
           'SubFF31': 'CarregaJogo', 'Sub105BF': 'MostraAjuda', 'Sub105BFX1': 'RestauraJanelaDeMensagens',
           'Sub1090E': 'MostraNotas', 'Sub1090EX1': 'FimDeJogoMorte', 'Sub1090EX2': 'FimDeJogoFinal',
           'Sub1090EX3': 'SaiParaODos'}

# O que a rotina faz, quando o nome não basta (o nome novo é a chave)
COMENTARIO_ROTINA = {
    'LimpaComando': 'Tira espaços repetidos e as palavras de FILTRO$ (artigos, preposições...).',
    'DesenhaTelaInicial': 'Moldura, título e janelas (depois disso elas só são atualizadas).',
    'RolaJanelaDeMensagens': 'Acrescenta LINHAMSG$ no fim da janela, empurrando as outras para cima.',
    'DescreveSala': 'Vai para a rotina da sala atual (SALA).',
    'ErroDeDisco': 'Tratador de ON ERROR de GravaJogo e CarregaJogo.',
    'RestauraJanelaDeMensagens': 'Devolve à janela as linhas guardadas em BACKUP$ (usado ao sair de Ajuda e Notas).',
    'GravaJogo': 'Pede o nome do arquivo e grava o estado do jogo em NOME.CA1.',
    'CarregaJogo': 'Pede o nome do arquivo e lê o estado do jogo de NOME.CA1.',
    'MostraAjuda': 'Telas de ajuda: uma tecla passa para a próxima, ESC volta ao jogo.',
    'MostraNotas': 'Minhas notas e agradecimentos.',
    'FimDeJogoMorte': 'Mostra o aviso de que o jogo acabou e recomeça.',
    'FimDeJogoFinal': 'Final do jogo: a lâmpada estoura, os bombeiros chegam, o cofre é aberto.',
    'SaiParaODos': 'Limpa a tela e termina.',
}

# Salas cujo NOMESALA$ falta, é vazio ou é vago demais
NOMES_SALAS = {10: 'OutraPraca', 13: 'Secretaria', 14: 'SalaDeAula', 19: 'DepositoDePapel', 20: 'BairroPerigoso',
               30: 'Elevador', 31: 'BanheiroFeminino', 32: 'BanheiroMasculino', 35: 'Salinha', 37: 'Mafiosos',
               39: 'FrenteDaBucanoWare', 47: 'SalaDeSecretaria', 48: 'SalaDeSecretaria', 49: 'SalaDeSecretaria',
               52: 'PortaAberta', 53: 'SalaDoSrL', 64: 'BanheiroMasculino', 65: 'PassagemSecreta', 66: 'Esconderijo',
               67: 'GaragemDeOnibus'}

# Variáveis cujo nome ainda era genérico
VARIAVEIS = {'FLAG4D6': 'COMANDOINVALIDO', 'N': 'SAIDANORTE', 'S': 'SAIDASUL', 'L': 'SAIDALESTE', 'O': 'SAIDAOESTE',
             'C': 'SAIDACIMA', 'B': 'SAIDABAIXO', 'NOZAVISO': 'AVISOUSOBRENOZ', 'DUPLO': 'POSDUPLOESPACO', 'S51E$': 'TEXTO$'}


# ---------------------------------------------------------------- varredura de texto fora de aspas

def fora_de_aspas(s):
    """Itera (trecho, dentro_de_aspas) cobrindo a linha toda."""
    ini, dentro = 0, False
    for i, c in enumerate(s):
        if c == '"':
            if dentro:
                yield s[ini:i + 1], True
                ini, dentro = i + 1, False
            else:
                if i > ini:
                    yield s[ini:i], False
                ini, dentro = i, True
    if ini < len(s):
        yield s[ini:], dentro


def troca_palavras(s, mapa, rx):
    return ''.join(t if q else rx.sub(lambda m: mapa[m.group(0)], t) for t, q in fora_de_aspas(s))


def regex_de(mapa):
    return re.compile(r'(?<![A-Za-z0-9$])(?:' + '|'.join(re.escape(k) for k in sorted(mapa, key=len, reverse=True)) +
                      r')(?![A-Za-z0-9])') if mapa else None


def posicoes(s, alvo):
    """Posições de `alvo` fora de aspas e de parênteses."""
    prof, dentro, res = 0, False, []
    for i, c in enumerate(s):
        if c == '"':
            dentro = not dentro
        elif not dentro:
            if c == '(':
                prof += 1
            elif c == ')':
                prof -= 1
            elif prof == 0 and s.startswith(alvo, i):
                res.append(i)
    return res


def divide_topo(s, sep=' : '):
    cortes, ant, res = posicoes(s, sep), 0, []
    for p in cortes:
        res.append(s[ant:p])
        ant = p + len(sep)
    res.append(s[ant:])
    return res


# ---------------------------------------------------------------- junta as continuações do gerador

def junta_continuacoes(linhas):
    out, i = [], 0
    while i < len(linhas):
        t = linhas[i]
        while i + 1 < len(linhas) and not t.lstrip().startswith(('DATA ', "'")) and t.endswith('_'):
            prox = linhas[i + 1].strip()
            if t.endswith('" + _') and prox.startswith('"'):
                t = t[:-5] + prox[1:]
            elif t.endswith(' _'):
                t = t[:-2] + ' ' + prox
            elif t.endswith(',_'):
                t = t[:-1] + ' ' + prox
            else:
                break
            i += 1
        out.append(t)
        i += 1
    return out


# ---------------------------------------------------------------- IF de uma linha vira bloco

def indent_de(t):
    return len(t) - len(t.lstrip(' '))


def corpo_de(ind, partes):
    """Instruções de um THEN/ELSE, uma por linha; um IF dentro absorve o que vem depois dele (é assim no BASIC)."""
    out = []
    for k, p in enumerate(partes):
        if p.startswith('IF '):
            out.extend(bloco_if(ind, ' : '.join(partes[k:]), forca=True))
            break
        out.append(' ' * ind + p)
    return out


def bloco_if(ind, s, forca=False):
    pos = posicoes(s, ' THEN ')
    if not pos or not s.startswith('IF '):
        return [' ' * ind + s]
    cond, resto = s[3:pos[0]], s[pos[0] + 6:]
    if not forca and len(' ' * ind + s) <= LARGURA:
        return [' ' * ind + s]
    partes = divide_topo(resto)
    if any(p.startswith('IF ') for p in partes):          # o IF de dentro leva o ELSE
        entao, senao = partes, None
    else:
        e = posicoes(resto, ' ELSE ')
        if e:
            entao, senao = divide_topo(resto[:e[0]]), divide_topo(resto[e[0] + 6:])
        else:
            entao, senao = partes, None
    out = [' ' * ind + 'IF ' + cond + ' THEN']
    out += corpo_de(ind + 2, entao)
    if senao:
        out.append(' ' * ind + 'ELSE')
        out += corpo_de(ind + 2, senao)
    out.append(' ' * ind + 'END IF')
    return out


# ---------------------------------------------------------------- 80 colunas

def quebra_comentario(t):
    ind = indent_de(t)
    pref = ' ' * ind + "' "
    corpo = t.strip()[2:] if t.strip().startswith("' ") else t.strip()[1:]
    out, atual = [], pref
    for palavra in corpo.split(' '):
        if len(atual) + len(palavra) > LARGURA and atual.strip() != "'":
            out.append(atual.rstrip())
            atual = pref
        atual += palavra + ' '
    out.append(atual.rstrip())
    return out


def candidatos(s):
    """Pontos de corte possíveis: (posição, tipo). Fora de aspas, depois de AND/OR/+/vírgula; dentro de texto, num espaço."""
    res, dentro, ini = [], False, 0
    for i, c in enumerate(s):
        if c == '"':
            dentro = not dentro
            ini = i
        elif dentro and c == ' ' and not FIEL[0] and i - ini > 12 and i + 1 < len(s) and s[i + 1] != '"':
            res.append((i + 1, 'lit'))
        elif not dentro:
            for op in (' AND ', ' OR ', ' + ', ', '):
                if s.startswith(op, i) and i > 8:
                    res.append((i + len(op) - (0 if op == ', ' else 0), 'op'))
    return res


def quebra_instrucao(t):
    """Uma instrução longa: corta no último ponto possível que caiba, com `_`. Devolve as linhas."""
    ind = indent_de(t)
    out, atual = [], t
    while len(atual) > LARGURA:
        melhor = None
        for pos, tipo in candidatos(atual):
            sufixo = '" + _' if tipo == 'lit' else ' _'
            tamanho = len(atual[:pos].rstrip() + sufixo if tipo == 'op' else atual[:pos] + sufixo)
            if tamanho <= LARGURA and pos > ind + 12:
                melhor = (pos, tipo)
        if not melhor:
            break
        pos, tipo = melhor
        if tipo == 'lit':
            out.append(atual[:pos] + '" + _')
            atual = ' ' * (ind + 4) + '"' + atual[pos:]
        else:
            out.append(atual[:pos].rstrip() + ' _')
            atual = ' ' * (ind + 4) + atual[pos:].lstrip()
    out.append(atual)
    return out


def ajusta_largura(linhas, fiel):
    out = []
    for t in linhas:
        s = t.strip()
        if len(t) <= LARGURA or s.startswith('DATA '):
            out.append(t)
        elif s.startswith("'"):
            out.extend(quebra_comentario(t))
        elif s.startswith('IF ') and fiel:
            out.extend(quebra_instrucao(t))
        elif s.startswith('IF ') and posicoes(s, ' THEN ') and not s.endswith(' THEN'):
            for b in bloco_if(indent_de(t), s):
                out.extend(quebra_instrucao(b) if len(b) > LARGURA else [b])
        elif s.startswith('ON ') and ' GOSUB ' in s or s.startswith('ON ') and ' GOTO ' in s:
            out.extend(quebra_lista(t))
        else:
            ps = divide_topo(s)
            for p in ps:
                u = ' ' * indent_de(t) + p
                out.extend(quebra_instrucao(u) if len(u) > LARGURA else [u])
    return out


def quebra_lista(t):
    """ON x GOSUB a, b, c...: continua depois de uma vírgula."""
    ind = indent_de(t)
    out, atual = [], t
    while len(atual) > LARGURA:
        corte = atual.rfind(', ', 0, LARGURA - 1)
        if corte <= ind + 12:
            break
        out.append(atual[:corte + 1] + '_')
        atual = ' ' * (ind + 4) + atual[corte + 2:]
    out.append(atual)
    return out


# ---------------------------------------------------------------- nomes de salas e verbos

def sem_acento(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn')


def camel(texto):
    return ''.join(p.capitalize() for p in re.split(r'[^A-Za-z0-9]+', sem_acento(texto)) if p)


def resumo(texto, limite=64):
    texto = texto.strip()
    for m in re.finditer(r'[.!?](?= |$)', texto):
        if m.end() <= 90 and not re.search(r'\b(Sr|Sra|Dr)\.$', texto[:m.end()]):
            return texto[:m.end()]
    if len(texto) <= limite:
        return texto
    corte = texto.rfind(' ', 0, limite)
    return texto[:corte if corte > 20 else limite].rstrip(' ,;:') + '...'


CAB = re.compile(r"' ===== (.*?)( @ [0-9a-f]+)? =====$")


def constroi_nomes(linhas):
    """Mapa nome-antigo -> nome-novo dos rótulos de verbos e salas, e o comentário de cada rotina (pelo nome novo)."""
    mapa, coment = dict(ROTINAS), dict(COMENTARIO_ROTINA)
    salas = {}
    for k, t in enumerate(linhas):
        h = CAB.fullmatch(t)
        if not h or k + 1 >= len(linhas):
            continue
        titulo, rotulo = h.group(1), linhas[k + 1].rstrip(':')
        v = re.match(r'verbo (\d+) (\S+)', titulo)
        s = re.match(r'sala (\d+):', titulo)
        if v:
            novo = 'Verbo%s%s' % (v.group(1), rotulo[len('Verbo'):])
            mapa[rotulo] = novo
            coment[novo] = ', '.join(v.group(2).split('/'))
        elif s:
            nome, msg = None, None
            for t2 in linhas[k + 2:k + 40]:
                if CAB.fullmatch(t2):
                    break
                n = re.match(r'\s*NOMESALA\$ = "([^"]*)"', t2)
                if n and nome is None:
                    nome = camel(n.group(1))
                m = re.search(r'MENSAGEM\$ = "([^"]+)"', t2)
                if m and msg is None:
                    msg = m.group(1)
                if nome and msg:
                    break
            novo = 'Sala%s%s' % (s.group(1), NOMES_SALAS.get(int(s.group(1))) or nome or '')
            mapa[rotulo] = novo
            coment[novo] = resumo(msg or titulo.split(': ', 1)[1])
            salas[int(s.group(1))] = NOMES_SALAS.get(int(s.group(1))) or nome or ''
    # desvios internos: NomeX1 acompanha o nome da rotina
    for k, t in enumerate(linhas):
        m = re.fullmatch(r'(\w+?)X(\d+):', t)
        if m and m.group(1) in mapa and t[:-1] not in mapa:
            mapa[t[:-1]] = '%sX%s' % (mapa[m.group(1)], m.group(2))
    return mapa, coment, salas


def nomes_objetos(linhas):
    """Número do objeto -> nome, pelos DATA que o laço READ OBJ$(I) consome (um por objeto, na ordem)."""
    k = next(i for i, t in enumerate(linhas) if t.strip().startswith('READ OBJ$(I)'))
    n = int(next(re.search(r'NUMOBJ = (\d+)', t).group(1) for t in linhas[:k] if re.search(r'NUMOBJ = (\d+)', t)))
    dados = [re.match(r'\s*DATA "([^"]*)"', t).group(1) for t in linhas[k:] if t.lstrip().startswith('DATA ')][:n]
    return {i + 1: nome if len(nome) <= 3 else nome.capitalize() for i, nome in enumerate(dados)}


# Números de objetos e salas que viram comentário: OBJ = n, SALA <> n (faixas como SALA <= 10 ficam sem nome),
# LOCOBJ(n) = -m (objeto n, na sala m), VISITADA(n) e SAIDANORTE = n (sala de destino).
NUMEROS = re.compile(r'(?<![A-Za-z0-9$])(?:(OBJ|SALA) *(?:=|<>) *(\d+)|LOCOBJ\((\d+)\)(?: *(?:=|<>) *-?(\d+))?|'
                     r'VISITADA\((\d+)\)|SAIDA[A-Z]+ *= *(\d+))(?![A-Za-z0-9])')


SO_NUMERO = re.compile(r'(?<![A-Za-z0-9$_])\d+')


def anota_numeros(linhas, salas, objetos):
    """Acrescenta ao fim de cada instrução `' 71=CD, 62=Mesa`: nomes dos objetos e salas citados, na ordem do código.
    Se o número citado é o único da instrução, o comentário traz só o nome."""
    def nome(tabela, n):
        return (n, tabela[n]) if tabela.get(n) else None

    out, grupo = [], []
    for t in linhas:
        grupo.append(t)
        if t.endswith(' _'):
            continue                                          # instrução continuada: o comentário vai na última linha
        codigo = [g for g in grupo if not g.lstrip().startswith(("'", 'DATA'))]
        achados = []
        for g in codigo:
            for trecho, dentro in fora_de_aspas(g):
                if dentro:
                    continue
                for m in NUMEROS.finditer(trecho):
                    if m.group(1):
                        achados.append(nome(objetos if m.group(1) == 'OBJ' else salas, int(m.group(2))))
                    elif m.group(3):
                        achados.append(nome(objetos, int(m.group(3))))
                        if m.group(4) and int(m.group(4)):
                            achados.append(nome(salas, int(m.group(4))))
                    else:
                        achados.append(nome(salas, int(m.group(5) or m.group(6))))
        achados = list(dict.fromkeys(a for a in achados if a))      # 0 e números sem nome ficam sem anotação; sem repetidos
        so_um = len(achados) == 1 and sum(len(SO_NUMERO.findall(t)) for g in codigo for t, q in fora_de_aspas(g) if not q) == 1
        achados = [a[1] if so_um else '%d=%s' % a for a in achados]
        if achados and len(codigo) == len(grupo) and not posicoes(t, "'"):
            grupo[-1] = t + " ' " + ', '.join(achados)
        out.extend(grupo)
        grupo = []
    return out + grupo


# ---------------------------------------------------------------- tudo junto

# O jogo grava `ä ö Ä Ö Å` e mostra `ã õ Ã Õ Á` (ver python/modernizar.py). Ler tudo como CP860 daria `Â` no lugar de
# `Á`; as outras letras acentuadas têm o mesmo código no CP437 e no CP860.
_PARA_UNICODE = str.maketrans({'ä': 'ã', 'ö': 'õ', 'Ä': 'Ã', 'Ö': 'Õ', 'Å': 'Á'})

TEXTOS_COMENTARIO = {
    "' Objetos: nome, local inicial (negativo: fixo no local), texto que a sala mostra com o objeto e texto do EXAMINAR":
        "' Objetos: nome, sala (local) inicial, descrição na sala e texto do EXAMINAR.\n"
        "' Valores especiais de local:\n"
        "'   negativo = fixo (não pode ser pego, mesmo estando naquela sala)\n"
        "'   0        = fora do jogo (ainda não apareceu, foi destruído ou é uma\n"
        "'              palavra imaterial, como NORTE)\n"
        "'   -999     = com o jogador (no inventário)"}

# comentários extras em linhas específicas (texto antes do comentário de números -> comentário acrescentado)
EXTRAS = {"LOCOBJ(34) = -998 ' 34=Passagem": "; -998 e não 0, senão a Mala devolveria a passagem"}

CABECALHO = ["' LEGIVEL.BAS: o CA1.BAS escrito para leitura (gerado por basic/gerar.py",
             "' --legivel a partir do CA1.EXE). Nomes de variáveis, rótulos e comentários são",
             "' nossos: o executável não guarda nenhum. Os números de salas, verbos e objetos",
             "' são os do jogo. O texto é UTF-8 (o jogo grava ä ö Ä Ö Å e mostra ã õ Ã Õ Á).",
             ""]


def legivel(linhas, fiel=False):
    linhas = junta_continuacoes(list(linhas))
    mapa, coment, salas = constroi_nomes(linhas)
    objetos = nomes_objetos(linhas)
    rx_rot = regex_de(mapa)
    rx_var = regex_de(VARIAVEIS)
    out = []
    for t in linhas:
        if t.startswith("' CA1.BAS gerado") or t.startswith("' Nomes de variáveis e de rótulos"):
            continue
        if t.strip() == 'READ C' or 'CHR$(C - I)' in t:
            t = t.replace('READ C', 'READ CODIGO').replace('CHR$(C - I)', 'CHR$(CODIGO - I)')
            out.append(t)
            continue
        if t.lstrip().startswith("'"):
            ind = t[:len(t) - len(t.lstrip())]
            out.extend(ind + x for x in TEXTOS_COMENTARIO.get(t.strip(), t.strip()).split('\n'))
            continue
        corte = t.find("   ' ")
        if corte > 0 and posicoes(t, "   ' ") == [corte]:
            t = t[:corte]                                        # o nome da rotina já diz o que ela faz
        t = troca_palavras(t, mapa, rx_rot)
        if 'S51E$' in t or t.strip() == 'S = (80 + -LEN(S51E$)) / 2':
            t = troca_palavras(t, {'S51E$': 'TEXTO$'}, regex_de({'S51E$': 1}))
        else:
            t = troca_palavras(t, VARIAVEIS, rx_var)
        out.append(t)
    # cabeçalhos de rotina: sem endereço nem "sub-rotina:"; com o que a rotina faz, quando o nome não basta
    final, vistos, k = [], set(), 0
    while k < len(out):
        t = out[k]
        h = CAB.fullmatch(t)
        rotulo = out[k + 1].rstrip(':') if h and k + 1 < len(out) else t[:-1] if re.fullmatch(r'\w+:', t) else None
        if rotulo in coment and rotulo not in vistos:
            vistos.add(rotulo)
            final.append('')
            final.extend(quebra_comentario("' " + coment[rotulo]))
        elif h:
            final.append('')
        if h:
            k += 1
            continue
        final.append(t)
        k += 1
    FIEL[0] = fiel
    final = ajusta_largura(final, fiel)
    final = acerta_blocos(final)
    final = anota_numeros(final, salas, objetos)
    final = [t + EXTRAS[t.strip()] if t.strip() in EXTRAS else t for t in final]
    final = marca_inalcancaveis(final)
    return '\n'.join(CABECALHO) + '\n' + '\n'.join(final).translate(_PARA_UNICODE) + '\n'


TERMINA_FLUXO = re.compile(r'(GOTO \w+|RETURN|END)')
CONTINUA_BLOCO = re.compile(r"(END IF|ELSE|ELSEIF|NEXT|WEND|LOOP|CASE|END SELECT|'|\w+:$)")


def marca_inalcancaveis(linhas):
    """O compilador não descarta código depois de um GOTO, RETURN ou END incondicional (provado em
    rosetta/t33.txt); o CA1.EXE tem alguns. Marca a linha, sem mudar o código."""
    out, morto = [], False
    for t in linhas:
        s = t.strip()
        if morto and s and not CONTINUA_BLOCO.match(s):
            t += "  ' inalcançável"
        morto = bool(TERMINA_FLUXO.fullmatch(s))
        out.append(t)
    return out


TEXTOS_BANNER = {"' INICIALIZACAO": "' INICIALIZAÇÃO",
                 "' Titulo, mensagens, tabelas (DATA) e estado inicial do jogo.": "' Título, mensagens, tabelas (DATA) e estado inicial do jogo.",
                 "' Mostra a sala quando muda, le e analisa o comando e executa o verbo.":
                     "' Mostra a sala quando muda, lê e analisa o comando e executa o verbo.",
                 "' SUB-ROTINAS (1/5): ENTRADA E TELA": "' ENTRADA E TELA",
                 "' SUB-ROTINAS (2/5): VERBOS": "' VERBOS",
                 "' Uma sub-rotina por verbo, escolhida por ON ... GOTO.":
                     "' Uma sub-rotina por verbo, escolhida por ON ... GOSUB no loop principal.\n"
                     "' O comentário antes de cada uma lista as palavras que a acionam.",
                 "' SUB-ROTINAS (3/5): USO GERAL": "' USO GERAL",
                 "' Avisos, mensagens e paineis.": "' Avisos, mensagens e painéis.",
                 "' SUB-ROTINAS (4/5): SALAS": "' SALAS",
                 "' SUB-ROTINAS (5/5): ARQUIVOS, MENU E FINAL": "' ARQUIVOS, AJUDA, NOTAS E FINAIS"}


def acerta_blocos(linhas):
    """Textos dos banners; o último banner antes de GravaJogo (o gerador o põe no meio dela); linha em branco antes
    dos banners e nenhuma depois; aviso no trecho que ninguém chama."""
    out = [x for t in linhas for x in TEXTOS_BANNER.get(t, t).split('\n')]
    k = next(i for i, t in enumerate(out) if t == "' ARQUIVOS, AJUDA, NOTAS E FINAIS")
    banner = out[k - 1:k + 2]
    del out[k - 1:k + 2]
    alvo = out.index('GravaJogo:')
    while out[alvo - 1].startswith("'") or out[alvo - 1] == '':
        alvo -= 1
        if out[alvo] == '':
            break
    out[alvo:alvo] = banner
    res, aberto, sem_branco = [], False, False
    for t in out:
        if t.startswith("' ***"):
            if not aberto and res and res[-1] != '':
                res.append('')
            aberto = not aberto
            sem_branco = not aberto
        elif t == '' and sem_branco:
            continue
        else:
            sem_branco = False
        if t.startswith('  S = (80 + -LEN(TEXTO$))'):
            res.append("  ' Trecho que nada chama: centraliza TEXTO$ em 80 colunas (S é só temporária)")
        res.append(t)
    return res
