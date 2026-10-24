# Gerador do .BAS: método e achados

`gerar.py` lê `original/CA1.EXE` (com os dumps de `analise/dumps/` para constantes e textos) e escreve um fonte Turbo Basic em `gerado/CA1.BAS` (CP850, como o original). Precisa do pacote `capstone` (`pip install -r requirements.txt`).

```
python3 basic/gerar.py -o basic/gerado/CA1.BAS     # reproduz o executável: MSG$(n) lido de AVENTURA.MSG (resumo no stderr)
python3 basic/gerar.py --legivel -o basic/gerado/LEGIVEL.BAS   # para ler: UTF-8, 80 colunas, nomes que dizem o que a rotina faz, texto das mensagens no fonte
python3 basic/gerar.py --relatorio                  # quantas linhas de cada verbo/sala foram traduzidas
```

## Como traduz

- Desmonta com capstone (16 bits), tratando os escapes do 8087 (`INT 34h-3Bh` = FWAIT + ESC; `INT 3Ch` = FWAIT + prefixo ES) e os operandos embutidos depois de `INT ECh` (seletor 0x22: 1 byte; 0x6E: 4 bytes; 0x70/0x72: tabela de `ON ... GOSUB/GOTO`, onde 0x72 não volta, é GOTO). A listagem de `analise/extracted/` não serve de entrada porque desalinha nesses pontos.
- Executa cada rotina simbolicamente (pilha do 8087, AX/BX/SI, pilha de strings, flags) e reconhece os idiomas do compilador: comparação `fild/fcomp`, booleano em AX (`mov ax,-1 / jcc / inc ax`) com AND/OR (inclusive o curto-circuito do AND), arrays de float e de string, atribuição de strings, `ON`.
- Desvios condicionais para a frente viram `IF cond THEN a : b [ELSE c]` numa linha só (o compilador emite o mesmo código para as duas formas, então escolhemos a que eu provavelmente escrevi); o que não cabe nessa forma fica como `IF ... THEN GOTO`. DATA: números sem aspas, textos com aspas.
- O resultado é BASIC com números de linha nossos (o executável não guarda os meus): de 10 em 10, cada sub-rotina (alvo de GOSUB) começando num múltiplo de 100 e com um comentário `' =====` na primeira linha; blocos redondos por região: programa e analisador a partir de 100, verbos a partir de 10000, rotinas auxiliares de 25000, salas de 30000, arquivos (gravar/carregar) de 50000. `--rotulos` troca os números por rótulos `Lxxxxx` (endereço da imagem), útil para cruzar com a listagem.  Não reconstrói blocos `IF/ELSE`: o compilador não guardou essa estrutura e o `GOTO` é equivalente.
- Mensagens: `MSG$(n)` é a linha `n-1` do `AVENTURA.MSG` (comentário ao lado). Literais de string vêm do heap (`E2.BIN`) em CP850 cru (`ä`, `ö`), como no original.
- Números mágicos ficam literais; nomes de variável são rótulos nossos.

## Estado (2026-10-21; superado por "Código byte a byte", abaixo)

O programa inteiro é traduzido, e **compila no Turbo Basic 1.0 sem erro**. O `.EXE` recompilado tem código de 35.565 bytes, igual ao original, e a sequência de instruções é 100% igual (0 trechos diferentes) (`comparar.py`, que mascara os endereços, mais `comparar_saltos.py`, que confere o destino de cada salto; eram 96,6% na primeira compilação). Nenhuma instrução do programa fica sem tradução. O que ainda difere são formas de escrever o mesmo que o compilador traduz de outro jeito (ver abaixo), não lógica do jogo.

O editor do Turbo Basic não abre arquivos de mais de ~64 KB ("too large. Truncate?"); o `CA1.BAS` completo (97 KB) passa disso. Isso explica por que guardei as mensagens no `AVENTURA.MSG`. Para compilar, `gerar.py --dividir 45000` gera `CA1.BAS` + `CA1A.INC`, `CA1B.INC` com `$INCLUDE` (o compilador junta o texto, o código gerado é o mesmo); está em `gerado/dividido/`.

