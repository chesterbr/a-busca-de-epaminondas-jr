# Ferramentas para pilotar o CA1.EXE no DOSBox-X (macOS)

- `iniciar.sh [save.CA1]`: compila `dbx` e `ocr` (Swift), copia o jogo para `jogo/` e abre o DOSBox-X. `teste.conf` desliga o aviso ao sair.
- `dbx`: posta teclas SO no PID do DOSBox-X (`CGEventPostToPid`); aborta se ele nao estiver em primeiro plano. Letras e digitos por key code (o `keystroke` do System Events perde `A` maiusculo e digitos).
- `k.sh "comando"`: ativa o DOSBox-X, espera o prompt (cinza em "Avisos e Extras"), dispensa as pausas "Digite qualquer tecla" (ciano), digita o comando e espera de novo. Cada captura vai para `log/NNNN.png` (com `OCR=1`, tambem `.txt` via `ocr`). Imprime `ESTADO primeira_captura ultima_captura`.
- `run.sh arquivo`: um comando por linha, para na primeira falha.
- `cenario.sh CAMINHO [SAVE LINHA]` e `cortar.py`: roda um arquivo de `python/caminhos/` no original, pulando o prefixo coberto pelo save. Mapa save/linha do caminho feliz: F2=15, P17=30, F3=42, F4=77, REC=78, F5=105 (nos caminhos derivados; no próprio 00, que tem 4 `OLHAR LISTA` a mais, são 19, 46, 81, 82 e 109). `comparar.py SAIDA_RUN CAMINHO LOGDIR [PULAR]` compara com a reimplementação.
- `estado.py`: classifica a caixa "Avisos e Extras" (PROMPT, PAUSA, OUTRO) a partir de um BMP.

Permissões do macOS: o app que roda estes scripts (Terminal, VS Code etc.) precisa de Acessibilidade (o `dbx` posta teclas), Gravação de Tela (as capturas de `k.sh`) e Automação do System Events (o `osascript` que traz o DOSBox-X para o primeiro plano), em Ajustes do Sistema > Privacidade e Segurança. Para revogar depois: `tccutil reset Accessibility|ScreenCapture|AppleEvents <bundle id>`. Enquanto isso roda, o computador não pode ser usado nem dormir (o foco precisa ficar no DOSBox-X).

Notas: o jogo ignora Enter vazio; entradas bloqueantes (linha do onibus, andar do elevador) sao digitadas como o proximo comando; ESC abre o menu do jogo (Gravar pede o nome do arquivo e grava `NOME.CA1` na pasta de trabalho).

Arquivos gerados (ignorar/apagar): `log/`, `jogo/`, `dbx`, `ocr`, `dbx.pid`, `dbx.log`. Os saves que valem a pena ficam em `saves/` (para usar: `./iniciar.sh F4.CA1`, depois `./carrega.sh F4` no menu do jogo).
