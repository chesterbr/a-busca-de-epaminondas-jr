"""Reimplementação do motor de CA1.EXE (primeira fase), a partir dos dados extraídos dos dumps.

Fontes: analise/dumps/G1.BIN (DS inicial), E1.BIN (arrays), E2.BIN (heap), analise/extracted/rooms_table.txt (as mensagens agora estão no fonte, com o número do AVENTURA.MSG em comentário).
As regras de cada verbo foram transcritas de analise/extracted/verbos_pseudocodigo.txt.
Só cobre o que foi lido até aqui; o resto responde "(nao implementado)".
"""
import re
import struct
from enum import IntEnum
import sys
import unicodedata
from pathlib import Path

from modernizar import moderniza

RAIZ = Path(__file__).resolve().parent.parent
DUMPS = RAIZ / 'analise' / 'dumps'
G = (DUMPS / 'G1.BIN').read_bytes()
E = (DUMPS / 'E1.BIN').read_bytes()
HEAP = (DUMPS / 'E2.BIN').read_bytes()
COM_JOGADOR = -999  # em loc: o objeto está com o jogador
PRECO_DO_VENDEDOR = 5000  # a loja de autopeças leva à BucanoWare por isso
GRANA_NO_COFRE = 5000  # o que o cofre da BucanoWare tem
PRECO_DO_ONIBUS = 200
GRANA_APOS_TAXI = 5  # o jogador dá "quase todo o dinheiro" ao taxista
NENHUM = 0  # em loc: destruído, consumido ou ainda não apareceu
GASTO = -998  # em loc: a passagem usada na porta automática (nem com o jogador, nem em sala)


class Sala(IntEnum):
    """Salas (número da tabela do jogo). O original só tem números: os nomes são nossos."""
    ESCRITORIO_CHEFE = 1
    RECEPCAO_ESCRITORIO = 2
    CALCADA = 3
    CALCADAO = 4
    BIBLIOTECA = 5
    BALCAO = 6
    DEPOSITO = 7
    VIELA = 8
    PRACA = 9
    PUNKS = 10
    FACULDADE = 11
    ESTACIONAMENTO = 12
    SECRETARIA_FACULDADE = 13
    SALA_DE_AULA = 14
    QUADRA = 15
    GINASIO = 16
    ALMOXARIFADO_FACULDADE = 17
    CPD_FACULDADE = 18
    DEPOSITO_ESCURO = 19
    BAIRRO_PERIGOSO = 20
    RUA_CENTRAL = 21
    BECO = 22
    LOJA = 23
    QUARTO = 24
    CORREDOR_QUARTO = 25
    FIM_DA_RUA = 26
    FLIPERAMA = 27
    ENTRADA_PREDIO = 28
    HALL_PREDIO = 29
    ELEVADOR_PREDIO = 30
    BANHEIRO_FEMININO = 31
    BANHEIRO_MASCULINO = 32
    POCO = 33
    FABRICA = 34
    SALA_DO_COFRE = 35
    ESGOTOS = 36
    FUZILAMENTO = 37
    ESCADARIA = 38
    FRENTE_BUCANOWARE = 39
    RECEPCAO_BUCANOWARE = 40
    HALL_BUCANOWARE = 41
    ELEVADOR_ANDARES = 42
    ELEVADOR_SUBSOLOS = 43
    ESCRITORIO_ANALISTAS = 44
    CPD_PROGRAMADORES = 45
    RECEPCAO_ADMINISTRACAO = 46
    SALA_SECRETARIA_1 = 47
    SALA_SECRETARIA_2 = 48
    SALA_SECRETARIA_3 = 49
    CORREDOR_ADMINISTRACAO = 50
    LAVABO = 51
    PORTA_DA_SALA_DO_L = 52
    SALA_DO_L = 53
    GARAGEM = 54
    ALMOXARIFADO_BUCANOWARE = 55
    BAIRRO_PIOR = 56
    AGENCIA = 57
    PORTARIA = 58
    PISTA = 59
    AREA_PRIVADA = 60
    BAR = 61
    MESA_DE_SOM = 62
    SACADA = 63
    BANHEIRO_DANCETERIA = 64
    PASSAGEM_SECRETA = 65
    CELA = 66
    VIAGEM_DE_ONIBUS = 67


class Obj(IntEnum):
    """Objetos (índice de VOC e de loc). Nomes repetidos no jogo (PORTA, COFRE, MESA...) levam um sufixo."""
    NORTE = 1
    SUL = 2
    LESTE = 3
    OESTE = 4
    LISTA = 5
    AZULEJO = 6
    COFRE_DO_CHEFE = 7
    HOMEM = 8
    POSTE = 9
    LOCAL = 10
    SALAO = 11
    PLACA_BIBLIOTECA = 12
    PORTA_BIBLIOTECA = 13
    BALCONISTA = 14
    LIVRO = 15
    PAPEL = 16
    BALCAO_BIBLIOTECA = 17
    ESCADA = 18
    CIMA = 19
    BAIXO = 20
    LANTERNA = 21
    PILHAS = 22
    SALA = 23
    AREA = 24
    ONIBUS = 25
    GRANA = 26
    VIGIA = 27
    BORRACHA = 28
    MESA_SECRETARIA = 29
    SECRETARIA = 30
    FOSFOROS = 31
    MALA = 32
    PAPEIS = 33
    PASSAGEM = 34
    PORTA_AUTOMATICA = 35
    AKIRA = 36
    CARTEIRA = 37
    CARTAO = 38
    VELHINHO = 39
    ELEVADOR_FLIPERAMA = 40
    BISPO = 41
    MARRETA = 42
    MADEIRA = 43
    PAREDE = 44
    COFRE = 45
    TUBO = 46
    TAXISTA = 47
    TAXI = 48
    ENVELOPE = 49
    RECEPCIONISTA = 50
    ELEVADOR_ANDARES = 51
    ELEVADOR_SUBSOLOS = 52
    PLACA_ELEVADOR = 53
    ANALISTAS = 54
    PROGRAMADORES = 55
    DISQUETES = 56
    COMPUTADORES = 57
    ARAME = 58
    PAINEL = 59
    PIA = 60
    PORTA_SALA_DO_L = 61
    MESA_SR_L = 62
    DOCUMENTOS = 63
    CESTO = 64
    LIXO = 65
    AGENDA = 66
    GRUPO = 67
    BALCAO_BAR = 68
    BARMAN = 69
    MESAS = 70
    CD = 71
    DJ = 72
    TETO = 73
    NOZ = 74
    CHAO = 75
    CHAVE = 76
    LAMPADA = 77
    BALA = 78
    EMBALAGEM = 79
    MESA_DE_SOM = 80
    NI = 81
    SOQUETE = 82
    PERFUME = 83
    BANHEIRO = 84
    LIVROS = 85
    RUA = 86
    COMPUTADOR = 87
    GRAVADOR = 88


class Verbo(IntEnum):
    """Verbos (índice da tabela de verbos; o nome é o do primeiro sinônimo)."""
    NORTE = 1
    SUL = 2
    LESTE = 3
    OESTE = 4
    IR = 5
    PEGAR = 6
    LISTAR = 7
    LARGAR = 8
    OLHAR = 9
    FALAR = 10
    CIMA = 11
    BAIXO = 12
    LER = 13
    LIGAR = 14
    ABRIR = 15
    BEIJAR = 16
    MENU = 17
    CHUPAR = 18
    QUEBRAR = 19
    SAIR = 20
    DIZER = 21
    FECHAR = 22
    ROSQUEAR = 23
    DESROSQUEAR = 24
    VOAR = 25
    MORDER = 26
    COMER = 27
    CHEIRAR = 28
    ATRAVESSAR = 29
    PULAR = 30
    JOGAR = 31
    ARREMESSAR = 32
    SENTAR = 33
    APAGAR = 34


def w(o):
    return struct.unpack('<H', G[o:o + 2])[0]


def arr_off(p):
    return (w(p) - 0x1b8d) * 16


def arr_str(p, n):
    out = []
    for i in range(n):
        ln, ptr = struct.unpack('<HH', E[arr_off(p) + 4 * i:arr_off(p) + 4 * i + 4])
        ln &= 0x7fff
        out.append(HEAP[ptr:ptr + ln].decode('cp850') if ln and ptr + ln <= len(HEAP) else '')
    return out


def arr_f(p, n):
    return list(struct.unpack('<%df' % n, E[arr_off(p):arr_off(p) + 4 * n]))


VOC = arr_str(0x306, 100)
AQUI = [moderniza(t, True) for t in arr_str(0x29a, 100)]  # textos lidos dos dumps passam por moderniza()
EXAM = [moderniza(t, True) for t in arr_str(0x264, 100)]
PALAVRAS_VERBO = arr_str(0x3a8, 80)
ID_VERBO = arr_f(0x372, 80)
ARIDADE = arr_f(0x33c, 80)  # 0: sem objeto, 1: opcional, 2: exige objeto
FILTRO = [s.strip() for s in arr_str(0x1f8, 32) if s.strip()]
LOC0 = arr_f(0x2d0, 100)

SALAS = {}
for linha in (RAIZ / 'analise/extracted/rooms_table.txt').read_text().split('\n')[1:]:
    p = [x.strip() for x in linha.split('|')]
    if len(p) > 4 and p[0].isdigit():
        n, ex = int(p[0]), p[1].split()
        SALAS[n] = dict(saidas=dict(zip('NSLOCB', [None if x == 'None' else int(x) for x in ex])))


def dstr(a):
    bruto = w(a)
    ln = bruto & 0x7fff
    p = w(a + 2)
    src = HEAP if bruto & 0x8000 or p >= 0x1000 else G
    return moderniza(src[p:p + ln].decode('cp850')) if ln else ''


LINHAS_LISTA = [None] + [dstr(0x11f0 + 4 * k) for k in range(1, 5)]
LINHA_CERTA = dstr(0x768)


# Nome de cada sala (SALANOME$, atribuído no começo da sub-rotina da sala; 19 depende da lanterna)
NOME_SALA = {
    Sala.ESCRITORIO_CHEFE: 'ESCRITORIO', Sala.RECEPCAO_ESCRITORIO: 'RECEPCAO',
    Sala.CALCADA: 'CALCADA', Sala.CALCADAO: 'CALCADAO', Sala.BIBLIOTECA: 'BIBLIOTECA',
    Sala.BALCAO: 'BALCAO', Sala.DEPOSITO: 'DEPOSITO', Sala.VIELA: 'VIELA', Sala.PRACA: 'PRACA',
    Sala.FACULDADE: 'FACULDADE', Sala.ESTACIONAMENTO: 'ESTACIONAMENTO',
    Sala.SECRETARIA_FACULDADE: '', Sala.QUADRA: 'QUADRA', Sala.GINASIO: 'GINASIO',
    Sala.ALMOXARIFADO_FACULDADE: 'ALMOXARIFADO', Sala.CPD_FACULDADE: 'CPD', Sala.RUA_CENTRAL: 'RUA',
    Sala.BECO: 'BECO', Sala.LOJA: 'LOJA', Sala.QUARTO: 'QUARTO', Sala.CORREDOR_QUARTO: 'CORREDOR',
    Sala.FIM_DA_RUA: 'FIM DA RUA', Sala.FLIPERAMA: 'FLIPERAMA', Sala.ENTRADA_PREDIO: 'ENTRADA',
    Sala.HALL_PREDIO: 'HALL', Sala.BANHEIRO_FEMININO: 'BANHEIRO',
    Sala.BANHEIRO_MASCULINO: 'BANHEIRO', Sala.POCO: 'POCO', Sala.FABRICA: 'FABRICA',
    Sala.ESGOTOS: 'ESGOTOS', Sala.ESCADARIA: 'ESCADARIA', Sala.RECEPCAO_BUCANOWARE: 'RECEPCAO',
    Sala.HALL_BUCANOWARE: 'HALL', Sala.ELEVADOR_ANDARES: 'ELEVADOR',
    Sala.ELEVADOR_SUBSOLOS: 'ELEVADOR', Sala.ESCRITORIO_ANALISTAS: 'ESCRITORIO',
    Sala.CPD_PROGRAMADORES: 'CPD', Sala.RECEPCAO_ADMINISTRACAO: 'RECEPCAO',
    Sala.SALA_SECRETARIA_1: 'SALA', Sala.SALA_SECRETARIA_2: 'SALA', Sala.SALA_SECRETARIA_3: 'SALA',
    Sala.CORREDOR_ADMINISTRACAO: 'CORREDOR', Sala.LAVABO: 'LAVABO', Sala.SALA_DO_L: 'SALA',
    Sala.GARAGEM: 'GARAGEM', Sala.ALMOXARIFADO_BUCANOWARE: 'ALMOXARIFADO',
    Sala.BAIRRO_PIOR: 'BAIRRO', Sala.AGENCIA: 'AGENCIA', Sala.PORTARIA: 'PORTARIA',
    Sala.PISTA: 'PISTA', Sala.AREA_PRIVADA: 'AREA', Sala.BAR: 'BAR', Sala.MESA_DE_SOM: 'MESA',
    Sala.SACADA: 'SACADA', Sala.BANHEIRO_DANCETERIA: 'BANHEIRO',
}


