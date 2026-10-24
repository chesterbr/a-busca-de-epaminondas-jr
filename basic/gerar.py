#!/usr/bin/env python3
"""Gera o fonte Turbo Basic (.BAS) a partir do CA1.EXE original.

Entrada: original/CA1.EXE (código), analise/dumps (pool de constantes, descritores de string, heap de textos) e
original/AVENTURA.MSG (só para comentários). Saída: o fonte em stdout (ou no arquivo dado em `-o`).

Como funciona: desmonta o código de usuário (capstone, 16 bits) com as regras do runtime do Turbo Basic
(escapes `INT 34h-3Bh` do 8087, operandos embutidos depois de `INT ECh`) e executa cada rotina simbolicamente,
reconhecendo os idiomas do compilador (comparação, booleano em AX, strings, arrays, ON GOSUB). Cada idioma
vira uma linha de BASIC; o que não é reconhecido sai como `REM ???` com o assembly, e o resumo no fim da
execução (stderr) diz quanto foi traduzido.

Números mágicos ficam literais. Os nomes de variáveis são rótulos nossos para os offsets do segmento de dados.
Uso: python3 gerar.py [-o saida.bas] [--regiao INICIO FIM]   (precisa do pacote `capstone`)
"""
import argparse
import re
import struct
import sys
from pathlib import Path

import capstone

RAIZ = Path(__file__).resolve().parent.parent
EXE = (RAIZ / 'original' / 'CA1.EXE').read_bytes()
G = (RAIZ / 'analise' / 'dumps' / 'G1.BIN').read_bytes()
HEAP = (RAIZ / 'analise' / 'dumps' / 'E2.BIN').read_bytes()
MSG = [m.decode('cp437') for m in (RAIZ / 'original' / 'AVENTURA.MSG').read_bytes().split(b'\r\n')]
IMG = EXE[0x20:]                      # imagem, endereços da listagem = offset no arquivo - 0x20
BASE_TABELA = 0x82c0                  # alvo de ON GOSUB = palavra da tabela + 0x82c0

# Rótulos nossos para offsets de DS (o original não tem nomes)
VAR = {0x4f6: 'SALA', 0x4b6: 'OBJ', 0x4d2: 'INDICEVERBO', 0x4da: 'SALAANT', 0x48e: 'N', 0x48a: 'S',
       0x486: 'L', 0x482: 'O', 0x50e: 'C', 0x46e: 'B', 0x4b2: 'OBJACHADO', 0x4d6: 'FLAG4D6',
       0x506: 'NUMSALAS', 0x4fe: 'NUMOBJ', 0x502: 'NUMSINONIMOS', 0x4f2: 'NUMPALAVROES', 0x4fa: 'NUMFILTRO', 0x50a: 'NUMMSG',
       0x4ea: 'GRANA', 0x4ee: 'NOZAVISO', 0x4e6: 'PORTAABERTA', 0x4e2: 'BARMAN', 0x4de: 'PAPELALUM', 0x46a: 'ELEVMOVEU',
       0x456: 'AULAUSADA', 0x4ce: 'ESPACO', 0x4ca: 'PALAVRAO', 0x4c6: 'QTDEPALAVROESDITOS', 0x4c2: 'J', 0x4ae: 'DUPLO', 0x4aa: 'K',
       0x49e: 'POSFILTRO', 0x49a: 'LIN', 0x47e: 'NINV', 0x47a: 'TOPO', 0x476: 'SEMESPERA', 0x472: 'PAGINA', 0x466: 'DESTINO',
       0x462: 'OPCAO', 0x45e: 'POSTECLA', 0x45a: 'COL', 0x452: 'LINBAK',
       0x512: 'V512', 0x51a: 'I', 0x516: 'FIM'}
ARR = {0x2d0: 'LOCOBJ', 0x372: 'VERBO', 0x33c: 'PARAM', 0x3a8: 'SINONIMOVERBO$', 0x306: 'OBJ$', 0x29a: 'AQUI$',
       0x264: 'EXAME$', 0x414: 'MSG$', 0x3de: 'VISITADA', 0x22e: 'INV$', 0x1f8: 'FILTRO$', 0x1c2: 'PALAVROES$'}
STR = {0x542: 'NOME$', 0x53a: 'AVISO$', 0x556: 'MENSAGEM$', 0x536: 'NOMESALA$', 0x55e: 'TITULO$', 0x546: 'PALAVRA$', 0x54e: 'COMANDO$',
       0x54a: 'ANTERIOR$', 0x552: 'TECLA$', 0x522: 'NOMEARQ$', 0x52e: 'TRECHO$', 0x52a: 'LINHAMSG$', 0x53e: 'TECLALISTA$', 0x532: 'TECLAMENU$',
       0x526: 'OBJSALA$', 0x55a: 'LANTERNA$'}
# Arrays estáticos (DIM com limite constante não gera código; a base em DS é o que sobra): base -> (nome, limite)
ESTATICOS = {0x11f0: ('DESCLISTA$', 4), 0x1210: ('BACKUP$', 11), 0x1240: ('JANELA$', 11)}
ARR_DS = {b: n for b, (n, _) in ESTATICOS.items()}


def estatico(a):
    for b, (n, m) in ESTATICOS.items():
        if b <= a < b + 4 * (m + 1):
            return '%s(%d)' % (n, (a - b) // 4)
    return None
LISTA_DATA = 0x10dd0                    # lista de ponteiros dos itens de DATA (logo depois do fim do código)
TMP = 0x2c                             # temporário usado nas conversões float <-> inteiro
REL = {'je': '=', 'jne': '<>', 'ja': '>', 'jg': '>', 'jae': '>=', 'jge': '>=', 'jb': '<', 'jl': '<', 'jbe': '<=',
       'jle': '<='}
NEG = {'=': '<>', '<>': '=', '>': '<=', '<=': '>', '>=': '<', '<': '>='}
FLIP = {'=': '=', '<>': '<>', '>': '<', '<': '>', '>=': '<=', '<=': '>='}
# Chamadas do runtime `INT EC/ED/EE <seletor>`: (tipo, seletor) -> bytes de operando embutidos (descobertos com basic/rosetta)
OPERANDOS = {(0xec, 0x22): 1, (0xec, 0x4c): 4, (0xec, 0x6e): 4, (0xec, 0xc4): 1}
SEM_OPERANDO = {0xec: {0x00, 0x0e, 0x14, 0x16, 0x18, 0x1a, 0x26, 0x28, 0x30, 0x50, 0x64, 0x80, 0x96, 0x98, 0x9a, 0x9c,
                       0x9e, 0xac, 0xae, 0xb8, 0xcc, 0xce, 0xe6, 0xea, 0xba, 0xb0, 0xb2, 0x2a, 0x2c, 0x36},
                0xed: {0x10, 0x14, 0x1c, 0x1e, 0x22, 0x3c, 0x44, 0x4a},
                0xee: {0x04, 0x0e, 0x10, 0x1e, 0x20, 0x24, 0x26, 0x28}}


def w(o):
    return struct.unpack('<H', G[o:o + 2])[0]


def cstr(texto):
    """Literal BASIC; aspas duplas dentro do texto viram CHR$(34)."""
    partes = texto.split('"')
    return ' + CHR$(34) + '.join('"%s"' % p for p in partes)


def descritor(a):
    """String do descritor em DS:a (literal no heap, ou texto fixo no segmento de dados)."""
    bruto, p = w(a), w(a + 2)
    ln = bruto & 0x7fff
    if not ln:
        return ''
    src = HEAP if bruto & 0x8000 or p >= 0x1000 else G
    return src[p:p + ln].decode('cp437')


class Ins:
    __slots__ = ('a', 'n', 'm', 'o', 'raw')

    def __init__(self, a, n, m, o, raw):
        self.a, self.n, self.m, self.o, self.raw = a, n, m, o, raw

    @property
    def fim(self):
        return self.a + self.n


md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)


def desmonta(ini, fim):
    """Varredura linear de [ini, fim) tratando os escapes do 8087 e os operandos embutidos do runtime.
    Devolve (instruções, tabelas) onde tabelas = {endereço do INT: (seletor, [alvos])}."""
    out, tabelas = [], {}
    a = ini
    while a < fim:
        b = IMG[a:a + 2]
        if b[0] == 0xcd and 0x34 <= b[1] <= 0x3c:       # escape do 8087: `INT 34h-3Bh` = FWAIT + ESC D8h-DFh; 3Ch = FWAIT + prefixo ES
            out.append(Ins(a, 1, 'wait', '', IMG[a:a + 1]))
            esc = 0x26 if b[1] == 0x3c else 0xd8 + b[1] - 0x34
            a += 1
            r = list(md.disasm(bytes([esc]) + IMG[a + 1:a + 8], a, 1))
            if not r:
                out.append(Ins(a, 1, 'db', '0x%02x' % IMG[a], IMG[a:a + 1]))
                a += 1
                continue
            out.append(Ins(a, r[0].size, r[0].mnemonic, r[0].op_str, IMG[a:a + r[0].size]))
            a += r[0].size
            continue
        elif b[0] == 0xcd and b[1] == 0x3e:             # chamada do emulador com 1 byte de função (ex.: potência `^`)
            out.append(Ins(a, 3, 'fpx', '0x%02x' % IMG[a + 2], IMG[a:a + 3]))
            a += 3
            continue
        elif b[0] == 0xcd and b[1] == 0x3d:             # FWAIT + NOP
            out.append(Ins(a, 2, 'wait', '', IMG[a:a + 2]))
            a += 2
            continue
        else:
            cod = IMG[a:a + 15]
        if b[0] == 0xcd and b[1] in (0xec, 0xed, 0xee):
            sel = IMG[a + 2]
            if b[1] == 0xec and sel in (0x70, 0x72):
                cnt = struct.unpack('<H', IMG[a + 3:a + 5])[0]
                alvos = [struct.unpack('<H', IMG[a + 5 + 4 * k:a + 7 + 4 * k])[0] + BASE_TABELA for k in range(cnt)]
                tabelas[a] = (sel, alvos)
                out.append(Ins(a, 5 + 4 * cnt, 'on', '0x%x' % sel, IMG[a:a + 5 + 4 * cnt]))
                a += 5 + 4 * cnt
                continue
            tam = OPERANDOS.get((b[1], sel), 0)
            if tam == 0 and sel not in SEM_OPERANDO[b[1]]:
                sys.stderr.write('aviso: seletor desconhecido INT %02X %02X em %05x\n' % (b[1], sel, a))
            out.append(Ins(a, 3 + tam, 'rt', '0x%x 0x%x' % (b[1], sel), IMG[a:a + 3 + tam]))
            a += 3 + tam
            continue
        r = list(md.disasm(cod, a, 1))
        if not r:
            out.append(Ins(a, 1, 'db', '0x%02x' % IMG[a], IMG[a:a + 1]))
            a += 1
            continue
        i = r[0]
        n = i.size
        op = i.op_str
        if i.mnemonic.startswith('j') or i.mnemonic in ('call', 'loop'):
            try:
                t = num(op)
                # o IP dá a volta em 64 KB: o código vai de 0x82c0 a 0x10dae na imagem
                if t >= 0x10dae + 0x100:
                    t -= 0x10000
                elif t < 0x82c0:
                    t += 0x10000
                op = '0x%x' % t
            except ValueError:
                pass
        out.append(Ins(a, n, i.mnemonic, op, IMG[a:a + n]))
        a += n
    return out, tabelas


