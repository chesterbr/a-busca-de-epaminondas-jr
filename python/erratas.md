# Textos: o que a reimplementação mudou em relação ao original

O texto original continua em `original/AVENTURA.MSG` e nos dumps (e é o que o gerador do .BAS vai ler). O `epa.py` traz o texto
modernizado; `modernizar.py` tem as regras e `testar_textos.py` confere o fonte contra o original.

## Regras mecânicas (todas as mensagens)

| Original | Reimplementação | Motivo |
|----------|-----------|--------|
| `ä ö Ä Ö` | `ã õ Ã Õ` | O jogo troca na hora de mostrar (fonte própria); o CP437 não tem til |
| `Å` | `Á` | Mesma limitação (3 ocorrências: `VÁ`, `PROCURÁ-LO`, `LÁ`) |
| aspas simples `'...'` | aspas curvas `“...”` | Eram simples por não saber escapar aspas duplas no Turbo Basic |
| `texto ?` e `texto !` | `texto?` e `texto!` | Espaço antes da pontuação |
| minúscula acentuada no meio de maiúsculas (`óBVIO`, `NóS`, `ARTIFíCIO`, `ôNIBUS`) | maiúscula (`ÓBVIO`, `NÓS`, `ARTIFÍCIO`, `ÔNIBUS`) | O CP437 não tem `Ó Í Ô`; eu usei a minúscula |

## Erratas pontuais

| Mensagem | Original | Reimplementação |
|----------|----------|-----------|
| 132 | `E' realmente inacreditável` | `É realmente inacreditável` |
| 267 | `maös` (mostrado como `maõs`) | `mãos` |
| 46, 125, 270, 324 | `VOCE` (maiúsculas, sem acento) | `VOCÊ` |
| 211 | `¿ Como te chamas ?` | `¿Como te chamas?` (sem espaço depois do `¿`) |
| 181 | `'MESMO ???':GOSUB P` (código dentro do texto, o bug do `GOSUB P`) | não existe: o original nunca imprime `MESMO???` (a reimplementação imprime `“MESMO???”` por decisão antiga, `docs/engenharia-reversa.md`) |

## Decididos para manter como está (pode mudar)

- `ESTA` sem acento nas mensagens 46 e 312: é o demonstrativo ("ESTA POCILGA", "ESTA É UMA CHAVE MESTRA"), correto sem acento.
- `TE CHAMABAS` (211, 989): é espanhol de brincadeira, mantido. 
- Ortografia da época mantida: `idéia` (93, 267), `conseqüências` (257), `seqüência` (325). Se quiser a ortografia atual
  (`ideia`, `consequências`, `sequência`), é só dizer.
- `idéia`/`conseqüências`/`seqüência` e `Páscoa` não mudaram; `BLAAAAAAAGH`, `HAHAHAHAHAAAA`, `XADREZZZZZ` também não.

## Mensagens do original que a reimplementação não usa

- 148 (praça dos carecas): o original carrega e salta por cima da impressão (`docs/engenharia-reversa.md`).
- 166 (pilhas caem no escuro): código morto no original.
- 280 a 293 (telas de ajuda e menu): o MENU está fora do escopo.
- 3 ("Ela está fechada...") **passou a ser usada**: `ENTRAR PORTA` na agência com a porta fechada (descoberto por esta conferência).

## Interface (diferenças propositais, fora do texto)

- Comandos com acento: o original apagava as letras acentuadas (`INVENTÁRIO` virava `INVENTRIO` e não era entendido). Aqui os acentos são tirados antes de interpretar o comando.