# Descrição das salas sem tratamento especial em Jogo.descrever()
TEXTO_SALA = {
    Sala.RECEPCAO_ESCRITORIO: (
        'Você está na recepção do escritório. Você vê a rua ao norte, o '
        'que lhe causa um enorme desejo de sair desta pocilga.',  # msg 131
    ),
    Sala.CALCADA: (
        "Você está na calçada de uma rua bastante movimentada. É "
        'realmente inacreditável o “coeficiente animal” dos motoristas '
        'deste bairro.',  # msg 132
    ),
    Sala.CALCADAO: (
        'Você se encontra num calçadão. Ao sul pode-se ver um salão '
        'bastante bonito (considerando o muquifo de bairro no qual você '
        'se encontra...)',  # msg 133
    ),
    Sala.BIBLIOTECA: (
        'Estamos na biblioteca. Este é um lugar interessante. As '
        'prateleiras dos livros ficam atrás do balcão, e não ao acesso do '
        'público..',  # msg 134
    ),
    Sala.BALCAO: (
        'O balcão é apertado, mas deu para entrar (agora que você se '
        'arrepende de não ter feito aquele regime). O perfume da '
        'balconista ainda é bastante forte.',  # msg 135
    ),
    Sala.DEPOSITO: (
        'A escada te levou até um depósito. Agora, basta subir que você '
        'pode sair do balcão.',  # msg 136
    ),
    Sala.VIELA: (
        'Você está numa viela totalmente deserta.',  # msg 137
    ),
    Sala.FACULDADE: (
        'Você está na entrada de uma faculdade. Não é nenhuma Oxford, mas '
        'dá para o gasto. Dá para ver muitos estudantes indo para todos '
        'os lados, e eles não devem estar interessados em conversar.',  # msg 155
    ),
    Sala.ESTACIONAMENTO: (
        'Você se encontra num estacionamento. Não há nenhum carro, o que '
        'lhe deixa muito decepcionado.',  # msg 156
    ),
    Sala.SECRETARIA_FACULDADE: (
        'Estamos na secretaria da faculdade. É uma salinha bem mixuruca, '
        'caindo aos pedaços.',  # msg 157
    ),
    Sala.QUADRA: (
        'Esta é a quadra de esportes. Nada de anormal aqui.',  # msg 160
    ),
    Sala.GINASIO: (
        'Você está no ginásio de esportes. O lugar está acabado. Na '
        'parede, uma pichação: “CHESTER NÃO ESTEVE AQUI”. Você se '
        'pergunta até que ponto a degradação humana pode chegar.',  # msg 161
    ),
    Sala.ALMOXARIFADO_FACULDADE: (
        'Você está no almoxarifado. O cheiro do local não é nada '
        'agradável, podendo-se dizer o mesmo do seu aspecto.',  # msg 162
    ),
    Sala.CPD_FACULDADE: (
        'Este é o Centro de Processamento de Dados da faculdade. '
        'Examinando mais profundamente, você observa o poderoso '
        'equipamento do pessoal: Um TK82C, conectado a um gravador CCE. '
        'Pena que não dá para utilizá-lo, pois ele está sem a fonte.',  # msg 163
    ),
    Sala.RUA_CENTRAL: (
        'Estamos em (mais) uma ruazinha louca, no sentido de norte a sul, '
        'que parece ser uma rua central do bairro. A oeste se vê um '
        'prédio, enquanto que ao leste há um escritório.',  # msg 169
    ),
    Sala.BECO: (
        'Estamos num beco sem saída.',  # msg 170
    ),
    Sala.QUARTO: (
        'Estamos num quarto. Na cama, um casal faz o que lhe é direito '
        'neste local. Graças à sua sutileza, eles não notaram. Aliás, '
        'acho que não notariam nem um terremoto.',  # msg 196
    ),
    Sala.CORREDOR_QUARTO: (
        'Você está num corredor estreito dentro do quarto. Não parece ser '
        'uma casa de excelente reputação.',  # msg 197
    ),
    Sala.FIM_DA_RUA: (
        'Estamos no fim da rua. Ao leste se vê um desses quartos baratos, '
        'e ao oeste um fliperama.',  # msg 198
    ),
    Sala.FLIPERAMA: (
        'Estamos numa casa de fliperama. Uma máquina de Street Fighter 2 '
        'olha apaixonada para você, mas você tem que ir atrás do '
        'disquete, e não gastar seu dinheiro com fliperama.',  # msg 199
    ),
    Sala.ENTRADA_PREDIO: (
        'Esta é a entrada do prédio. Um local exalando um cheiro '
        'nauseante está a oeste, enquanto que ao norte se vê o hall.',  # msg 200
    ),
    Sala.ELEVADOR_PREDIO: (
        'Estamos no elevador.',  # msg 203
    ),
    Sala.BANHEIRO_MASCULINO: (
        'Este é o banheiro masculino. Nem pense em fazer nada aqui, pois '
        'o lugar é horrível.',  # msg 205
    ),
    Sala.POCO: (
        'Você está num poço.',  # msg 206
    ),
    Sala.FABRICA: (
        'Estamos num lugar, que, pelo maquinário, parece ser uma fábrica '
        'de bebidas clandestina.',  # msg 207
    ),
    Sala.SALA_DO_COFRE: (
        'Estamos numa salinha apertada.',  # msg 208
    ),
    Sala.ESGOTOS: (
        'Caímos numa rede de esgotos. Após tatear muito, encontramos uma '
        'saída.',  # msg 209
    ),
    Sala.ESCADARIA: (
        'Ahá! Uma escadaria.',  # msg 214
    ),
    Sala.HALL_BUCANOWARE: (
        'Estamos no hall do edifício. Ao sul está a mesa da secretária, '
        'que provavelmente não vai nos deixar voltar se formos até lá. A '
        'leste e a oeste temos elevadores.',  # msg 221
    ),
    Sala.ESCRITORIO_ANALISTAS: (
        'Ao sair do elevador, você chegou num belíssimo escritório com '
        'móveis de cerejeira, decorado com pinturas expressionistas e '
        'tudo o mais. O elevador está a oeste.',  # msg 224
    ),
    Sala.CPD_PROGRAMADORES: (
        'Você está no CPD da firma. Ninguém nota sua chegada.',  # msg 225
    ),
    Sala.RECEPCAO_ADMINISTRACAO: (
        'Estamos na recepção da administração.',  # msg 226
    ),
    Sala.SALA_SECRETARIA_1: (
        'Estamos numa sala que parece pertencer a alguma secretária.',  # msg 227
    ),
    Sala.CORREDOR_ADMINISTRACAO: (
        'Estamos num corredor no sentido de leste a oeste.',  # msg 231
    ),
    Sala.LAVABO: (
        'Estamos num pequeno lavabo.',  # msg 232
    ),
    Sala.PORTA_DA_SALA_DO_L: (
        'Estamos em frente a uma porta. Ela está aberta.',  # msg 233
    ),
    Sala.SALA_DO_L: (
        'Estamos na sala do Sr. L. O local é bastante incrementado, o que '
        'mostra quanto dinheiro ele anda ganhando sobre os outros. (Agora '
        'você para para pensar quanto deverá valer este disquete, para '
        'que seu patrão te chute assim...).',  # msg 234
    ),
    Sala.GARAGEM: (
        'Estamos na garagem do edifício.',  # msg 235
    ),
    Sala.ALMOXARIFADO_BUCANOWARE: (
        'Estamos no almoxarifado. Valendo-se de sua inteligência '
        'superior, você chega à brilhante conclusão de que o disquete '
        'pode estar aqui.',  # msg 236
    ),
    Sala.AGENCIA: (
        'Estamos numa agência de viagens. Todos os guichês estão '
        'fechados, e não parece haver ninguém além de você aqui.',  # msg 238
    ),
    Sala.PISTA: (
        'Você está na pista de dança.',  # msg 249
    ),
    Sala.AREA_PRIVADA: (
        'Você está no que se pode chamar de “área privada” da danceteria.',  # msg 250
    ),
    Sala.BAR: (
        'Você está no bar.',  # msg 251
    ),
    Sala.MESA_DE_SOM: (
        'Você está em frente à mesa de som, perto do acesso que dá na sacada.',  # msg 252
    ),
    Sala.SACADA: (
        'Esta é a sacada. Daqui dá para ver todo o movimento do local.',  # msg 253
    ),
    Sala.BANHEIRO_DANCETERIA: (
        'Estamos no banheiro masculino (poderíamos ter entrado no '
        'feminino, mas as experiências anteriores não recomendam isso).',  # msg 254
    ),
}


LARGURA = 58  # a janela de mensagens do original tem 58 colunas (MostraMensagem quebra quando COL passa disso)


def quebra_linhas(texto):
    """Quebra como o MostraMensagem do original: palavras com o espaço final, rolando quando a coluna passa de 58."""
    texto += ' '
    linhas, linha, col = [], '', 1
    while texto:
        i = texto.index(' ') + 1
        trecho, texto = texto[:i], texto[i:]
        col += len(trecho)
        if col > LARGURA:
            linhas.append(linha.rstrip(' '))
            linha, col = '', len(trecho) + 1
        linha += trecho
    linhas.append(linha.rstrip(' '))
    return linhas


# o que a abertura e o comando AJUDA explicam (baseado nas telas de ajuda 2 e 3 do original)
AJUDA = ('Digite comandos com um verbo e um objeto, como PEGAR AZULEJO ou EXAMINAR HOMEM. Artigos e complementos '
         'são ignorados: PEGAR A NOZ é a mesma coisa que PEGAR NOZ.',
         'Para se mover, digite IR PARA O NORTE, IR NORTE ou só N (também S, L e O; C para cima e B para baixo). '
         'Vale a pena EXAMINAR qualquer objeto, e EXAMINAR LOCAL descreve onde você está. '
         'INVENTARIO mostra o que você carrega, e SAIR termina o jogo.')


