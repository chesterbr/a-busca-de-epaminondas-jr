# Testes no jogo original (CA1.EXE)

Ordem de jogo, da fase 1 à 5. Em cada item: o que fazer, o que a reimplementação faz hoje (o que eu li do código) e o que anotar. Se o original for diferente, é só me dizer o que apareceu.

## Resultados (2026-10-18, testado no DOSBox-X por `ferramentas/dosbox/`)

Todos os itens abaixo foram conferidos no original e batem com a reimplementação, exceto onde indicado.

| Item | Original |
|------|----------|
| A | `LER LISTA` e `LER POSTE`: "Não posso ler isso" |
| B | `USAR LANTERNA` na sala 19, já ligada: "Ela já está ligada, toupeira !". A mensagem 166 ("pilhas caem") não foi vista (ver abaixo) |
| C | Sem 'MESMO ???': "...Indústrias L & L Ltda..." e direto "...mediante um módico preço." |
| D | `USAR ELEVADOR` na sala 30: qualquer número dá "O elevador não se move." (Enter vazio é ignorado pelo jogo) |
| E | Depois de largar o envelope, o `N` da recepção fica bloqueado, sem mensagem, e o jogo trava |
| F | Elevador oeste: "Ele desce automaticamente até o térreo."; leste: "Ele sobe automaticamente até o térreo." |
| G | `LER PLACA` no elevador: "Não posso ler isso" (a reimplementação corrige de propósito); `OLHAR PLACA` mostra a tabela |
| H | Salas 48 e 49: textos da primeira e da segunda visita conferem |
| I | `ESVAZIAR LIXO`: "Não entendi o verbo ESVAZIAR" |
| J | A AGENDA continua no inventário depois do táxi; `OLHAR GRANA`: "Você tem $5" |
| K | Sem o cartão: "seus $5" e chute pela janela. `L`/`O` no bairro pior: cena "Meu Deus, que lugar horrível...", morte e reinício |

Achado extra, da comparação do caminho completo (`ferramentas/dosbox/comparar.py`): na primeira visita à praça dos carecas (sala 9) o original NÃO imprime a frase "Você olha para o chão e vê aquilo que um dia foi seu cabelo..." (mensagem 148). O código carrega a mensagem e salta por cima da impressão (0xdc8e, `jmp 0xdcac`), outro `GOSUB P` que faltou. A reimplementação foi ajustado para não imprimi-la.

Parser e BEIJAR/ABRIR (2026-10-19): ver `docs/engenharia-reversa.md`. `BEIJAR AKIRA` sempre dá "Não está aqui..."; o atalho de desenvolvimento ficou inalcançável (teste `OBJ = 36000`).

Dica: grave o jogo (ESC > Gravar) antes dos itens marcados com **(arriscado)**.

Para abrir o DOSBox-X na pasta atual, a partir da pasta do projeto (`a-busca-de-epaminondas-jr/`):

```
dosbox-x -nopromptfolder -defaultdir "$PWD" -c "mount c ." -c "c:" -c "ca1.exe"
```

## Fase 1 (escritório e campus)

### A. LER LISTA e LER POSTE (item 6)

- Sala 2 (recepção, com a lista telefônica no chão): `LER LISTA`.
- Sala 3 (rua, com o poste): `LER POSTE`.
- Reimplementação: os dois respondem "Não posso ler isso" (o texto anterior, "Aonde está isso ?" para o poste, estava errado).
- Anotar: o que o original responde. Se mostrar o texto de OLHAR ("É um ponto de ônibus."), eu estendo `LER` a qualquer objeto que tenha texto de OLHAR.

## Fase 2 (depósito escuro)

### B. Escuro na sala 19 e as pilhas (item 12)

- Com a lanterna e as pilhas (no almoxarifado, sala 17, `USAR LANTERNA`), desça (`B`) para a sala 19.
- Já dentro da sala 19, tente `USAR LANTERNA` de novo.
- Reimplementação: responde "Está muito escuro. Não consigo achá-la. Que tal iluminar o local com outra coisa ?".
- Anotar: a frase que aparece. Alguma coisa acontece com as pilhas (elas "caem")? No arquivo de mensagens existe uma mensagem sobre isso, mas nenhum código a usa.

## Fase 3 (bairro)

### C. 'MESMO ???' na loja de autopeças (item 5)

- Sala 23 (loja, a leste da rua central), na primeira visita, com qualquer valor de grana.
- Reimplementação: imprime `'MESMO ???'` (decisão nossa). O original, pelo código, NÃO imprime.
- Anotar: depois de "...Indústrias L & L Ltda..." vem `'MESMO ???'` ou direto "...mediante um módico preço."? (É o bug do `GOSUB P` que você quer citar no post.)

