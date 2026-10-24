# A Busca de Epaminondas Jr.

Um adventure de texto para MS-DOS, escrito por mim em 1992 usando Turbo Basic 1.0. Este repositório contém o jogo original que, à época, publiquei em BBSes como domínio público, mas o código-fonte se perdeu. Você é Epaminondas, e precisa achar o disquete do seu chefe para não perder o emprego.

Este repositório documenta a engenharia reversa do `CA1.EXE`, traz uma reimplementação fiel em Python e uma reconstrução do fonte em Turbo Basic (que recompila para o mesmo código do `CA1.EXE`). Também recria uma versão um pouco mais legível e comentada, que [pode ser lida diretamente aqui](basic/gerado/LEGIVEL.BAS).

> **In English:** this is a 1992 Brazilian Portuguese text adventure written in Turbo Basic 1.0, whose source code was lost. The repository has the original DOS files, the reverse-engineering notes and memory dumps, a faithful Python reimplementation checked against the original running in DOSBox-X, and a rebuilt Turbo Basic source that recompiles to byte-identical code. The game is in Portuguese only.

## Jogar

A reimplementação em Python não tem dependências (Python 3.9 ou mais novo):

```
python3 python/epa.py
```

Para rodar um roteiro de comandos (um por linha) em vez de digitar:

```
python3 python/epa.py python/caminhos/00_caminho_feliz.txt
```

O `00_caminho_feliz.txt` é a solução completa, comentada.

Para jogar o original, use o DOSBox (ou DOSBox-X). Na raiz do repositório, este comando monta `original/` como `C:` e roda `AVENTURA.BAT`, que mostra a abertura (`CHESTER.EXE`) e depois chama o jogo:

```
dosbox -c "mount c original" -c "c:" -c "aventura.bat"
```

Para ir direto ao jogo, sem a abertura, troque o último comando por `-c "ca1.exe"`. Os jogos gravados (`*.CA1`) vão para a pasta montada.

## Engenharia reversa

Foi conduzida com o Claude Code, com estas ferramentas:

- Um decodificador próprio em Python (com [capstone](https://www.capstone-engine.org/)) para desmontar o `CA1.EXE`, que tem chamadas ao runtime com operandos embutidos (`basic/gerar.py`).
- O DOSBox-X e seu depurador (`BPINT`, `MEMDUMPBIN`), para extrair a memória do jogo rodando e comparar o original com a reimplementação.
- O Turbo Basic 1.0 ([WinWorld](https://winworldpc.com/product/turbo-basic/1x)), para compilar programas de teste e descobrir o que o compilador gera (`basic/rosetta/`).

Os detalhes estão em `docs/engenharia-reversa.md`.

## O que tem aqui

| Pasta | Conteúdo |
|---|---|
| `original/` | Os arquivos de 1992 (`CA1.EXE`, `CHESTER.EXE`, `AVENTURA.MSG`, `AVENTURA.BAT`, `LEIAME.TXT`), com `SHA256SUMS`, o `epa15.zip` de onde saíram (https://chester.me/download/epa15.zip; guarda as datas originais dos arquivos) e cópias em UTF-8 dos textos |
| `analise/` | Engenharia reversa: dumps de memória, listagem do código, tabelas e pseudocódigo de salas e verbos |
| `python/` | A reimplementação em Python, os 45 roteiros de teste e as saídas esperadas |
| `docs/` | Como o jogo funciona por dentro, e os testes feitos no original |
| `ferramentas/dosbox/` | Scripts (macOS) que pilotam o original no DOSBox-X para comparar com a reimplementação |
| `basic/` | O fonte Turbo Basic reconstruído (`gerado/CA1.BAS`, que recompila para o mesmo código do `CA1.EXE`, e `gerado/LEGIVEL.BAS`, para ler), o gerador a partir do executável e a "Pedra de Roseta" do compilador (`rosetta/`) |

Comece por `docs/engenharia-reversa.md`.

## Testes

Um comando roda tudo (os 45 roteiros contra as saídas esperadas, mais a conferência dos textos):

```
python3 python/testar.py
```

As saídas esperadas foram conferidas contra o original rodando no DOSBox-X (ver `python/caminhos/LEIA.md`). Se uma mudança de comportamento for de propósito, `python3 python/testar.py --atualizar` regrava as saídas e o diff do git mostra o que mudou.

## Fidelidade e diferenças

A reimplementação segue o original, bugs inclusive. As diferenças são poucas e propositais, e estão listadas em `docs/engenharia-reversa.md` e `python/erratas.md`: os textos foram modernizados (acentos, aspas, pontuação; o original usava CP437, sem `ã` e `õ`), e dois erros óbvios foram corrigidos (a frase "MESMO ???", engolida por um bug, e `LER PLACA` no elevador). O `MENU` do jogo não foi reimplementado.

## Licença

Código, ferramentas e documentos deste repositório: [MIT](LICENSE). O jogo original é de domínio público, por declaração minha em `original/AVENTURA.BAT` ("Este é um programa de domínio público. A cópia é livre e autorizada.").