def par(x):
    """Parênteses em volta de uma relação ou de AND/OR usada como número (-1 ou 0)."""
    x = str(x)
    if len(divide_topo(x, ['AND', 'OR'])[0]) > 1 or relacao(x):
        return '(%s)' % x
    return x


PREC = {'OR': 0, 'AND': 1, 'NOT': 2, 'rel': 3, '+': 4, '-': 4, '*': 6, '/': 6, 'neg': 7}


class Ex(str):
    """Expressão com a precedência do operador de cima (para só pôr parênteses onde a árvore exige)."""
    prec = 10


class ExF(Ex):
    """Resultado inteiro de uma função (LEN, INSTR...) convertido para ponto flutuante."""


def ex(texto, prec):
    e = Ex(texto)
    e.prec = prec
    return e


def pd(x):
    if isinstance(x, Ex):
        return x.prec
    t = str(x)
    if re.fullmatch(r'-?[\w$.]+|"[^"]*"', t):
        return 10
    m = re.fullmatch(r'[A-Z][A-Z0-9$]*\(.*\)', t)
    if m:                                  # chamada ou elemento de array: os parênteses abertos no começo fecham no fim
        nivel = 0
        for j in range(t.index('('), len(t)):
            nivel += t[j] == '('
            nivel -= t[j] == ')'
            if nivel == 0 and j < len(t) - 1:
                return -1
        return 10
    return -1


FUNCOES = {'ABS', 'INT', 'FIX', 'VAL', 'SGN', 'LEN', 'ASC', 'INSTR', 'CHR$', 'LEFT$', 'RIGHT$', 'MID$', 'STR$', 'UCASE$', 'RND'}


def simples(x):
    """Número, variável ou elemento de array (carregado com um `fld`/`fild` só)."""
    t = str(x)
    if isinstance(x, Ex):
        return bool(re.fullmatch(r'-?\d+', t))
    if re.fullmatch(r'-?[\w$.]+', t):
        return True
    m = re.fullmatch(r'([A-Z][A-Z0-9$]*)\(.*\)', t)
    return bool(m) and m.group(1) not in FUNCOES and pd(t) == 10


def binop(a, op, b, prec):
    l, r = str(a), str(b)
    if pd(a) < prec or (prec == 0 and pd(a) == 1):
        l = '(%s)' % l       # grupos AND dentro de OR: o original os tinha entre parênteses (sem curto-circuito)
    if pd(b) <= prec or (prec == 0 and pd(b) == 1):
        r = '(%s)' % r
    return ex('%s %s %s' % (l, op, r), prec)


def unario(prefixo, x, prec):
    t = str(x)
    if pd(x) < prec:
        t = '(%s)' % t
    return ex(prefixo + t, prec)


def P(x):
    """Sem os parênteses externos (argumentos e lados direitos de atribuição)."""
    return Tradutor.sem_parens(str(x))


def num(s):
    return int(s, 16) if s.startswith('0x') else int(s)


MEM = re.compile(r'^(?:(?:byte|word|dword|qword) ptr )?(?:(es):)?\[(0x[0-9a-f]+|si|bx|di)\]$')


FORVARS = set()          # variáveis de laço FOR: `v + w` com uma delas compila como `eval(w) / fadd v`
GRUPO_AND = re.compile(r'(?!.* OR ).* AND .*')
CMP_TEXTO = re.compile(r'(?!.* (OR|AND) )[A-Za-z0-9.]+\$ = .*')


