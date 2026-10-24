# Como o CA1.EXE funciona (notas da engenharia reversa)

O fonte de "A Busca de Epaminondas Jr." se perdeu; só sobrou o `CA1.EXE` (Turbo Basic 1.0, compilado, 1992). Estas notas resumem o que foi descoberto. Os dados brutos estão em `analise/`, e `python/epa.py` é a prova executável de que o entendimento está certo.

## O executável

- Turbo Basic compilado: não sobraram nomes de variáveis, números de linha nem comentários. Os nomes do `epa.py` (`SALA`, `OBJ`, `SALANOME$`, `MSGBUF2$`...) são rótulos nossos para offsets do segmento de dados (por exemplo `SALA` = DS:0x4F6, `OBJ` = DS:0x4B6, `SALANOME$` = DS:0x536, `MSGBUF2$` = DS:0x556).
- As instruções de ponto flutuante são escapes `INT 34h-3Bh` do emulador de 8087 do Turbo Basic; todas as variáveis numéricas são de ponto flutuante (por isso o código tem `fldz`/`fcomp` onde se esperaria `cmp`).
- Chamadas ao runtime são `INT nn` (`analise/extracted/ca1_int_map.txt`). Os despachos `ON ... GOSUB` são `INT 0xEC` com seletor 0x70 e uma tabela de entradas de 4 bytes embutida no código (endereço = palavra + 0x82C0). `INT 0xED`/`0xEE` são despachos por byte seletor (`ED 22` = tamanho de string, `ED 1C` = `INSTR`); `INT 0xEC 0x14` é `RUN`.
- Endereços citados nas notas são offsets na imagem do `.EXE` (depois do cabeçalho MZ de 32 bytes); o endereço da listagem é o offset no arquivo menos 0x20. Isso só vale para o `CA1.EXE` com o SHA-256 de `original/SHA256SUMS`.

## Dados

- Strings: descritores `{ponteiro, tamanho, flag}`. Com o bit alto (0x8000) no tamanho, é um literal e aponta para o heap de strings (`E2.BIN`); sem ele, é variável de string no segmento de dados. As mensagens do `AVENTURA.MSG` são numeradas pela linha (a partir de 0); 111 literais ficaram no próprio código.
- Texto em CP437: não existem `ã õ Ã Õ Á`. Eu digitei `ä ö Ä Ö` e `Å`, e o jogo troca `ä`/`ö` por `ã`/`õ` na hora de mostrar (fonte própria). Minúsculas acentuadas aparecem no meio de palavras em maiúsculas (`óBVIO`, `NóS`) pelo mesmo motivo. As regras de modernização estão em `python/modernizar.py` e `python/erratas.md`.
- 67 salas (`analise/extracted/rooms_table.txt`: saídas N S L O C B, sub-rotina, linhas de mensagem), 88 objetos (`objects_table.txt`), 34 verbos com sinônimos (`verbs_table.txt`). `loc[obj]`: positivo = solto naquela sala; negativo = fixo; 0 = em lugar nenhum; -999 = com o jogador; -998 = passagem já usada na porta automática.

## Fluxo

- Cada sala é uma sub-rotina terminada em `RETURN`. A escolha da sala é `ON ... GOSUB` com tabela, sem fórmula de linha: uma rotina em 0xD4DF testa a faixa de `SALA` e usa sete `ON GOSUB` (salas 1-10, 11-20, 21-30, 31-40, 41-50, 51-60 e 61-67, os de cima com o índice deslocado, `SALA-10` etc.). Os verbos usam uma tabela única de 34 entradas em 0x8B9E (`ON verbo GOSUB`, com o verbo traduzido pelo array em 0x372). Os handlers estão em `analise/extracted/verb_handlers.txt`.
- O analisador de comandos (0x92D7 a 0x9647) tem as mensagens de erro ("O que você quer dizer com X?"); a aridade de cada verbo vem do array 0x33C (0 sem objeto, 1 opcional, 2 exige).
- Morte: mensagens 294 e 295, pausa e `RUN` (o jogo recomeça). O epílogo (296 a 326) é do curto-circuito, o final do jogo (lâmpada com papel-alumínio rosqueada no soquete da cela); o final varia conforme o jogador tenha a CHAVE.

## Curiosidades e bugs do original

- Mensagem 181: o fonte tinha `'MESMO ???':GOSUB P`, e o `GOSUB P` virou texto. A reimplementação imprime a frase; o original nunca imprimiu.
- Mensagem 148 (praça dos carecas) é carregada mas nunca impressa (falta um `GOSUB P`). A 166 (pilhas caem no escuro) é código morto.
- `BEIJAR AKIRA` tinha um atalho de depuração para pular para qualquer sala (mensagens 112 e 113), mas o teste compara com `36000`, não com o número do AKIRA (36), então é inalcançável. A reimplementação o restaura atrás de uma opção (`--teleporta-ao-beijar-akira`).
- `LER PLACA` no elevador da BucanoWare responde "Não posso ler isso" no original; a reimplementação lê a placa de propósito.
- A sala 66 (cela) não tem saídas; a sala 30 (elevador do fliperama) nunca se move.

## Como a fidelidade foi verificada

1. A lógica de cada verbo e de cada sala foi transcrita da listagem e do pseudocódigo (`analise/extracted/*_pseudocodigo.txt`).
2. Os 45 roteiros de `python/caminhos/` foram rodados no `epa.py` e no `CA1.EXE` original, no DOSBox-X, comparando o texto da tela (OCR) nos dois sentidos (`ferramentas/dosbox/comparar.py`). Resultado: nenhuma divergência além das propositais.
3. Uma busca sistemática, verbo por verbo, das constantes comparadas com objeto e sala no disassembly achou as poucas lacunas restantes.
4. O estado (inventário, dinheiro) foi comparado com `LISTAR` e `OLHAR GRANA` a cada passo do caminho feliz.

O que a comparação não cobre: o painel "Direções" e a ordem exata de condições raras. O `MENU` do jogo está fora do escopo; `SAIR` sai direto.
