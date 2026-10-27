# A Busca de Epaminondas Jr.

Em 1992 publiquei este adventure de texto para MS-DOS, feito em Turbo Basic 1.0: você é Epaminondas e precisa achar o disquete do chefe para não perder o emprego. Na época distribuí só o executável, e o código-fonte se perdeu.

Com ferramentas como o [REA](https://github.com/morluto/rea), resolvi fazer o disassembly e reconstruir o fonte, assistido por IA. O resultado:

- **[LEGIVEL.BAS](basic/gerado/LEGIVEL.BAS)** **(comece por aqui)**: o fonte do jogo, comentado e formatado.
- **[CA1.BAS](basic/gerado/CA1.BAS)**: o fonte mais próximo do original, que recompila para o executável idêntico byte a byte.
- **[epa.py](python/epa.py)**: uma implementação de referência em Python, de linha de comando.

O repositório também tem o [jogo original](original/), o [disassembly](analise/) e a [documentação do processo](docs/engenharia-reversa.md). E dá para jogar no navegador:

- [o original](https://chester.me/a-busca-de-epaminondas-jr/original.html) (via [js-dos](https://js-dos.com/), um DOSBox em WebAssembly)
- [a versão Python](https://chester.me/a-busca-de-epaminondas-jr/python.html) (via [Pyodide](https://pyodide.org/) e [xterm.js](https://xtermjs.org/))

<img src="docs/tela.png" width="440" alt="O original rodando no DOSBox-X: o escritório de Epaminondas, com os painéis de mensagens, objetos, direções, comando e avisos"> | <img src="docs/tela-python.png" width="440" alt="A versão Python no terminal: o mesmo texto de abertura da sala, com as saídas e os objetos que você carrega, e o prompt de comando">
:-:|:-:
Original | Versão Python (terminal)

> **In English:** a 1992 Brazilian Portuguese text adventure written in Turbo Basic 1.0, whose source was lost (I only distributed the executable). With AI help I disassembled it and rebuilt the source: a readable, commented version, one that recompiles to a byte-identical executable, and a Python reimplementation checked against the original in DOSBox-X, plus the original files, notes and memory dumps. Play [the original](https://chester.me/a-busca-de-epaminondas-jr/original.html) or [the Python version](https://chester.me/a-busca-de-epaminondas-jr/python.html) in the browser. Portuguese only.

## Jogar localmente

A versão Python não tem dependências, só o Python 3.9 ou mais novo:

```
python3 python/epa.py
```

Ela aceita um arquivo com os comandos, como a [solução completa](python/caminhos/00_caminho_feliz.txt) (SPOILERS):

```
python3 python/epa.py python/caminhos/00_caminho_feliz.txt
```

Para o original, use o DOSBox (ou DOSBox-X):

```
dosbox -c "mount c original" -c "c:" -c "aventura.bat"
```

Troque `aventura.bat` por `ca1.exe` para pular a abertura. Os jogos gravados (`*.CA1`) ficam salvos.

## Engenharia reversa

Feita com o Claude Code e estas ferramentas:

- Um decodificador em Python (com [capstone](https://www.capstone-engine.org/)) para desmontar o `CA1.EXE`, que tem chamadas ao runtime com operandos embutidos (`basic/gerar.py`).
- O DOSBox-X e seu depurador (`BPINT`, `MEMDUMPBIN`), para extrair a memória do jogo rodando e comparar com a reimplementação.
- O Turbo Basic 1.0 ([WinWorld](https://winworldpc.com/product/turbo-basic/1x)), para compilar programas de teste e ver o que o compilador gera (`basic/rosetta/`).

Comece por `docs/engenharia-reversa.md`.

## O que tem aqui

| Pasta | Conteúdo |
|---|---|
| [`original/`](original/) | Os arquivos de 1992, com `SHA256SUMS`, o [epa15.zip](https://chester.me/download/epa15.zip) de onde saíram e cópias em UTF-8 dos textos |
| [`analise/`](analise/) | Dumps de memória, listagem do código, tabelas e pseudocódigo de salas e verbos |
| [`basic/`](basic/) | Os fontes Turbo Basic, o gerador a partir do executável e a "Pedra de Roseta" do compilador (`rosetta/`) |
| [`python/`](python/) | A reimplementação, os 45 roteiros de teste e as saídas esperadas |
| [`web/`](web/) | As páginas para jogar no navegador e o `montar.py`, que monta o site do GitHub Pages |
| [`docs/`](docs/engenharia-reversa.md) | Como o jogo funciona por dentro e os testes feitos no original |
| [`ferramentas/dosbox/`](ferramentas/dosbox/) | Scripts (macOS) que pilotam o original no DOSBox-X para comparar com a reimplementação |

## Testes

Um comando roda tudo (os 45 roteiros contra as saídas esperadas, mais a conferência dos textos):

```
python3 python/testar.py
```

As saídas esperadas foram conferidas contra o original rodando no DOSBox-X (ver `python/caminhos/LEIA.md`). Se uma mudança de comportamento for de propósito, `python3 python/testar.py --atualizar` regrava as saídas e o diff do git mostra o que mudou.

## Fidelidade e diferenças

O `CA1.BAS` e o `LEGIVEL.BAS` reproduzem o executável como ele é, bugs inclusive. O `epa.py` também segue o original, com poucas diferenças propositais, listadas em `docs/engenharia-reversa.md` e `python/erratas.md`: os textos foram modernizados (acentos, aspas, pontuação; o original usava CP437, sem `ã` e `õ`), e dois erros óbvios foram corrigidos (a frase "MESMO ???", engolida por um bug, e `LER PLACA` no elevador). O `MENU` do jogo não foi reimplementado.

## Licença

Código, ferramentas e documentos deste repositório: [MIT](LICENSE). O jogo original é de domínio público, por declaração minha em `original/AVENTURA.BAT` ("Este é um programa de domínio público. A cópia é livre e autorizada.").