class Tradutor:
    def __init__(self, ins, tabelas, alvos_extra=()):
        self.ins = ins
        self.tabelas = tabelas
        self.idx = {i.a: k for k, i in enumerate(ins)}
        self.alvos = set(alvos_extra)
        interno = set()
        for k, i in enumerate(ins[:-2]):
            if i.m == 'mov' and i.o == 'ax, 0xffff' and ins[k + 1].m in REL and ins[k + 2].m == 'inc':
                interno.add(ins[k + 2].fim)
        for i in ins:
            if i.m == 'call' or i.m == 'jmp' or i.m in REL or i.m in ('jo', 'jno', 'jp', 'jnp', 'js', 'jns', 'loop'):
                try:
                    self.alvos.add(num(i.o))
                except ValueError:
                    pass
        for _, ts in tabelas.values():
            self.alvos.update(ts)
        self.alvos -= interno
        self.cai = set()                  # `jcc X; jmp Y; <aqui>`: o ramo "verdadeiro" é a queda, não um recomeço
        for k, i in enumerate(ins[:-1]):
            if i.m in REL and ins[k + 1].m == 'jmp':
                self.cai.add(ins[k + 1].fim)
        self.linhas = []                  # (endereço, texto)
        self.dim_limite = {}
        self.entrada = ''
        self.pf = '?'
        self.nao_traduzido = 0
        self.traduzido = 0

    # -- utilidades ---------------------------------------------------
    def rot(self, a):
        return '<<L%X>>' % a

    def comenta_msg(self, idx):
        if self.es_off == 0x414 and 1 <= idx <= len(MSG):
            return "msg %d: %s" % (idx - 1, MSG[idx - 1][:60])
        return None

    def reseta(self):
        self.fp = []
        self.ax = self.bx = self.cx = self.dx = self.di = self.si = None
        self.es = None
        self.cmp = None                   # (tipo, esq, dir) da última comparação
        self.truth = None                 # expressão cujo valor foi testado por `or ax, ax`
        self.sp = []                      # strings
        self.tmp = None
        self.coment = None
        self.or_pend = []
        self.slot = {}                    # palavras de DS usadas como argumento de chamadas do runtime ([0x88], [0x94], [0x60]...)
        self.prt = []                     # itens de um PRINT em andamento (strings, números, TAB, SPC)

    def flush_print(self, a, nl=False):
        if self.prt:
            self.linhas.append((a, 'PRINT ' + self.junta_print(self.prt) + ('' if nl else ';')))
            self.traduzido += 1
            self.prt = []
        elif nl:
            self.linhas.append((a, 'PRINT'))
            self.traduzido += 1

    @staticmethod
    def junta_print(itens):
        out = ''
        for it in itens:
            if it == ',':
                out += ','
            else:
                out += ('; ' if out and not out.endswith(',') else '') + it
        return out

    def emite(self, a, txt):
        if self.prt:
            self.flush_print(a)
        if self.coment and txt.endswith(')') is not None and 'MSG$' in txt:
            txt += "   ' " + self.coment
            self.coment = None
        self.linhas.append((a, txt))
        self.traduzido += 1

    def nada(self, i, motivo=''):
        self.linhas.append((i.a, "REM ??? %05x  %s %s%s" % (i.a, i.m, i.o, ('  ; ' + motivo) if motivo else '')))
        self.nao_traduzido += 1

    def var(self, o):
        return VAR.get(o, 'V%X' % o)

    def mem(self, op):
        """Operando de memória numérico (float): variável, elemento de array ou None."""
        m = MEM.match(op)
        if not m:
            return None
        es, off = m.groups()
        if es:
            nome = ARR.get(self.es_off, 'ARR%X' % (self.es_off or 0))
            if off == 'si':
                return '%s(%s)' % (nome, self.si_idx())
            return '%s(%d)' % (nome, num(off) // 4)
        if off.startswith('0x'):
            return self.var(num(off))
        return None

    def si_idx(self):
        if isinstance(self.si, tuple):       # ('idx', expr, deslocamento)
            return self.si[1]
        return '?%s' % (self.si,)

    # -- tradução -----------------------------------------------------
    def cond_rel(self, jm):
        rel = REL[jm]
        if self.truth is not None:           # `or ax, ax`: je = falso, jne = verdadeiro
            if 'None' in str(self.truth):
                return None
            return self.truth if jm == 'jne' else unario('NOT ', self.truth, 2)
        if self.cmp is None:
            return None
        if self.cmp[0] == 'sinal':
            return '%s >= 0' % self.cmp[1] if jm == 'je' else '%s < 0' % self.cmp[1]
        a, b = self.cmp[1], self.cmp[2]
        modo = self.cmp[3] if len(self.cmp) > 3 else None
        if 'None' in (str(a), str(b)) or '?' in (str(a) + str(b)):
            return None
        # `L rel R` compila como `eval(R) / fcomp L` quando R é simples (variável, constante, elemento de array)
        # ou resultado de função; com R complexo, `eval(L) / fcomp R`
        if modo == 'mem' and (simples(a) or isinstance(a, ExF)):
            a, b, rel = b, a, FLIP[rel]
        return binop(a, rel, b, 3)

    def corrige_neg(self, c):
        return c

    def traduz(self):
        ins = self.ins
        k = 0
        self.reseta()
        while k < len(ins):
            i = ins[k]
            if i.a in self.alvos:
                self.flush_print(i.a)        # `PRINT x;` pendente termina antes do alvo do salto
                self.linhas.append((i.a, self.rot(i.a) + ':'))
                if k == 0 or (ins[k - 1].m in ('ret', 'jmp') and i.a not in self.cai):
                    self.reseta()
            k = self.um(k)
        eh_rot = lambda t: re.fullmatch(r'<<L[0-9A-F]+>>:', t)       # noqa: E731
        usados = set(re.findall(r'<<L[0-9A-F]+>>', ' '.join(t for _, t in self.linhas if not eh_rot(t))))
        self.linhas = [(a, t) for a, t in self.linhas if not (eh_rot(t) and t[:-1] not in usados)]
        return self.linhas

    def proximo_fstp_mesmo(self, k, o):
        """O `fadd` é o incremento do NEXT (`v = passo + v`): o resultado volta para a mesma variável."""
        for j in self.ins[k + 1:k + 4]:
            if j.m != 'wait':
                return j.m == 'fstp' and j.o == o
        return False

    def um(self, k):
        ins = self.ins
        i = ins[k]
        m, o = i.m, i.o
        prox = ins[k + 1] if k + 1 < len(ins) else None
        if m in ('nop', 'wait'):
            return k + 1
        # --- FPU ---
        if m == 'fldz':
            self.fp.append('0')
        elif m == 'fld1':
            self.fp.append('1')
        elif m == 'fild':
            mm = MEM.match(o)
            off = num(mm.group(2))
            if off == TMP:
                t0 = self.tmp
                if not re.fullmatch(r'-?\d+', str(t0)):       # vindo de AX: `v + x` fica com o operando de memória à esquerda
                    f = ExF(str(t0))
                    f.prec = pd(t0)
                    t0 = f
                self.fp.append(t0 if isinstance(t0, Ex) else str(t0))
            elif o.startswith('dword ptr'):
                self.fp.append(str(struct.unpack('<i', G[off:off + 4])[0]))     # constante de 32 bits (ex.: 36000)
            elif off == 0x74:
                self.fp.append('ERR')                                          # número do erro (ON ERROR)
            else:
                self.fp.append(str(struct.unpack('<h', G[off:off + 2])[0]))
        elif m == 'fld':
            e = self.mem(o)
            if e is None:
                self.nada(i)
            else:
                self.fp.append(e)
        elif m == 'fabs':
            self.fp[-1] = 'ABS(%s)' % self.fp[-1]
        elif m in ('fadd', 'fsub', 'fmul', 'fdiv', 'fsubr', 'fdivr') and self.fp:
            e = self.mem(o)
            if e is None:
                self.nada(i)
            else:
                t = self.fp[-1]
                sym = {'fadd': '+', 'fsub': '-', 'fmul': '*', 'fdiv': '/', 'fsubr': '-', 'fdivr': '/'}[m]
                a, b = (e, t) if m in ('fsubr', 'fdivr') else (t, e)
                if m in ('fadd', 'fmul') and (re.fullmatch(r'-?\d+', str(t)) or isinstance(t, ExF) or ((str(t) in FORVARS) != (str(e) in FORVARS) and not self.proximo_fstp_mesmo(k, o))):
                    a, b = e, t              # `v + 1` e `v + LEN(x)` compilam como `eval(direita) / fadd v`: o operando de memória estava à esquerda
                self.fp[-1] = binop(a, sym, b, PREC[sym])
        elif m in ('fiadd', 'fisub', 'fisubr', 'fimul', 'fidiv', 'fidivr') and self.fp and MEM.match(o):
            off = num(MEM.match(o).group(2))
            e = str(self.tmp) if off == TMP else str(struct.unpack('<h', G[off:off + 2])[0])
            sym = {'fiadd': '+', 'fisub': '-', 'fisubr': '-', 'fimul': '*', 'fidiv': '/', 'fidivr': '/'}[m]
            a, b = (e, self.fp[-1]) if m in ('fisubr', 'fidivr') else (self.fp[-1], e)
            if m in ('fiadd', 'fimul'):
                a, b = e, self.fp[-1]        # `2 + v` compila como `fld v / fiadd 2`
            self.fp[-1] = binop(a, sym, b, PREC[sym])
        elif m in ('faddp', 'fsubp', 'fsubrp', 'fmulp', 'fdivp', 'fdivrp') and len(self.fp) > 1:
            b = self.fp.pop()
            a = self.fp[-1]
            sym = {'faddp': '+', 'fsubp': '-', 'fsubrp': '-', 'fmulp': '*', 'fdivp': '/', 'fdivrp': '/'}[m]
            x, y = (b, a) if m in ('fsubrp', 'fdivrp') else (a, b)
            self.fp[-1] = binop(x, sym, y, PREC[sym])
        elif m == 'fistp':
            self.tmp = self.fp.pop() if self.fp else '?'
        elif m == 'fstp':
            e = self.mem(o)
            if e is None or not self.fp:
                self.nada(i)
            else:
                self.asigna(i.a, e, self.fp.pop())
        elif m in ('fcomp', 'fcompp'):
            if m == 'fcomp':
                e = self.mem(o)
                esq = self.fp.pop() if self.fp else '?'
                if e is None:
                    self.nada(i)
                    return k + 1
                self.cmp = ('num', esq, e, 'mem')
            else:
                esq = self.fp.pop() if self.fp else '?'
                dir_ = self.fp.pop() if self.fp else '?'
                self.cmp = ('num', esq, dir_, 'pp')
            self.truth = None
        # --- registradores ---
        elif m == 'mov':
            return self.mov(k)
        elif m == 'neg' and o == 'ax':
            self.ax = ex('-' + str(self.ax), 10) if re.fullmatch(r'\d+', str(self.ax)) else unario('-', self.ax, 7)
        elif m == 'xor' and o == 'ax, ax':
            self.ax = '0'
        elif m == 'xchg':
            self.nada(i)
        elif m == 'cdq' or (m == 'idiv'):
            self.nada(i)
        elif m == 'shl' and o.startswith('si') and isinstance(self.si, tuple):
            self.si = (self.si[0], self.si[1], self.si[2] + 1)
        elif m == 'add' and o.startswith('si, '):
            self.si = ('base', self.si, num(o.split(', ')[1]))
        elif m == 'or' and o == 'ax, ax':
            if self.or_pend:
                acc = None
                for t1 in self.or_pend + [self.ax]:
                    acc = t1 if acc is None else binop(acc, 'OR', t1, 0)
                self.ax = acc
                self.or_pend = []
            self.truth = self.ax
            self.cmp = None
        elif m in ('and', 'or') and o == 'ax, bx':
            esq, dir_ = self.bx, self.ax
            if m == 'or' and CMP_TEXTO.match(str(esq)) and CMP_TEXTO.match(str(dir_)):
                esq, dir_ = dir_, esq        # `a$ = x OR a$ = y` (sem curto-circuito): o compilador avalia a comparação da direita primeiro
            if m == 'or' and GRUPO_AND.match(str(esq)) and GRUPO_AND.match(str(dir_)):
                esq, dir_ = dir_, esq        # `(a AND b) OR (c AND d)` sem curto-circuito: o segundo grupo é avaliado primeiro
            self.ax = binop(esq, m.upper(), dir_, PREC[m.upper()])
            self.truth = self.ax
        elif m == 'cmp' and o == 'ax, bx':
            self.cmp = ('int', self.ax, self.bx)
            self.truth = None
        elif m == 'sub' and o == 'ax, bx':
            self.ax = binop(self.ax, '-', self.bx, 4)
        elif m == 'add' and o == 'ax, bx':
            self.ax = binop(self.ax, '+', self.bx, 4)
        elif m == 'imul' and o == 'bx':
            self.ax = binop(self.ax, '*', self.bx, 6)
        elif m == 'imul' and re.fullmatch(r'word ptr \[0x[0-9a-f]+\]', o):
            off = num(o[o.index('[') + 1:-1])
            self.ax = binop(struct.unpack('<h', G[off:off + 2])[0], '*', self.ax, 6)
        elif m in ('add', 'sub', 'cmp') and re.fullmatch(r'ax, word ptr \[0x[0-9a-f]+\]', o):
            off = num(o[o.index('[') + 1:-1])
            val = struct.unpack('<h', G[off:off + 2])[0]
            if m == 'cmp':
                self.cmp = ('int', self.ax, str(val))
                self.truth = None
            else:
                # `const + LEN(x)` compila como `ax = LEN / add ax,[const]`; `LEN(x) + const` carrega a constante antes
                self.ax = binop(val, '+', self.ax, 4) if m == 'add' else binop(self.ax, '-', val, 4)
        elif m == 'test' and re.fullmatch(r'word ptr \[0x[0-9a-f]+\], 0x8000', o):
            self.cmp = ('sinal', self.var(num(o[o.index('[') + 1:o.index(']')]) - 2), '0')
            self.truth = None
        elif m == 'not' and o == 'ax':
            self.ax = unario('NOT ', self.ax, 2)
        elif m == 'mov' and o == 'ax, bx':
            self.ax = self.bx
        elif m == 'inc' and o == 'ax':
            self.nada(i)
        # --- strings e runtime ---
        elif m == 'int':
            return self.runtime(k)
        elif m == 'rt':
            return self.rt(k)
        elif m == 'on':
            return self.on(k)
        # --- fluxo ---
        elif m == 'call':
            self.emite(i.a, 'GOSUB %s' % self.rot(num(o)))
            self.reseta()
        elif m == 'ret':
            self.emite(i.a, 'RETURN')
        elif m == 'jmp':
            self.emite(i.a, 'GOTO %s' % self.rot(num(o)))
        elif m in REL:
            return self.salto(k)
        else:
            self.nada(i)
        return k + 1

    def dim_alvo(self, off):
        return off if (off - 0xa) in ARR else None

    def mov(self, k):
        i = self.ins[k]
        o = i.o
        a, _, b = o.partition(', ')
        if a == 'ax' and b == '0xffff':
            # mov ax, 0xffff ; jcc L ; inc ax ; L:  => AX = (condição)
            n1, n2 = self.ins[k + 1], self.ins[k + 2]
            if n1.m in REL and n2.m == 'inc' and n2.o == 'ax' and num(n1.o) == n2.fim:
                self.ax = self.cond_rel(n1.m)
                self.truth = None
                return k + 3
            self.ax = '-1'
        elif a == 'ax' and re.fullmatch(r'(0x[0-9a-f]+|\d+)', b):
            self.ax = str(num(b))
        elif a == 'ax' and b == 'word ptr [0x2c]':
            self.ax = self.tmp
        elif a == 'word ptr [0x2c]' and b == 'ax':
            self.tmp = self.ax
        elif a == 'word ptr [0x78]' and b == '0':
            self.emite(i.a, 'RESTORE')
        elif re.fullmatch(r'word ptr \[0x[0-9a-f]+\]', a) and (b == 'ax' or re.fullmatch(r'(0x[0-9a-f]+|\d+)', b)):
            off = num(a[10:-1])
            val = self.ax if b == 'ax' else str(num(b))
            self.slot[off] = val
            if off == self.dim_alvo(off):
                self.dim_limite[off - 0xa] = val
        elif a in ('ax', 'bx', 'cx', 'di') and b in ('ax', 'bx', 'cx', 'di'):
            setattr(self, a, getattr(self, b))
        elif a == 'si' and b == 'ax':
            self.si = ('idx', self.ax, 0)
        elif a == 'si' and re.fullmatch(r'(0x[0-9a-f]+|\d+)', b):
            self.si = num(b)
        elif a == 'es' and b.startswith('word ptr ['):
            self.es_off = num(b[len('word ptr ['):-1])
            self.es = 'arr'
        elif a == 'word ptr [0x78]' and b == '0':
            self.emite(i.a, 'RESTORE')
        elif a == 'es' and b == 'dx':
            pass
        elif a == 'dx' and not b.startswith('word'):
            self.dx = b
        elif a == 'dx':
            pass
        elif a == 'es':
            self.nada(i)
        elif a == 'ax' and b == 'si':
            self.ax = self.si
        else:
            self.nada(i)
        return k + 1

    def salto(self, k):
        """jcc X; (jmp Y)  =>  IF ... GOTO."""
        i = self.ins[k]
        if self.or_pend and self.truth is not None:
            acc = None
            for t1 in self.or_pend + [self.truth]:
                acc = t1 if acc is None else binop(acc, 'OR', t1, 0)
            self.truth = self.ax = acc
            self.or_pend = []
        mat = self.truth is not None and self.cmp is None        # condição passou por um booleano em AX
        cond = self.cond_rel(i.m)
        if cond is None:
            self.nada(i, 'condição desconhecida')
            return k + 1
        cond = self.sem_parens(cond)
        # relação simples via booleano em AX: no Turbo Basic é o código de IF em bloco e de WHILE (o IF de uma linha
        # compara direto); condições compostas passam pelo booleano de qualquer jeito
        marca = '\x02' if mat and len(divide_topo(cond, ['AND', 'OR'])[0]) == 1 and relacao(cond) else ''
        x = num(i.o)
        prox = self.ins[k + 1] if k + 1 < len(self.ins) else None
        if prox and prox.m == 'jmp':
            y = num(prox.o)
            nxt = prox.fim
            ant = self.ins[self.idx[y] - 1] if y in self.idx else None
            if x == nxt and ant is not None and ant.m in ('and', 'or') and ant.o == 'ax, bx' and i.m == 'jne':
                return k + 2            # curto-circuito de AND: o teste final fica depois do segundo operando
            if x == nxt and ant is not None and i.m == 'je' and (ant.m == 'inc' and ant.o == 'ax' or
                                                                 ant.m in ('and', 'or') and ant.o == 'ax, bx'):
                t1 = self.truth if isinstance(self.truth, Ex) else self.sem_parens(str(self.truth))
                self.or_pend.append(t1)  # curto-circuito de OR: se verdadeiro vai direto ao teste final
                return k + 2
            if x == nxt:
                self.emite(i.a, 'IF%s %s THEN GOTO %s' % (marca, self.nega(cond), self.rot(y)))
            elif y == nxt:
                self.emite(i.a, 'IF%s %s THEN GOTO %s' % (marca, cond, self.rot(x)))
            else:
                self.emite(i.a, 'IF %s THEN GOTO %s ELSE GOTO %s' % (cond, self.rot(x), self.rot(y)))
            self.cmp = self.truth = None
            return k + 2
        self.emite(i.a, 'IF %s THEN GOTO %s' % (cond, self.rot(x)))
        return k + 1

    @staticmethod
    def sem_parens(c):
        while c.startswith('(') and c.endswith(')'):
            nivel = 0
            for j, ch in enumerate(c):
                nivel += ch == '('
                nivel -= ch == ')'
                if nivel == 0 and j < len(c) - 1:
                    return c
            c = c[1:-1]
        return c

    def nega(self, cond):
        return nega_texto(cond)

    def str_desc(self, a):
        if a in STR:
            return STR[a]
        if estatico(a):
            return estatico(a)
        if a < 0x570 or a >= 0xf50:          # fora do pool de literais: variável de string
            return 'S%X$' % a
        return cstr(descritor(a))

    def asigna(self, a, alvo, valor):
        if str(valor).startswith('\x01'):       # leitura (INPUT, LINE INPUT, READ): vira instrução de entrada
            self.emite(a, valor[1:] + alvo)
        else:
            self.emite(a, '%s = %s' % (alvo, P(valor)))

    def pop_str(self):
        return self.sp.pop() if self.sp else '?'

    def pop_fp(self):
        return self.fp.pop() if self.fp else '?'

    def runtime(self, k):
        i = self.ins[k]
        n = num(i.o)
        if n in (0x81, 0x93):
            return k + 1                  # espera do 8087 / flags da comparação em ponto flutuante
        a = self.ax
        if n == 0x96 and isinstance(self.si, int):
            self.sp.append(self.str_desc(self.si))
        elif n == 0x96 and isinstance(self.si, tuple):
            self.sp.append(self.elemento(self.si))
        elif n == 0x97 and isinstance(self.si, int) and self.es:
            self.sp.append('%s(%d)' % (ARR.get(self.es_off, 'ARR%X$' % self.es_off), self.si // 4))
            self.coment = self.comenta_msg(self.si // 4)
        elif n == 0x97 and isinstance(self.si, tuple) and self.es:
            self.sp.append('%s(%s)' % (ARR.get(self.es_off, 'ARR%X$' % self.es_off), self.si_idx()))
        elif n == 0x9a and isinstance(self.si, int) and self.sp:
            self.asigna(i.a, self.str_desc(self.si), self.sp.pop())
        elif n == 0x9a and isinstance(self.si, tuple) and self.sp:
            self.asigna(i.a, self.elemento(self.si), self.sp.pop())
        elif n == 0x9b and self.es and self.sp:
            nome = ARR.get(self.es_off, 'ARR%X$' % self.es_off)
            idx = self.si // 4 if isinstance(self.si, int) else self.si_idx()
            self.asigna(i.a, '%s(%s)' % (nome, idx), self.sp.pop())
        elif n == 0x95 and len(self.sp) > 1:
            b = self.sp.pop()
            self.sp[-1] = binop(self.sp[-1], '+', b, 4)
        elif n == 0x94 and len(self.sp) > 1:
            b = self.sp.pop()
            a2 = self.sp.pop()
            self.cmp = ('str', a2, b)
            self.truth = None
        # --- tela ---
        elif n == 0xb8:
            self.prt.append(self.pop_str())
        elif n == 0xb5:
            self.prt.append(self.pop_fp())
        elif n == 0xb2:
            self.flush_print(i.a, nl=True)
        elif n == 0xc1:
            self.prt.append('TAB(%s)' % P(a))
        elif n == 0xbe:
            self.prt.append('SPC(%s)' % P(a))
        elif n == 0xbb:
            self.prt.append(',')
        elif n == 0xc9:
            self.emite(i.a, 'LOCATE %s, %s' % (P(self.bx), P(a)))
        # --- funções de string ---
        elif n == 0xad:
            self.sp.append('CHR$(%s)' % P(a))
        elif n == 0xa0:
            self.ax = 'ASC(%s)' % self.pop_str()
        elif n == 0xa7:
            self.sp.append('LEFT$(%s, %s)' % (self.pop_str(), P(a)))
        elif n == 0xac:
            self.sp.append('RIGHT$(%s, %s)' % (self.pop_str(), P(a)))
        elif n == 0xab:
            self.sp.append('MID$(%s, %s, %s)' % (self.pop_str(), P(self.bx), P(a)))
        elif n == 0xaa:
            self.sp.append('MID$(%s, %s)' % (self.pop_str(), P(a)))
        elif n == 0xa6:
            self.fp.append('VAL(%s)' % self.pop_str())
        elif n == 0xa5:
            self.fp[-1] = 'INT(%s)' % self.fp[-1] if self.fp else '?'
        # --- arquivos ---
        elif n == 0xc7:
            nome = self.pop_str()
            modo = {0x49: 'INPUT', 0x4f: 'OUTPUT', 0x41: 'APPEND'}.get((int(self.slot.get(0x2e, 0)) >> 8) & 0xff, '?')
            self.abrindo = (nome, modo)
        elif n == 0xba:
            self.pf = self.pop_str()
        elif n == 0xb7:
            self.pf = self.pop_fp()
        elif n == 0xb4:
            self.emite(i.a, 'PRINT #%s, %s' % (self.slot.get(0x60, '?'), self.pf))
        else:
            self.nada(i)
            self.ax = self.bx = None
            self.cmp = self.truth = None
        return k + 1

    def elemento(self, si):
        """Elemento de array em DS (arrays estáticos): ('base', ('idx', expr, 2), deslocamento)."""
        if isinstance(si, tuple) and si[0] == 'base' and isinstance(si[1], tuple):
            return '%s(%s)' % (ARR_DS.get(si[2], 'A%X' % si[2]), si[1][1])
        return '?%s' % (si,)

    def rt(self, k):
        i = self.ins[k]
        tipo, sel = [int(x, 16) for x in i.o.split()]
        a = self.ax
        e = lambda t: self.emite(i.a, t)      # noqa: E731
        if (tipo, sel) == (0xec, 0x14):
            e('CLEAR')
        elif (tipo, sel) == (0xec, 0x1a):
            e('CLS')
        elif (tipo, sel) == (0xec, 0x22):
            op = self.ins[k].raw[3]
            fg, bg = self.slot.get(0x88, '?'), self.slot.get(0x94, '?')
            e('COLOR %s' % fg if op == 4 else 'COLOR %s, %s' % (fg, bg) if op == 6 else
              'COLOR %s, %s, %s' % (fg, bg, self.slot.get(0xa0, '?')))
        elif (tipo, sel) == (0xec, 0x6e):
            alvo = struct.unpack('<I', i.raw[3:7])[0]
            e('ON ERROR GOTO 0' if alvo == 0xffffffff else 'ON ERROR GOTO %s' % self.rot(alvo + BASE_TABELA))
            self.alvos.add(alvo + BASE_TABELA) if alvo != 0xffffffff else None
        elif (tipo, sel) == (0xec, 0xba):
            prox = self.ins[k + 1] if k + 1 < len(self.ins) else None
            if prox and prox.m == 'jmp':
                e('RESUME %s' % self.rot(num(prox.o)))
                return k + 2
            e('RESUME')
        elif (tipo, sel) == (0xee, 0x10):
            self.sp.append('INPUT$(%s)' % a)
        elif (tipo, sel) == (0xec, 0xb0):
            self.fp.append('\x01READ ')
        elif (tipo, sel) == (0xec, 0xb2):
            self.sp.append('\x01READ ')
        elif (tipo, sel) in ((0xec, 0x2a), (0xec, 0x36)):
            pass
        elif (tipo, sel) == (0xec, 0x2c):
            d = self.si if isinstance(self.si, int) else None
            nome = ARR.get(d, 'ARR%X' % (d or 0))
            e('DIM %s(%s)' % (nome, self.dim_limite.get(d, '?')))
        elif (tipo, sel) == (0xec, 0x00):
            e('BEEP')
        elif (tipo, sel) == (0xec, 0xce):
            e('SOUND %s, %s' % (a, self.pop_fp()))
        elif (tipo, sel) in ((0xec, 0x9a), (0xec, 0x98)):
            pre = self.entrada
            (self.sp if sel == 0x9a else self.fp).append('\x01INPUT ' + pre)
        elif (tipo, sel) in ((0xec, 0x9e), (0xec, 0x9c)):
            (self.sp if sel == 0x9e else self.fp).append('\x01INPUT #%s, ' % self.slot.get(0x60, '?'))
        elif (tipo, sel) == (0xec, 0x4c):
            desc = struct.unpack('<H', i.raw[3:5])[0]
            txt = descritor(desc)
            self.entrada = '' if txt in ('', '? ', '?') or desc < 0x100 else '%s; ' % cstr(txt)
        elif (tipo, sel) == (0xec, 0x64):
            self.sp.append('\x01LINE INPUT #%s, ' % self.slot.get(0x60, '?'))
        elif (tipo, sel) == (0xec, 0x80):
            nome, modo = getattr(self, 'abrindo', ('?', '?'))
            e('OPEN %s FOR %s AS #%s' % (nome, modo, self.slot.get(0x60, '?')))
        elif (tipo, sel) == (0xec, 0x18):
            e('CLOSE #%s' % a)
        elif (tipo, sel) == (0xec, 0x16):
            e('CLOSE')
        elif (tipo, sel) == (0xed, 0x22):
            self.ax = 'LEN(%s)' % self.pop_str()
        elif (tipo, sel) == (0xed, 0x1c):
            b = self.pop_str()
            a2 = self.pop_str()
            self.ax = 'INSTR(%s, %s)' % (a2, b)
        elif (tipo, sel) == (0xed, 0x1e):
            b = self.pop_str()
            a2 = self.pop_str()
            self.ax = 'INSTR(%s, %s, %s)' % (a, a2, b)
        elif (tipo, sel) == (0xed, 0x3c):
            self.fp.append('RND')
        elif (tipo, sel) == (0xed, 0x14):
            self.fp[-1] = 'FIX(%s)' % self.fp[-1] if self.fp else '?'
        elif (tipo, sel) == (0xed, 0x44):
            self.ax = 'SGN(%s)' % self.pop_fp()
        elif (tipo, sel) == (0xed, 0x4a):
            self.fp.append('TIMER')
        elif (tipo, sel) == (0xed, 0x10):
            self.ax = 'EOF(%s)' % a
        elif (tipo, sel) == (0xee, 0x0e):
            self.sp.append('INKEY$')
        elif (tipo, sel) == (0xee, 0x1e):
            self.sp.append('SPACE$(%s)' % P(a))
        elif (tipo, sel) == (0xee, 0x20):
            self.sp.append('STR$(%s)' % self.pop_fp())
        elif (tipo, sel) == (0xee, 0x22):
            self.sp.append('STRING$(%s, %s)' % (P(self.bx), P(a)))
        elif (tipo, sel) == (0xee, 0x24):
            self.sp.append('STRING$(%s, %s)' % (P(a), self.pop_str()))
        elif (tipo, sel) == (0xee, 0x28):
            self.sp.append('UCASE$(%s)' % self.pop_str())
        elif (tipo, sel) == (0xee, 0x26):
            self.sp.append('TIME$')
        elif (tipo, sel) == (0xee, 0x04):
            self.sp.append('DATE$')
        elif (tipo, sel) == (0xec, 0x30):
            if k == 0 or not (self.ins[k - 1].m == 'rt' and self.ins[k - 1].o == '0xec 0xe6'):
                e('END')                    # o que vem logo depois do epílogo (INT EC E6) é implícito
        elif (tipo, sel) == (0xec, 0x96):
            e('PLAY %s' % self.pop_str())
        elif (tipo, sel) in ((0xec, 0xb8), (0xec, 0xe6)):
            pass                            # prólogo e epílogo do programa
        else:
            self.nada(i, 'runtime')
            self.ax = self.bx = None        # o resultado do runtime não é conhecido
            self.cmp = self.truth = None
        return k + 1

    def on(self, k):
        i = self.ins[k]
        sel, alvos = self.tabelas[i.a]
        # 0x70 volta ao fim da sub-rotina escolhida (GOSUB); 0x72 não volta: o RETURN da escolhida sai de quem a chamou (GOTO)
        self.emite(i.a, 'ON %s %s %s' % (self.ax, 'GOSUB' if sel == 0x70 else 'GOTO', ', '.join(self.rot(a) for a in alvos)))
        self.reseta()
        return k + 1


def reconstroi_for(linhas):
    """`lim = a / passo = s / v = b / GOTO teste ... v = (passo + v) / teste: ...` vira `FOR v = b TO a [STEP s]` ... `NEXT v`."""
    L = list(linhas)
    i = 0
    while i + 3 < len(L):
        m = [re.fullmatch(r'(\w+) = (.+)', L[i + j][1]) for j in range(3)]
        g = re.fullmatch(r'GOTO <<(L[0-9A-F]+)>>', L[i + 3][1])
        if all(m) and g:
            lim, passo, var = m[0].group(1), m[1].group(1), m[2].group(1)
            alvo = '<<%s>>:' % g.group(1)
            inc = '%s = %s + %s' % (var, passo, var)
            ts = [k for k in range(i + 4, len(L)) if L[k][1] == alvo]
            if ts and L[ts[0] - 1][1] == inc:
                t = ts[0]
                # fim do teste: o último `IF lim <= var THEN GOTO` do bloco
                fim = None
                for k in range(t + 1, min(len(L), t + 12)):
                    pat = r'IF (%s <= %s|%s >= %s) THEN GOTO <<L[0-9A-F]+>>' % (re.escape(lim), re.escape(var), re.escape(var), re.escape(lim))
                    if re.fullmatch(pat, L[k][1]):
                        fim = k
                        break
                if fim:
                    for_ = 'FOR %s = %s TO %s%s' % (var, m[2].group(2), m[0].group(2), '' if m[1].group(2) == '1' else ' STEP ' + m[1].group(2))
                    L[i:i + 4] = [(L[i][0], for_)]
                    t -= 3
                    fim -= 3
                    L[t - 1:fim + 1] = [(L[t - 1][0], 'NEXT %s' % var)]
                    # remove rótulos de linha só de rótulo que ficaram sem uso (feito em limpa_rotulos)
                    continue
        i += 1
    return L


def itens_data():
    """Itens dos DATA na ordem de leitura: lista de ponteiros para descritores logo depois do fim do código."""
    ptrs = []
    o = LISTA_DATA
    while True:
        v = struct.unpack('<H', IMG[o:o + 2])[0]
        if v == 0:
            break
        ptrs.append(v)
        o += 2
    return [descritor(v) for v in ptrs]


def item_data(t):
    """Números sem aspas, textos com aspas (o Turbo Basic aceita texto sem aspas, exceto com vírgula, dois-pontos
    ou espaços nas pontas, mas eu lembro de ter escrito assim)."""
    return t if re.fullmatch(r'-?\d+(\.\d+)?', t) else '"%s"' % t


LIMITE_DATA = 225             # o editor do Turbo Basic quebra linhas com mais de 248 colunas


def insere_data(linhas):
    """Põe os DATA depois do laço FOR que os lê (o original tinha as linhas DATA em algum lugar do fonte;
    a posição não muda o comportamento, só a ordem entre elas)."""
    itens = itens_data()
    valor = {}
    saida, pos, i = [], 0, 0
    L = list(linhas)
    while i < len(L):
        a, t = L[i]
        m = re.fullmatch(r'(\w+) = (\d+)', t)
        if m:
            valor[m.group(1)] = int(m.group(2))
        saida.append(L[i])
        f = re.fullmatch(r'FOR (\w+) = (\d+) TO (\w+|\d+)', t)
        if f:
            j = i + 1
            while j < len(L) and L[j][1] != 'NEXT %s' % f.group(1):
                j += 1
            lidos = sum(1 for k in range(i + 1, j) if L[k][1].startswith('READ '))
            if lidos and j < len(L):
                lim = f.group(3)
                n = (int(lim) if lim.isdigit() else valor.get(lim, 0)) - int(f.group(2)) + 1
                saida.extend(L[i + 1:j + 1])
                grupo = lidos if lidos > 1 else 10
                total = n * lidos
                for k in range(0, total, grupo):
                    # o editor do Turbo Basic quebra linhas com mais de 248 colunas: o registro vai para mais de um DATA
                    atual = []
                    for x in itens[pos + k:pos + min(k + grupo, total)]:
                        if atual and len('DATA ' + ','.join(atual + [item_data(x)])) > LIMITE_DATA:
                            saida.append((L[j][0], 'DATA ' + ','.join(atual)))
                            atual = []
                        atual.append(item_data(x))
                    saida.append((L[j][0], 'DATA ' + ','.join(atual)))
                pos += total
                i = j + 1
                continue
        i += 1
    if pos != len(itens):
        sys.stderr.write('aviso: %d itens de DATA, %d consumidos pelos laços\n' % (len(itens), pos))
    return saida


def divide_topo(c, seps):
    """Divide `c` nos separadores (palavras ou operadores cercados de espaço) fora de parênteses e de aspas."""
    partes, ops, nivel, aspas, ini, i = [], [], 0, False, 0, 0
    while i < len(c):
        ch = c[i]
        if ch == '"':
            aspas = not aspas
        elif not aspas:
            nivel += ch == '('
            nivel -= ch == ')'
            if nivel == 0:
                for sp in seps:
                    if c.startswith(' %s ' % sp, i):
                        partes.append(c[ini:i])
                        ops.append(sp)
                        i += len(sp) + 1
                        ini = i + 1
                        break
        i += 1
    partes.append(c[ini:])
    return partes, ops


def relacao(t):
    """(esq, op, dir) se `t` é uma relação simples; None caso contrário."""
    for op in ('<>', '<=', '>=', '=', '<', '>'):
        partes, ops = divide_topo(t, [op])
        if len(partes) == 2:
            return partes[0], op, partes[1]
    return None


def nega_texto(c):
    """Nega uma condição (De Morgan para AND/OR de relações simples)."""
    c = Tradutor.sem_parens(c)
    termos, ops = divide_topo(c, ['AND', 'OR'])
    if len(termos) > 1 and len(set(ops)) == 1:
        op = 'OR' if ops[0] == 'AND' else 'AND'
        neg = []
        for t in termos:
            n = nega_texto(t)
            if len(divide_topo(n, ['AND', 'OR'])[0]) > 1:
                n = '(%s)' % n
            neg.append(n)
        return (' %s ' % op).join(neg)
    r = relacao(c) if len(termos) == 1 else None
    if r:
        return '%s %s %s' % (r[0], NEG[r[1]], r[2])
    if c.startswith('NOT (') and c.endswith(')') and Tradutor.sem_parens(c[4:]) != c[4:] and \
            Tradutor.sem_parens(c[4:]) == Tradutor.sem_parens(c[5:-1]):
        return Tradutor.sem_parens(c[5:-1])
    if c.startswith('NOT ') and len(termos) == 1 and not c.startswith('NOT ('):
        return c[4:]
    if re.fullmatch(r'[\w$]+(\([^()]*\))?', c):
        return 'NOT %s' % c
    return 'NOT (%s)' % c


def cabe(txt, comentarios, limite):
    """Junta o comentário ao fim da linha, cortando-o para caber; None se nem o código cabe."""
    if len(txt) > limite:
        return None
    if comentarios:
        resto = limite - len(txt) - 5
        if resto > 10:
            txt += "   ' " + ' | '.join(comentarios)[:resto]
    return txt


def estrutura_blocos(linhas):
    """IF/WHILE em bloco: o Turbo Basic compila `IF c THEN` + linhas + `END IF` (e `WHILE c`) com a condição simples
    passando por um booleano em AX, e o IF de uma linha comparando direto. O gerador marca (\\x02) as condições
    simples que vieram do booleano; aqui viram bloco ou laço, e as que não couberem perdem a marca."""
    L = list(linhas)
    rot = lambda t: re.fullmatch(r'<<(L[0-9A-F]+)>>:', t)       # noqa: E731
    refs = lambda r: sum(1 for _, x in L if not rot(x) and '<<%s>>' % r in x)       # noqa: E731

    def fechado(ini, fim):
        """Os rótulos do trecho só são usados de dentro dele (laços internos): dá para virar bloco."""
        if not balanceado(L, ini, fim):
            return False
        for k in range(ini, fim):
            r = rot(L[k][1])
            if r:
                fora = [q for q, (_, x) in enumerate(L) if not rot(x) and '<<%s>>' % r.group(1) in x and not ini <= q < fim]
                if fora:
                    return False
        return True

    i = len(L) - 1
    while i >= 0:
        a, t = L[i]
        m = re.fullmatch(r'IF\x02 (.+) THEN GOTO <<(L[0-9A-F]+)>>', t)

        if m:
            alvo = '<<%s>>:' % m.group(2)
            j = next((k for k in range(i + 1, len(L)) if L[k][1] == alvo), None)
            topo = L[i - 1][1][2:-3] if i > 0 and rot(L[i - 1][1]) else None
            volta = None
            if j and topo:   # WHILE: o corpo termina em GOTO topo e o rótulo de saída vem logo depois
                volta = next((k for k in range(i + 1, j) if L[k][1] == 'GOTO <<%s>>' % topo and k == j - 1), None)
            if volta is not None:
                L[i] = (a, 'WHILE %s' % nega_texto(m.group(1)))
                L[volta] = (L[volta][0], 'WEND')
            elif j and fechado(i + 1, j) and j - i > 1:
                pos = nega_texto(m.group(1))
                ult = L[j - 1][1]
                g = re.fullmatch(r'GOTO <<(L[0-9A-F]+)>>', ult)
                fim = None
                if g and j - 1 > i + 1 and refs_ok(L, m.group(2)):
                    fim = next((k for k in range(j + 1, len(L)) if L[k][1] == '<<%s>>:' % g.group(1)), None)
                    if fim and (any(rot(x[1]) for x in L[j + 1:fim]) or refs(g.group(1)) != 1):
                        fim = None
                if fim:
                    corpo1 = [(x[0], x[1]) for x in L[i + 1:j - 1]]
                    corpo2 = [(x[0], x[1]) for x in L[j + 1:fim]]
                    L[i:fim + 1] = [(a, 'IF %s THEN' % pos)] + corpo1 + [(L[j][0], 'ELSE')] + corpo2 + [(L[fim][0], 'END IF'), L[fim]]
                else:
                    corpo = [(x[0], x[1]) for x in L[i + 1:j]]
                    L[i:j + 1] = [(a, 'IF %s THEN' % pos)] + corpo + [(L[j][0], 'END IF'), L[j]]
            else:
                L[i] = (a, t.replace('\x02', '', 1))
        i -= 1
    return [(a, t.replace('\x02', '')) for a, t in L]


def estrutura_if(linhas, limite=240):
    """`IF c THEN GOTO Y / corpo / Y:` vira `IF !c THEN corpo` (uma linha, instruções separadas por `:`);
    com `GOTO Fim` no fim do corpo e o rótulo do desvio logo depois, vira `IF !c THEN corpo1 ELSE corpo2`."""
    L = list(linhas)
    rot = lambda t: re.fullmatch(r'<<(L[0-9A-F]+)>>:', t)       # noqa: E731
    ok = lambda t: not (rot(t) or t.startswith(('FOR ', 'NEXT', 'DATA ', 'DIM ', 'REM ', "'", 'ON ERROR', 'WHILE ', 'WEND',  # noqa: E731
                                                  'END IF', 'ELSE')) or re.match(r'IF .* THEN$', t))

    def corpo(trecho):
        if not trecho or any(not ok(t) for _, t in trecho):
            return None
        # IF só como última instrução do corpo (senão o resto da linha passaria a depender dele)
        if any(re.match(r'IF .* THEN', t) for _, t in trecho[:-1]):
            return None
        coments = []
        stmts = []
        for _, t in trecho:
            m = re.fullmatch(r"(.*?)(?:   ' (.*))?", t)
            stmts.append(m.group(1))
            if m.group(2):
                coments.append(m.group(2))
        return stmts, coments

    def simples(c):
        return len(divide_topo(c, ['AND', 'OR'])[0]) == 1 and relacao(c) is not None

    def bloco(pos, trecho):
        return [(trecho[0][0], 'IF %s THEN' % pos)] + [(x[0], x[1]) for x in trecho]

    i = len(L) - 1
    while i >= 0:
        a, t = L[i]
        m = re.fullmatch(r'IF (.+) THEN GOTO <<(L[0-9A-F]+)>>', t)
        if m and ' THEN ' not in m.group(1):
            alvo = '<<%s>>:' % m.group(2)
            j = next((k for k in range(i + 1, len(L)) if L[k][1] == alvo), None)
            if j:
                pos = nega_texto(m.group(1))
                curto = simples(pos)    # relação simples: o IF de uma linha compara direto, o bloco usa o booleano
                # com ELSE: o corpo termina em GOTO Fim e Fim vem depois do corpo do ELSE
                ult = L[j - 1][1] if j - 1 > i else ''
                g = re.fullmatch(r'GOTO <<(L[0-9A-F]+)>>', ult)
                novo = None
                if g and j - 1 > i + 1 and refs_ok(L, m.group(2)):
                    fim = next((k for k in range(j + 1, len(L)) if L[k][1] == '<<%s>>:' % g.group(1)), None)
                    c1, c2 = corpo(L[i + 1:j - 1]), corpo(L[j + 1:fim]) if fim else None
                    if fim and c1 and c2:
                        co = c1[1] + c2[1]
                        txt = 'IF %s THEN %s ELSE %s' % (pos, ' : '.join(c1[0]), ' : '.join(c2[0]))
                        txt2 = cabe(txt, co, limite)
                        if txt2 or curto:
                            novo = (i, fim, [(a, txt2 or txt)])
                        elif not any(rot(x[1]) for x in L[i + 1:fim]) and refs_ok(L, g.group(1)):
                            novo = (i, fim, [(a, 'IF %s THEN' % pos)] + [(x[0], x[1]) for x in L[i + 1:j - 1]] +
                                    [(L[j][0], 'ELSE')] + [(x[0], x[1]) for x in L[j + 1:fim]] + [(L[fim][0], 'END IF')])
                # os `END IF`/`WEND`/`NEXT` de blocos de fora que terminam junto com este desvio ficam depois do IF
                fin, tail = j, []
                while fin - 1 > i and re.fullmatch(r'(END IF|WEND|NEXT.*)', L[fin - 1][1].strip()) \
                        and not balanceado(L, i + 1, fin) and balanceado(L, i + 1, fin - 1):
                    tail.insert(0, L[fin - 1])
                    fin -= 1
                span = L[i + 1:fin]
                if novo is None and not curto and corpo(span) is None and fin - i > 1 and interno_fechado(L, i + 1, fin):
                    # condição composta cujo corpo tem rótulos internos (IF/ELSE aninhados com GOTO): bloco
                    novo = (i, j - 1, bloco(pos, span) + [(L[fin][0] if fin < len(L) else a, 'END IF')] + tail)
                if novo is None:
                    c1 = corpo(span)
                    if c1:
                        txt = 'IF %s THEN %s' % (pos, ' : '.join(c1[0]))
                        txt2 = cabe(txt, c1[1], limite)
                        if txt2 or curto:
                            novo = (i, j - 1, [(a, txt2 or txt)] + tail)
                        else:
                            novo = (i, j - 1, bloco(pos, span) + [(a, 'END IF')] + tail)
                if novo:
                    ini, fim_, rep = novo
                    L[ini:fim_ + 1] = rep
        i -= 1
    return L


def balanceado(L, ini, fim):
    """FOR/NEXT, WHILE/WEND e IF em bloco do trecho abrem e fecham dentro dele."""
    pilha = []
    for k in range(ini, fim):
        t = L[k][1].strip()
        if t.startswith('FOR ') and ' : ' not in t:
            pilha.append('FOR')
        elif t.startswith('WHILE ') and ' : ' not in t:
            pilha.append('WHILE')
        elif t.startswith('IF ') and t.endswith(' THEN'):
            pilha.append('IF')
        elif t == 'ELSE':
            if not pilha or pilha[-1] != 'IF':
                return False
        elif t.startswith('NEXT'):
            if not pilha or pilha.pop() != 'FOR':
                return False
        elif t == 'WEND':
            if not pilha or pilha.pop() != 'WHILE':
                return False
        elif t == 'END IF':
            if not pilha or pilha.pop() != 'IF':
                return False
    return not pilha


def interno_fechado(L, ini, fim):
    """Os rótulos do trecho L[ini:fim] só são usados de dentro dele e não há FOR/WHILE/blocos partidos."""
    rot = lambda t: re.fullmatch(r'<<(L[0-9A-F]+)>>:', t)       # noqa: E731
    if not balanceado(L, ini, fim):
        return False
    for k in range(ini, fim):
        t = L[k][1]
        r = rot(t)
        if r:
            for q, (_, x) in enumerate(L):
                if not rot(x) and '<<%s>>' % r.group(1) in x and not ini <= q < fim:
                    return False
    return True


def refs_ok(L, r):
    return sum(1 for _, x in L if not re.fullmatch(r'<<(L[0-9A-F]+)>>:', x) and '<<%s>>' % r in x) == 1


def junta_linhas(linhas):
    """Casos óbvios de várias instruções na mesma linha: texto + chamada que o imprime, e blocos de saídas da sala."""
    L, out, i = list(linhas), [], 0
    saida = re.compile(r'[NSLOCB] = -?\d+')
    while i < len(L):
        a, t = L[i]
        m = re.fullmatch(r"((?:AVISO|MENSAGEM)\$ = .+?)(   ' .*)?", t)
        if m and i + 1 < len(L) and re.fullmatch(r'GOSUB <<L(CF33|CFBC)>>', L[i + 1][1]):
            out.append((a, '%s : %s%s' % (m.group(1), L[i + 1][1], m.group(2) or '')))
            i += 2
            continue
        if saida.fullmatch(t):
            j = i
            while j < len(L) and saida.fullmatch(L[j][1]):
                j += 1
            if j - i > 1:
                out.append((a, ' : '.join(x[1] for x in L[i:j])))
                i = j
                continue
        if t == 'CLEAR' and i + 1 < len(L) and L[i + 1][1] == 'RESTORE':
            out.append((a, 'CLEAR : RESTORE'))
            i += 2
            continue
        if t.startswith('READ ') and not t.startswith('READ #'):
            j = i
            while j < len(L) and L[j][1].startswith('READ ') and not L[j][1].startswith('READ #'):
                j += 1
            if j - i > 1:
                out.append((a, 'READ ' + ', '.join(x[1][5:] for x in L[i:j])))
                i = j
                continue
        d = re.fullmatch(r'DIM (.+)\((\w+)\)', t)
        if d:
            j, itens = i, []
            while j < len(L):
                dj = re.fullmatch(r'DIM (.+\(\w+\))', L[j][1])
                if not dj or not dj.group(1).endswith('(%s)' % d.group(2)):
                    break
                itens.append(dj.group(1))
                j += 1
            if len(itens) > 1:
                out.append((a, 'DIM ' + ', '.join(itens)))
                i = j
                continue
        out.append(L[i])
        i += 1
    return out


def junta_lacos(linhas, limite=240):
    """Laço de uma instrução só vai numa linha: `WHILE c : instrução : WEND`, `FOR v = a TO b : instrução : NEXT v`."""
    L, out, i = list(linhas), [], 0
    while i < len(L):
        a, t = L[i]
        if i + 2 < len(L) and (t.startswith('WHILE ') or t.startswith('FOR ')):
            corpo, fim = L[i + 1][1].strip(), L[i + 2][1].strip()
            if (t.startswith('WHILE ') and fim == 'WEND') or (t.startswith('FOR ') and fim.startswith('NEXT ')):
                if not re.match(r"(IF .* THEN$|ELSE$|END IF|FOR |WHILE |NEXT |WEND|<<L|DATA |')", corpo):
                    m = re.fullmatch(r"(.*?)(   ' .*)?", corpo)
                    txt = '%s : %s : %s%s' % (t, m.group(1), fim, m.group(2) or '')
                    if len(txt) <= limite:
                        out.append((a, txt))
                        i += 3
                        continue
        out.append(L[i])
        i += 1
    return out


def indenta(linhas):
    """Dois espaços por nível de FOR / WHILE / IF em bloco."""
    out, nivel = [], 0
    for a, t in linhas:
        t = t.lstrip(' ')
        if t.startswith("' ====="):
            nivel = 0
        if t.startswith(('NEXT', 'WEND', 'END IF')):
            nivel = max(0, nivel - 1)
        if t == 'ELSE':
            nivel = max(0, nivel - 1)
        out.append((a, '  ' * nivel + t if not re.fullmatch(r'<<L[0-9A-F]+>>:', t) else t))
        if t == 'ELSE' or t.startswith(('FOR ', 'WHILE ')) and ' : ' not in t or (t.startswith('IF ') and t.endswith(' THEN')):
            nivel += 1
    return out


def comenta_chamadas(linhas):
    cont = {}
    for _, t in linhas:
        if not t.startswith('ON '):
            for r in re.findall(r'GOSUB <<L([0-9A-F]+)>>', t):
                cont[int(r, 16)] = cont.get(int(r, 16), 0) + 1
    out = []
    for a, t in linhas:
        if ' GOSUB ' in t and not t.startswith('ON ') and "   ' " not in t:
            cs = []
            for r in re.findall(r'GOSUB <<L([0-9A-F]+)>>', t):
                c = CHAMADAS.get(int(r, 16))
                if c and (cont[int(r, 16)] <= 6 or a < 0x9bc9) and c not in cs:
                    cs.append(c)
            if cs:
                t += "   ' " + '; '.join(cs)
        out.append((a, t))
    return out


def declara_estaticos(linhas):
    """DIM dos arrays estáticos (não geram código): antes do primeiro uso."""
    usados = {}
    for k, (_, t) in enumerate(linhas):
        for b, (n, m) in ESTATICOS.items():
            if re.search(r'\b%s\(' % re.escape(n), t):
                usados.setdefault(n, k)
    if not usados:
        return linhas
    primeiro = min(usados.values())
    dim = 'DIM ' + ', '.join('%s(%d)' % (n, m) for b, (n, m) in sorted(ESTATICOS.items(), reverse=True) if n in usados)
    return linhas[:primeiro] + [(linhas[primeiro][0], dim)] + linhas[primeiro:]


def converte_while(linhas):
    """`top: IF 1 <> 1 THEN GOTO fim ... GOTO top / fim:` vira `WHILE 1 = 1 ... WEND` (mesmo código)."""
    L = list(linhas)
    for i, (a, t) in enumerate(L):
        m = re.fullmatch(r'IF 1 <> 1 THEN GOTO <<(L[0-9A-F]+)>>', t)
        if m and i > 0 and re.fullmatch(r'<<(L[0-9A-F]+)>>:', L[i - 1][1]):
            top = L[i - 1][1][2:-3]
            for j in range(i + 1, len(L) - 1):
                if L[j][1] == 'GOTO <<%s>>' % top and L[j + 1][1] == '<<%s>>:' % m.group(1):
                    L[i] = (a, 'WHILE 1 = 1')
                    L[j] = (L[j][0], 'WEND')
                    break
    return L


COMENTARIOS = [
    (r'TITULO\$ = ""', "' Título do jogo: lido de DATA e decodificado (cada número é o código ASCII mais a posição), para dificultar a edição com um editor binário"),
    (r'NUMMSG = ', "' Mensagens do jogo: AVENTURA.MSG, uma por linha, em MSG$(1) a MSG$(NUMMSG)"),
    (r'NUMSALAS = ', "' Visitas às salas e dicionário de sinônimos de verbos (palavra, número do verbo, parâmetros: 0 nenhum, 1 opcional, 2 obrigatório)"),
    (r'NUMOBJ = ', "' Objetos: nome, local inicial (negativo: fixo no local), texto que a sala mostra com o objeto e texto do EXAMINAR"),
    (r'NUMFILTRO = ', "' Palavras ignoradas na análise do comando"),
    (r'NUMPALAVROES = ', "' Palavrões (quando digitados como verbo, o jogo reage)"),
    (r'DESCLISTA\$\(1\) = ', "' Páginas da lista telefônica (cada OLHAR LISTA mostra a seguinte)"),
    (r'LANTERNA\$ = "desligada"', "' Estado do jogo: valores que mudam com o progresso (o que veio antes são tabelas)"),
]


def comenta_blocos(linhas):
    out = []
    for a, t in linhas:
        for rx, c in COMENTARIOS:
            if re.match(rx, t):
                out.append((a, c))
        out.append((a, t))
    return out


def inline_mensagens(linhas):
    """Troca `MSG$(n)` pelo texto de AVENTURA.MSG (como o fonte era antes de existir o arquivo de mensagens) e
    tira o trecho que carregava o arquivo."""
    def troca(m):
        n = int(m.group(1))
        return cstr(MSG[n - 1]) if 1 <= n <= len(MSG) else m.group(0)

    def codigo(t):
        corte = t.find("   ' ")
        parte, coment = (t, '') if corte < 0 else (t[:corte], t[corte:])
        if t.lstrip().startswith("'"):
            return t
        return re.sub(r'MSG\$\((\d+)\)', troca, parte) + re.sub(r"   ' msg \d+: .*$", '', coment)

    out, pulando = [], False
    for a, t in linhas:
        if t.startswith("' Mensagens do jogo: AVENTURA.MSG"):
            pulando = True
        if pulando:
            pulando = t.strip() != 'CLOSE #1'
            continue
        out.append((a, codigo(t)))
    return out


def quebra_literal(txt, limite=248):
    """Linha longa demais: parte o maior texto entre aspas em dois (`"..." + _` e continuação)."""
    saida = []
    while len(txt) > limite:
        lits = [(m.start(), m.end()) for m in re.finditer(r'"[^"]*"', txt) if m.end() - m.start() > 40]
        if not lits:
            break
        ini, fim = max(lits, key=lambda x: x[1] - x[0])
        # corta num espaço perto do ponto em que a linha estoura
        alvo = min(limite - 8, (ini + fim) // 2)
        corte = txt.rfind(' ', ini + 20, alvo)
        if corte < 0:
            break
        saida.append(txt[:corte + 1] + '" + _')
        txt = '      "' + txt[corte + 1:]
    saida.append(txt)
    return saida


def limpa_rotulos(linhas):
    usados = set(re.findall(r'<<L[0-9A-F]+>>', ' '.join(t for _, t in linhas if not re.fullmatch(r'<<L[0-9A-F]+>>:', t))))
    vistos, out = set(), []
    for a, t in linhas:
        if re.fullmatch(r'<<L[0-9A-F]+>>:', t):
            if t[:-1] not in usados or t in vistos:
                continue                    # sem uso, ou repetido (o rótulo só pode existir uma vez)
            vistos.add(t)
        out.append((a, t))
    return out


BASES = [(0x82c0, 100), (0x8a4e, 10000), (0x8c10, 12000), (0x9bc9, 20000), (0xcf33, 40000), (0xd807, 45000), (0xfba7, 60000)]


def banner(titulo, *mais):
    barra = "' " + '*' * 62
    return [barra, "' " + titulo] + ["' " + m for m in mais] + [barra]


# Blocos grandes do programa (a ordem do fonte é a ordem do executável): endereço -> comentário
BANNERS = {
    0x8a4e: banner('LOOP PRINCIPAL', 'Mostra a sala quando muda, le e analisa o comando e executa o verbo.'),
    0x8c10: banner('SUB-ROTINAS (1/5): ENTRADA E TELA', 'Ler e analisar o comando, desenhar a tela.'),
    0x9bc9: banner('SUB-ROTINAS (2/5): VERBOS', 'Uma sub-rotina por verbo, escolhida por ON ... GOTO.'),
    0xcf33: banner('SUB-ROTINAS (3/5): USO GERAL', 'Avisos, mensagens e paineis.'),
    0xd807: banner('SUB-ROTINAS (4/5): SALAS', 'Uma sub-rotina por sala, escolhida por ON SALA GOSUB.'),
    0xfba7: banner('SUB-ROTINAS (5/5): ARQUIVOS, MENU E FINAL'),
}
BANNER_INICIO = banner('INICIALIZACAO', 'Titulo, mensagens, tabelas (DATA) e estado inicial do jogo.')

# Chamadas que merecem um comentário (a rotina é pouco óbvia): endereço -> texto
CHAMADAS = {0x9818: 'Desenha a tela inicial (moldura, título e janelas)', 0x9648: 'Limpa o comando',
            0x8c10: 'Lê o comando digitado', 0x8f7e: 'Analisa o comando (verbo e objeto)',
            0xd0c5: 'Rola a janela de mensagens', 0xd215: 'Mostra os objetos da sala',
            0xd342: 'Atualiza o painel de objetos', 0xd35a: 'Atualiza as direções possíveis',
            0xd4df: 'Executa a rotina da sala'}
SUBS_CONHECIDAS = {0xcf33: 'aviso: AVISO$ na janela de avisos e espera uma tecla', 0xcfbc: 'mensagem: MENSAGEM$ na janela de mensagens',
                   0xd4df: 'escolhe a rotina da sala (ON SALA GOSUB)', 0x8c10: 'lê o comando', 0x8f7e: 'analisa o comando',
                   0x9818: 'desenha o estado inicial da tela: moldura, título e janelas (que depois só são atualizadas)',
                   0x9648: 'limpa o comando: espaços repetidos e palavras de FILTRO$',
                   0xd0c5: 'rola a janela de mensagens (JANELA$) uma linha', 0xd215: 'mostra os objetos que estão na sala (AQUI$)',
                   0xd342: 'atualiza o painel de objetos (LISTAR sem esperar tecla)', 0xd35a: 'atualiza a janela de direções (acende as saídas)'}


# O fonte é gravado em CP437 (como o original). O que não existe nele recebe a convenção do próprio jogo
# (`ä ö Ä Ö Å` no lugar de `ã õ Ã Õ Á`, que a tela converte) ou a letra minúscula acentuada.
CP437 = str.maketrans({'ã': 'ä', 'õ': 'ö', 'Ã': 'Ä', 'Õ': 'Ö', 'Á': 'Å', 'Â': 'â', 'Ê': 'ê', 'Ô': 'ô', 'Ó': 'ó', 'Í': 'í',
                       'Ú': 'ú', 'À': 'à', 'ç': 'ç'})


def para_cp437(texto):
    return texto.translate(CP437)


def quebra_linha(txt, l):
    """Linha maior que a do editor (248 colunas): continua na de baixo com `_` (ON ... GOSUB, ou entre instruções
    separadas por `:`). Um texto grande demais fica inteiro: o `$INCLUDE` não passa pelo editor."""
    out = []
    while len(txt) > 248 and l.startswith('ON ') and ', ' in txt[200:]:
        corte = txt.rindex(', ', 0, 220) + 1
        out.append(txt[:corte] + '_')
        txt = '      ' + txt[corte + 1:]
    while len(txt) > 248 and not l.lstrip().startswith(('DATA ', "'")) and ' : ' in txt[8:244]:
        corte = txt.rindex(' : ', 8, 244) + 2
        out.append(txt[:corte] + ' _')
        txt = '      ' + txt[corte + 1:]
    out.append(txt)
    return out


def numera(linhas, inicios, passo=10):
    """Troca rótulos por números de linha: de 10 em 10, cada sub-rotina (alvo de GOSUB) começando num múltiplo de 100
    e as principais num múltiplo de 1000; cada região (programa, verbos, auxiliares, salas, arquivos) num bloco redondo.
    O rótulo de uma rotina vale o número do comentário de cabeçalho; os outros, o da linha seguinte."""
    numero, pend, saida, n, cab = {}, [], [], 0, None
    regiao = None
    pre = 10                       # os comentários do começo do arquivo vêm antes da linha 100
    ant_data = False
    for a, l in linhas:
        m = re.fullmatch(r'<<(L[0-9A-F]+)>>:', l)
        if m:
            pend.append(m.group(1))
            continue
        if a == 0:
            saida.append((pre, l))
            pre += 10
            continue
        e_data = l.lstrip().startswith('DATA ')
        if e_data != ant_data and n % 1000:            # os DATA começam (e terminam) num milhar: sobra espaço para inserir
            n = (n // 1000 + 1) * 1000
        ant_data = e_data
        base = max((v for k, v in BASES if a >= k), default=100)
        if base != regiao:
            regiao = base
            n = max(n, base)
        cabecalho = l.startswith("' =====")
        novo = cabecalho or (any(r in inicios for r in pend) and cab is None)
        if novo:
            mult = 1000 if (cabecalho and a in (0xcf33, 0xcfbc)) else 100
            if n % mult:
                n = (n // mult + 1) * mult
        for r in pend:
            numero[r] = cab if cab is not None else n
        pend = []
        cab = n if cabecalho else None
        saida.append((n, l))
        n += passo
    faltam = {r for _, l in saida for r in re.findall(r'<<(L[0-9A-F]+)>>', l)} - set(numero)
    if faltam:
        sys.stderr.write('aviso: rótulos sem linha: %s\n' % sorted(faltam))
    out = []
    for k, l in saida:
        txt = '%d %s' % (k, re.sub(r'<<(L[0-9A-F]+)>>', lambda m: str(numero.get(m.group(1), m.group(1))), l))
        out.extend(quebra_linha(txt, l))
    return out


NOMES_SUBS = {0x8a4e: 'LoopPrincipal', 0x82c3: 'Inicio', 0x8c10: 'LeComando', 0x8f7e: 'AnalisaComando',
              0x9648: 'LimpaComando', 0x9818: 'DesenhaTela', 0xcf33: 'Aviso', 0xcfbc: 'Mensagem', 0xd0c5: 'RolaJanela',
              0xd215: 'ObjetosDaSala', 0xd342: 'PainelObjetos', 0xd35a: 'PainelDirecoes', 0xd4df: 'EscolheSala'}


def nome_de_rotina(titulo, ad):
    v = re.match(r'verbo \d+ ([^/ ]+)', titulo)
    sa = re.match(r'sala (\d+)', titulo)
    if v:
        return 'Verbo' + re.sub(r'\W', '', v.group(1)).capitalize()
    if sa:
        return 'Sala' + sa.group(1)
    return NOMES_SUBS.get(ad, 'Sub%X' % ad)


def nomeia(linhas):
    """Rótulos com nome em maiúsculas e minúsculas (VerboSul, Sala9, Aviso, Mensagem...); os desvios internos de uma
    rotina viram NomeX1, NomeX2... Só letras e dígitos. Devolve as linhas sem números, com `Nome:` no lugar de
    `<<Lxxxx>>:` e o código recuado dois espaços em relação ao rótulo."""
    cab = re.compile(r"' ===== (.*) @ ([0-9a-f]+) =====")
    fixas = set(BANNER_INICIO) | {l for ls in BANNERS.values() for l in ls}
    mapa, rotina, cont, ini = {}, 'Inicio', 0, None
    for a, t in linhas:
        h = cab.fullmatch(t)
        if h:
            ini = int(h.group(2), 16)
            rotina, cont = nome_de_rotina(h.group(1), ini), 0
            continue
        m = re.fullmatch(r'<<L([0-9A-F]+)>>:', t)
        if m and m.group(1) not in mapa:
            la = int(m.group(1), 16)
            if la in NOMES_SUBS:
                rotina, cont = NOMES_SUBS[la], 0
                mapa[m.group(1)] = rotina
            elif la == ini:
                mapa[m.group(1)] = rotina
            else:
                cont += 1
                mapa[m.group(1)] = '%sX%d' % (rotina, cont)
    res = []
    for k, (a, t) in enumerate(linhas):
        m = re.fullmatch(r'<<L([0-9A-F]+)>>:', t)
        if m:
            res.append(mapa.get(m.group(1), 'L' + m.group(1)) + ':')
            continue
        txt = re.sub(r'<<L([0-9A-F]+)>>', lambda x: mapa.get(x.group(1), 'L' + x.group(1)), t)
        if a == 0 or t in fixas or cab.fullmatch(t):
            res.append(txt)                       # banners, comentário do arquivo e cabeçalhos de rotina: na margem
        else:
            res.extend(quebra_linha('  ' + txt, t))
    return res


def rotinas():
    """Início e nome de cada sub-rotina conhecida: verbos (verb_handlers.txt) e salas (rooms_table.txt)."""
    r = {}
    ext = RAIZ / 'analise' / 'extracted'
    for l in (ext / 'verb_handlers.txt').read_text().splitlines():
        p = [x.strip() for x in l.split('|')]
        r[int(p[1], 16)] = 'verbo %s %s' % (p[0].split()[1], p[2])
    for l in (ext / 'rooms_table.txt').read_text().splitlines()[1:]:
        p = [x.strip() for x in l.split('|')]
        if len(p) > 4 and p[0].isdigit():
            r[int(p[2], 16)] = 'sala %s: %s' % (p[0], p[4].strip()[:46])
    return r


def traduz_com_for(ins, tabelas, alvos_extra):
    """Traduz em duas passadas: a primeira descobre as variáveis de FOR, que mudam a ordem dos operandos de uma soma."""
    t = Tradutor(ins, tabelas, alvos_extra=alvos_extra)
    linhas = t.traduz()
    achadas = {m.group(1) for _, tx in reconstroi_for(linhas) for m in [re.match(r'FOR (\w+) = ', tx)] if m}
    if not achadas <= FORVARS:
        FORVARS.update(achadas)
        t = Tradutor(ins, tabelas, alvos_extra=alvos_extra)
        linhas = t.traduz()
    return t, linhas


def main():
    global LIMITE_DATA
    ap = argparse.ArgumentParser()
    ap.add_argument('-o', '--saida')
    ap.add_argument('--regiao', nargs=2, default=['0x82c0', '0x10dae'])
    ap.add_argument('--rotulos', action='store_true', help='rótulos Lxxxxx em vez de números de linha')
    ap.add_argument('--nomeados', action='store_true', help='rótulos com nome (VERBOSUL, SALA9...) em vez de números de linha')
    ap.add_argument('--mensagens-inline', action='store_true', help='texto das mensagens no fonte em vez de MSG$(n) lido de AVENTURA.MSG (o padrão reproduz o executável)')
    ap.add_argument('--dividir', type=int, default=0, metavar='BYTES',
                    help='o editor do Turbo Basic não abre arquivos de mais de ~64 KB: divide em NOME.BAS + $INCLUDE de NOMEA.INC, NOMEB.INC...')
    ap.add_argument('--legivel', action='store_true', help='versão para leitura (legivel.py): nomes que dizem o que a rotina faz, 80 colunas, UTF-8')
    ap.add_argument('--mensagens-arquivo', action='store_true', help='com --legivel: mantém MSG$(n) lido de AVENTURA.MSG (o texto inline não roda: ver NOTAS.md)')
    ap.add_argument('--fiel', action='store_true', help='com --legivel: mantém os IF de uma linha e os textos inteiros, o que compila para o mesmo código do CA1.BAS')
    ap.add_argument('--dos', action='store_true', help='com --legivel: grava nos bytes do jogo (CP437, `ä` no lugar de `ã`...) com CRLF, para compilar, em vez de UTF-8')
    ap.add_argument('--relatorio', action='store_true', help='só o resumo por rotina')
    args = ap.parse_args()
    if args.legivel:
        args.nomeados = True
        args.mensagens_inline = not args.mensagens_arquivo
        LIMITE_DATA = 10 ** 6         # para ler, o registro fica numa linha só (a linha pode estourar)
    ini, fim = num(args.regiao[0]), num(args.regiao[1])
    ins, tabelas = desmonta(ini, fim)
    nomes = rotinas()
    t, traduzido = traduz_com_for(ins, tabelas, nomes.keys())
    base = estrutura_if(estrutura_blocos(insere_data(reconstroi_for(traduzido))))
    linhas = comenta_blocos(junta_linhas(base))
    linhas = limpa_rotulos(indenta(junta_lacos(converte_while(declara_estaticos(comenta_chamadas(linhas))))))
    if args.mensagens_inline:
        linhas = inline_mensagens(linhas)
    gosubs = set(re.findall(r'GOSUB <<(L[0-9A-F]+)>>', ' '.join(t for _, t in linhas)))
    for _, tx in linhas:
        if ' GOSUB ' in tx and tx.startswith('ON '):
            gosubs.update(re.findall(r'<<(L[0-9A-F]+)>>', tx))
    cont, out, nome_atual = {}, [], 'inicio / interface'
    pend_banners = sorted(BANNERS.items())
    for a, txt in linhas:
        while pend_banners and pend_banners[0][0] <= a:
            ba, bl = pend_banners.pop(0)
            out.extend((ba, b) for b in bl)
        r = re.fullmatch(r'<<(L[0-9A-F]+)>>:', txt)
        if r and a in (nomes.keys() | {int(g[1:], 16) for g in gosubs}):
            nome_atual = nomes.get(a) or SUBS_CONHECIDAS.get(a) and 'sub-rotina: ' + SUBS_CONHECIDAS[a] or 'sub-rotina'
            out.append((a, "' ===== %s @ %05x =====" % (nome_atual, a)))
        out.append((a, txt))
        c = cont.setdefault(nome_atual, [0, 0])
        c[0] += 1
        if txt.startswith('REM ???'):
            c[1] += 1
    cab = [(0, "' CA1.BAS gerado por basic/gerar.py a partir do CA1.EXE. As linhas `REM ???` são instruções ainda sem tradução."),
           (0, "' Nomes de variáveis e de rótulos foram adicionados durante a engenharia reversa (o executável não guarda nenhum); " + ("os números de linha também; com --rotulos, Lxxxxx = endereço da imagem do .EXE." if not args.nomeados else "o texto das mensagens vem de AVENTURA.MSG (MSG$(n) = linha n-1)." if not args.mensagens_inline else "o texto das mensagens está no fonte."))]
    out = cab + [(0, b) for b in BANNER_INICIO] + out
    if args.nomeados:
        out_linhas = nomeia(out)
    elif args.rotulos:
        out_linhas = [re.sub(r'<<(L[0-9A-F]+)>>', r'\1', l) for _, l in out]
    else:
        out_linhas = numera(out, gosubs | {'L%X' % k for k in nomes})
    if args.dividir and args.saida:
        saida = Path(args.saida)
        partes, atual, tam = [], [], 0
        for l in out_linhas:
            if atual and tam > args.dividir and re.match(r"(\d+ )?' =====", l):
                partes.append(atual)
                atual, tam = [], 0
            atual.append(l)
            tam += len(l) + 2
        partes.append(atual)
        nomes_inc = []
        for k, parte in enumerate(partes[1:]):
            nome = '%s%s.INC' % (saida.stem, chr(65 + k))
            (saida.parent / nome).write_bytes(para_cp437('\r\n'.join(parte) + '\r\n').encode('cp437', errors='replace'))
            nomes_inc.append(nome)
        out_linhas = partes[0] + ['$INCLUDE "%s"' % n for n in nomes_inc]
    texto = '\n'.join(out_linhas) + '\n'
    if args.relatorio:
        for n, (tot, ruim) in cont.items():
            print('%-40s %5d linhas %4d sem tradução' % (n, tot, ruim))
    elif args.legivel and args.saida:
        from legivel import legivel
        texto = legivel(out_linhas, args.fiel)
        if args.dos:
            Path(args.saida).write_bytes(para_cp437(texto).replace('\n', '\r\n').encode('cp437', errors='replace'))
        else:
            Path(args.saida).write_text(texto, encoding='utf-8')
    elif args.saida:
        Path(args.saida).write_bytes(para_cp437(texto).encode('cp437', errors='replace'))
    else:
        sys.stdout.write(texto)
    sys.stderr.write('%d linhas traduzidas, %d instruções não reconhecidas\n' % (t.traduzido, t.nao_traduzido))


if __name__ == '__main__':
    main()