## Ciclo de refinamento

`rosetta/` (programas pequenos para descobrir o que o compilador faz) + `rodada.sh` (gera, compila no DOSBox-X, compara) + `comparar.py ORIGINAL.EXE RECOMPILADO.EXE -v` (mostra, para cada trecho diferente, o endereço no original e a linha de BAS que o gerou). Cada diferença vira uma regra do gerador. O que já se aprendeu assim:

- `IF c THEN` de uma linha com relação simples compara direto; o `IF ... THEN` em bloco (`END IF`) e o `WHILE` passam a condição por um booleano em AX (código diferente), e condições compostas passam sempre. O gerador marca as relações simples que vieram do booleano e as transforma em bloco ou `WHILE`.
- `v + 1` e `v + LEN(x)` (constante ou resultado inteiro) carregam o outro operando antes e usam `fadd v`; `i + k` (duas variáveis) é `fld i / fadd k`. O gerador escreve o operando de memória à esquerda nos dois primeiros casos.
- `L rel R` compila como `eval(R) / fcomp L` quando R é simples (variável, constante, elemento de array) ou resultado de função, e como `eval(L) / fcomp R` quando L é uma expressão: o gerador escreve a comparação na ordem que reproduz isso.
- Laços e blocos com GOTO dentro: a leitura do comando é `IF ... THEN` em bloco com um `GOTO` de volta ao começo (e não `WHILE`); a espera de tecla é `WHILE ... WEND`.
- `a AND b OR c AND d` leva parênteses em volta dos grupos `AND` (sem eles o compilador faz curto-circuito dentro do grupo).
- `a AND b AND c` (sem parênteses) faz curto-circuito entre os termos, `(a AND b) AND c` não: o gerador não coloca parênteses em cadeias do mesmo operador.
- `n + 1` e `n * 2` carregam a constante antes (`fld1 / fadd n`); `1 + n` carrega `n` antes. O inteiro `const + LEN(x)` faz `add ax,[const]`, e `LEN(x) + const` carrega a constante antes. O gerador escreve cada forma do jeito que reproduz o código.
- `END`/`STOP`/`SYSTEM` são `INT EC 30`; `CLEAR` é `INT EC 14`; `RESTORE` é `mov [78h],0`; `PLAY` é `INT EC 96`; `RUN` é só um `jmp` para o começo do programa. O programa começa com `CLEAR` e `RESTORE`, e as mortes fazem `CLEAR` e `GOTO` para a primeira linha.
- Parênteses mudam o código: `I + K - 1` compila como `fld I / fadd K / fisub 1`, `(I + K) - 1` como `fld1 / fld I / fadd K / fsubrp`. O gerador monta as expressões como árvores e só põe parênteses onde a precedência exige.
- `a AND b OR c AND d` é uma cadeia de curto-circuitos (`je/jmp` entre os termos, tanto depois de `inc ax` quanto depois de `and ax,bx`).
- Uma instrução longa demais vai para a linha de baixo com ` : _`; texto grande não é partido (`"a" + "b"` gera uma concatenação a mais).
- `WHILE 1 = 1` (e não `WHILE 1`) é o laço da rotina LISTAR; `ASC("0")` não vira constante; `DIM` com limite constante não gera código.

## Meu modelo

O adventure da revista INPUT (`p0386.bas`, C64) tem a mesma estrutura do jogo: `ON L GOSUB` em blocos de 10 salas (`IF L<11 THEN ON L GOSUB ...`, `IF L<21 THEN ON L-10 GOSUB ...`) e `ON I GOTO` para os verbos (as sub-rotinas dos verbos terminam em `RETURN` do chamador, que é o `0x72` = `ON GOTO`). Isso confirma números de linha e serve de guia para o texto do gerador e para a ordem das rotinas.

