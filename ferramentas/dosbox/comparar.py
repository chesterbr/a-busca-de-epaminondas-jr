"""Compara a saída da reimplementação (epa.py) com o que o original mostrou no DOSBox-X.

uso: python3 comparar.py SAIDA_RUN CAMINHO LOGDIR [PULAR]
  SAIDA_RUN  saída do run.sh (linhas "comando -> ESTADO primeira ultima")
  CAMINHO    arquivo de comandos (o mesmo passado ao run.sh e à reimplementação)
  LOGDIR     pasta com as capturas NNNN.txt (OCR de cada captura)
  PULAR      comandos do começo do CAMINHO que o original não rodou (ele partiu de um save); padrão 0

Para cada comando, cada parágrafo da saída da reimplementação precisa aparecer (início e fim, com tolerância a
erros de OCR) no texto reconhecido nas capturas daquele comando. Imprime só os parágrafos não encontrados.
"""
import re
import subprocess
import sys
import unicodedata
from difflib import SequenceMatcher
from pathlib import Path

saida_run, caminho, logdir = sys.argv[1], sys.argv[2], Path(sys.argv[3])
PULAR = int(sys.argv[4]) if len(sys.argv) > 4 else 0
RAIZ = Path(__file__).resolve().parents[2]


def norm(t):
    t = unicodedata.normalize('NFD', t.lower())
    t = ''.join(c for c in t if not unicodedata.combining(c))
    return re.sub(r'[^a-z0-9]', '', t)


# saída da reimplementação por comando (bloco 0 = descrição inicial)
proto = subprocess.run([sys.executable, str(RAIZ / 'python' / 'epa.py'), str(Path(caminho).resolve())],
                       capture_output=True, text=True, cwd=RAIZ / 'python')
blocos = re.split(r'\n> ', '\n' + proto.stdout)
blocos = [b for b in blocos if b != '']
blocos = blocos[PULAR:]  # o bloco 0 passa a ser o último comando já feito pelo save
def texto_ocr(a, b):
    partes = []
    for n in range(a, b + 1):
        f = logdir / f'{n:04d}.txt'
        if f.exists():
            for l in f.read_text().splitlines():
                if re.fullmatch(r'[A-Z0-9 ]{2,14}', l.strip()):  # itens da caixa Objetos
                    continue
                partes.append(l)
    return norm(' '.join(partes))


# passos do original: [(comando, primeira, ultima)]; a linha que responde a uma pergunta do jogo (linha do
# ônibus, andar do elevador: a reimplementação mostra "Digite o ...") é juntada ao comando que perguntou
passos = []
esperando = False
for linha in Path(saida_run).read_text().splitlines():
    m = re.match(r'^(.*) -> \w+ (\d+) (\d+)$', linha)
    if not m:
        continue
    cmd, a, b = m.group(1), int(m.group(2)), int(m.group(3))
    if esperando:
        passos[-1] = (passos[-1][0], passos[-1][1], b)
        esperando = False
        continue
    passos.append((cmd, a, b))
    k = len(passos)  # blocos[0] é o último comando que o save já tinha feito
    esperando = k < len(blocos) and 'Digite o ' in blocos[k]

print(f'{len(passos)} passos no original, {len(blocos) - 1} comandos na reimplementação (depois de pular {PULAR})')


def acha(frag, U):
    if frag in U:
        return True
    n = len(frag)
    melhor = 0
    for i in range(0, max(1, len(U) - n + 1)):
        r = SequenceMatcher(None, frag, U[i:i + n]).quick_ratio()
        if r > 0.8 and SequenceMatcher(None, frag, U[i:i + n]).ratio() >= 0.8:
            return True
    return False


faltas = 0
for i, (cmd, a, b) in enumerate(passos):
    if i + 1 >= len(blocos):
        break
    bloco = blocos[i + 1]
    cmd_proto, _, corpo = bloco.partition('\n')
    if cmd_proto.strip() != cmd.strip():
        print(f'!! passo {i + 1}: original "{cmd}" x reimplementação "{cmd_proto}" (desalinhado)')
        break
    U = texto_ocr(a, b)
    for par in re.split(r'\n\s*\n', corpo):
        par = '\n'.join(l for l in par.splitlines() if not l.startswith('[saídas'))
        p = norm(par)
        if len(p) < 10:
            continue
        if not (acha(p[:22], U) and acha(p[-22:], U)):
            faltas += 1
            print(f'--- passo {i + 1} "{cmd}" (capturas {a}-{b}): não achei no original:\n    {par.strip()[:200]}')
print(f'{faltas} parágrafos sem correspondência (reimplementação -> original)')

# verificação inversa: linhas que o original mostrou e que não estão na reimplementação (neste passo ou nos 3 anteriores)
extras = 0
vistas = set()
for i, (cmd, a, b) in enumerate(passos):
    if i + 1 >= len(blocos):
        break
    if PULAR and i < 3:  # a janela de mensagens ainda mostra texto de antes do save
        continue
    ctx = norm(' '.join(blocos[max(0, i - 2):i + 2]))
    reiniciou = False
    for n in range(a, b + 1):
        f = logdir / f'{n:04d}.txt'
        if not f.exists() or reiniciou:
            continue
        for l in f.read_text().splitlines():
            if re.fullmatch(r'[A-Z0-9 .]{2,14}', l.strip()):
                continue
            ln = norm(l)
            if 'reiniciar' in l:  # morte: o que vem depois é o jogo recomeçando
                reiniciou = True
            if len(ln) < 18 or ln in vistas or ln.startswith(('dosboxx', 'abuscadeepaminondas', 'digiteumcomando', 'digitequalquertecla')):
                continue
            vistas.add(ln)
            if not acha(ln, ctx):
                extras += 1
                print(f'+++ passo {i + 1} "{cmd}" (captura {n}): no original e não na reimplementação: {l.strip()[:120]}')
print(f'{extras} linhas extras no original')
