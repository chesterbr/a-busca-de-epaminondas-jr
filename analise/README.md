# Material da engenharia reversa

Tudo aqui foi extraído do `CA1.EXE` de `original/` (confira o hash em `original/SHA256SUMS`).

## `dumps/`: memória do jogo rodando

Capturados no depurador do DOSBox-X com `MEMDUMPBIN <segmento>:0 FFFF arquivo` (65.535 bytes cada). Lista de hashes em `SHA256SUMS`.

| Arquivo | O que é |
|---|---|
| `G1.BIN`, `G2.BIN`, `G3.BIN` | Segmento de dados (variáveis, descritores de string, tabelas) em três momentos do jogo (escritório, recepção, rua). `G1.BIN` é o que o `epa.py` usa |
| `E1.BIN` | Segmento dos arrays (vocabulário, verbos, objetos, saídas). O `epa.py` usa; o heap de strings aqui está truncado |
| `E2.BIN` | Heap de strings completo. O `epa.py` usa |
| `DS.BIN`, `DS2.BIN`, `DS3.BIN`, `ES2.BIN`, `ES3.BIN` | Primeiras capturas (segmentos de dados e extra), da fase em que a análise ainda localizava os segmentos. `DS.BIN` é de antes da inicialização; `DS2` e `DS3` são do jogo na introdução. Substituídos pelos `G*` e `E*` |
| `CS.BIN` | Segmento de código, capturado junto com `DS.BIN` |
| `DSA.BIN`, `DSB.BIN`, `DSC.BIN` | Imagem do programa (segmento 0823), não variáveis do jogo; a diferença entre eles é só o runtime reescrevendo as instruções do 8087. Mantidos por completude |

## `extracted/`: o que saiu da análise

| Arquivo | Conteúdo |
|---|---|
| `ca1_code_listing.txt` | Disassembly linear do código de usuário (offsets 0x8A60 a 0x12000 da imagem). Um `nop` antes de operação de ponto flutuante é o escape `INT 34h-3Bh` do emulador de 8087 |
| `ca1_int_map.txt` | Mapa das interrupções do runtime do Turbo Basic |
| `ca1_strings.txt`, `ca1_data_region.bin` | Região de strings do executável (0x12000 a 0x16000) |
| `aventura_msg_numbered.txt` | `AVENTURA.MSG` numerado (a numeração das mensagens usada em todo o repositório) |
| `rooms_table.txt` | As 67 salas: saídas, sub-rotina, linhas de mensagem |
| `objects_table.txt`, `verbs_table.txt`, `verb_handlers.txt` | Objetos, verbos (com sinônimos) e endereço do handler de cada verbo |
| `salas_pseudocodigo.txt`, `verbos_pseudocodigo.txt`, `handlers_annotated.txt` | O código das salas e dos verbos em pseudocódigo/anotado |
| `map_first_section.txt` | O primeiro trecho do mapa, como eu lembrava |

Os scripts que geraram estes arquivos não foram guardados. Os dados e as conclusões estão aqui, e `python/epa.py` e `python/testar.py` provam que o entendimento está certo.