## Limites do editor

O editor do Turbo Basic 1.0 aceita linhas de até 248 colunas e, acima disso, insere um CR ("Line too long - CR inserted"), o que quebra um literal no meio. O gerador mantém as linhas com no máximo 240 colunas: `DATA` de objetos longos vai para mais de uma linha `DATA`, o `ON ... GOSUB` dos verbos usa continuação com `_`. Resta uma exceção: o texto longo do fim do jogo (271 caracteres, `MENSAGEM$ = "Eu até diria..."`). A concatenação `"a" + "b"` não é dobrada pelo compilador (gera duas cargas e um `INT 95`), então o literal único só pode ter vindo de uma continuação `_` dentro da string; falta testar se o compilador aceita isso.

## Nomes e anotações (palpites nossos, a confirmar)

Nomes de variáveis, arrays e comentários de bloco são do gerador (`VAR`, `ARR`, `STR`, `COMENTARIOS` em `gerar.py`); o executável não guarda nenhum. As saídas da sala são `N S L O C B` (o laço do título usa a mesma variável que a saída `C`, o que sugere nomes de uma letra). `DATA` vai logo depois do laço que lê: o binário só guarda a ordem dos itens, não onde estavam as linhas. Instruções na mesma linha só nos corpos de `IF`, no par `AVISO$/MENSAGEM$ = ... : GOSUB` e nos blocos de saídas.

## Confirmações por compilação (rosetta/t10.txt)

- `ASC("0")` não é dobrado em constante (carrega o literal e chama `INT A0`), então os `ASC(...) >= 48` do `CA1.EXE` eram números no fonte.
- `WHILE 1 = 1` gera exatamente o código do laço da rotina LISTAR (`mov ax,1 / cmp ax,[constante]`); `WHILE 1` gera outro (`mov ax,1 / or ax,ax`). `WEND` é um `jmp` para o começo.
- `DIM` com limite constante não gera código (o array fica no segmento de dados): o gerador declara `DESCLISTA$`, `BACKUP$` e `JANELA$` antes do primeiro uso.

## Números de linha ou rótulos

Compilei duas vezes o mesmo programa, uma com números de linha e outra com rótulos `Lxxxxx:` (`gerar.py --rotulos`): os dois `.EXE` saem **idênticos byte a byte** (90.537 bytes). Então o binário não diz qual dos dois eu usei. O Turbo Basic aceita nome de rótulo/variável só com letras, dígitos e ponto (o `_` é continuação de linha): `NOME.SALA$` vale, `NOME_SALA$` não.

## Linhas longas e `$INCLUDE`

O limite de 248 colunas é do editor; um arquivo incluído com `$INCLUDE` não passa por ele, e o compilador aceita ali um texto de 271 caracteres numa linha só. O gerador não parte mais textos (parti-los gerava uma concatenação a mais) e deixa as linhas longas nos `.INC`.

## LEGIVEL.BAS

É só para ler (o `CA1.BAS` é o fonte fiel, congelado). `gerar.py --legivel` passa a saída `--nomeados --mensagens-inline` por `legivel.py`:

- UTF-8, 80 colunas (as linhas de `DATA` e o texto de `DATA` estouram, de propósito: um registro por linha). Instruções longas continuam com `_`; textos longos viram `"..." + _`; `IF` de uma linha que passa de 80 vira bloco `IF/ELSE/END IF`.
- Letras: o jogo grava `ä ö Ä Ö Å` e mostra `ã õ Ã Õ Á` (ver `python/modernizar.py`). Ler tudo como CP860 estragaria o `Å` (daria `Â` em `VÁ PROCURÁ-LO`); as outras letras acentuadas têm o mesmo código no CP437 e no CP860, e os caracteres de moldura também. O executável não muda de página de código (não há `INT 21h` função 66h).
- Rótulos que dizem o que a rotina faz (`DescreveSala`, `MostraObjetosDaSala`, `AtualizaPainelDirecoes`, `GravaJogo`...), com o número no nome de verbos e salas (`Verbo27Comer`, `Sala3Calcada`); o comentário traz só os sinônimos do verbo ou um resumo da sala. Sem endereços e sem os comentários que repetiam o nome. Variáveis que ainda eram genéricas ganharam nome (`FLAG4D6` virou `COMANDOINVALIDO`, `N S L O C B` viraram `SAIDANORTE`...).
- Os números de salas, verbos e objetos continuam literais no código, como no original.

