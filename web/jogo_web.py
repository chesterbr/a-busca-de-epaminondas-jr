"""A sessão da página python.html: o mesmo que o interativo() de epa.py faz no terminal, sem input() nem print().

A página (JS) chama abertura() uma vez e depois enviar(linha) a cada linha digitada; cada chamada devolve o texto
(com sequências ANSI de cor) para o xterm.js mostrar, e prompt() diz o que escrever antes da próxima linha.
"""
from epa import AJUDA, LARGURA, PAUSA_MORTE, Jogo, quebra_linhas


class Sessao:
    def __init__(self):
        self.linhas = []
        self.jogo = None  # None até o ENTER da abertura
        self.morreu = False  # esperando o ENTER que reinicia o jogo
        self.terminou = False

    def _texto(self):
        t = ''.join(l + '\n' for l in self.linhas)
        self.linhas.clear()
        return t

    def _novo_jogo(self):
        self.jogo = Jogo(saida=self.linhas.append, cor=True)
        self.jogo.iniciar()

    def abertura(self):
        """Caixa com o título, as instruções e o pedido de ENTER."""
        self.linhas.append('╔' + '═' * (LARGURA - 2) + '╗')
        for linha in ('A Busca de Epaminondas Jr. V1.5', '(c) 1992 por CHESTER (Carlos Duarte do Nascimento)',
                      'https://github.com/chesterbr/a-busca-de-epaminondas-jr'):
            self.linhas.append('║' + linha.center(LARGURA - 2) + '║')
        self.linhas.append('╚' + '═' * (LARGURA - 2) + '╝')
        self.linhas.append('')
        for p in AJUDA:
            self.linhas.extend(quebra_linhas(p))
            self.linhas.append('')
        return self._texto()

    def prompt(self):
        if self.jogo is None:
            return 'Tecle ENTER para começar...'
        if self.morreu:
            return PAUSA_MORTE
        return self.jogo.pergunta[0] if self.jogo.pergunta else '> '

    def enviar(self, linha):
        """Uma linha digitada. Na abertura, qualquer linha é o ENTER que começa o jogo."""
        if self.jogo is None or self.morreu:  # o ENTER da abertura, ou o que reinicia depois da morte
            self.morreu = False
            self.linhas.append('')
            self._novo_jogo()
            return self._texto()
        self.jogo.comando(linha)
        if self.jogo.morreu:  # como o original: pausa e recomeça (RUN)
            self.morreu = True
        elif self.jogo.saiu:
            self.terminou = True
        return self._texto()