class Jogo:
    def __init__(self, entrada=input, saida=print, teleporta_ao_beijar_akira=False, quebra=True):
        # Meu atalho de desenvolvimento, desligado no jogo distribuído (ver v16): BEIJAR AKIRA pergunta
        # um número e teleporta para a sala (1 a 66); 999 vai direto ao final. Na linha de comando:
        # --teleporta-ao-beijar-akira
        self.teleporta_ao_beijar_akira = teleporta_ao_beijar_akira
        self.quebra = quebra         # False (--sem-wrap): não quebra as linhas (a linha em branco depois de cada mensagem fica)
        self.loc = {i: int(v) for i, v in enumerate(LOC0[:90])
                    if v == v and abs(v) < 1e5}
        self.sala = Sala.ESCRITORIO_CHEFE
        self.grana = struct.unpack('<f', G[0x4ea:0x4ee])[0]
        self.pagina_lista = 0
        self.lanterna_ligada = False
        self.visitada = set()
        self.aula_usada = False
        self.porta57 = False
        self.noz_avisada = False
        self.entrada = entrada
        self.saida = saida
        self.fim = False
        self.morreu = False
        self.saiu = False
        self.palavra = ''            # primeira palavra do comando (verbo digitado)
        self.elevador_moveu = False  # flag 0x46a: o elevador acabou de levar o jogador a um andar
        self.barman_falou = False    # flag 0x4e2
        self.papel_aluminio = False  # flag 0x4de: lâmpada embrulhada no papel-alumínio
        self.nome_sala = ''          # SALANOME$: OLHAR <nome> (e LUGAR) mostra a sala
        self.txt_aqui = {}           # textos que o jogo troca durante a partida (txtaqui[]/txtexam[])
        self.txt_exam = {}
        self.branco_pendente = False
        self.objetos_mostrados = None  # última lista mostrada por mostrar_objetos (o painel Objetos do original)

    # ---------- util
    def dizer(self, t, junto=False, colado=False):
        # como o original: cada mensagem termina com uma linha em branco. junto: a linha em branco só sai
        # antes da próxima mensagem (ou no fim do comando); colado: a mensagem vem sem a linha em branco antes
        # (as saídas e a lista de objetos formam um bloco)
        if self.branco_pendente and not colado:
            self.saida('')
        self.branco_pendente = False
        for linha in quebra_linhas(t) if self.quebra else [t]:
            self.saida(linha)
        if junto:
            self.branco_pendente = True
        else:
            self.saida('')

    def fechar_bloco(self):
        if self.branco_pendente:
            self.saida('')
            self.branco_pendente = False

    def aqui(self, o):
        return abs(self.loc.get(o, 0)) == self.sala

    def com_jogador(self, o):
        return self.loc.get(o) == COM_JOGADOR

    def objeto(self, nome):
        """Lógica de 0x9396: primeiro nome que casa; outro de mesmo nome só vale se estiver na sala."""
        achado = 0
        for i, v in enumerate(VOC):
            if v and v == nome:
                if achado == 0 or self.aqui(i):
                    achado = i
        return achado

    # ---------- descrição e entrada nas salas (cada sala é uma sub-rotina no original)
    def saidas(self):
        sd = dict(SALAS[self.sala]['saidas'])
        if self.sala == Sala.SECRETARIA_FACULDADE:  # a sala de aula só existe até o ataque (flag 0x456 no original)
            sd['L'] = 0 if self.aula_usada else Sala.SALA_DE_AULA
        if self.sala == Sala.AGENCIA:
            sd['L'] = Sala.VIAGEM_DE_ONIBUS if self.porta57 else 0
        if self.sala == Sala.MESA_DE_SOM:  # a porta atrás da mesa de som só existe depois que o DJ sai
            sd['N'] = Sala.PASSAGEM_SECRETA if self.loc[Obj.DJ] == NENHUM else 0
        if self.sala == Sala.DEPOSITO_ESCURO:  # com luz sai por cima (almoxarifado); no escuro nem as saídas aparecem
            sd['C'] = Sala.ALMOXARIFADO_FACULDADE if self.iluminado() else 0
        return sd

    def iluminado(self):
        return self.lanterna_ligada and self.com_jogador(Obj.LANTERNA) and self.com_jogador(Obj.PILHAS)

    def fim_descricao(self):
        for o in sorted(self.loc):
            if self.aqui(o) and self.txt_aqui.get(o, AQUI[o]):
                self.dizer(self.txt_aqui.get(o, AQUI[o]))
        sd = self.saidas()
        nomes = {'N': 'NORTE', 'S': 'SUL', 'L': 'LESTE', 'O': 'OESTE', 'C': 'CIMA', 'B': 'BAIXO'}
        self.dizer('[saídas: %s]' % ', '.join(nomes[d] for d in 'NSLOCB' if sd.get(d)), junto=True)

    def descrever(self):
        s = self.sala
        if s in NOME_SALA:  # SALANOME$ (0x536): quem não atribui (salas 10, 14, 20...) herda o da sala anterior
            self.nome_sala = NOME_SALA[s]
        if s == Sala.DEPOSITO_ESCURO:
            self.nome_sala = 'DEPOSITO' if self.iluminado() else ''
        primeira = s not in self.visitada
        metodo = getattr(self, 'descrever_' + Sala(s).name.lower(), None)
        if metodo:
            return metodo(primeira)
        for texto in TEXTO_SALA[s]:
            self.dizer(texto)
        self.terminar_descricao()

    def terminar_descricao(self):
        self.visitada.add(self.sala)
        self.fim_descricao()

    def descrever_escritorio_chefe(self, primeira):
        if primeira:
            textos = (
                'Você está no escritório do chefe. Não é a primeira '
                'vez que você aparece nesta sala, mas você sente que '
                'está ferrado.',  # msg 123
                'De repente, a porta se abre. Aquele cara grandão, '
                'que você conhece apenas e tão somente como “O Chefe” '
                'aparece na porta.',  # msg 124
                '“Então é VOCÊ!!!”, ele diz, enquanto você se '
                'despede mentalmente do seu emprego. “Nem tente me '
                'enrolar. Onde está o disquete?”',  # msg 125
                '“Que disquete???”, você responde, surpreso por não '
                'saber do que ele está falando.',  # msg 126
                '“Não venha com essa. EU QUERO ESTE DISQUETE. VÁ '
                'PROCURÁ-LO AGORA, IMBECIL!!!”',  # msg 127
                '“Sim, senhor!”, você responde, enquanto o babaca '
                'sai e bate a porta.',  # msg 128
                'Parece que você está bem encrencado agora. Vê se '
                'acha este disquete logo. Afinal de contas, este deve '
                'ser o objetivo do jogo...',  # msg 129
            )
        else:
            textos = (
                'Você está no escritório do chefe.',  # msg 130
            )
        for texto in textos:
            self.dizer(texto)
        self.terminar_descricao()

    def descrever_praca(self, primeira):
        # A 148 ("Você olha para o chão e vê aquilo que um dia foi seu cabelo...") nunca aparece no
        # original: o código (0xdc8e) carrega a mensagem e salta (jmp 0xdcac) por cima do print.
        if primeira:
            textos = (
                'Estamos numa praça. Um fato curioso é que ninguém '
                'aqui tem um fio de cabelo, e muitos usam uma argola '
                'no nariz.',  # msg 138
                'De repente, o povo se aglomera à sua volta. Todos '
                'começam a gritar.',  # msg 139
                '“Olá, amigos. Tudo bem com vocês? Mas que dia lindo '
                'está hoje, não é mesmo?” - você diz.',  # msg 140
                '“Ih, moçada, esse mané é Mauricinho. Olha que '
                'frufru” - diz um deles aos outros, debochando. Ele '
                'fica sério e olha para você.',  # msg 141
                '“Aí, loque, esse barato é território dos carecas. '
                'Que é que cê tá fazendo aqui?”',  # msg 142
                '“N-N-N-Nada. Só passeando...” - você responde, '
                'pensando no seu testamento.',  # msg 143
                '“Mas, apesar de tudo, gostei de você. Aliás, te '
                'achei super-gostosinho. Uma graça. EI, GENTE, QUE '
                'TAL SE ELE FOR UM DOS NOSSOS?”',  # msg 144
                '“YEAH! YEAH! YEAH!” - diz a galera. E o cara '
                'continua - “Vamo nessa. Pega a maquininha zero”',  # msg 145
                '“Ei, o que vocês vão fazer. Espere aí, esse cabelo é '
                'meu!!! Meu cabelo! Meu cabelinho!” - você grita, '
                'enquanto eles raspam sua cabeça.',  # msg 146
                '“Muito bem” - diz o grandão, quando o serviço '
                'termina - “Agora você também é um careca. Pode '
                'circular aqui à vontade”. Ele se retira do local, '
                'gritando e pulando.',  # msg 147
            )
        else:
            textos = (
                'Você está na praça dos carecas. Seus últimos '
                'momentos aqui não foram muito agradáveis, mas você '
                'nota que tem total liberdade por aqui como um careca.',  # msg 149
            )
        for texto in textos:
            self.dizer(texto)
        self.terminar_descricao()

    def descrever_punks(self, primeira):
        for texto in (
            'Estamos em outra praça. Mais tipos estranhos aparecem, '
            'não exatamente carecas, “mas devem ser do mesmo '
            'clubinho”, você pensa.',  # msg 150
            'Muito feliz por ser um deles, você começa a pular e '
            'gritar: “EI, GENTE, VEJAM TODOS, EU SOU UM CARECA. VIVA '
            'A NOSSA GANGUE. SEREI CARECA ATÉ MORRER. VAMOS LÁ, '
            'AMIGOS!!!”',  # msg 151
            'A multidão vem eufórica em sua direção, e você delira '
            'por estar tão a salvo e em segurança no meio dos seus '
            'companheiros. Um deles chega e grita:',  # msg 152
            '“Você é um dos carecas, mesmo?”, e você responde: “Sim! '
            'E vocês, irmãos”',  # msg 153
            '“SOMOS PUNKS. NÓS ODIAMOS OS CARECAS!!!!!!” - grita a '
            'multidão, enquanto avançam para cima de você, '
            'triturando-o',  # msg 154
        ):
            self.dizer(texto)
        return self.morrer()

    def descrever_sala_de_aula(self, primeira):
        self.dizer(
            'Ei, esta é uma sala de aula. Os alunos e o '
            'professor olham para você com desprezo.')  # msg 158
        self.dizer(
            'De repente, o professor grita: “ATACAR!!!”, e '
            'os alunos lançam toda sorte de projéteis sobre '
            'você, desde papeis até apontadores de metal. '
            'Você sai da classe e o professor tranca a porta.')  # msg 159
        self.aula_usada = True
        self.loc[Obj.BORRACHA] = Sala.SECRETARIA_FACULDADE
        self.sala = Sala.SECRETARIA_FACULDADE
        return self.descrever()

    def descrever_deposito_escuro(self, primeira):
        if self.iluminado():
            self.dizer('Você está num depósito de papel.')  # msg 164
            if self.loc[Obj.MALA] == 0:
                self.loc[Obj.MALA] = Sala.DEPOSITO_ESCURO
        else:
            self.dizer(
                'Estamos num lugar escuro, muito escuro. Não '
                'dá nem para enxergar as saídas.')  # msg 165
        self.terminar_descricao()

    def descrever_bairro_perigoso(self, primeira):
        self.dizer(
            'Meu Deus, que lugar horrível. Não dá para andar '
            'um minuto sem que um marreteiro, traficante ou '
            'bicheiro venha lhe atazanar.')  # msg 167
        self.dizer(
            'Um corrózinho vem lhe pedir uma grana. Você dá a '
            'ele tudo o que suas possibilidades econômicas '
            'lhe permitem. Ele se enfurece e mete a faca.')  # msg 168
        return self.morrer()

    # loja de autopeças: o vendedor leva a BucanoWare por 5000
    def descrever_loja(self, primeira):
        if primeira:
            for texto in (
                'Você entra na loja, que parece negociar peças de '
                'automóveis. Um vendedor aborda você.',  # msg 171
                '“Em que posso servi-lo?” - ele pergunta.',  # msg 172
                '“Bem, eu gostaria de saber aonde procurar um '
                'disquete roubado...” - você diz, sem esperanças.',  # msg 173
                '“Oh, mas isso é ÓBVIO! Procure o Sr. L!!!',  # msg 174
                '“SR. L? Quem é o tipo?',  # msg 175
                '“Ele está há tempos tentando controlar os negócios '
                'da cidade ilegalmente. Já tentou arruinar o mercado '
                'de autopeças, e agora dizem que partiu para a '
                'informática...',  # msg 176
                '“BELEZA! Vou atrás do salafrário!!!” - você diz, '
                'eufórico.',  # msg 177
                '“Calma aí, rapaz” - ele diz - “Em primeiro lugar, '
                'você precisa achá-lo. Em segundo, é impossível '
                'atingi-lo. Ele é muito esperto, e não tem ficha na '
                'polícia.”',  # msg 178
                '“Hmm...”',  # msg 179
                '“Mas eu posso levá-lo até a sede das Indústrias L & '
                'L Ltda...”',  # msg 180
                '“MESMO???”',  # msg 181
                '“...mediante um módico preço.”',  # msg 182
                '“Hmm...” - você diz, abrindo sua carteira e exibindo seus' + dstr(0x664),  # msg 183
            ):
                self.dizer(texto)
        else:
            self.dizer(
                'Estamos na loja de autopeças. O vendedor nos '
                'aborda.')  # msg 185
        self.visitada.add(self.sala)
        if self.grana < PRECO_DO_VENDEDOR:
            self.dizer((
                '“Ei, isso não dá nem pro cheiro. Nada feito.” - '
                'Ele diz, e lhe aponta a porta. Você percebe a '
                'derrota e sai.') if primeira else (
                '“Trouxe a grana?” - ele diz, ao que você '
                'responde negativamente - “Então vá embora!!!” - '
                'ele diz, virando as costas enquanto você sai.'))  # msg 184, 186
            self.sala = Sala.RUA_CENTRAL
            self.dizer('Estamos de volta à rua central.')  # msg 195
            return self.fim_descricao()
        for texto in (
            '“Ah, vejo que sua carteira está recheada” - ele diz, nos '
            'tomando a carteira e quase toda a grana. “Fique com o '
            'troco”.',  # msg 187
            '“Vai me levar agora?” - você diz, nervoso por perder '
            'toda aquela grana por causa de um mísero disquete.',  # msg 188
            '“Claro. Venha comigo”',  # msg 189
            (
                'Vocês se dirigem a uma garagem no fundo da loja, '
                'enquanto ele lhe enche o saco - “Você verá agora que '
                'belezinha. Este bólido provido de motor superior com '
                'carburação ') + dstr(0x660),  # msg 190
            'Finalmente ele chega ao falado carro. Ele lhe lembra '
            'vagamente o desenho animado da “Super Motoca”. Após 243 '
            'tentativas frustradas de dar a partida, vocês finalmente '
            'saem (ou quase).',  # msg 191
            'O carro vai, sacolejando, enquanto você imagina se, em '
            'caso de acidente, morrerá com o impacto ou de tétano, '
            'considerando a idade do maquinário.',  # msg 192
            '“Aqui”, ele diz, apontando para o prédio aonde vocês '
            'param, “é o seu lugar. Esta é a BucanoWare Inc., a firma '
            'do Sr. L. Em matéria de sacanagem e cópia dos outros, '
            'eles são os melhores.',  # msg 193
            'Você sai do carro, e ele vai embora, cantando os pneus '
            '(ou melhor, o escapamento e o para-lamas, visto que a '
            'única coisa naquele carro que não produzia absolutamente '
            'nenhum ruído era a buzina).',  # msg 194
        ):
            self.dizer(texto)
        self.grana -= PRECO_DO_VENDEDOR
        self.sala = Sala.FRENTE_BUCANOWARE
        return self.descrever()

    # voltar à frente do prédio faz a recepção repetir a conversa (visitada[40] = 0)
    def descrever_frente_bucanoware(self, primeira):
        self.visitada.discard(Sala.RECEPCAO_BUCANOWARE)
        self.dizer(
            'Estamos na frente da BucanoWare INC. Não parece '
            'haver outro lugar a ir, senão a própria.')  # msg 215
        self.terminar_descricao()

    def descrever_recepcao_bucanoware(self, primeira):
        if primeira:
            textos = (
                'Você entra na recepçao. A recepcionista sorri e diz:',  # msg 216
                '“Bom dia. O que o senhor deseja?”',  # msg 217
                '“Bem, eu, aham, precisava conversar com o Sr. L”',  # msg 218
                '“Infelizmente, o Sr. L. hoje está muito ocupado. A '
                'não ser que seja algo importante, o senhor deveria '
                'se retirar...”',  # msg 219
            )
        else:
            textos = (
                'Estamos na recepção.',  # msg 220
            )
        for texto in textos:
            self.dizer(texto)
        self.terminar_descricao()

    # elevadores: depois de usar, ao voltar ele leva sozinho ao térreo
    def descrever_elevador_andares(self, primeira):
        texto = 'Você está num elevador.' if self.sala == Sala.ELEVADOR_ANDARES else 'Você está num elevador.'  # msg 222, 223
        if self.elevador_moveu:
            texto += ' Ele desce automaticamente até o térreo.' if self.sala == Sala.ELEVADOR_ANDARES else ' Ele sobe automaticamente até o térreo.'
            self.elevador_moveu = False
        self.dizer(texto)
        self.terminar_descricao()

    descrever_elevador_subsolos = descrever_elevador_andares

    def descrever_sala_secretaria_2(self, primeira):
        self.dizer('Eis OUTRA sala de secretária.' if primeira else 'Você está numa (outra) salinha de secretária.')  # msg 228
        self.terminar_descricao()

    def descrever_sala_secretaria_3(self, primeira):
        self.dizer((
            'Eis MAIS UMA sala de secretária (esse Sr. L é bom '
            'mesmo). Pena que o andar parece estar em férias '
            'coletivas, caso contrário você nem pensaria mais no '
            'disquete...') if primeira else 'Estamos numa salinha pertencente a alguma secretária.')  # msg 229, 230
        self.terminar_descricao()

    def descrever_bairro_pior(self, primeira):
        self.dizer((
            'Estamos num bairro pior do que todos os outros já '
            'vistos. Ao norte temos uma danceteria, e a rua vai '
            'no sentido de leste a oeste. Mas, sinceramente, eu '
            'não recomendaria passear nela. Aliás, eu não '
            'recomendaria entrar na danceteria, muito') + dstr(0x618))  # msg 237
        self.terminar_descricao()

    # o engomadinho só deixa passar quem tem o cartão (ou já esteve lá dentro)
    def descrever_portaria(self, primeira):
        if Sala.PISTA in self.visitada:
            self.dizer(
                '“Boa noite, cavalheiro”, lhe diz o '
                'engomadinho, enquanto você passa pela '
                'portaria.')  # msg 239
        else:
            self.dizer(
                'Entramos numa passagem. Um indivíduo '
                'engravatadinho e engomadinho, pronto para '
                'ser modelo de enfeite de geladeira, barra a '
                'sua passagem.')  # msg 240
            self.dizer('“Você é sócio?”')  # msg 241
            if not self.com_jogador(Obj.CARTAO):
                for texto in (
                    '“Não, mas...”',  # msg 242
                    '“Então terá que comprar o convite.”',  # msg 243
                    'Você mostra a ele seus $5, e ele dá uma '
                    'risadinha. “Ah, claro” - ele diz - “Escute, sr., '
                    'está vendo aquela janela?”',  # msg 244
                    '“Sim, claro” - você diz, virando-se para a '
                    'janela ao sul - “Por quê?”',  # msg 245
                    '“VAI NESSA, PALHAÇO!!!” - diz ele, chutando o '
                    'seu traseiro e te colocando para fora através '
                    'dela.',  # msg 246
                ):
                    self.dizer(texto)
                self.sala = Sala.BAIRRO_PIOR
                return self.descrever()
            self.dizer(
                'Você pega o cartão “emprestado” do cara do '
                'quarto e mostra ao rapaz.')  # msg 247
            self.dizer(
                '“Ah, claro. Desculpe não tê-lo reconhecido '
                'antes, Sr. Elbestáquio Josiclélio Alves de '
                'Calógeras e Mello. Pode entrar” - diz o '
                'engomadinho.')  # msg 248
        self.terminar_descricao()

    # a passagem atrás da mesa de som fecha e leva à cela
    def descrever_passagem_secreta(self, primeira):
        for texto in (
            'Ao dar a volta pela mesa de som, você entrou neste lugar '
            'sombrio. Cheio de teias de aranha, o local é totalmente '
            'desolado.',  # msg 255
            'Um silêncio sepulcral assola o local, até que uma voz se '
            'faz ouvir ao longe.',  # msg 256
            '“Ei, Mike, que história é essa de abrir a passagem com a '
            'danceteria aberta? Isso pode causar graves '
            'conseqüências caso alguém...”',  # msg 257
            'Você se vira para a saída, mas eis que de repente a '
            'passagem se fecha. Uh-oh...',  # msg 258
            '“Ahá! Vejo que temos um espião aqui! NÃO SE MOVA, '
            'MALDITO!!!',  # msg 259
            'Mas você não vai se entregar sem luta! Agora você se '
            'lembra de todos os ensinamentos de seu mestre e '
            'prepara-se para o combate corpo-a-corpo. Você se vira em '
            'direção ao inimigo e prepara-se para um salto mortal, '
            'quando...',  # msg 260
            '...você escorrega numa casca de banana (isso mesmo, numa '
            'casca de banana, dessas que sempre aparecem nos desenhos '
            'animados) e cai pateticamente no chão, perdendo a '
            'consciência.',  # msg 261
        ):
            self.dizer(texto)
        self.sala = Sala.CELA
        return self.descrever()

    def descrever_cela(self, primeira):
        texto = 'Você recupera lentamente a consciência. ' if primeira else ''  # msg 263
        self.dizer(texto + 'Estamos num fétido local que sugere um esconderijo. É realmente nauseante o cheiro do local.')
        if primeira:
            for texto in (
                'A porta se abre, rangendo. Uma figura, que você vê '
                'vagamente, vai se aproximando. Ao vê-la de perto, '
                'você reconhece a silhueta do cara que queria te '
                'atacar. Mas a iluminação ainda é muito fraca para '
                'ver seu rosto.',  # msg 264
                '“Eu já vi idiotas de todo tipo, Epaminondas, mas '
                'você me surpreende.”',  # msg 265
                '“Como você sabe o meu...” - você diz, mas imagina '
                'que ele deve ter visto seus documentos ao trazê-lo '
                'para cá.',  # msg 266
                'Você pensa em atacar, mas o instrumento metálico nas '
                'mãos do seu antagonista o demove da idéia.',  # msg 267
                '“Achei que você se mataria na cidade para encontrar '
                'o disquete. Mas você foi mais longe do que imaginei. '
                'Não importa. Cedo ou tarde um erro infantil seu iria '
                'deixá-lo em minhas mãos.”',  # msg 268
                '“Ei, cara, que tal fazermos um trato? Eu nem quero '
                'saber deste disquete. Fica com ele, eu vou embora e '
                'tá tudo certo. Eu...”',  # msg 269
                '“CHEGA! Não há motivos para mais mistérios!” - diz '
                'ele, acendendo a luz repentinamente. O impacto é '
                'enorme. “VOCÊ!! MAS... MAS... O QUE... POR QUE...”',  # msg 270
                '“Chefinho, então você trabalha para o Sr. L????',  # msg 271
                '“NÃO, SEU IDIOTA!!! Eu SOU o Sr. L.! HAHAHAHAHAAAA!!!”',  # msg 272
                '“Mas... por quê roubar seu próprio disquete? E o '
                'que EU tenho a ver com isso?”',  # msg 273
                (
                    '“Você ia descobrir, mais cedo ou mais tarde. Ia '
                    'mexer nas minhas coisas. Ia achar a mensagem que eu '
                    'recebi do serviço secreto e tirá-la de mim!!! Mas '
                    'eu não deixei! Meu plano foi magistral! Só teve '
                    'uma falha: você sobreviveu. Mas vou') + dstr(0x5fc),  # msg 274
                'Ele sai da sala, gargalhando, mas não fecha a porta. '
                'Em vez disso, enche o lugar de tijolos e cimenta-os, '
                'deixando-o sem saídas.',  # msg 275
            ):
                self.dizer(texto)
        self.terminar_descricao()

    # o hall: quem já esteve no banheiro feminino é linchado ao voltar
    def descrever_hall_predio(self, primeira):
        if Sala.BANHEIRO_FEMININO in self.visitada:
            self.dizer(
                'A mulherada que havia saído do banheiro '
                'avança sobre você, e o lincha em segundos, '
                'sob gritos de “TARADO”, “PERVERTIDO” e '
                'similares.')  # msg 201
            return self.morrer()
        self.dizer(
            'Você está no hall do prédio. Não há onde '
            'sentar-se, e mesmo que houvesse, você não tem '
            'tempo para isso. O banheiro feminino é a oeste.')  # msg 202
        self.terminar_descricao()

    def descrever_banheiro_feminino(self, primeira):
        self.dizer((
            'Entramos no banheiro feminino. A mulherada sai '
            'gritando com as saias na mão.') if primeira else dstr(0x644))  # msg 204
        self.terminar_descricao()

    def descrever_fuzilamento(self, primeira):
        for texto in (
            'Abrimos uma portinhola e eis o que aparece: metade do '
            'elenco de “O Poderoso Chefão”, embora com aspecto '
            'latino, está fumando charuto e jogando baralho, quando '
            'olha para você. Um deles diz:',  # msg 210
            '“¿Como te chamas?”',  # msg 211
            '“E-E-Epaminondas.”.',  # msg 212
            '“TE CHAMABAS!!!!” - dizem todos eles, ao fuzilá-lo.',  # msg 213
        ):
            self.dizer(texto)
        return self.morrer()

    def descrever_viagem_de_onibus(self, primeira):
        for texto in (
            'Você atravessa a porta e entra numa garagem, aonde um '
            'ônibus de viagem aguarda você.',  # msg 276
            'O motorista cita algumas passagens da vida da sua mãe, '
            'por você estar demorando, e você entra no ônibus, '
            'apressado.',  # msg 277
            'O ônibus segue viagem, e só agora você se pergunta aonde '
            'está indo, e volta a pensar no disquete e no seu emprego.',  # msg 278
            'Eis o final. Você desce, e volta para o jogo, perdido '
            'como sempre',  # msg 279
        ):
            self.dizer(texto)
        self.sala = Sala.RUA_CENTRAL
        return self.descrever()

    # ---------- morte (0x10aae): mensagens 294 e 295, "Digite qualquer tecla para reiniciar o jogo..." e RUN
    def morrer(self):
        self.dizer(
            'Você falhou em sua missão de recuperar seu emprego. '
            'Aliás, você morreu. Mas, como isso é um adventure, '
            'este fato é irrelevante. Basta recomeçar ou carregar '
            'um jogo gravado.')  # msg 294
        self.dizer(
            'Vamos lá! Não se desespere! O Papai Smurf está '
            'contando com você! E, afinal de contas, você não '
            'quer saber o que raios tem neste disquete? Levante '
            'a cabeça...')  # msg 295
        self.morreu = True  # quem controla o jogo reinicia (RUN no original)

    # ---------- curto-circuito (0x10af6): epílogo 296-306; o final depende da CHAVE (objeto 76)
    def curto_circuito(self):
        for texto in (
            'Você coloca a lâmpada no soquete, e ouve um estouro. As '
            'poucas frestas que emanavam alguma luz não são mais '
            'visíveis. Tudo indica que você causou um curto-circuito.',  # msg 296
            'Algumas horas se passam na escuridão. De repente, algumas '
            'vozes se fazem ouvir do lado de fora',  # msg 297
            '“Ei, me tirem daqui!!!!”, você grita, enquanto bate '
            'desesperado na parede.',  # msg 298
            '“Você aí dentro”, diz uma das vozes, “afaste-se desta parede!”',  # msg 299
            'Você obedece, e um barulho de metal batendo no concreto '
            'começa a ficar mais e mais alto, até que um bombeiro adentra '
            'o local com uma máquina de demolição.',  # msg 300
            'Ao ver os bombeiros, você logo grita: “Foi o Sr. L.! É tudo '
            'culpa dele!”.',  # msg 301
            '“Sim, nós já sabemos. Fomos chamados para conter o tumulto '
            'do blecaute, e acabamos vistoriando o local e descobrindo '
            'suas ligações com o Serviço Secreto de Ohio.',  # msg 302
            'Você é retirado do local, e após algumas horas de '
            'interrogatório e investigação, e um breve descanso na sua '
            'casa, você vai até o escritório.',  # msg 303
            'Ao chegar lá, você descobre que o gerente assumiu o posto do '
            'seu chefe, e seu emprego está a salvo. Vocês trocam algumas '
            'informações, até que chegam “naquele” assunto:',  # msg 304
            '“E o disquete, o que tinha?”',  # msg 305
            '“Não se sabe. A polícia procurou em todo lugar, e não '
            'encontrou nada. Só sobrou este cofre, totalmente selado...',  # msg 306
        ):
            self.dizer(texto)
        if self.com_jogador(Obj.CHAVE):
            for texto in (
                '“Ei, eu tenho uma chave!!!”, você diz, eufórico.',  # msg 311
                '“Duvido que sirva para algo, mas... EI, ESTA É UMA CHAVE '
                'MESTRA!!!”',  # msg 312
                'Vocês correm na direção do cofre, tiram as fitas que a '
                'perícia pôs sobre ele e assopram a poeira.',  # msg 313
                'Você dá a chave ao gerente. Ele coloca-a dentro do '
                'buraco. Ele vira a chave para a esquerda, depois para a '
                'direita, e NADA!!!',  # msg 314
                '“QUE DROGA!!!!” - você diz, enquanto pensa em voltar à '
                'sua vida de aventuras para procurar a chave.',  # msg 315
                'Você pega um cinzeiro da mesa e atira na direção do '
                'cofre, raivoso. De repente...',  # msg 316
                '...CLIC! O cinzeiro pressionou a chave no ponto '
                'correto, o que destravou o cofre. Você e o gerente olham '
                'abismados para a porta que se abre automaticamente.',  # msg 317
                'Uma névoa densa é revelada (que o Sr. L deve ter '
                'importado do show do Prince, só para dar um clima), até '
                'que ele se encontra totalmente aberto.',  # msg 318
                '“É O DISQUETE!!!”, você grita, enquanto vai pulando com '
                'ele até a mesa do Sr. L. Vocês ligam o computador dele '
                '(nunca demorou tanto para aparecer o cursor quanto '
                'agora), e inserem o disquete.',  # msg 319
                'O gerente digita o comando para acessar o disquete. A '
                'luz do drive acende, enquanto vocês, pasmos, observam a '
                'tela escura. De repente, o disco para. O micro solta um '
                'bip, e então...',  # msg 320
                'Uma mensagem aparece no monitor. Abismado, você verifica '
                'que ela diz:',  # msg 321
                '           Felicitações pelo dia da Páscoa!!!',  # msg 322
                '\t\t\tAss.:Serviço Secreto de Ohio.',  # msg 323
                'ESSA NÃO!!! VOCÊ PASSOU POR TUDO ISSO POR CAUSA DE UMA '
                'CARTA DE FELICITAÇÕES?!?!?!?!',  # msg 324
                'Parabéns! Você chegou ao fim do jogo! Todos os '
                'objetivos foram cumpridos, mas o Sr. L. escapou. Não se '
                'preocupe. Ou melhor, se preocupe com a seqüência desta '
                'aventura. Ela estará disponível em breve.',  # msg 325
                (
                    'Como em todo episódio do Jaspion, você terminou '
                    'exatamente onde começou, não capturou nenhum bandido, e '
                    'o que fugiu promete vingança. ') + dstr(0x578),  # msg 326
            ):
                self.dizer(texto)
        else:
            for texto in (
                'Sem solução para isso, você continua a trabalhar até o '
                'fim de seus dias, sem jamais saber o que havia neste '
                'cofre (arrombá-lo seria perigoso, nunca se sabe o que o '
                'Sr. L. colocou como segurança).',  # msg 307
                'Acho que o jogo termina por aqui. Muito embora não tenha '
                'capturado o Sr. L, você cumpriu um dos objetivos básicos '
                'do jogo: recuperou seu emprego. Mas...',  # msg 308
                'O que haveria no cofre? Seria o disquete? Se não, '
                'aonde está o disquete? O que havia dentro dele? Quem '
                'matou Odete Roytmann? Quantas vezes por segundo uma '
                'andorinha africana bate as asas contra o vento para se '
                'manter voando?',  # msg 309
                'Você jamais saberá a resposta destas perguntas. No '
                'entanto, você chegou no fim do jogo. Que tal voltar '
                'agora e tentar jogar de novo, só que procurando a chave '
                'e o disquete? Vai lá, meu garoto!!!',  # msg 310
            ):
                self.dizer(texto)
        self.fim = True

    # ---------- parser
    def comando(self, texto):
        self.executar(texto)
        self.mostrar_objetos()
        self.fechar_bloco()

    def iniciar(self):
        self.descrever()
        self.mostrar_objetos()
        self.fechar_bloco()

    def ajuda(self):
        for p in AJUDA:
            self.dizer(p)

    def executar(self, texto):
        if texto.strip().upper() in ('AJUDA', '?'):  # no original a ajuda ficava no menu (ESC)
            return self.ajuda()
        # o original apagava as letras acentuadas (INVENTÁRIO virava INVENTRIO); aqui os acentos são tirados antes
        texto = ''.join(c for c in unicodedata.normalize('NFD', texto) if not unicodedata.combining(c))
        pal = [p for p in re.sub(r'[^A-Za-z ]', '', texto.upper()).split() if p]
        if len(pal) > 1:  # o filtro do jogo usa ' O ' com espaços, então "O" sozinho (oeste) sobrevive
            pal = [p for p in pal if p not in FILTRO]
        if not pal:
            return
        verbo = None
        for i, v in enumerate(PALAVRAS_VERBO):
            if v == pal[0]:
                verbo = int(ID_VERBO[i])
                aridade = int(ARIDADE[i])
                break
        if verbo is None:
            self.dizer('Não entendi o verbo ' + pal[0])
            return
        self.palavra = pal[0]
        nome = ' '.join(pal[1:])
        if aridade == 2 and not nome:  # verbo que exige objeto (0x92d7)
            return self.dizer(pal[0] + ' O QUE?')
        if nome == 'LISTA TELEFONICA':
            nome = 'LISTA'
        obj = self.objeto(nome) if nome else 0
        if nome == 'DINHEIRO':
            obj = Obj.GRANA  # GRANA
        if nome in (self.nome_sala, 'LUGAR') and obj == 0:  # nome da sala atual (SALANOME$) ou LUGAR
            obj = Obj.LOCAL  # LOCAL
        if obj == 0 and aridade == 2:
            return self.dizer('O que você quer dizer com ' + nome + '?')
        if nome and aridade == 0:
            return self.dizer(pal[0] + ' não combina com ' + nome)
        if verbo == Verbo.IR and Obj.NORTE <= obj <= Obj.OESTE:
            verbo, obj = obj, 0
        getattr(self, 'verbo_' + Verbo(verbo).name.lower(), self.nao_implementado)(obj)

    # ---------- ABRIR: 0xbfd9 (mala e porta automática)
    def abrir_porta57(self):
        if self.com_jogador(Obj.PASSAGEM):
            self.dizer(
                'Você coloca a passagem na abertura ao lado da '
                'porta, e ela se abre.')  # msg 108
            self.porta57 = True
            self.loc[Obj.PASSAGEM] = GASTO
        else:
            self.dizer(
                'Não dá. Ela é automática, e só abre se você '
                'tiver a passagem.')  # msg 109

    # verbo 15 @ 0xbfd9: ABRIR
    def verbo_abrir(self, o):
        v = VOC[o]
        if o == Obj.CARTEIRA:  # CARTEIRA: o original desvia para o OLHAR (0xaa4a)
            return self.verbo_olhar(o)
        if o == Obj.PORTA_SALA_DO_L:  # a PORTA da sala 52
            return self.dizer('Já está aberta')  # msg 104
        if o == Obj.COFRE:  # COFRE (não precisa estar na sala, o original não confere)
            return self.dizer('Já está aberto.')  # msg 110
        if v == 'MALA':
            if not self.com_jogador(Obj.MALA):
                return self.dizer('Você não a tem.')
            if self.loc[Obj.PASSAGEM] == 0:
                self.dizer(
                    'Há uma passagem de ônibus nela. Você a pega '
                    'imediatamente.')  # msg 106
                self.loc[Obj.PASSAGEM] = COM_JOGADOR
            else:
                self.dizer('Está vazia.')  # msg 107
        elif v == 'PORTA' and o == Obj.PORTA_AUTOMATICA and self.sala == Sala.AGENCIA:
            if self.porta57:
                self.dizer('A porta já está aberta.')  # msg 105
            else:
                self.abrir_porta57()
        else:
            self.dizer('Não posso abrir isso.')  # msg 111

    # ---------- SAIR/ABANDONAR: 0xcac1
    # verbo 20 @ 0xcac1: SAIR/ABANDONAR
    def verbo_sair(self, o):
        # O original pergunta "Digite «S» para sair ao DOS ou outra tecla para jogar..." (uma tecla).
        # Aqui sai direto, sem confirmação.
        self.saiu = True

    # ---------- BEIJAR/ABRACAR: 0xc289
    # verbo 16 @ 0xc289: BEIJAR/ABRACAR
    def verbo_beijar(self, o):
        # O atalho de desenvolvimento (BEIJAR AKIRA pulava para qualquer sala, msgs 112 e 113) ficou
        # inalcançável no original: o teste foi trocado de OBJ=36 para OBJ=36000, que nenhum nome resolve.
        # Com teleporta_ao_beijar_akira ligado o atalho volta (o 36 é inferido; o resto está no código).
        if o == Obj.SOQUETE:  # SOQUETE: desvia para o PEGAR (0x9f9e)
            return self.verbo_pegar(o)
        if self.teleporta_ao_beijar_akira and o == Obj.AKIRA:  # AKIRA
            self.dizer('Muito bem! Agora digite o número da tela desejada:')  # msg 112
            try:
                n = float(self.entrada('sala> ').replace(',', '.'))
            except ValueError:
                n = 0
            if n == 999:  # salta direto para o curto-circuito (0x10af6), o final do jogo
                return self.curto_circuito()
            if 1 <= n <= Sala.CELA:
                self.sala = int(n)
                return self.descrever()
            return self.dizer('Nada feito.')  # msg 113
        if self.sala != abs(self.loc.get(o, 0)) and self.loc.get(o) != COM_JOGADOR:
            return self.dizer('Não está aqui...')  # msg 114
        self.dizer('Vá com calma...' if o in (Obj.BALCONISTA, Obj.SECRETARIA, Obj.RECEPCIONISTA) else 'Freud explica...')  # msg 115, 116

    # ---------- verbos de resposta fixa (0xccfc a 0xcf25) e ATRAVESSAR
    # verbo 25 @ 0xccfc: VOAR
    def verbo_voar(self, o): self.dizer(dstr(0x6fc))
    # verbo 26 @ 0xcd0a: MORDER/XINGAR/BATER/ESPANCAR/LAMBER
    def verbo_morder(self, o): self.dizer(dstr(0x6f8))

    # verbo 28 @ 0xcdd8: CHEIRAR
    def verbo_cheirar(self, o):
        self.dizer(dstr({Sala.BALCAO: 0x6e4, Sala.BANHEIRO_MASCULINO: 0x6e0}.get(self.sala, 0x6dc)))

    # verbo 29 @ 0xce28: ATRAVESSAR
    def verbo_atravessar(self, o):
        if o != Obj.RUA:
            return self.dizer(dstr(0x6d8))
        if self.sala not in (Sala.CALCADA, Sala.BAIRRO_PIOR):
            return self.dizer(dstr(0x6d4))
        for a in (0x6d0, 0x6cc, 0x6c8, 0x6c4, 0x6c0):
            self.dizer(dstr(a))
        self.morrer()

    # verbo 30 @ 0xceed: PULAR
    def verbo_pular(self, o): self.dizer(dstr(0x6bc))
    # verbo 31 @ 0xcefb: JOGAR/BRINCAR/PASSEAR/DORMIR/CAVALGAR/MASTURBAR
    def verbo_jogar(self, o): self.dizer(dstr(0x6b8))
    # verbo 32 @ 0xcf09: ARREMESSAR/LANCAR
    def verbo_arremessar(self, o): self.dizer(dstr(0x6b4))
    # verbo 33 @ 0xcf17: SENTAR/DEITAR
    def verbo_sentar(self, o): self.dizer(dstr(0x6b0))
    # verbo 34 @ 0xcf25: APAGAR
    def verbo_apagar(self, o): self.dizer(dstr(0x6ac))

    def nao_implementado(self, obj):
        self.dizer('(nao implementado)')

    # ---------- verbos de movimento (1-4, 11, 12): 0x9bc9..0x9cf5, 0xb715, 0xb744
    def ir(self, d, nome):
        dest = self.saidas().get(d)
        if not dest:
            self.dizer('SUA ANTA! Você não pode ir para %s!!!' % nome)
            return
        self.sala = dest
        self.descrever()

    # verbo 1 @ 0x9bc9: NORTE/N
    def verbo_norte(self, o): self.ir('N', 'o norte')

    # verbo 2 @ 0x9bf8: SUL/S
    def verbo_sul(self, o):
        if self.sala == Sala.FACULDADE:  # o vigia só deixa passar quem passou pelos carecas (visitada[9])
            if Sala.PRACA not in self.visitada:
                return self.dizer(
                    'O vigia barra seu caminho. “Esta '
                    'passagem é apenas para alunos da '
                    'faculdade”, ele diz.')  # msg 0
            self.dizer(
                'O vigia olha para você com desprezo e diz “Pode '
                'passar. Com esta careca, só pode ser bicho... '
                'Que raça abominável!”')  # msg 1
        self.ir('S', 'o sul')

    # verbo 3 @ 0x9c98: LESTE/L
    def verbo_leste(self, o): self.ir('L', 'o leste')
    # verbo 4 @ 0x9cc7: OESTE/O
    def verbo_oeste(self, o): self.ir('O', 'o oeste')
    # verbo 11 @ 0xb715: CIMA/C/SUBIR
    def verbo_cima(self, o): self.ir('C', 'cima')
    # verbo 12 @ 0xb744: BAIXO/B/DESCER
    def verbo_baixo(self, o): self.ir('B', 'baixo')

    # ---------- IR/ENTRAR: 0x9cf6
    # verbo 5 @ 0x9cf6: IR/ENTRAR
    def verbo_ir(self, o):
        v = VOC[o] if o else ''
        if v == 'SALAO' and self.sala == Sala.CALCADAO:
            self.sala = Sala.BIBLIOTECA
        elif o == Obj.BALCAO_BIBLIOTECA and self.sala != Sala.BIBLIOTECA:
            return self.dizer('Não posso.')
        elif v == 'BALCAO' and self.sala == Sala.BIBLIOTECA:
            if self.loc[Obj.BALCONISTA] != 0:
                self.dizer(
                    '“Sinto muito, mas esta área é restrita a '
                    'funcionários...” - diz a balconista, num tom '
                    'de voz mais do que educado.')  # msg 2
                return
            self.sala = Sala.BALCAO
        elif v == 'ESCADA' and self.sala == Sala.BALCAO:
            self.sala = Sala.DEPOSITO
        elif o == Obj.PORTA_BIBLIOTECA and self.sala == Sala.CALCADAO:  # 0x9db8: cai no SUL (0x9bf8)
            return self.verbo_sul(o)
        elif o == Obj.PORTA_AUTOMATICA and self.sala == Sala.AGENCIA:
            if not self.porta57:
                return self.dizer('Ela está fechada...')  # msg 3
            return self.verbo_leste(o)  # 0x9f85: cai no LESTE (0x9c98)
        elif v == 'TUBO' and self.sala == Sala.SALA_DO_COFRE:
            return self.verbo_baixo(o)
        elif v in ('CIMA',):
            return self.verbo_cima(o)
        elif v in ('BAIXO',):
            return self.verbo_baixo(o)
        else:
            self.dizer('Você não pode ir até isso!')  # msg 4
            return
        self.descrever()

    # ---------- PEGAR: 0x9f9e
    # verbo 6 @ 0x9f9e: PEGAR/CATAR/APANHAR/TOMAR
    def verbo_pegar(self, o):
        v = VOC[o]
        if v == 'ONIBUS':
            return self.verbo_ligar(o)
        if v == 'SOQUETE' and self.sala == Sala.CELA:
            self.dizer('ZZZZZZAAAP!!! Um choque de 220V escurece o local e a você, que morre carbonizado.')
            return self.morrer()
        if v == 'LAMPADA' and self.sala == Sala.CELA and self.loc[Obj.LAMPADA] == Sala.CELA:
            return self.dizer('Tente desrosqueá-la.')
        if v == 'ARAME':
            return self.dizer(
                'Não dá. Ele está firmemente preso ao '
                'chão. A não ser que você “dê um '
                'jeitinho”. Raciocine...')  # msg 5
        if self.com_jogador(o):
            return self.dizer('Não seja estúpido! Você já tem isso!!!')  # msg 6
        if self.sala != abs(self.loc.get(o, 0)):
            return self.dizer('Este objeto não está aqui...')  # msg 7
        if v == 'BALA':
            self.txt_exam[Obj.PIA] = 'Nem pense em fazer nada aí. Esta pia é nojenta.'
        elif v == 'LIXO':  # só tira a agenda do cesto, sem pegar o lixo
            self.dizer(
                'Nem pense em levar isso. Eu não sou tão porco '
                'assim. Vou apenas tirá-lo do cesto e deixá-lo de '
                'lado.')  # msg 8
            self.loc[Obj.AGENDA] = self.sala
            self.txt_exam[Obj.CESTO] = 'Tem uma agenda aqui dentro.'
            return
        elif v == 'AGENDA':
            self.txt_aqui[Obj.AGENDA] = 'Tem uma agenda aqui.'
            self.txt_exam[Obj.CESTO] = 'Não tem nada aqui.'
        if self.loc[o] < 0:
            return self.dizer('Não posso pegar isso.')  # msg 9
        self.loc[o] = COM_JOGADOR
        self.dizer((
            'Você pega o bispo sem constrangimento, pois ninguém '
            'daria pela falta de uma peça de xadrez.') if VOC[o] == 'BISPO' else 'Ok.')  # msg 10

    # ---------- LISTAR: 0xa23e
    # verbo 7 @ 0xa23e: LISTAR/INVENTARIO/OBJETOS
    def verbo_listar(self, o):
        itens = [VOC[i] for i in sorted(self.loc) if self.loc[i] == COM_JOGADOR]
        self.dizer('Objetos: ' + (', '.join(itens) or 'NADA'))

    def mostrar_objetos(self):
        """O painel Objetos do original se redesenha quando o inventário muda; aqui a lista sai só nessas horas."""
        itens = [VOC[i] for i in sorted(self.loc) if self.loc[i] == COM_JOGADOR]
        if itens != self.objetos_mostrados:
            self.objetos_mostrados = itens
            self.dizer('[com você: %s]' % (', '.join(itens) or 'NADA'), colado=True)

    # ---------- LARGAR: 0xa5a1 (caso geral)
    # verbo 8 @ 0xa5a1: LARGAR/DEIXAR/SOLTAR
    def verbo_largar(self, o):
        v = VOC[o]
        if v == 'LAMPADA' and self.com_jogador(o):
            self.dizer('Seu desastrado! Você largou a lâmpada e ela se espatifou!')
            self.loc[Obj.LAMPADA] = NENHUM
            return
        if v == 'ENVELOPE' and self.com_jogador(o) and self.sala == Sala.RECEPCAO_BUCANOWARE:  # a recepcionista deixa passar o "office-boy"
            self.loc[Obj.ENVELOPE] = NENHUM
            for texto in (
                'Você dá o envelope à secretária.',  # msg 11
                '“Ah, pelo seu estilo capilar logo imaginei que era um '
                'office-boy”',  # msg 12
                '(suspiro)',  # msg 13
                '“Venha comigo. Vou levá-lo ao hall” - diz ela, tomando-o '
                'pelo braço.',  # msg 14
            ):
                self.dizer(texto)
            self.sala = Sala.HALL_BUCANOWARE
            return self.descrever()
        if v == 'FOSFOROS':
            return self.dizer(
                'Pra que? Apesar de você não fumar, eles '
                'podem ser úteis para aquecer, iluminar, '
                'etc.')  # msg 15
        if not self.com_jogador(o):
            return self.dizer('Você não pode largar o que não tem...')  # msg 16
        if v == 'CD' and self.sala == Sala.MESA_DE_SOM:  # entregar o CD ao DJ não adianta: ele só sai da mesa se o CD cair na pista
            self.dizer(
                'Você tira o CD do bolso e, imediatamente, o '
                'disk-jockey o apanha.')  # msg 17
            self.dizer('“Oh, MUITO OBRIGADO! DEUS LHE PAGUE!”, diz ele.')
            self.loc[Obj.CD] = NENHUM
            return
        if v == 'CD' and self.sala == Sala.PISTA:
            self.dizer(
                'O DJ sai da mesa lá no fundo e vem pegar o CD '
                'que você colocou num canto. Antes dele chegar, '
                'porém, os dançarinos esmagam o CD. Ele vê qual '
                'era o CD e corre até a rua, aonde comete '
                'suicídio. Felizmente o tape-deck mantém a música '
                'tocando')  # msg 18
            self.loc[Obj.CD] = NENHUM
            self.loc[Obj.DJ] = NENHUM
            return
        if v == 'GRANA':
            return self.dizer('Sem essa de Papai Noel. Nada feito.')  # msg 19
        if v == 'BISPO' and self.sala == Sala.FLIPERAMA:  # o velhinho troca o bispo pela marreta
            for texto in (
                'O velhinho percebe que você quer lhe dar a peça. Ele '
                'começa a gritar e babar.',  # msg 20
                '“ACHEI!!! ACHEI!!! AGORA VOU TERMINAR O JOGO!!!!”',  # msg 21
                'Ele lhe dá uma marreta, e sai gritando “BLAAAAAAAGH” ou '
                'algo semelhante.',  # msg 22
            ):
                self.dizer(texto)
            self.loc[Obj.VELHINHO] = NENHUM
            self.loc[Obj.BISPO] = NENHUM
            self.loc[Obj.MARRETA] = COM_JOGADOR
            return
        if v == 'AGENDA' and self.sala == Sala.FRENTE_BUCANOWARE:  # o taxista não fala a nossa língua, mas entende a agenda
            self.dizer(
                'O homem do taxi pega a agenda que você entregou '
                'a ele. Ele abre na página em que você não '
                'entendia nada e, vociferando e gritando palvras '
                'estranhas, lhe aponta aonde fica o local. Ele '
                'olha para você, diz “Heil” e abre a porta do '
                'carro.')  # msg 23
            self.dizer((
                'Vocês entram. A viagem não é longa, pois o cara '
                'parece conhecer a cidade. Apesar de não saber para '
                'onde está indo (sabe lá que local este Sr. L. anotou '
                'naquela agenda), você sente que está na pista certa. '
                'Pena que o taxista não fala sua') + ' língua. Ele seria de grande ajuda...')  # msg 24
            self.dizer(
                'O taxi para. Você desce e lhe dá quase todo o '
                'seu dinheiro. Ele olha para você, com aquela '
                'cara de quem está doido para conversar, mas '
                'acelera o carro.')  # msg 25
            self.grana = GRANA_APOS_TAXI
            self.dizer(
                'Antes de sumir, ele põe a cabeça para fora e '
                'grita: “Valeu, mané. A gente se vê por aí...”')  # msg 26
            self.dizer('(suspiro)')  # msg 27
            self.sala = Sala.BAIRRO_PIOR
            return self.descrever()
        if v in ('LANTERNA', 'PILHAS') and self.lanterna_ligada:
            return self.dizer('Desligue a lanterna antes')
        self.loc[o] = self.sala
        self.dizer('Ok.')  # msg 28

    # ---------- OLHAR: 0xaa4a (caso geral)
    # verbo 9 @ 0xaa4a: OLHAR/VER/EXAMINAR/OBSERVAR/VERIFICAR
    def verbo_olhar(self, o):
        v = VOC[o]
        if v == 'PAREDE' and self.sala != Sala.BANHEIRO_FEMININO:
            return self.dizer('Nada ali vai lhe ajudar...')
        if v in ('TETO', 'CIMA') and self.sala == Sala.CELA:
            return self.dizer('Tem uma lâmpada no teto.' if self.loc[Obj.LAMPADA] == Sala.CELA else 'Há um soquete de lâmpada no teto.')  # msg 29
        if o in (Obj.TETO, Obj.CHAO, Obj.CIMA, Obj.BAIXO):  # 0xab6b: texto de exame em qualquer sala
            return self.dizer(self.txt_exam.get(o, EXAM[o]))
        if v == 'GRANA':
            return self.dizer('Você tem $' + str(int(self.grana)))  # msg 30
        if o == Obj.PLACA_BIBLIOTECA and self.sala != Sala.CALCADAO:  # PLACA da biblioteca
            return self.dizer('Não estou vendo nada parecido aqui.')  # msg 31
        if v in ('LOCAL', 'SALA', 'AREA'):
            return self.descrever()
        if Obj.NORTE <= o <= Obj.OESTE:
            return self.dizer('Deixe de ser preguiçoso e ande até lá!!!')  # msg 32
        if not self.aqui(o) and not self.com_jogador(o):
            return self.dizer('Não estou vendo nada parecido aqui.')  # msg 33
        if self.sala == Sala.DEPOSITO_ESCURO and self.nome_sala == '' and o in (
                Obj.LISTA, Obj.AZULEJO, Obj.LIVRO, Obj.PAPEL, Obj.GRANA, Obj.ENVELOPE, Obj.BORRACHA):
            return self.dizer('Não consigo ver nada.')  # 0xadb0: escuro (SALANOME$ vazio)
        if v == 'LISTA':
            if not self.com_jogador(o):
                return self.dizer('Não a tenho.')  # msg 34
            self.pagina_lista = self.pagina_lista % 4 + 1
            return self.dizer(LINHAS_LISTA[self.pagina_lista])
        if v == 'CARTEIRA' and self.com_jogador(o) and self.loc[Obj.CARTAO] == 0:
            self.dizer('Temos um cartão aqui.')  # msg 39
            self.loc[Obj.CARTAO] = COM_JOGADOR
            return
        if v == 'LANTERNA' and self.com_jogador(Obj.PILHAS):
            return self.dizer('Ela está ' + ('ligada' if self.lanterna_ligada else 'desligada'))  # msg 36
        if v == 'PORTA' and o == Obj.PORTA_AUTOMATICA and self.sala == Sala.AGENCIA:
            return self.dizer('Ela está aberta.' if self.porta57 else 'Ela está fechada.')  # msg 37, 38
        if v == 'POSTE':
            return self.dizer('É um ponto de ônibus.')  # msg 35
        if v == 'COFRE' and o == Obj.COFRE and self.sala == Sala.SALA_DO_COFRE and self.grana < GRANA_NO_COFRE:
            self.dizer(
                'Temos uns $5000 aqui. Nem precisa mandar pegar o '
                'dinheiro.')  # msg 40
            self.grana += GRANA_NO_COFRE
            return
        self.dizer(self.txt_exam.get(o, EXAM[o]) or 'Nada de especial.')

    # ---------- FALAR: 0xb1ce
    # verbo 10 @ 0xb1ce: FALAR/CONVERSAR
    def verbo_falar(self, o):
        if self.sala != abs(self.loc.get(o, 0)):
            return self.dizer('Aonde você vê isso?')  # msg 41
        v = VOC[o]
        if v == 'DJ':
            for texto in (
                '“Ei, você conhece este local?”',  # msg 42
                '“O quê”',  # msg 43
                '“Eu perguntei se você conhece isto aqui?”',  # msg 44
                '“O QUE?”',  # msg 45
                '“EU PERGUNTEI SE VOCÊ CONHECE ESTA POCILGA!!!!!!',  # msg 46
                '“COMO É?”',  # msg 47
                'Você desiste. Com este som alto não vai ter jeito.',  # msg 48
            ):
                self.dizer(texto)
        elif v == 'GRUPO':
            self.dizer(
                'Eles só se interessam em dançar. Aliás, acho que '
                'não parariam por nada deste mundo.')  # msg 49
        elif v == 'BARMAN':
            if self.barman_falou:
                return self.dizer(
                    '“Nada disso” - diz Moe - “Você já '
                    'passou da cota esta noite”')  # msg 50
            for texto in (
                '“Olá, Moe (você já supôs que todo garçom de danceteria '
                'se chama Moe ou Sam).',  # msg 51
                '“E então, chefe. Vai o de sempre?”',  # msg 52
                '“Claro” - você diz, feliz de ter sido confundido com '
                'algum dos sócios.',  # msg 53
                '“Aqui está. É por conta da casa, outro dia você acerta...”',  # msg 54
                '“Obrigado”. Ao olhar para a massa no copo, você diz: '
                '“Ei, o que é isso?”',  # msg 55
                '“O seu milk-shake. Como sempre foi seu pedido. Lembro '
                'bem do dia em que você pediu ½ copo de cerveja e voltou '
                'bêbado para casa... Ha Ha!!”',  # msg 56
                '“Grunf”, você diz, tomando o milk-shake. Em certo '
                'momento, você para e pensa: “Será que eu já vim aqui e '
                'não me lembro?”',  # msg 57
                '“Obrigado”, diz Moe, tirando o copo na metade. “Volte sempre”',  # msg 58
            ):
                self.dizer(texto)
            self.barman_falou = True
        elif v == 'HOMEM':
            self.dizer(
                'Talvez isso não vá fazer muito bem à sua saúde. '
                'Ele não é o que se chamaria de “tipo amigável”.')  # msg 59
        elif v == 'VIGIA':
            for texto in (
                '“Bom dia. Por favor, eu gostaria de procurar meu '
                'disquete por aqui, no laboratório da faculdade...”',  # msg 60
                '“E eu com isso?”, diz ele, enquanto começa a roer a unha.',  # msg 61
                '(suspiro)',  # msg 62
            ):
                self.dizer(texto)
        elif v == 'ANALISTAS':
            self.dizer(
                'Você fica falando sozinho, pois todos o ignoram. '
                'Afinal de contas, você não tem nada que lhes '
                'interesse...')  # msg 63
        elif v == 'PROGRAMADORES':
            self.dizer('Inútil. Eles estão muito ocupados com o jogo.')  # msg 64
        elif v == 'BALCONISTA':
            for texto in (
                '“Bom dia. Em que posso servi-lo?”',  # msg 65
                '“Seu sorriso já o fez...” - você responde, e ela dá uma '
                'risadinha maliciosa - “O que você tem de interessante '
                'aqui?”',  # msg 66
                '“Leve este aqui” - ela diz. Neste momento, um homem '
                'adentra a sala e abraça-a. Ela muda de expressão, '
                'confusa. Discretamente, anota qualquer coisa num papel e '
                'o coloca dentro do livro.',  # msg 67
                '“Mais alguma coisa?” - ela diz, suspirando quando o '
                'homem sai.',  # msg 68
                '“Por enquanto não. Mas quem sabe em outra '
                'oportunidade...” - você diz, enquanto ela se retira com '
                'o eterno sorriso.',  # msg 69
                '“Essa foi boa” - você pensa, enquanto observa ela sair '
                'pela porta afora. Mas você ainda tem um jogo para jogar. '
                'Tire esta expressão ridícula do seu rosto, rapaz!!!',  # msg 70
            ):
                self.dizer(texto)
            self.loc[Obj.BALCONISTA] = NENHUM
            self.loc[Obj.LIVRO] = COM_JOGADOR
            self.loc[Obj.PAPEL] = COM_JOGADOR
        elif v == 'SECRETARIA':
            self.dizer(
                'Esquece. Ela não vai acordar, e mesmo que o '
                'fizesse, cinco minutos de conversa com você '
                'seriam suficientes para que ela voltasse a dormir')  # msg 71
        elif v == 'VELHINHO':
            for texto in (
                '“Bom dia, ó bom velhinho!” - você diz, alegremente.',  # msg 72
                '“XADREZZZZZ!” - ele responde - “Traga o XADREZZZZZ!”',  # msg 73
                'Você o fita por alguns segundos, e ele se vira novamente '
                'para a máquina, ignorando-o.',  # msg 74
            ):
                self.dizer(texto)
        elif v == 'TAXISTA':
            for texto in (
                '“Bom dia. O senhor anda bastante por aqui?”',  # msg 75
                'Ele diz: “Chucrutz WolksVagen MercedesBens Kibe '
                'HeilHitler”, ou algo assim.',  # msg 76
                '“É, tio, acho que você não fala a minha língua...”, você '
                'diz, virando as costas para ele.',  # msg 77
            ):
                self.dizer(texto)
        elif v == 'RECEPCIONISTA' and self.sala == Sala.RECEPCAO_BUCANOWARE:
            self.dizer('“Escute, srta., isto é muito importante”')  # msg 78
            self.dizer('“Isto o QUE? Você não tem nada a oferecer ao Sr. L, logo explique-se ou retire-se, por favor.”')
        elif v == 'BISPO' and (self.sala == Sala.HALL_PREDIO or self.com_jogador(o)):
            self.dizer('Talvez ele não tenha muito o que falar.')  # msg 79
        else:
            self.dizer('Você deveria se sentir ridículo conversando com isso.')  # msg 80

    # ---------- LER: 0xb773
    # verbo 13 @ 0xb773: LER
    def verbo_ler(self, o):
        v = VOC[o]
        if self.sala != abs(self.loc.get(o, 0)) and not self.com_jogador(o):
            return self.dizer('Aonde está isso?')  # msg 81
        if self.sala == Sala.DEPOSITO_ESCURO:
            return self.dizer('O ministério da saúde adverte: Ler no escuro é prejudicial à saúde.')
        # O original só testava a PLACA da biblioteca (12), então LER PLACA no elevador (53) respondia
        # "Não posso ler isso" (omissão). Aqui as duas placas se comportam como OLHAR.
        if o in (Obj.PLACA_BIBLIOTECA, Obj.PLACA_ELEVADOR) or v in ('PAPEL', 'AGENDA'):
            return self.verbo_olhar(o)
        if v == 'LIVRO':
            return self.dizer(
                'Cê pirou? Isso vai levar o mês inteiro, '
                'cara, e você tem um jogo para jogar...')  # msg 82
        self.dizer('Não posso ler isso')  # msg 83

    # ---------- DIZER (0xcb01), FECHAR/DESLIGAR (0xcb30), CHUPAR (0xc921)
    # verbo 21 @ 0xcb01: DIZER
    def verbo_dizer(self, o):
        if VOC[o] == 'NI':
            return self.dizer('Engraçado, ninguém responde...')
        self.dizer('Oh, mas aonde este mundo foi parar, se nobres cavaleiros ficam dizendo “ni” a torto e direito por aí...')

    # verbo 22 @ 0xcb30: FECHAR/DESLIGAR
    def verbo_fechar(self, o):
        if o == Obj.LANTERNA and self.lanterna_ligada:
            return self.dizer('Ah, agora que você ligou, deixe assim.')
        self.dizer('Não perca tempo fechando ou desligando as coisas neste jogo. É inútil e muito educado para você.')

    # verbo 18 @ 0xc921: CHUPAR
    def verbo_chupar(self, o):
        if not self.com_jogador(o):
            return self.dizer('Você não tem isso!')  # msg 117
        if VOC[o] != 'BALA':
            return self.dizer('Isso pode ser muito perigoso. Melhor evitar...')  # msg 118
        self.dizer((
            'Você abre a bala e joga fora o papel. A bala está meio '
            'passada, mas mesmo assim a sensação é refrescante.'))  # a embalagem (papel-alumínio) fica no chão  # msg 119
        self.loc[Obj.BALA] = NENHUM
        self.loc[Obj.EMBALAGEM] = self.sala

    # ---------- ROSQUEAR (0xcb82) e DESROSQUEAR (0xcc1b): só a lâmpada
    # verbo 23 @ 0xcb82: ROSQUEAR
    def verbo_rosquear(self, o):
        if not self.com_jogador(o):
            return self.dizer('Não posso rosquear o que não tenho.')
        if VOC[o] != 'LAMPADA':
            return self.dizer('Cê pirou?')
        if self.papel_aluminio:
            return self.curto_circuito()
        self.dizer('Ok.')
        self.loc[Obj.LAMPADA] = Sala.CELA

    # verbo 24 @ 0xcc1b: DESROSQUEAR
    def verbo_desrosquear(self, o):
        if VOC[o] != 'LAMPADA':
            return self.dizer('Como vou desrosquear esta biromba?')
        if self.sala != Sala.CELA:
            return self.dizer('Não está aqui.')
        if self.com_jogador(o):
            return self.dizer('Já está desrosqueada e nas suas mãos.')
        if self.loc[o] == 0:
            return self.dizer('Agora é tarde. Você a destruiu, palerma.')
        self.dizer('Ok.')
        self.loc[Obj.LAMPADA] = COM_JOGADOR

    # ---------- QUEBRAR (0xc9c0) e COMER (0xcd18): a noz
    # verbo 19 @ 0xc9c0: QUEBRAR/DETONAR/ARREBENTAR/DESTRUIR
    def verbo_quebrar(self, o):
        v = VOC[o]
        if v in ('MADEIRA', 'PAREDE') and self.sala == Sala.BANHEIRO_FEMININO:
            return self.dizer('É muito forte para você. Tente usar algum instrumento para isso...')
        if not self.com_jogador(o):
            return self.dizer('Você não tem isso!')  # msg 120
        if v != 'NOZ':
            return self.dizer('Você não é homem o suficiente...')  # msg 121
        self.dizer(
            'Você quebra a noz, ansioso para comê-la, mas na '
            'verdade só encontra uma chave ali.')  # msg 122
        self.loc[Obj.NOZ] = NENHUM
        self.loc[Obj.CHAVE] = COM_JOGADOR

    # verbo 27 @ 0xcd18: COMER
    def verbo_comer(self, o):
        if not self.com_jogador(o):
            return self.dizer('Não posso comer o que não tenho.')
        if VOC[o] == 'NOZ':
            if not self.noz_avisada:
                self.noz_avisada = True
                return self.dizer('Melhor não. Ela pode lhe ser útil se você não a comer.')
            self.dizer('Já que você insiste... Você a engole. Ela fica engasgada na sua garganta. Você começa a tossir, e ver o mundo ficar verde, rosa, azul, amarelo, branco com bolinhas vermelhas, e, finalmente, negro...')
            return self.morrer()
        self.dizer('Isso não é muito digestivo. Talvez com um sal de frutas vá, mas como você não o tem...')

    # ---------- LIGAR/USAR: 0xb8cf (lanterna e ônibus)
    # verbo 14 @ 0xb8cf: LIGAR/USAR/ACENDER
    def verbo_ligar(self, o):
        v = VOC[o]
        if self.palavra == 'LIGAR' and o != Obj.LANTERNA:
            return self.dizer(dstr(0x77c))
        if v in ('PIA', 'MESA') and o in (Obj.PIA, Obj.MESA_SECRETARIA):
            return self.verbo_olhar(o)
        # elevadores: pergunta o andar e leva até lá
        if (o, self.sala) in ((Obj.ELEVADOR_FLIPERAMA, Sala.ELEVADOR_PREDIO),
                              (Obj.ELEVADOR_ANDARES, Sala.ELEVADOR_ANDARES),
                              (Obj.ELEVADOR_SUBSOLOS, Sala.ELEVADOR_SUBSOLOS)):
            self.dizer('Digite o número do sub-solo:' if self.sala == Sala.ELEVADOR_SUBSOLOS else dstr(0x778))  # msg 84
            resposta = self.entrada('andar> ').strip()
            if o == Obj.ELEVADOR_FLIPERAMA:
                return self.dizer('O elevador não se move.')  # msg 85
            andares, primeiro = (('123', Sala.ESCRITORIO_ANALISTAS) if o == Obj.ELEVADOR_ANDARES
                                 else ('12', Sala.GARAGEM))  # no original: 43 ou 53 + posição
            if len(resposta) != 1 or resposta not in andares:
                return self.dizer('O elevador não se move.')  # msg 86 e 87 (iguais)
            self.sala = primeiro + andares.index(resposta)
            self.elevador_moveu = True
            return self.descrever()
        if v == 'EMBALAGEM' and self.com_jogador(Obj.EMBALAGEM) and self.com_jogador(Obj.LAMPADA):
            self.dizer(
                'Você coloca o papel-alumínio da bala em volta da '
                'lâmpada.')  # msg 102
            self.loc[Obj.EMBALAGEM] = NENHUM
            self.papel_aluminio = True
            return
        if v == 'LANTERNA':
            if not self.com_jogador(Obj.LANTERNA):
                return self.dizer('Não a tenho.')  # msg 88
            if not self.com_jogador(Obj.PILHAS):
                return self.dizer('Sem pilhas. Nada feito.')  # msg 89
            if self.lanterna_ligada:
                return self.dizer('Ela já está ligada, toupeira!')
            if self.sala == Sala.DEPOSITO_ESCURO:
                return self.dizer('Está muito escuro. Não consigo achá-la. Que tal iluminar o local com outra coisa?')
            if self.sala != Sala.ALMOXARIFADO_FACULDADE:
                return self.dizer(
                    'Melhor você economizar pilhas. Elas '
                    'não durarão muito. Não vou acender.')  # msg 90
            self.lanterna_ligada = True
            return self.dizer('Você coloca as pilhas na lanterna e acende.')  # msg 91
        if v == 'MARRETA' and self.sala == Sala.BANHEIRO_FEMININO and self.com_jogador(Obj.MARRETA):
            self.dizer(
                'Você destrói a parede e pula no buraco. '
                'Misteriosamente, um mecanismo coloca outra placa '
                'de madeira aonde havia a que você destruiu. '
                'Estranho...')  # msg 95
            self.sala = Sala.POCO
            return self.descrever()
        if v == 'FOSFOROS':
            if self.sala == Sala.DEPOSITO_ESCURO:
                self.dizer(
                    'Muito bem! O local está mais iluminado. '
                    'Veja esta caixa à sua frente. Há uma '
                    'etiqueta nela. Deixe-me ver... ela contém... '
                    'oh, NÃO! FOGOS DE ARTIFÍCIO!!! MELOU!!!')  # msg 92
                return self.morrer()
            if self.sala == Sala.BANHEIRO_FEMININO:
                self.dizer(
                    'Você põe fogo na madeira. Seria uma boa '
                    'idéia, se o fogo não se espalhasse e '
                    'chegasse a você...')  # msg 93
                return self.morrer()
            return self.dizer(
                'Você acende um fósforo. Ele deve ser '
                'especial, pois ilumina muito bem o local. '
                'Depois de um certo tempo, ele apaga, não '
                'sem antes queimar o seu dedo')  # msg 94
        if v == 'PASSAGEM' and self.com_jogador(Obj.PASSAGEM) and self.sala == Sala.AGENCIA:
            return self.abrir_porta57()
        if v == 'ONIBUS':
            if self.sala != Sala.CALCADA:
                return self.dizer('Não aqui.')  # msg 96
            self.dizer('Digite o nº da linha do ônibus:')  # msg 97
            linha = self.entrada('linha> ').strip()
            if not linha.isdigit() or int(linha) == 0:
                return self.dizer('Não entendi. Nada feito.')  # msg 98
            self.dizer(
                'Você entra no ônibus. Este meio sem-vergonha de '
                'transporte continua cada vez mais sem-vergonha.')  # msg 99
            self.dizer(
                'Ao chegar na metade do mesmo, depara com um '
                'indivíduo que tenta lhe mostrar exatamente o que '
                'comeu no almoço. Você passa direto e paga o '
                'motorista.')  # msg 100
            self.grana -= PRECO_DO_ONIBUS
            self.dizer(
                'O ônibus para. Este é o ponto final. Todos '
                'descem, inclusive você.')  # msg 101
            self.sala = Sala.VIELA if linha == LINHA_CERTA else Sala.BAIRRO_PERIGOSO
            return self.descrever()
        self.dizer('Você não pode usar isso!')  # msg 103