Não é idêntico ao `CA1.BAS` em código compilado, por duas razões do próprio Turbo Basic: um `IF` em bloco gera um booleano em AX onde o de uma linha desvia direto, e `"a" + _ "b"` gera uma concatenação em tempo de execução que um texto inteiro não gera. `--fiel` mantém os `IF` de uma linha e os textos inteiros (as linhas estouram) e compila para exatamente o mesmo código do `CA1.BAS`, o que prova que o resto (nomes, comentários, quebras com `_`) não muda nada. A versão com `MSG$(n)` e nomes (`--nomeados`) também compila para um `.EXE` idêntico ao da numerada.

Cada instrução que cita objeto ou sala por número leva no fim um comentário `chave=valor` na ordem do código (`' 71=CD, 62=Mesa`; `LOCOBJ(n) = m` anota o objeto n e a sala m). Quando o número citado é o único da instrução, o comentário traz só o nome (`IF OBJ = 39 THEN ' Velhinho`). Entram também as saídas das salas (`SAIDASUL = 5 ' Biblioteca`); comparações de faixa (`SALA <= 10`) e o zero ficam sem anotação. Os nomes de objeto vêm do `DATA`, os de sala dos rótulos; números sem nome (0, 36000) ficam sem anotação e comentários não alteram o código gerado.

O LEGIVEL com o texto no fonte **não roda**: compilado, o jogo mostra as mensagens misturadas (a mesma coisa com a versão anterior do `LEGIVEL.BAS`). Suspeita: os textos juntos passam do que o pool de literais do Turbo Basic comporta (64 KB); é por isso que o original lê `AVENTURA.MSG`. Para testar o comportamento do legível, `--legivel --mensagens-arquivo --dos` gera a mesma coisa com `MSG$(n)`, nos bytes do jogo e com CRLF, e esse `.EXE` foi rodado pelos 45 roteiros de `python/caminhos` (2026-10-22): o resultado é o mesmo do recompilado e do original (as poucas diferenças restantes são do OCR do comparador e aparecem igual nos três, por exemplo `Levante a cabesa` em `42_olhar_chao_teto`, que é o texto do próprio jogo).

## A linha das setas do menu

Era a última diferença de instruções. O compilador avalia o termo simples de um `OR` antes do que tem concatenação, então `A$ = CHR$(0) + "P" OR A$ = " " OR A$ = CHR$(9)` gera primeiro o `" "`. O gerador escrevia na ordem de execução; agora troca. Achado com uma busca automática de variantes (ordem das parcelas, agrupamento, parênteses, `1 *`): parênteses em volta de igualdades e o `1 *` não mudam nada, e só duas formas dão 100%.

## Artefato de tela (2026-10-21)

Rodando o `CA1.EXE` recompilado, o menu e o ENTER vazio apagavam um pedaço da tela. Causa: um `PRINT x;` pendente era descarregado depois do rótulo do `GOTO` que volta para o laço, então o rótulo ficava uma linha antes do certo e o `PRINT SPACE$(64);` rodava de novo com o cursor fora do lugar. A comparação de instruções não via isso porque mascara endereços de salto; o `comparar_saltos.py` pega. Sobram diferenças só na ordem dos arrays estáticos e nos testes de faixa de caracteres (`"0"` a `"9"` e `"A"` a `"Z"` em outra ordem), sem efeito no comportamento.

