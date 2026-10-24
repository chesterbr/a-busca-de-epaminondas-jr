# Para testar o executável recompilado

- `CA1.EXE`: o `basic/gerado/CA1.BAS` (dividido em `gerado/dividido/`) compilado no Turbo Basic 1.0, rodando antes no editor como eu fazia (ver `../NOTAS.md`). Precisa do `AVENTURA.MSG` na mesma pasta.
- `ORIGINAL.EXE`: o `CA1.EXE` de 1992 (`original/CA1.EXE`), para comparar lado a lado (também precisa do `AVENTURA.MSG`).

No DOSBox-X: `mount c <esta pasta>`, `c:`, `ca1` (ou `original`). Os dois leem e gravam jogos (`*.CA1`) na pasta corrente: use pastas separadas se quiser manter as gravações separadas.

O código de usuário é idêntico ao original, byte a byte (35.565 bytes). O que difere no arquivo é o cabeçalho e a área de dados do runtime.