### D. Elevador do prédio do fliperama (item 8)

- Sala 30 (elevador, ao norte do hall da sala 29). `USAR ELEVADOR`.
- Reimplementação: pergunta "Digite o número do andar:" e responde "O elevador não se move." para qualquer resposta.
- Anotar: o que aparece com uma resposta qualquer (por exemplo `1`) e com resposta vazia.

## Fase 4 (BucanoWare)

Grave aqui, antes de entrar na recepção.

### E. Armadilha da recepção (item 1) **(arriscado)**

- Sala 40 (recepção): `LARGAR ENVELOPE` leva ao hall (sala 41). Do hall vá ao sul (de volta à recepção) e tente o norte.
- Reimplementação: a recepção mostra só "Estamos na recepção." com a saída sul, e o norte fica fechado. Sem o envelope você não passa de novo.
- Anotar: o norte bloqueia mesmo? (Se sim, o hall avisa disso no texto.)

### F. Elevadores (item 9)

- Hall (sala 41): oeste é o elevador dos andares, leste o dos sub-solos. `USAR ELEVADOR` e responda `1`, depois `O` (volta ao elevador).
- Faça o mesmo no elevador leste (sub-solo `1` ou `2`).
- Reimplementação: ao voltar ao elevador oeste o texto termina com "Ele desce automaticamente até o térreo."; no elevador leste, com "Ele sobe automaticamente até o térreo.". Resposta inválida dá "O elevador não se move.".

### G. LER PLACA no elevador (item 7)

- No elevador oeste (sala 42): `LER PLACA` e `OLHAR PLACA`.
- Reimplementação: os dois mostram a tabela dos andares (corrigi uma omissão do original).
- Anotar: o que o original responde para `LER PLACA` ("Não posso ler isso"?).

### H. Salas das secretárias (item 13)

- Andar 3 do elevador oeste: recepção da administração (46), leste (47), depois sul (48), sul (49).
- Nas salas 48 e 49, na primeira visita e depois voltando.
- Reimplementação: na primeira vez, "Eis OUTRA sala de secretária." (48) e "Eis MAIS UMA sala de secretária (esse Sr. L é bom mesmo)..." (49). Na segunda: "Você está numa (outra) salinha de secretária." (48) e "Estamos numa salinha pertencente a alguma secretária." (49).
- Anotar: os textos que aparecem nas duas visitas.

### I. ESVAZIAR LIXO (item 6, parte 2)

- Sala 53 (sala do Sr. L, ao fim do corredor, a oeste de uma porta aberta): `ESVAZIAR LIXO`.
- Reimplementação: "Não entendi o verbo." (a palavra não está no vocabulário).
- Anotar: o que o original responde. O caminho que conheço é `PEGAR LIXO`, que tira a agenda do cesto.

### J. Depois do táxi (item 2)

- Com a agenda, na frente do prédio (sala 39): `LARGAR AGENDA`. Você chega ao bairro pior (56).
- Em seguida: `LISTAR` e `OLHAR GRANA`.
- Reimplementação: a agenda continua na lista (o código não a remove) e a grana vira `$5` ("Você tem $5").
- Anotar: a agenda ainda aparece em `LISTAR`? Qual a grana?

## Fase 5 (danceteria)

### K. Bairro pior sem o cartão (item 10)

- Sala 56 (logo depois do táxi): tente `L` ou `O`. Depois tente `N` sem o cartão (se der, grave antes).
- Reimplementação: leste e oeste levam à cena "Meu Deus, que lugar horrível..." (você morre). Sem o cartão, o engomadinho mostra "seus $5" e te chuta pela janela de volta à rua.
- Anotar: os dois textos, e se a morte reinicia o jogo depois das mensagens "Você falhou em sua missão..." e "Vamos lá ! Não se desespere !...".

### L. CD na mesa de som (item 11, já confirmado por você)

- Só para registro, não precisa repetir: `LARGAR CD` na mesa de som (sala 62) faz o DJ agradecer e o jogo fica sem saída.

## Resumo dos itens

| Letra | Item | Fase |
|-------|------|------|
| A | 6, parte 1 (LER LISTA, LER POSTE) | 1 |
| B | 12 (escuro e pilhas) | 2 |
| C | 5 (MESMO ???) | 3 |
| D | 8 (elevador do fliperama) | 3 |
| E | 1 (armadilha da recepção) | 4 |
| F | 9 (elevadores) | 4 |
| G | 7 (LER PLACA) | 4 |
| H | 13 (salas das secretárias) | 4 |
| I | 6, parte 2 (ESVAZIAR LIXO) | 4 |
| J | 2 (agenda e grana) | 4 |
| K | 10 (bairro pior) | 5 |