## Código byte a byte

O código de usuário do `.EXE` recompilado (35.565 bytes) é **idêntico ao original, byte a byte**, desde que o EXE seja gerado do mesmo jeito que eu gerei. Por padrão a compilação dava 108 bytes diferentes: 54 lugares logo depois de um `fistp` (conversão de número para inteiro), onde o original tem `nop nop` e o recompilado tem `cd 3d` (o `FWAIT` do emulador de 8087). Não vem do fonte nem das opções (testei as cinco do menu Options e a FPU do DOSBox-X ligada ou desligada).

Causa: sem FPU, o runtime troca cada `cd 3d` por `nop nop` **na primeira vez que o trecho é executado**, e o "Compile to EXE" do editor copia essa imagem da memória. Eu rodei o jogo no editor antes de compilar, então os trechos que executei saíram corrigidos. Os `cd 3d` que sobraram no original mostram o que não executei antes de compilar: nenhum comando digitado (a análise de comandos, os verbos e as salas ficaram intactos). Reproduzi com a FPU do DOSBox-X desligada (`fpu=false`), rodando `CA1.BAS` no editor (F10, Run), passando a introdução, abrindo no menu (ESC) **Ajuda** (A) e **Notas** (N) até o fim, saindo por **Fim** (F) e `S`, e então compilando (`rosetta/compila_como_eu.sh`, com `rosetta/tb_sem_fpu.conf`, faz tudo isso): os 54 lugares batem, nenhum a mais nem a menos. Sem Ajuda e Notas, 5 deles (os laços `FOR I = 1 TO 11` e `LINBAK` dessas duas telas) ficam sem corrigir.

O que ainda difere no arquivo (12.282 de 90.553 bytes) está fora do código: o cabeçalho e a área de dados do runtime (estado da memória do editor, como modo de vídeo e larguras de tela) e 22 bytes de lixo no fim do pool (por exemplo `lquer ` de "qualquer" e restos de código velho). Não vêm do fonte.

O que as comparações de valores revelaram e já foi corrigido (eram 28 valores diferentes): o `DIM` dos arrays estáticos sai na ordem inversa; `(a AND b) OR (c AND d)` sem curto-circuito é avaliado com o segundo grupo primeiro; `a$ = x OR a$ = y` (sem curto-circuito) com o termo da direita primeiro; e uma soma de duas variáveis em que uma é a variável de um `FOR` (`I + TOPO`) compila com a ordem dos operandos invertida, então o original tem `TOPO + I - 1` (o gerador usa `traduz_com_for`, que descobre as variáveis de `FOR` numa primeira passada). `comparar_valores.py` e `comparar_saltos.py` conferem isso.

## Comportamento do `.EXE` recompilado (2026-10-22)

Os 45 caminhos de `python/caminhos/` rodaram no `teste/CA1.EXE` (recompilado) com `ferramentas/dosbox/rodar_todos.sh`, usando os saves do original para pular os prefixos (o que também testa que o recompilado carrega os saves). O comparador conferiu cada resposta do jogo com a reimplementação em Python: nenhum caminho teve texto do jogo diferente. O que o comparador aponta é igual no original e no recompilado: o marcador `--- reiniciando o jogo ---` que a reimplementação imprime no fim de jogo, o `LISTAR` (o jogo mostra a lista num painel, a reimplementação imprime `Objetos: ...`), as mensagens do `DIZER` (aspas no OCR) e linhas de texto antigo que ficam na tela. Controles no original (39, 20, 36, 18, 19 inteiros e os primeiros comandos de 30, 37 e 40) dão exatamente os mesmos pontos do recompilado. Os caminhos 18 e 19 divergem nos dois porque o save `REC` não corresponde a eles (a investigar se for preciso).
