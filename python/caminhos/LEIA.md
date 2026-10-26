# Caminhos alternativos

Cada `.txt` é uma lista de comandos para a reimplementação (`python3 python/epa.py python/caminhos/NN_nome.txt`). Linhas vazias e com `#` são ignoradas. Todos começam com o trecho do caminho feliz necessário (marcado no cabeçalho) e depois divergem. Todos foram rodados na reimplementação e no original (DOSBox-X, `ferramentas/dosbox/comparar.py`), usando os saves de `ferramentas/dosbox/saves/` para pular fases (`REC`, `F2`, `P17`, `F3`, `F4`, `F5`).

Resultado da comparação (2026-10-19): nenhum texto da reimplementação ficou sem correspondência no original, e nenhum texto novo do original ficou sem correspondência na reimplementação, exceto ruído do OCR. Diferença conhecida e proposital: `LER PLACA` no elevador da BucanoWare (o original responde "Não posso ler isso").

## Final

| Arquivo | O que mostra | Desfecho |
|---|---|---|
| 00_caminho_feliz | Solução completa, comentada, com a lista relida várias vezes | Final com a CHAVE (jogo completo) |
| 28_final_sem_chave | Sem pegar a noz nem quebrá-la | Final menos feliz: curto-circuito sem a chave |
| 30_caminho_exaustivo | Caminho feliz com OLHAR/FALAR/BEIJAR em tudo | Final com a CHAVE (serve para conferir textos) |

## Mortes

| Arquivo | Como morre |
|---|---|
| 01_onibus_errado | Ônibus na linha errada: bairro perigoso (sala 20) |
| 04_punks_morte | Careca vai ao norte da praça: os punks matam (sala 10) |
| 07_escuro_sem_saida | Depósito escuro sem luz: sem saída, só os fósforos |
| 08_fosforos_banheiro | Fósforo aceso no banheiro feminino (fogo na madeira) |
| 09_banheiro_linchamento | Volta ao hall depois do banheiro feminino: linchamento |
| 10_noz_engasgo | Come a noz duas vezes |
| 11_noz_chave_indigesta | Come a noz, quebra e tenta comer a chave |
| 12_mafia_na_portinhola | Portinhola da fábrica: a máfia fuzila (sala 37) |
| 13_atravessar_a_rua | Atravessar a rua na calçada (sala 3) |
| 20_bairro_pior_leste, 21_bairro_pior_oeste | Corrozinho com faca, saindo do bairro pior |
| 22_atravessar_no_bairro_pior | Atravessar a rua no bairro pior (sala 56) |
| 25_soquete_choque | Pegar o soquete da cela: choque de 220V |

A morte só mostra as mensagens 294 e 295, pausa e reinicia o jogo (`RUN`). A reimplementação também reinicia (nos roteiros imprime "--- reiniciando o jogo ---"; no terminal e na página pede uma tecla antes, como o original) e os comandos seguintes do arquivo valem para o jogo novo, como no original.

## Becos sem saída e tentativas que falham

| Arquivo | O que mostra |
|---|---|
| 03_vigia_sem_careca | A faculdade barra quem ainda tem cabelo; depois dos carecas, entra |
| 24_cd_na_mesa_de_som | CD entregue ao DJ na mesa de som: jogo sem saída |
| 26_lampada_quebrada | Lâmpada largada na cela se quebra: sem curto-circuito |
| 27_lampada_sem_aluminio | Lâmpada rosqueada sem papel-alumínio: nada acontece |
| 15_loja_sem_grana | Loja de autopeças só leva à BucanoWare com $5000 |
| 16_taxista_sem_agenda | O taxista só funciona com a agenda |
| 17_recepcao_sem_envelope | Sem o envelope a recepcionista não deixa passar |
| 18_armadilha_da_recepcao | Depois de largar o envelope, a recepção não leva mais a lugar algum |
| 23_engomadinho_sem_cartao | Sem olhar a carteira, o engomadinho chuta de volta à rua |

## Respostas padrão, ordens diferentes e salas laterais

02 (linhas de ônibus inválidas), 05 (balcão antes de conversar), 06 (lanterna e pilhas), 14 (atravessar fora da rua), 19 (elevadores), 29 (secretaria e sala de aula), 31 (mala e passagem), 32 (velhinho e bispo), 33 (parede e marreta), 34 (elevador do fliperama), 35 (beco e banheiro masculino), 36 (danceteria), 37 (matriz de verbos: cada verbo com cada objeto das três primeiras salas), 38 (lista largada), 39 (leituras).

Com o atalho `--teleporta-ao-beijar-akira` (ver `docs/engenharia-reversa.md`) dá para pular direto a qualquer sala ao testar mortes novas.

- `40_estado.txt`: caminho feliz com `LISTAR` e `OLHAR GRANA` intercalados, usado para comparar inventário e grana com o original.
- `41_entrar_porta.txt`: `ENTRAR PORTA` no calçadão leva à biblioteca (conferido no original).
- `42_olhar_chao_teto.txt` (OLHAR CHAO/TETO/CIMA/BAIXO e ENTRAR BALCAO fora da biblioteca) e `43_olhar_no_escuro.txt` (OLHAR de objetos no depósito escuro; save P17, 30 linhas): conferidos no original.
- `44_amostra_fase3.txt`: caminho feliz com OLHAR/PEGAR/USAR nos objetos fixos das salas novas da fase 3 em diante (save F3, 46 linhas).
