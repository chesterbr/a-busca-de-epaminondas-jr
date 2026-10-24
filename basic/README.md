# Reconstrução em Turbo Basic

`gerar.py` gera o fonte a partir do `CA1.EXE`; veja `NOTAS.md` para o método e o que se aprendeu. `gerado/CA1.BAS` é o fonte fiel (congelado): recompilado no Turbo Basic, dá código idêntico ao do `CA1.EXE`, byte a byte (lê `AVENTURA.MSG` como o executável); `gerado/LEGIVEL.BAS` é a mesma tradução para ler (UTF-8, 80 colunas, o texto das mensagens no fonte e rótulos que dizem o que a rotina faz, como `DescreveSala` e `Verbo27Comer`, no lugar dos números de linha).

Decisões já tomadas:

- Números mágicos ficam literais no código, com o nome só em comentário (o original não tinha nomes simbólicos; os de `python/epa.py` são rótulos nossos).
- Salas: `ON SALA GOSUB` em blocos de 10, como o original (sete `ON GOSUB`, ver `docs/engenharia-reversa.md`). Verbos: um `ON verbo GOSUB` com 34 entradas.
- Os textos vêm sempre de `original/AVENTURA.MSG` e dos dumps (sem as correções de `python/modernizar.py`).
- O critério de pronto é o mesmo dos testes do Python: os roteiros de `python/caminhos/` produzem a saída de `python/esperado/`.
