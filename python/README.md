# Reimplementação em Python

`epa.py` reproduz o comportamento do `CA1.EXE` (as regras de cada verbo e de cada sala foram transcritas do código). Lê os dados dos dumps de `analise/dumps/` e de `analise/extracted/rooms_table.txt`; os textos estão no próprio fonte, com o número da mensagem do `AVENTURA.MSG` em comentário.

- `epa.py`: o jogo (`python3 epa.py [roteiro.txt]`). `Sala`, `Obj` e `Verbo` são `IntEnum` cujo valor é o número do original e o nome é nosso.
- `modernizar.py`: regras que levam o texto de 1992 (CP437, aspas simples, espaço antes de `?` e `!`) ao texto atual.
- `testar.py`: roda os roteiros e compara com `esperado/`; `testar_textos.py` confere o fonte contra o `AVENTURA.MSG`.
- `caminhos/`: 45 roteiros (finais, mortes, becos sem saída, matriz de verbos). O índice está em `caminhos/LEIA.md`.
- `esperado/`: a saída de cada roteiro, conferida contra o original.
- `erratas.md`: tudo o que mudou nos textos em relação ao original.
