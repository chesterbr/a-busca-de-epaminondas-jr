# Pedra de Roseta do Turbo Basic

O `CA1.EXE` não tem nomes nem comentários, e o runtime do Turbo Basic é chamado por `INT EC/ED/EE <seletor>` e `INT 80h-CFh`. Para descobrir o que cada chamada faz, compilamos instruções soltas no Turbo Basic 1.0 e lemos o código que ele gera.

- `gera.py LISTA.txt SAIDA.BAS`: monta um programa com cada linha de `LISTA.txt` entre marcadores `PRINT "@@"`. Antes de `++`: linhas do começo (`REM $DYNAMIC`); depois de `--`: linhas depois do `END` (rótulos, DATA).
- `analisa.py PROGRAMA.EXE LISTA.txt`: desmonta o código do usuário do executável (usa `desmonta()` do `gerar.py`) e imprime o trecho de cada linha.
- `compila.sh NOME` e `t.sh`: automatizam o Turbo Basic no DOSBox-X (macOS: teclas via `ferramentas/dosbox/dbx`, captura de tela). O Turbo Basic 1.0 não faz parte do repositório (usamos a cópia 1.0 de 5.25" baixada de https://winworldpc.com/product/turbo-basic/1x, que também tem a 1.1); os scripts esperam `dosroot/` com o `TB.EXE`, os `.BAS` e um `TBCONFIG.TB` com "Compile to EXE file". Dá para fazer à mão: abrir o `.BAS`, Options > Compile to > EXE file, Compile.
- `t2.txt` a `t33.txt`: as listas usadas (`t33`: o compilador emite o código depois de um `GOTO` incondicional). `../rodada.sh` gera o `.BAS`, compila e compara com o original.

## O que descobrimos

| Compilador emite | Instrução BASIC |
|---|---|
| `INT EC 1A` | `CLS` |
| `mov ax,col / mov bx,lin ... INT C9` (bx = linha, ax = coluna) | `LOCATE lin, col` |
| `mov [88],fg (mov [94],bg) / INT EC 22 04` (ou `06` com fundo) | `COLOR fg[, bg]` |
| push string (`INT 96`) + `INT B8` | item de `PRINT` (string); `INT B5` número; `INT C1` `TAB(ax)`; `INT BE` `SPC(ax)`; `INT BB` vírgula |
| `INT B2` | fim do `PRINT` (nova linha); sem ele o `PRINT` terminou em `;` |
| `INT EC 4C <desc,flags>` + `INT EC 9A` / `98` | `INPUT ["prompt";] var$` / `var` |
| `INT EC 64` | `LINE INPUT #n, var$` |
| `INT EC 9E` / `9C` | `INPUT #n, var$` / `var` |
| `INT C7` + `[2E]=modo` + `[60]=n` + `INT EC 80` | `OPEN nome FOR INPUT/OUTPUT AS #n` (modo `49`/`4F`) |
| `INT BA`/`B7` + `INT B4` | `PRINT #n, string` / número |
| `INT EC 18` / `16` | `CLOSE #n` / `CLOSE` |
| `INT ED 10` | `EOF(n)` |
| `INT EC B0` / `B2` | `READ` número / string |
| `INT EC 2A` + limites + `INT EC 2C` | `DIM arr(n)` dinâmico (limite variável); `INT EC 36` = `ERASE` |
| `INT EC 6E <ptr>` | `ON ERROR GOTO` (ptr = alvo - 82C0h; `FFFFFFFF` = `ON ERROR GOTO 0`); `INT EC BA` + `jmp` = `RESUME` |
| `INT EC 70` / `72` + tabela | `ON x GOSUB` / `ON x GOTO` |
| `INT AD` | `CHR$(ax)` |
| `INT A0` | `ASC(s)` |
| `INT A7` / `AC` / `AB` / `AA` | `LEFT$` / `RIGHT$` / `MID$(s,bx,ax)` / `MID$(s,ax)` |
| `INT ED 22` | `LEN(s)` |
| `INT ED 1C` / `1E` | `INSTR(a$,b$)` / `INSTR(n,a$,b$)` |
| `INT EE 20` / `1E` / `22` / `24` / `28` | `STR$` / `SPACE$` / `STRING$(bx,código)` / `STRING$(ax,s$)` / `UCASE$` |
| `INT EE 0E` / `10` | `INKEY$` / `INPUT$(ax)` |
| `INT A6` / `A5` | `VAL(s$)` / `INT(x)` |
| `INT ED 3C` / `14` / `44` / `4A` | `RND` / `FIX` / `SGN` / `TIMER` |
| `INT EC 00` / `CE` | `BEEP` / `SOUND` |
| `fild/fstp` com contador, limite e passo + `test [passo+2],8000h` | `FOR v = a TO b [STEP s]` ... `NEXT v` |
| `DATA` | lista de ponteiros para descritores logo depois do código; textos deduplicados no pool de literais |

Arrays com limite variável (`DIM x(n)`) são dinâmicos (`mov es,[seg]` / `fld es:[si]`); com limite constante ficam no segmento de dados (`add si, base`).