def jogar(cmds, **opcoes):
    # linhas vazias e comentários (#) são ignorados; o jogo para no fim ou em SAIR. Na morte reinicia, como o
    # original (RUN): os comandos seguintes do arquivo valem para o jogo novo
    it = iter([c for c in cmds if c.strip() and not c.startswith('#')])

    def novo():
        return Jogo(entrada=lambda _: next(it), saida=print, **opcoes)

    j = novo()
    j.iniciar()
    for c in it:
        print('> ' + c)
        j.comando(c)
        if j.morreu:
            print('--- reiniciando o jogo ---\n')
            j = novo()
            j.iniciar()
        elif j.saiu or j.fim:
            break
    return j


def interativo(opcoes):
    # abertura (só no modo interativo; os textos vêm das telas de ajuda 2 e 3 do original)
    print('╔' + '═' * (LARGURA - 2) + '╗')
    for linha in ('A Busca de Epaminondas Jr. V1.5', '(c) 1992 por CHESTER (Carlos Duarte do Nascimento)',
                  'https://github.com/chesterbr/a-busca-de-epaminondas-jr'):
        print('║' + linha.center(LARGURA - 2) + '║')
    print('╚' + '═' * (LARGURA - 2) + '╝\n')
    for p in AJUDA:
        print(*(quebra_linhas(p) if opcoes.get('quebra', True) else [p]), sep='\n', end='\n\n')
    if sys.stdin.isatty():  # numa sessão interativa, espera para a abertura não rolar para fora da tela
        try:
            input('Tecle ENTER para começar...')
        except EOFError:
            pass
        print()
    try:  # histórico (seta para cima) e edição da linha; onde não existe (Windows), segue sem
        import readline  # noqa: F401
    except ImportError:
        pass
    j = Jogo(**opcoes)
    j.iniciar()
    while True:
        try:
            c = input('> ')
        except EOFError:  # Ctrl-D
            print()
            break
        j.comando(c)
        if j.morreu:
            print('--- reiniciando o jogo ---\n')
            j = Jogo(**opcoes)
            j.iniciar()
        elif j.saiu:
            break


if __name__ == '__main__':
    opcoes = {}
    if '--teleporta-ao-beijar-akira' in sys.argv:
        sys.argv.remove('--teleporta-ao-beijar-akira')
        opcoes['teleporta_ao_beijar_akira'] = True
    if '--sem-wrap' in sys.argv:
        sys.argv.remove('--sem-wrap')
        opcoes['quebra'] = False
    if len(sys.argv) > 1:  # python3 epa.py caminhos/00_caminho_feliz.txt: roda os comandos do arquivo (um por linha)
        jogar(Path(sys.argv[1]).read_text().splitlines(), **opcoes)
        sys.exit()
    try:
        interativo(opcoes)
    except KeyboardInterrupt:  # Ctrl-C: sai sem traceback
        print()
