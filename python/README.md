# Reimplementação em Python

`epa.py` reproduz o comportamento do `CA1.EXE` (as regras de cada verbo e de cada sala foram transcritas do código). Lê os dados dos dumps de `analise/dumps/` e de `analise/extracted/rooms_table.txt`; os textos estão no próprio fonte, com o número da mensagem do `AVENTURA.MSG` em comentário.

- `epa.py`: o jogo (`python3 epa.py [roteiro.txt]`). Quebra as linhas em 58 colunas e separa as mensagens com uma linha em branco, como a janela de mensagens do original; `--sem-wrap` desliga só a quebra. Mostra `[com você: …]` na abertura e sempre que o inventário muda (como o painel Objetos), e, no modo interativo, uma abertura (título, comandos básicos e "Tecle ENTER para começar...", que só espera quando a entrada é um terminal) (de `[roteiro.txt]` não imprime a abertura). `Sala`, `Obj` e `Verbo` são `IntEnum` cujo valor é o número do original e o nome é nosso.
- `modernizar.py`: regras que levam o texto de 1992 (CP437, aspas simples, espaço antes de `?` e `!`) ao texto atual.
- `testar.py`: roda os roteiros (com `--sem-wrap`) e compara com `esperado/`; dois deles (`00` e `19`) rodam também com a quebra, contra `esperado/*.quebra.out`; `testar_textos.py` confere o fonte contra o `AVENTURA.MSG`.
- `caminhos/`: 45 roteiros (finais, mortes, becos sem saída, matriz de verbos). O índice está em `caminhos/LEIA.md`.
- `esperado/`: a saída de cada roteiro, conferida contra o original.
- `erratas.md`: tudo o que mudou nos textos em relação ao original.
