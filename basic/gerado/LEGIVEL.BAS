' LEGIVEL.BAS: o CA1.BAS escrito para leitura (gerado por basic/gerar.py
' --legivel a partir do CA1.EXE). Nomes de variáveis, rótulos e comentários são
' nossos: o executável não guarda nenhum. Os números de salas, verbos e objetos
' são os do jogo. O texto é UTF-8 (o jogo grava ä ö Ä Ö Å e mostra ã õ Ã Õ Á).

' **************************************************************
' INICIALIZAÇÃO
' Título, mensagens, tabelas (DATA) e estado inicial do jogo.
' **************************************************************
Inicio:
  CLEAR : RESTORE
  ' Título do jogo: lido de DATA e decodificado (cada número é o código ASCII
  ' mais a posição), para dificultar a edição com um editor binário
  TITULO$ = ""
  FOR I = 1 TO 70
    READ CODIGO
    TITULO$ = TITULO$ + CHR$(CODIGO - I)
  NEXT I
  DATA 66,34,69,121,120,105,104,40,109,111
  DATA 43,81,125,111,124,121,127,129,129,120
  DATA 118,137,55,98,139,72,59,114,78,76
  DATA 84,64,78,66,75,135,78,70,88,97
  DATA 98,92,75,156,156,160,79,115,121,119
  DATA 134,136,122,136,87,96,124,155,173,168
  DATA 172,177,95,132,182,163,181,184,170,111
  ' Visitas às salas e dicionário de sinônimos de verbos (palavra, número do
  ' verbo, parâmetros: 0 nenhum, 1 opcional, 2 obrigatório)
  NUMSALAS = 67
  NUMSINONIMOS = 74
  DIM VISITADA(NUMSALAS)
  DIM SINONIMOVERBO$(NUMSINONIMOS), VERBO(NUMSINONIMOS), PARAM(NUMSINONIMOS)
  FOR I = 1 TO NUMSINONIMOS
    READ SINONIMOVERBO$(I), VERBO(I), PARAM(I)
  NEXT I
  DATA "NORTE",1,0
  DATA "N",1,0
  DATA "SUL",2,0
  DATA "S",2,0
  DATA "LESTE",3,0
  DATA "L",3,0
  DATA "OESTE",4,0
  DATA "O",4,0
  DATA "IR",5,2
  DATA "ENTRAR",5,2
  DATA "PEGAR",6,2
  DATA "CATAR",6,2
  DATA "APANHAR",6,2
  DATA "TOMAR",6,2
  DATA "LISTAR",7,0
  DATA "INVENTARIO",7,0
  DATA "OBJETOS",7,0
  DATA "LARGAR",8,2
  DATA "DEIXAR",8,2
  DATA "SOLTAR",8,2
  DATA "OLHAR",9,2
  DATA "VER",9,2
  DATA "EXAMINAR",9,2
  DATA "OBSERVAR",9,2
  DATA "VERIFICAR",9,2
  DATA "FALAR",10,2
  DATA "CONVERSAR",10,2
  DATA "CIMA",11,0
  DATA "C",11,0
  DATA "SUBIR",11,0
  DATA "BAIXO",12,0
  DATA "B",12,0
  DATA "DESCER",12,0
  DATA "LER",13,2
  DATA "LIGAR",14,2
  DATA "USAR",14,2
  DATA "ACENDER",14,2
  DATA "ABRIR",15,2
  DATA "BEIJAR",16,2
  DATA "ABRACAR",16,2
  DATA "MENU",17,0
  DATA "CHUPAR",18,2
  DATA "QUEBRAR",19,2
  DATA "DETONAR",19,2
  DATA "ARREBENTAR",19,2
  DATA "DESTRUIR",19,2
  DATA "SAIR",20,0
  DATA "ABANDONAR",20,0
  DATA "DIZER",21,2
  DATA "FECHAR",22,2
  DATA "DESLIGAR",22,2
  DATA "ROSQUEAR",23,2
  DATA "DESROSQUEAR",24,2
  DATA "VOAR",25,0
  DATA "MORDER",26,2
  DATA "XINGAR",26,2
  DATA "BATER",26,2
  DATA "ESPANCAR",26,2
  DATA "LAMBER",26,2
  DATA "COMER",27,2
  DATA "CHEIRAR",28,0
  DATA "ATRAVESSAR",29,2
  DATA "PULAR",30,1
  DATA "JOGAR",31,1
  DATA "BRINCAR",31,1
  DATA "PASSEAR",31,1
  DATA "DORMIR",31,1
  DATA "CAVALGAR",31,1
  DATA "MASTURBAR",31,1
  DATA "ARREMESSAR",32,2
  DATA "LANCAR",32,2
  DATA "SENTAR",33,1
  DATA "DEITAR",33,1
  DATA "APAGAR",34,2
  ' Objetos: nome, sala (local) inicial, descrição na sala e texto do EXAMINAR.
  ' Valores especiais de local:
  '   negativo = fixo (não pode ser pego, mesmo estando naquela sala)
  '   0        = fora do jogo (ainda não apareceu, foi destruído ou é uma
  '              palavra imaterial, como NORTE)
  '   -999     = com o jogador (no inventário)
  NUMOBJ = 88
  DIM OBJ$(NUMOBJ), LOCOBJ(NUMOBJ), AQUI$(NUMOBJ), EXAME$(NUMOBJ), INV$(NUMOBJ)
  FOR I = 1 TO NUMOBJ
    READ OBJ$(I), LOCOBJ(I), AQUI$(I), EXAME$(I)
  NEXT I
  DATA "NORTE",0,"",""
  DATA "SUL",0,"",""
  DATA "LESTE",0,"",""
  DATA "OESTE",0,"",""
  DATA "LISTA",2,"Há uma lista telefônica jogada num canto.",""
  DATA "AZULEJO",1,"Você nota um azulejo solto no chão.","O azulejo tem um desenho bastante trabalhado. No verso está escrito algo sobre o estilo, o autor e o material utilizado e aquele blá-blá-blá característico do seu professor de literatura..."
  DATA "COFRE",-1,"Um grande cofre de metal jaz na parede.","Cheio de trancas e travas, este cofre somente pode ser aberto por quem tiver a chave. Não perca tempo. VAI PROCURAR, SEU PULHA !!!"
  DATA "HOMEM",-3,"Um homem mal-encarado está apoiado num poste.","'Qualé, nunca viu, ô palhaço ?', ele diz, enquanto polui a calçada cuspindo algo extremamente nojento para que possa ser descrito neste jogo."
  DATA "POSTE",-3,"","Ali diz: 'PONTO DE ôNIBUS'"
  DATA "LOCAL",0,"",""
  DATA "SALAO",-4,"","A porta está aberta. Há uma placa no topo da mesma"
  DATA "PLACA",-4,"","Ela diz: 'BIBLIOTECA'"
  DATA "PORTA",-4,"","Ela está aberta."
  DATA "BALCONISTA",-5,"Uma linda balconista devora um exemplar da revista 'Capricho' atrás do balcão.","Ela é totalmente DEMAIS. Ela nota seu olhar insistente, e responde da mesma forma."
  DATA "LIVRO",0,"Um livro atrapalha a passagem","É um exemplar de 'Operação Cavalo de Tróia III'."
  DATA "PAPEL",0,"","Ali diz: ' 442-8093 '."
  DATA "BALCAO",-5,"O balcão lhe chama a atenção, pois ocupa metade da biblioteca.","A única coisa notável é que só se pode pegar livros de dentro dele."
  DATA "ESCADA",-6,"Há uma escada aqui.","Nada de especial nela."
  DATA "CIMA",0,"","Nada a declarar."
  DATA "BAIXO",0,"","Nada de novo que chame a atenção."
  DATA "LANTERNA",7,"Uma lanterna está no chão.","Ela está sem pilhas"
  DATA "PILHAS",15,"Algumas pilhas estão jogadas no chão.","As pilhas servem bem na lanterna."
  DATA "SALA",0,"",""
  DATA "AREA",0,"",""
  DATA "ONIBUS",-4,"","Vários deles passam por aqui, e PEGAR um ONIBUS seria uma idéia bastante interessante..."
  DATA "GRANA",-999,"",""
  DATA "VIGIA",-11,"Um vigia está te encarando, rapaz.","O homem não é tão forte para exercer a profissão de vigia, mas sua autoridade se concentra num ·38 que ele tem na cintura."
  DATA "BORRACHA",0,"Uma borracha está largada no chão.","Nada de especial nela"
  DATA "MESA",-13,"","Nem pense em mexer nela. Você poderia acordar a secretária, e ser preso por invasão e roubo. Você já tem problemas demais, como, por exemplo, AQUELE disquete (lembra?). PROCURE-O !!!"
  DATA "SECRETARIA",-13,"A secretária 'puxa um ronco' sobre sua mesa.","Ela não é nada de que se diga 'OH, mas que secretária SUPIMPA', mas não é de se jogar fora"
  DATA "FOSFOROS",-999,"","Cada um dos fósforos consiste em uma haste de madeira e uma concentração de material combustível na ponta. Ao utilizá-los, eles devem acender, e, não antes, nem durante, mas depois, eles devem apagar."
  DATA "MALA",0,"Uma mala lhe chama a atenção.","Deve haver algo interessante dentro dela."
  DATA "PAPEIS",0,"Há um bolo de papéis aqui.","São apenas papéis em branco"
  DATA "PASSAGEM",0,"Uma passagem perdida repousa no chão.","'Destino: Bazárgada'"
  DATA "PORTA",-57,"Há uma porta automática ao leste.",""
  DATA "AKIRA",0,"",""
  DATA "CARTEIRA",24,"Uma carteira está largada no chão.","Nada de especial."
  DATA "CARTAO",0,"Há um cartão aqui.","Ele diz: 'JADER DANCING POINT - «A» Danceteria - Permanente'"
  DATA "VELHINHO",-27,"Um velhinho está jogando uma máquina qualquer","Ele é, sem dúvida, um bom velhinho."
  DATA "ELEVADOR",-30,"","Nada a declarar."
  DATA "BISPO",29,"Uma figura imponente se destaca do cenário. É um bispo. Todos os que passam olham para este, com aquele olhar que só os muito crentes têm.","É um bispo como outro qualquer."
  DATA "MARRETA",0,"Eis uma marreta no chão.","Não pode destruir uma parede, mas quem sabe algo menos forte..."
  DATA "MADEIRA",-31,"","É apenas madeira."
  DATA "PAREDE",-31,"","É feita de madeira."
  DATA "COFRE",-35,"Há um cofre aqui.","Está vazio."
  DATA "TUBO",-35,"Um tubo abaixo de você dá acesso a alguma coisa.","Está bem escuro lá embaixo."
  DATA "TAXISTA",-39,"Um taxista está apoiado em seu taxi.","O cara não parece ser daqui."
  DATA "TAXI",-39,"","Não é o MACH 5, mas depois do carro do vendedor, qualquer eca serve."
  DATA "ENVELOPE",12,"Tem um envelope marrom no chão.","O envelope é daqueles comerciais, que costumam conter documentos importantes. Infelizmente, este está vazio."
  DATA "RECEPCIONISTA",-40,"","Ela é muito bonita, mas precisa de um bom truque para ser dobrada e nos deixar passar."
  DATA "ELEVADOR",-42,"","Não é o que se possa chamar de 'estado-da-arte' em termos de elevadores, mas você já viu coisa pior. Há uma placa nele."
  DATA "ELEVADOR",-43,"","Ele só conduz aos sub-solos inferiores (1 e 2)"
  DATA "PLACA",-42,"","É uma tabela que diz: 	1ºAndar.........................Analistas 	2ºAndar............................C.P.D. 	3ºAndar..........................Gerência"
  DATA "ANALISTAS",-44,"Alguns analistas de sistemas passam por você.","Não parecem ser as pessoas mais amigáveis do mundo, nem as mais trabalhadoras, pois muitos estão massageando seus órgãos genitais (com pomadinha Hippolgrós, é claro)."
  DATA "PROGRAMADORES",-45,"Alguns programadores estão com o nariz colado nos monitores.","Eles parecem muito interessados no que estão fazendo"
  DATA "DISQUETES",-55,"Há uma pilha de disquetes bem presa ao chão.","Hum... vejamos... imagens digitalizadas... Space Quest III... Digger (amasse este)... Nenhum deles é o nosso disquete. Mas mesmo que fosse, eles foram presos ao chão com arame farpado, o que os inutilizou."
  DATA "COMPUTADORES",-45,"Os computadores estão todos sendo usados por eles.","Agora você vê o que eles estão fazendo. É melhor não incomodá-los. Afinal, quem seria tão cruel a ponto de interromper uma partida de 'Leisure Suit Larry' ?"
  DATA "ARAME",-55,"","Isso pode ser útil num adventure, especialmente quando você precisar de uma corda..."
  DATA "PAINEL",-50,"Há um grande painel na parede.","Um desenho bastante incrementado, e uma frase do Laerte: 'Neste local, quem não vive para servir não serve para viver.'"
  DATA "PIA",-51,"Tem uma pia aqui.","Olhe, alguém deixou uma bala aqui..."
  DATA "PORTA",-52,"","Ela está aberta."
  DATA "MESA",-53,"A mesa do Sr. L. está cheia de coisinhas.","Não prima muito pela organização. As coisas estão caindo pelos cantos, quando não vão parar no cesto de lixo, caem no chão e ali ficam para sempre."
  DATA "DOCUMENTOS",53,"Estes documentos aí podem ser importantes.","Nada que lhe fascine. Apenas coisas corriqueiras da firma, como subornos, transações ilícitas e tudo o que se encontra numa firma assim."
  DATA "CESTO",-53,"","Ele está cheio de lixo."
  DATA "LIXO",-53,"","O que você espera encontrar ?"
  DATA "AGENDA",0,"","Vejamos as anotações recentes... A caligrafia é boa, mas não dá para entender uma palavra. Hmm..."
  DATA "GRUPO",-59,"Um grupo de dança está fazendo seu showzinho","O grupo é organizado, mas nada de incrível"
  DATA "BALCAO",-61,"Não há ninguém no balcão.","Nada de especial."
  DATA "BARMAN",-61,"O Barman está olhando para você.","A única função dele é servir bebidas. Ele não serve para mais nada."
  DATA "MESAS",-60,"As mesas estão espalhadas pelo lugar","Estão todas ocupadas, e o pessoal parece não querer ser incomodado. Nem tente mexer com eles."
  DATA "CD",53,"Tem um CD aqui no chão.","É um disco laser do Bomb the Bass"
  DATA "DJ",-62,"O DJ vai selecionando as músicas.","Ele parece curtir o que faz."
  DATA "TETO",0,"","Nada ali em cima vai lhe ajudar"
  DATA "NOZ",30,"Tem uma noz aqui.","É uma noz comum."
  DATA "CHAO",0,"","Levante a cabeça, rapaz !!!"
  DATA "CHAVE",0,"Tem uma chave aqui.","Parece ser uma chave de cofre..."
  DATA "LAMPADA",66,"","A lâmpada faz parte de uma ligação elétrica bastante ruim."
  DATA "BALA",51,"","É uma bala comum."
  DATA "EMBALAGEM",0,"Há uma embalagem de bala no chão.","A embalagem da bala é de papel-alumínio"
  DATA "MESA",-62,"","Atrás da mesa de som (e do DJ, obviamente) tem uma porta. Mas não dá para passar sem que o DJ saia de lá"
  DATA "NI",0,"",""
  DATA "SOQUETE",-66,"","Geralmente é utilizado para segurar lâmpadas no teto, impedindo que elas caiam."
  DATA "PERFUME",0,"","Talvez isso seja um pouco difícil..."
  DATA "BANHEIRO",0,"",""
  DATA "LIVROS",-6,"","São muitos volumes, mas não dá para alcançá-los."
  DATA "RUA",-3,"","Está bastante movimentada, com todos os tipos de veículos imagináveis. Nem pense em atravessá-la."
  DATA "COMPUTADOR",-18,"","Está firmemente preso à mesa. Uma preciosidade dessas não pode ser levada tão facilmente."
  DATA "GRAVADOR",-18,"","Como você já deve ter suposto, ele não funciona. Nem tente levá-lo."
  GOSUB MostraMensagem
  ' Palavras ignoradas na análise do comando
  NUMFILTRO = 21
  DIM FILTRO$(NUMFILTRO)
  FILTRO$(1) = " COM "
  FILTRO$(2) = " A "
  FILTRO$(3) = " O "
  FILTRO$(4) = " PARA "
  FILTRO$(5) = " DE "
  FILTRO$(6) = " POR "
  FILTRO$(7) = " PRA "
  FILTRO$(8) = " PRO "
  FILTRO$(9) = " QUE "
  FILTRO$(10) = " AO "
  FILTRO$(11) = " ATE "
  FILTRO$(12) = " OS "
  FILTRO$(13) = " AS "
  FILTRO$(14) = " UM "
  FILTRO$(15) = " UMA "
  FILTRO$(16) = " UNS "
  FILTRO$(17) = " UMAS "
  FILTRO$(18) = " EM "
  FILTRO$(19) = " NO "
  FILTRO$(20) = " NA "
  FILTRO$(21) = " DO "
  SALA = 1 ' Escritorio
  GOSUB DesenhaTelaInicial
  ' Palavrões (quando digitados como verbo, o jogo reage)
  NUMPALAVROES = 16
  DIM PALAVROES$(NUMPALAVROES)
  FOR I = 1 TO NUMPALAVROES
    READ PALAVROES$(I)
  NEXT I
  DATA "MERDA","BOSTA","CU","CARALHO","PORRA","BICHA","VEADO","VIADO","CACETE","BOCETA"
  DATA "BUCETA","PUTA","SE FODER","FODA","FODA-SE","CUZAO"
  ' Páginas da lista telefônica (cada OLHAR LISTA mostra a seguinte)
  DIM JANELA$(11), BACKUP$(11), DESCLISTA$(4)
  DESCLISTA$(1) = "Existem muitas informações nesta lista. Uma delas é " + _
      "'Acesso ao VideoTexto'. Você passa batido."
  DESCLISTA$(2) = "Outra coisa quase interessante na lista: 'Como adquirir " + _
      "seu telefone'."
  DESCLISTA$(3) = "Olhe só, um mapa de ruas. Pena estar todo esburacado. " + _
      "Mas já é mais interessante..."
  DESCLISTA$(4) = "Opa, um guia de 'Itinerário de ônibus'. Interessante é " + _
      "que a frase 'Linha 4283 - Vila Inhangózinho' está sublinhada. Hum..."
  ' Estado do jogo: valores que mudam com o progresso (o que veio antes são
  ' tabelas)
  LANTERNA$ = "desligada"
  AVISOUSOBRENOZ = 0
  GRANA = 500
  PORTAABERTA = 0
  GOSUB AtualizaPainelObjetos
  BARMAN = 0
  PAPELALUM = 0

' **************************************************************
' LOOP PRINCIPAL
' Mostra a sala quando muda, lê e analisa o comando e executa o verbo.
' **************************************************************
LoopPrincipal:
  IF SALAANT <> SALA THEN
    GOSUB DescreveSala
    GOSUB MostraObjetosDaSala
    GOSUB AtualizaPainelDirecoes
  END IF
  SALAANT = SALA
  VISITADA(SALA) = 1
  COMANDOINVALIDO = 1
LeProximoComando:
  IF COMANDOINVALIDO THEN
    GOSUB LeComando
    GOSUB AnalisaComando
    GOTO LeProximoComando
  END IF
  IF VERBO(INDICEVERBO) <> 27 THEN AVISOUSOBRENOZ = 0
  IF VERBO(INDICEVERBO) = 9 AND SALA = 58 THEN ' 58=Portaria
    MENSAGEM$ = "É melhor sair da portaria, antes que o engomadinho venha " + _
        "lhe encher o saco de novo."
    GOSUB MostraMensagem
    GOTO LoopPrincipal
  END IF
  ON VERBO(INDICEVERBO) GOSUB Verbo1Norte, Verbo2Sul, Verbo3Leste,_
      Verbo4Oeste, Verbo5Ir, Verbo6Pegar, Verbo7Listar, Verbo8Largar,_
      Verbo9Olhar, Verbo10Falar, Verbo11Cima, Verbo12Baixo, Verbo13Ler,_
      Verbo14Ligar, Verbo15Abrir, Verbo16Beijar, Verbo17Menu, Verbo18Chupar,_
      Verbo19Quebrar, Verbo20Sair, Verbo21Dizer, Verbo22Fechar,_
      Verbo23Rosquear, Verbo24Desrosquear, Verbo25Voar, Verbo26Morder,_
      Verbo27Comer, Verbo28Cheirar, Verbo29Atravessar, Verbo30Pular,_
      Verbo31Jogar, Verbo32Arremessar, Verbo33Sentar, Verbo34Apagar
  GOTO LoopPrincipal

' **************************************************************
' ENTRADA E TELA
' Ler e analisar o comando, desenhar a tela.
' **************************************************************
LeComando:
  TECLA$ = ""
  COMANDO$ = ""
  LOCATE 18, 16
  PRINT SPACE$(64);
  WHILE TECLA$ <> CHR$(13)
    LOCATE 18, 16
    COLOR 7
    PRINT COMANDO$;
    COLOR 31
    PRINT "■";
    COLOR 11
    PRINT " ";
    LOCATE 18, 16 + LEN(COMANDO$)
    LOCATE 21, 16
    COLOR 7
    PRINT "Digite um comando, ou «ESC» para menu..."
    LOCATE 1, 1
    TECLA$ = ""
    WHILE TECLA$ = "" : TECLA$ = INKEY$ : WEND
    IF TECLA$ >= "a" AND TECLA$ <= "z" THEN TECLA$ = CHR$(ASC(TECLA$) - 32)
    IF ASC(TECLA$) >= 32 AND ASC(TECLA$) <= 127 AND LEN(COMANDO$) < 60 THEN
      COMANDO$ = COMANDO$ + TECLA$
    END IF
    IF TECLA$ = CHR$(8) AND COMANDO$ <> "" THEN
      COMANDO$ = LEFT$(COMANDO$, LEN(COMANDO$) - 1)
    END IF
    IF TECLA$ = CHR$(27) THEN
      ANTERIOR$ = COMANDO$
      COMANDO$ = ""
      LOCATE 18, 16
      PRINT SPACE$(64);
      GOSUB Verbo17Menu
    END IF
    IF TECLA$ = CHR$(0) + CHR$(59) AND LEN(COMANDO$) < LEN(ANTERIOR$) THEN
      COMANDO$ = COMANDO$ + MID$(ANTERIOR$, LEN(COMANDO$) + 1, 1)
    END IF
    IF TECLA$ = CHR$(0) + CHR$(61) AND LEN(COMANDO$) < LEN(ANTERIOR$) THEN
      COMANDO$ = COMANDO$ + RIGHT$(ANTERIOR$, LEN(ANTERIOR$) - LEN(COMANDO$))
    END IF
  WEND
  LOCATE 18, 16
  PRINT SPACE$(64);
  LOCATE 21, 16
  PRINT SPACE$(64);
  LOCATE 18, 16
  COLOR 7
  PRINT COMANDO$;
  COLOR 11
  IF COMANDO$ = "" THEN GOTO LeComando
  ANTERIOR$ = COMANDO$
  RETURN

AnalisaComando:
  GOSUB LimpaComando
  ESPACO = INSTR(COMANDO$, " ")
  IF ESPACO = 0 THEN
    PALAVRA$ = COMANDO$
    NOME$ = ""
  ELSE
    PALAVRA$ = LEFT$(COMANDO$, ESPACO - 1)
    NOME$ = MID$(COMANDO$, ESPACO + 1)
  END IF
  PALAVRAO = 0
  FOR I = 1 TO NUMPALAVROES
    IF PALAVROES$(I) = PALAVRA$ OR PALAVROES$(I) = NOME$ THEN
      QTDEPALAVROESDITOS = QTDEPALAVROESDITOS + 1
      PALAVRAO = 1
    END IF
  NEXT I
  IF QTDEPALAVROESDITOS > 10 THEN
    COLOR 15, 0, 0
    CLS
    COLOR 31
    PLAY "O2L2C"
    PRINT "ERRO INTERNO # 143 ! FALTA DE BONS COSTUMES ! ABORTAR..."
    COLOR 15
    PRINT "Seja mais educado na próxima vez..."
    FOR J = 1 TO 10
      TECLALISTA$ = RIGHT$(TIME$, 2)
      WHILE TECLALISTA$ = RIGHT$(TIME$, 2)
      WEND
    NEXT J
    CLS
    END
  END IF
  IF PALAVRAO THEN
    MENSAGEM$ = "Você não deveria ser tão mal-educado com um jogo como este."
    GOSUB MostraMensagem
    GOSUB LeComando
    GOTO AnalisaComando
  END IF
  INDICEVERBO = 0
  FOR I = 1 TO NUMSINONIMOS
    IF PALAVRA$ = SINONIMOVERBO$(I) THEN INDICEVERBO = I
  NEXT I
  IF INDICEVERBO = 0 THEN
    AVISO$ = "Não entendi o verbo " + PALAVRA$
    GOSUB MostraAviso
    COMANDOINVALIDO = 1
    RETURN
  END IF
  IF NOME$ = "" AND PARAM(INDICEVERBO) = 2 THEN
    AVISO$ = PALAVRA$ + " O QUE ?"
    GOSUB MostraAviso
    COMANDOINVALIDO = 1
    RETURN
  END IF
  OBJ = 0
  OBJACHADO = 0
  IF NOME$ = "LISTA TELEFONICA" THEN NOME$ = "LISTA"
  FOR I = 1 TO NUMOBJ
    IF NOME$ = OBJ$(I) AND OBJACHADO AND ABS(LOCOBJ(I)) = SALA THEN OBJ = I
    IF NOME$ = OBJ$(I) AND NOT OBJACHADO THEN OBJ = I : OBJACHADO = -1
  NEXT I
  IF NOME$ = "DINHEIRO" THEN OBJ = 26 ' Grana
  IF (NOME$ = "LUGAR" OR NOME$ = NOMESALA$) AND OBJ = 0 THEN OBJ = 10 ' 10=Local
  IF OBJ = 0 AND PARAM(INDICEVERBO) = 2 THEN
    AVISO$ = "O que você quer dizer com " + NOME$ + " ?"
    GOSUB MostraAviso
    COMANDOINVALIDO = 1
    RETURN
  END IF
  IF NOME$ <> "" AND PARAM(INDICEVERBO) = 0 THEN
    AVISO$ = PALAVRA$ + " não combina com " + NOME$
    GOSUB MostraAviso
    COMANDOINVALIDO = 1
    RETURN
  END IF
  COMANDOINVALIDO = 0
  RETURN

' Tira espaços repetidos e as palavras de FILTRO$ (artigos, preposições...).
LimpaComando:
  POSDUPLOESPACO = INSTR(COMANDO$, "  ")
  IF POSDUPLOESPACO <> 0 THEN
    COMANDO$ = LEFT$(COMANDO$, POSDUPLOESPACO) + MID$(COMANDO$, _
        POSDUPLOESPACO + 2)
    GOTO LimpaComando
  END IF
  IF LEFT$(COMANDO$, 1) = " " THEN
    COMANDO$ = MID$(COMANDO$, 2)
    GOTO LimpaComando
  END IF
  IF RIGHT$(COMANDO$, 1) = " " THEN
    COMANDO$ = LEFT$(COMANDO$, LEN(COMANDO$) - 1)
    GOTO LimpaComando
  END IF
  FOR K = 1 TO NUMFILTRO
    POSFILTRO = INSTR(COMANDO$, FILTRO$(K))
    IF POSFILTRO <> 0 THEN
      COMANDO$ = LEFT$(COMANDO$, POSFILTRO - 1) + MID$(COMANDO$, POSFILTRO + _
          LEN(FILTRO$(K)) - 1)
    END IF
  NEXT K
  RETURN

' Moldura, título e janelas (depois disso elas só são atualizadas).
DesenhaTelaInicial:
  LOCATE 1, 1
  COLOR 11, 10, 2
  CLS
  PRINT "╔"; STRING$(78, "═"); "╗"; "║    ";
  COLOR 15
  PRINT TITULO$;
  COLOR 11
  PRINT "    ║"; "╚"; STRING$(78, "═"); "╝"; "╔"; STRING$(58, _
      "═"); "╗╔"; STRING$(18, "═"); "╗";
  FOR LIN = 5 TO 15
    LOCATE LIN, 1
    PRINT "║";
    LOCATE LIN, 60
    PRINT "║║";
    LOCATE LIN, 80
    PRINT "║";
  NEXT LIN
  PRINT "╚"; STRING$(58, "═"); "╝╚"; STRING$(18, "═"); "╝"; "╔"; STRING$(12, _
      "═"); "╗╔"; STRING$(64, "═"); "╗"; "║    ";
  COLOR 8
  PRINT "";
  COLOR 11
  PRINT "       ║║"; SPACE$(64); "║"; "║";
  COLOR 8
  PRINT "    N     C ";
  COLOR 11
  PRINT "║╚"; STRING$(64, "═"); "╝"; "║";
  COLOR 8
  PRINT " O   L " + CHR$(26) + "  ";
  COLOR 11
  PRINT "║╔"; STRING$(64, "═"); "╗"; "║";
  COLOR 8
  PRINT "    S     B ";
  COLOR 11
  PRINT "║║"; SPACE$(64); "║"; "║";
  COLOR 8
  PRINT "           ";
  COLOR 11
  PRINT "║║"; SPACE$(64); "║"; "╚"; STRING$(12, "═"); "╝╚"; STRING$(64, _
      "═"); "╝";
  COLOR 15, 0
  LOCATE 4, 26
  PRINT " Mensagens "
  LOCATE 4, 67
  PRINT " Objetos "
  LOCATE 17, 3
  PRINT " Direções "
  LOCATE 17, 42
  PRINT " Comando "
  LOCATE 20, 38
  PRINT " Avisos e Extras "
  COLOR 11, 10
  RETURN

' **************************************************************
' VERBOS
' Uma sub-rotina por verbo, escolhida por ON ... GOSUB no loop principal.
' O comentário antes de cada uma lista as palavras que a acionam.
' **************************************************************
' NORTE, N
Verbo1Norte:
  IF SAIDANORTE = 0 THEN
    AVISO$ = "SUA ANTA ! Você não pode ir para o norte !!!"
    GOSUB MostraAviso
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  SALA = SAIDANORTE
  RETURN

' SUL, S
Verbo2Sul:
  IF SALA = 11 AND VISITADA(9) = 0 THEN ' 11=Faculdade, 9=Praca
    MENSAGEM$ = "O vigia barra seu caminho. 'Esta passagem é apenas para " + _
        "alunos da faculdade', ele diz."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF SALA = 11 THEN ' Faculdade
    MENSAGEM$ = "O vigia olha para você com desprezo e diz 'Pode passar. " + _
        "Com esta careca, só pode ser bicho... Que raça abominável !'"
    GOSUB MostraMensagem
  END IF
  IF SAIDASUL = 0 THEN
    AVISO$ = "SUA ANTA ! Você não pode ir para o sul !!!"
    GOSUB MostraAviso
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  SALA = SAIDASUL
  RETURN

' LESTE, L
Verbo3Leste:
  IF SAIDALESTE = 0 THEN
    AVISO$ = "SUA ANTA ! Você não pode ir para o leste !!!"
    GOSUB MostraAviso
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  SALA = SAIDALESTE
  RETURN

' OESTE, O
Verbo4Oeste:
  IF SAIDAOESTE = 0 THEN
    AVISO$ = "SUA ANTA ! Você não pode ir para o oeste !!!"
    GOSUB MostraAviso
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  SALA = SAIDAOESTE
  RETURN

' IR, ENTRAR
Verbo5Ir:
  ON OBJ GOTO Verbo1Norte, Verbo2Sul, Verbo3Leste, Verbo4Oeste
  IF OBJ = 11 AND SALA = 4 THEN SALA = 5 : RETURN ' 11=Salao, 4=Calcadao, 5=Biblioteca
  IF OBJ = 19 THEN GOTO Verbo11Cima ' Cima
  IF OBJ = 20 THEN GOTO Verbo12Baixo ' Baixo
  IF OBJ = 13 AND SALA = 4 THEN GOTO Verbo2Sul ' 13=Porta, 4=Calcadao
  IF OBJ = 46 AND SALA = 35 THEN GOTO Verbo12Baixo ' 46=Tubo, 35=Salinha
  IF OBJ = 17 AND SALA <> 5 THEN ' 17=Balcao, 5=Biblioteca
    MENSAGEM$ = "Não posso."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 17 AND LOCOBJ(14) <> 0 THEN ' 17=Balcao, 14=Balconista
    MENSAGEM$ = "'Sinto muito, mas esta área é restrita a funcionários...' " + _
        "- diz a balconista, num tom de voz mais do que educado."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 17 THEN SALA = 6 : RETURN ' 17=Balcao, 6=Balcao
  IF OBJ = 18 AND SALA = 6 THEN SALA = 7 : RETURN ' 18=Escada, 6=Balcao, 7=Deposito
  IF OBJ = 35 AND SALA = 57 AND PORTAABERTA = 0 THEN ' 35=Porta, 57=Agencia
    MENSAGEM$ = "Ela está fechada..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 35 AND SALA = 57 THEN GOTO Verbo3Leste ' 35=Porta, 57=Agencia
  MENSAGEM$ = "Você não pode ir até isso !" : GOSUB MostraMensagem
  RETURN

' PEGAR, CATAR, APANHAR, TOMAR
Verbo6Pegar:
  IF OBJ = 82 AND SALA = 66 THEN ' 82=Soquete, 66=Esconderijo
    MENSAGEM$ = "ZZZZZZAAAP !!! Um choque de 220V escurece o local e a " + _
        "você, que morre carbonizado."
    GOSUB MostraMensagem
    GOTO FimDeJogoMorte
  END IF
  IF OBJ = 77 AND SALA = 66 AND LOCOBJ(77) = 66 THEN ' 77=Lampada, 66=Esconderijo
    MENSAGEM$ = "Tente desrosqueá-la."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 25 THEN GOTO Verbo14Ligar ' Onibus
  IF OBJ = 58 THEN ' Arame
    MENSAGEM$ = "Não dá. Ele está firmemente preso ao chão. A não ser que " + _
        "você 'dê um jeitinho'. Raciocine..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF LOCOBJ(OBJ) = -999 THEN
    MENSAGEM$ = "Não seja estúpido ! Você já tem isso !!!"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF ABS(LOCOBJ(OBJ)) <> SALA THEN
    MENSAGEM$ = "Este objeto não está aqui..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 78 THEN ' Bala
    EXAME$(60) = "Nem pense em fazer nada aí. Esta pia é nojenta."
  END IF
  IF OBJ = 65 THEN ' Lixo
    MENSAGEM$ = "Nem pense em levar isso. Eu não sou tão porco assim. Vou " + _
        "apenas tirá-lo do cesto e deixá-lo de lado."
    GOSUB MostraMensagem
    LOCOBJ(66) = SALA ' Agenda
    EXAME$(64) = "Tem uma agenda aqui dentro."
    RETURN
  END IF
  IF OBJ = 66 THEN ' Agenda
    AQUI$(66) = "Tem uma agenda aqui."
    EXAME$(64) = "Não tem nada aqui."
  END IF
  IF LOCOBJ(OBJ) < 0 THEN
    MENSAGEM$ = "Não posso pegar isso."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 41 THEN ' Bispo
    MENSAGEM$ = "Você pega o bispo sem constrangimento, pois ninguém daria " + _
        "pela falta de uma peça de xadrez."
  ELSE
    MENSAGEM$ = "Ok."
  END IF
  LOCOBJ(OBJ) = -999
  GOSUB MostraMensagem
  GOSUB AtualizaPainelObjetos
  RETURN

' LISTAR, INVENTARIO, OBJETOS
Verbo7Listar:
  NINV = 0
  FOR I = 1 TO NUMOBJ
    IF LOCOBJ(I) = -999 THEN NINV = NINV + 1 : INV$(NINV) = OBJ$(I)
  NEXT I
  IF NINV = 0 THEN NINV = 1 : INV$(1) = "NADA"
  TOPO = 1
  WHILE 1 = 1
    FOR I = 1 TO 11
      LOCATE 4 + I, 62
      PRINT SPACE$(16)
      LOCATE 4 + I, 62
      IF TOPO + I - 1 <= NINV THEN PRINT INV$(TOPO + I - 1)
    NEXT I
    IF SEMESPERA = 1 THEN RETURN
    LOCATE 21, 16
    PRINT "Digite " + CHR$(24) + " e " + CHR$(25) + " p/ ver objetos ou " + _
        "ENTER p/ continuar...";
    COLOR 31
    PRINT "■";
    COLOR 11
    TECLALISTA$ = ""
    WHILE TECLALISTA$ = "" : TECLALISTA$ = INKEY$ : WEND
    IF TECLALISTA$ = CHR$(0) + CHR$(72) AND TOPO <> 1 THEN TOPO = TOPO - 1
    IF TECLALISTA$ = CHR$(0) + CHR$(80) AND TOPO < NINV THEN TOPO = TOPO + 1
    IF TECLALISTA$ = CHR$(13) THEN LOCATE 21, 16 : PRINT SPACE$(54) : RETURN
  WEND

' LARGAR, DEIXAR, SOLTAR
Verbo8Largar:
  IF OBJ = 77 AND LOCOBJ(77) = -999 THEN ' 77=Lampada
    MENSAGEM$ = "Seu desastrado ! Você largou a lâmpada e ela se espatifou !"
    GOSUB MostraMensagem
    LOCOBJ(77) = 0 ' 77=Lampada
    RETURN
  END IF
  IF OBJ = 49 AND LOCOBJ(49) = -999 AND SALA = 40 THEN ' 49=Envelope, 40=Recepcao
    LOCOBJ(49) = 0 ' 49=Envelope
    MENSAGEM$ = "Você dá o envelope à secretária." : GOSUB MostraMensagem
    GOSUB AtualizaPainelObjetos
    MENSAGEM$ = "'Ah, pelo seu estilo capilar logo imaginei que era um " + _
        "office-boy'"
    GOSUB MostraMensagem
    MENSAGEM$ = "(suspiro)" : GOSUB MostraMensagem
    AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
    MENSAGEM$ = "'Venha comigo. Vou levá-lo ao hall' - diz ela, tomando-o " + _
        "pelo braço."
    GOSUB MostraMensagem
    SAIDANORTE = 41 ' Hall
    GOTO Verbo1Norte
  END IF
  IF OBJ = 31 THEN ' Fosforos
    MENSAGEM$ = "Pra que ? Apesar de você não fumar, eles podem ser úteis " + _
        "para aquecer, iluminar, etc."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Você não pode largar o que não tem..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 71 AND SALA = 62 THEN ' 71=CD, 62=Mesa
    MENSAGEM$ = "Você tira o CD do bolso e, imediatamente, o disk-jockey o " + _
        "apanha."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Oh, MUITO OBRIGADO ! DEUS LHE PAGUE !', diz ele."
    GOSUB MostraMensagem
    LOCOBJ(71) = 0 ' 71=CD
    RETURN
  END IF
  IF OBJ = 71 AND SALA = 59 THEN ' 71=CD, 59=Pista
    MENSAGEM$ = "O DJ sai da mesa lá no fundo e vem pegar o CD que você " + _
        "colocou num canto. Antes dele chegar, porém, os dançarinos " + _
        "esmagam o CD. Ele vê qual era o CD e corre até a rua, aonde " + _
        "comete suicídio. Felizmente o tape-deck mantém a música tocando"
    GOSUB MostraMensagem
    LOCOBJ(71) = 0 ' 71=CD
    LOCOBJ(72) = 0 ' 72=DJ
    GOSUB AtualizaPainelObjetos
    RETURN
  END IF
  IF OBJ = 26 THEN ' Grana
    MENSAGEM$ = "Sem essa de Papai Noel. Nada feito."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 41 AND SALA = 27 THEN ' 41=Bispo, 27=Fliperama
    MENSAGEM$ = "O velhinho percebe que você quer lhe dar a peça. Ele " + _
        "começa a gritar e babar."
    GOSUB MostraMensagem
    MENSAGEM$ = "'ACHEI !!! ACHEI !!! AGORA VOU TERMINAR O JOGO !!!!'"
    GOSUB MostraMensagem
    MENSAGEM$ = "Ele lhe dá uma marreta, e sai gritando 'BLAAAAAAAGH' ou " + _
        "algo semelhante."
    GOSUB MostraMensagem
    LOCOBJ(39) = 0 ' 39=Velhinho
    LOCOBJ(41) = 0 ' 41=Bispo
    LOCOBJ(42) = -999 ' 42=Marreta
    GOSUB AtualizaPainelObjetos
    RETURN
  END IF
  IF OBJ = 66 AND SALA = 39 THEN ' 66=Agenda, 39=FrenteDaBucanoWare
    MENSAGEM$ = "O homem do taxi pega a agenda que você entregou a ele. " + _
        "Ele abre na página em que você não entendia nada e, vociferando e " + _
        "gritando palvras estranhas, lhe aponta aonde fica o local. Ele " + _
        "olha para você, diz 'Heil' e abre a porta do carro."
    GOSUB MostraMensagem
    AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
    MENSAGEM$ = "Vocês entram. A viagem não é longa, pois o cara parece " + _
        "conhecer a cidade. Apesar de não saber para onde está indo (sabe " + _
        "lá que local este Sr. L. anotou naquela agenda), você sente que " + _
        "está na pista certa. Pena que o taxista não fala sua"
    MENSAGEM$ = MENSAGEM$ + " língua. Ele seria de grande ajuda..."
    GOSUB MostraMensagem
    MENSAGEM$ = "O taxi para. Você desce e lhe dá quase todo o seu " + _
        "dinheiro. Ele olha para você, com aquela cara de quem está doido " + _
        "para conversar, mas acelera o carro."
    GOSUB MostraMensagem
    GRANA = 5
    AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
    MENSAGEM$ = "Antes de sumir, ele põe a cabeça para fora e grita: " + _
        "'Valeu, mané. A gente se vê por aí...'"
    GOSUB MostraMensagem
    MENSAGEM$ = "(suspiro)" : GOSUB MostraMensagem
    GOSUB MostraAviso
    SALA = 56 ' Bairro
    RETURN
  END IF
  IF (OBJ = 21 OR OBJ = 22) AND LANTERNA$ = "ligada" THEN ' 21=Lanterna, 22=Pilhas
    MENSAGEM$ = "Desligue a lanterna antes"
    GOSUB MostraMensagem
    RETURN
  END IF
  LOCOBJ(OBJ) = SALA
  MENSAGEM$ = "Ok." : GOSUB MostraMensagem
  GOSUB AtualizaPainelObjetos
  RETURN

' OLHAR, VER, EXAMINAR, OBSERVAR, VERIFICAR
Verbo9Olhar:
  IF OBJ = 44 AND SALA <> 31 THEN ' 44=Parede, 31=BanheiroFeminino
    MENSAGEM$ = "Nada ali vai lhe ajudar..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF (OBJ = 73 OR OBJ = 19) AND SALA = 66 AND LOCOBJ(77) <> 66 THEN ' 73=Teto, 19=Cima, 66=Esconderijo, 77=Lampada
    MENSAGEM$ = "Há um soquete de lâmpada no teto."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF (OBJ = 73 OR OBJ = 19) AND SALA = 66 THEN ' 73=Teto, 19=Cima, 66=Esconderijo
    MENSAGEM$ = "Tem uma lâmpada no teto."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 73 OR OBJ = 75 OR OBJ = 19 OR OBJ = 20 THEN ' 73=Teto, 75=Chao, 19=Cima, 20=Baixo
    MENSAGEM$ = EXAME$(OBJ)
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 26 THEN ' Grana
    MENSAGEM$ = "Você tem $" + MID$(STR$(GRANA), 2)
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 12 AND SALA <> 4 THEN ' 12=Placa, 4=Calcadao
    MENSAGEM$ = "Não estou vendo nada parecido aqui."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 10 OR OBJ = 23 OR OBJ = 24 THEN ' 10=Local, 23=Sala, 24=Area
    GOSUB DescreveSala
    GOSUB MostraObjetosDaSala
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  IF OBJ >= 1 AND OBJ <= 4 THEN
    MENSAGEM$ = "Deixe de ser preguiçoso e ande até lá !!!"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF ABS(LOCOBJ(OBJ)) <> SALA AND LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Não estou vendo nada parecido aqui."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF SALA = 19 AND NOMESALA$ = "" AND (OBJ = 5 OR OBJ = 6 OR OBJ = 15 OR _
      OBJ = 16 OR OBJ = 26 OR OBJ = 49 OR OBJ = 28) THEN ' 19=DepositoDePapel, 5=Lista, 6=Azulejo, 15=Livro, 16=Papel, 26=Grana, 49=Envelope, 28=Borracha
    MENSAGEM$ = "Não consigo ver nada."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 5 AND LOCOBJ(5) = -999 THEN ' 5=Lista
    PAGINA = 1 - PAGINA * (PAGINA <> 4)
    MENSAGEM$ = DESCLISTA$(PAGINA)
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 5 THEN MENSAGEM$ = "Não a tenho." : GOSUB MostraMensagem : RETURN ' Lista
  IF OBJ = 9 THEN ' Poste
    MENSAGEM$ = "É um ponto de ônibus."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 21 AND LOCOBJ(22) = -999 THEN ' 21=Lanterna, 22=Pilhas
    MENSAGEM$ = "Ela está " + LANTERNA$
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 35 AND PORTAABERTA = 1 THEN ' 35=Porta
    MENSAGEM$ = "Ela está aberta."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 35 AND PORTAABERTA = 0 THEN ' 35=Porta
    MENSAGEM$ = "Ela está fechada."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 37 AND LOCOBJ(OBJ) = -999 AND LOCOBJ(38) = 0 THEN ' 37=Carteira, 38=Cartao
    MENSAGEM$ = "Temos um cartão aqui."
    GOSUB MostraMensagem
    LOCOBJ(38) = -999 ' 38=Cartao
    GOSUB AtualizaPainelObjetos
    RETURN
  END IF
  IF OBJ = 45 AND SALA = 35 AND GRANA < 5000 THEN ' 45=Cofre, 35=Salinha
    MENSAGEM$ = "Temos uns $5000 aqui. Nem precisa mandar pegar o dinheiro."
    GRANA = GRANA + 5000
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = EXAME$(OBJ) : GOSUB MostraMensagem
  RETURN

' FALAR, CONVERSAR
Verbo10Falar:
  IF ABS(LOCOBJ(OBJ)) <> SALA THEN
    MENSAGEM$ = "Aonde você vê isso ?"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 72 THEN ' DJ
    MENSAGEM$ = "'Ei, você conhece este local ?'" : GOSUB MostraMensagem
    MENSAGEM$ = "'O quê'" : GOSUB MostraMensagem
    MENSAGEM$ = "'Eu perguntei se você conhece isto aqui ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'O QUE ?'" : GOSUB MostraMensagem
    AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
    MENSAGEM$ = "'EU PERGUNTEI SE VOCE CONHECE ESTA POCILGA !!!!!!"
    GOSUB MostraMensagem
    MENSAGEM$ = "'COMO É ?'" : GOSUB MostraMensagem
    MENSAGEM$ = "Você desiste. Com este som alto não vai ter jeito."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 67 THEN ' Grupo
    MENSAGEM$ = "Eles só se interessam em dançar. Aliás, acho que não " + _
        "parariam por nada deste mundo."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 69 AND BARMAN = 1 THEN ' 69=Barman
    MENSAGEM$ = "'Nada disso' - diz Moe - 'Você já passou da cota esta noite'"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 69 THEN ' Barman
    MENSAGEM$ = "'Olá, Moe (você já supôs que todo garçom de danceteria se " + _
        "chama Moe ou Sam)."
    GOSUB MostraMensagem
    MENSAGEM$ = "'E então, chefe. Vai o de sempre ?'" : GOSUB MostraMensagem
    MENSAGEM$ = "'Claro' - você diz, feliz de ter sido confundido com " + _
        "algum dos sócios."
    GOSUB MostraMensagem
    AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
    MENSAGEM$ = "'Aqui está. É por conta da casa, outro dia você acerta...'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Obrigado'. Ao olhar para a massa no copo, você diz: 'Ei, " + _
        "o que é isso ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'O seu milk-shake. Como sempre foi seu pedido. Lembro bem " + _
        "do dia em que você pediu ½ copo de cerveja e voltou bêbado para " + _
        "casa... Ha Ha !!'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Grunf', você diz, tomando o milk-shake. Em certo " + _
        "momento, você para e pensa: 'Será que eu já vim aqui e não me " + _
        "lembro ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Obrigado', diz Moe, tirando o copo na metade. 'Volte sempre'"
    GOSUB MostraMensagem
    BARMAN = 1
    RETURN
  END IF
  IF OBJ = 8 THEN ' Homem
    MENSAGEM$ = "Talvez isso não vá fazer muito bem à sua saúde. Ele não é " + _
        "o que se chamaria de 'tipo amigável'."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 27 THEN ' Vigia
    MENSAGEM$ = "'Bom dia. Por favor, eu gostaria de procurar meu disquete " + _
        "por aqui, no laboratório da faculdade...'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'E eu com isso ?', diz ele, enquanto começa a roer a unha."
    GOSUB MostraMensagem
    MENSAGEM$ = "(suspiro)" : GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 54 THEN ' Analistas
    MENSAGEM$ = "Você fica falando sozinho, pois todos o ignoram. Afinal " + _
        "de contas, você não tem nada que lhes interesse..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 55 THEN ' Programadores
    MENSAGEM$ = "Inútil. Eles estão muito ocupados com o jogo."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 14 THEN ' Balconista
    AVISO$ = "Digite qualquer tecla..."
    MENSAGEM$ = "'Bom dia. Em que posso servi-lo ?'" : GOSUB MostraMensagem
    MENSAGEM$ = "'Seu sorriso já o fez...' - você responde, e ela dá uma " + _
        "risadinha maliciosa - 'O que você tem de interessante aqui ?'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Leve este aqui' - ela diz. Neste momento, um homem " + _
        "adentra a sala e abraça-a. Ela muda de expressão, confusa. " + _
        "Discretamente, anota qualquer coisa num papel e o coloca dentro " + _
        "do livro."
    GOSUB MostraMensagem
    LOCOBJ(14) = 0 ' 14=Balconista
    LOCOBJ(15) = -999 ' 15=Livro
    LOCOBJ(16) = -999 ' 16=Papel
    GOSUB AtualizaPainelObjetos
    MENSAGEM$ = "'Mais alguma coisa ?' - ela diz, suspirando quando o " + _
        "homem sai."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Por enquanto não. Mas quem sabe em outra " + _
        "oportunidade...' - você diz, enquanto ela se retira com o eterno " + _
        "sorriso."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Essa foi boa' - você pensa, enquanto observa ela sair " + _
        "pela porta afora. Mas você ainda tem um jogo para jogar. Tire " + _
        "esta expressão ridícula do seu rosto, rapaz !!!"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 30 THEN ' Secretaria
    MENSAGEM$ = "Esquece. Ela não vai acordar, e mesmo que o fizesse, " + _
        "cinco minutos de conversa com você seriam suficientes para que " + _
        "ela voltasse a dormir"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 39 THEN ' Velhinho
    MENSAGEM$ = "'Bom dia, ó bom velhinho !' - você diz, alegremente."
    GOSUB MostraMensagem
    MENSAGEM$ = "'XADREZZZZZ !' - ele responde - 'Traga o XADREZZZZZ !'"
    GOSUB MostraMensagem
    MENSAGEM$ = "Você o fita por alguns segundos, e ele se vira novamente " + _
        "para a máquina, ignorando-o."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 47 THEN ' Taxista
    MENSAGEM$ = "'Bom dia. O senhor anda bastante por aqui ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "Ele diz: 'Chucrutz WolksVagen MercedesBens Kibe " + _
        "HeilHitler', ou algo assim."
    GOSUB MostraMensagem
    MENSAGEM$ = "'É, tio, acho que você não fala a minha língua...', você " + _
        "diz, virando as costas para ele."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 50 AND SALA = 40 THEN ' 50=Recepcionista, 40=Recepcao
    MENSAGEM$ = "'Escute, srta., isto é muito importante'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Isto o QUE ? Você não tem nada a oferecer ao Sr. L, logo " + _
        "explique-se ou retire-se, por favor.'"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 41 AND (SALA = 29 OR LOCOBJ(41) = -999) THEN ' 41=Bispo, 29=Hall
    MENSAGEM$ = "Talvez ele não tenha muito o que falar."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Você deveria se sentir ridículo conversando com isso."
  GOSUB MostraMensagem
  RETURN

' CIMA, C, SUBIR
Verbo11Cima:
  IF SAIDACIMA = 0 THEN
    AVISO$ = "SUA ANTA ! Você não pode ir para cima !!!"
    GOSUB MostraAviso
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  SALA = SAIDACIMA
  RETURN

' BAIXO, B, DESCER
Verbo12Baixo:
  IF SAIDABAIXO = 0 THEN
    AVISO$ = "SUA ANTA ! Você não pode ir para baixo !!!"
    GOSUB MostraAviso
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  SALA = SAIDABAIXO
  RETURN

' LER
Verbo13Ler:
  IF ABS(LOCOBJ(OBJ)) <> SALA AND LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Aonde está isso ?"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF SALA = 19 AND NOMESALA$ = "" THEN ' DepositoDePapel
    MENSAGEM$ = "O ministério da saúde adverte: Ler no escuro é " + _
        "prejudicial à saúde."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 12 OR OBJ = 16 OR OBJ = 66 THEN GOTO Verbo9Olhar ' 12=Placa, 16=Papel, 66=Agenda
  IF OBJ = 15 THEN ' Livro
    MENSAGEM$ = "Cê pirou ? Isso vai levar o mês inteiro, cara, e você tem " + _
        "um jogo para jogar..."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Não posso ler isso" : GOSUB MostraMensagem
  RETURN

' LIGAR, USAR, ACENDER
Verbo14Ligar:
  IF OBJ <> 21 AND PALAVRA$ = "LIGAR" THEN ' Lanterna
    MENSAGEM$ = "Como diabos você vai ligar isso ?"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 60 THEN GOTO Verbo9Olhar ' PIA
  IF (OBJ = 40 AND SALA = 30) OR (OBJ = 51 AND SALA = 42) OR (OBJ = 52 AND _
      SALA = 43) THEN ' 40=Elevador, 30=Elevador, 51=Elevador, 42=Elevador, 52=Elevador, 43=Elevador
    IF SALA = 43 THEN ' Elevador
      MENSAGEM$ = "Digite o número do sub-solo:"
    ELSE
      MENSAGEM$ = "Digite o número do andar:"
    END IF
    GOSUB MostraMensagem
    GOSUB LeComando
    IF OBJ = 40 THEN ' Elevador
      MENSAGEM$ = "O elevador não se move."
      GOSUB MostraMensagem
      RETURN
    END IF
    IF OBJ = 51 THEN ' Elevador
      IF LEN(COMANDO$) <> 1 OR INSTR("123", COMANDO$) = 0 THEN
        MENSAGEM$ = "O elevador não se move."
        GOSUB MostraMensagem
        RETURN
      END IF
      SALA = INSTR("123", COMANDO$) + 43
      ELEVMOVEU = 1
      RETURN
    END IF
    IF OBJ = 52 THEN ' Elevador
      IF LEN(COMANDO$) <> 1 OR INSTR("12", COMANDO$) = 0 THEN
        MENSAGEM$ = "O elevador não se move."
        GOSUB MostraMensagem
        RETURN
      END IF
      SALA = INSTR("12", COMANDO$) + 53
      ELEVMOVEU = 1
      RETURN
    END IF
  END IF
  IF OBJ = 34 AND LOCOBJ(34) = -999 AND SALA = 57 THEN ' 34=Passagem, 57=Agencia
    OBJ = 35 ' Porta
    GOTO Verbo15Abrir
  END IF
  IF OBJ = 21 THEN ' Lanterna
    IF LOCOBJ(21) <> -999 THEN ' 21=Lanterna
      MENSAGEM$ = "Não a tenho."
      GOSUB MostraMensagem
      RETURN
    END IF
    IF LOCOBJ(22) <> -999 THEN ' 22=Pilhas
      MENSAGEM$ = "Sem pilhas. Nada feito."
      GOSUB MostraMensagem
      RETURN
    END IF
    IF LANTERNA$ = "ligada" THEN
      MENSAGEM$ = "Ela já está ligada, toupeira !"
      GOSUB MostraMensagem
      RETURN
    END IF
    IF SALA = 19 THEN ' DepositoDePapel
      MENSAGEM$ = "Está muito escuro. Não consigo achá-la. Que tal " + _
          "iluminar o local com outra coisa ?"
      GOSUB MostraMensagem
      RETURN
    END IF
    IF SALA <> 17 THEN ' Almoxarifado
      MENSAGEM$ = "Melhor você economizar pilhas. Elas não durarão muito. " + _
          "Não vou acender."
      GOSUB MostraMensagem
      RETURN
    END IF
    MENSAGEM$ = "Você coloca as pilhas na lanterna e acende."
    GOSUB MostraMensagem
    LANTERNA$ = "ligada"
    RETURN
  END IF
  IF OBJ = 31 AND SALA = 19 THEN ' 31=Fosforos, 19=DepositoDePapel
    MENSAGEM$ = "Muito bem ! O local está mais iluminado. Veja esta caixa " + _
        "à sua frente. Há uma etiqueta nela. Deixe-me ver... ela contém... " + _
        "oh, NÃO ! FOGOS DE ARTIFíCIO !!! MELOU !!!"
    GOSUB MostraMensagem
    GOTO FimDeJogoMorte
  END IF
  IF OBJ = 31 AND SALA = 31 THEN ' 31=Fosforos, 31=BanheiroFeminino
    MENSAGEM$ = "Você põe fogo na madeira. Seria uma boa idéia, se o fogo " + _
        "não se espalhasse e chegasse a você..."
    GOSUB MostraMensagem
    GOTO FimDeJogoMorte
  END IF
  IF OBJ = 31 THEN ' Fosforos
    MENSAGEM$ = "Você acende um fósforo. Ele deve ser especial, pois " + _
        "ilumina muito bem o local. Depois de um certo tempo, ele apaga, " + _
        "não sem antes queimar o seu dedo"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 42 AND SALA = 31 AND LOCOBJ(42) = -999 THEN ' 42=Marreta, 31=BanheiroFeminino
    MENSAGEM$ = "Você destrói a parede e pula no buraco. Misteriosamente, " + _
        "um mecanismo coloca outra placa de madeira aonde havia a que você " + _
        "destruiu. Estranho..."
    GOSUB MostraMensagem
    SALA = 33 ' Poco
    RETURN
  END IF
  IF OBJ = 29 THEN GOTO Verbo9Olhar ' Mesa
  IF OBJ = 25 AND SALA <> 3 THEN ' 25=Onibus, 3=Calcada
    MENSAGEM$ = "Não aqui."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 25 THEN ' Onibus
    MENSAGEM$ = "Digite o nº da linha do ônibus:" : GOSUB MostraMensagem
    GOSUB LeComando
    IF VAL(COMANDO$) = 0 THEN
      MENSAGEM$ = "Não entendi. Nada feito."
      GOSUB MostraMensagem
      RETURN
    END IF
    AVISO$ = "Digite qualquer tecla..."
    MENSAGEM$ = "Você entra no ônibus. Este meio sem-vergonha de " + _
        "transporte continua cada vez mais sem-vergonha."
    GOSUB MostraMensagem
    MENSAGEM$ = "Ao chegar na metade do mesmo, depara com um indivíduo que " + _
        "tenta lhe mostrar exatamente o que comeu no almoço. Você passa " + _
        "direto e paga o motorista."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    GRANA = GRANA - 200
    MENSAGEM$ = "O ônibus para. Este é o ponto final. Todos descem, " + _
        "inclusive você."
    GOSUB MostraMensagem
    IF COMANDO$ <> "4283" THEN SALA = 20 ELSE SALA = 8 ' 20=BairroPerigoso, 8=Viela
    RETURN
  END IF
  IF OBJ = 79 AND LOCOBJ(79) = -999 AND LOCOBJ(77) = -999 THEN ' 79=Embalagem, 77=Lampada
    MENSAGEM$ = "Você coloca o papel-alumínio da bala em volta da lâmpada."
    GOSUB MostraMensagem
    LOCOBJ(79) = 0 ' 79=Embalagem
    PAPELALUM = 1
    GOSUB AtualizaPainelObjetos
    RETURN
  END IF
  MENSAGEM$ = "Você não pode usar isso !" : GOSUB MostraMensagem
  RETURN

' ABRIR
Verbo15Abrir:
  IF OBJ = 37 THEN GOTO Verbo9Olhar ' Carteira
  IF OBJ = 61 THEN MENSAGEM$ = "Já está aberta" : GOSUB MostraMensagem : RETURN ' Porta
  IF OBJ = 35 AND SALA = 57 AND PORTAABERTA = 1 THEN ' 35=Porta, 57=Agencia
    MENSAGEM$ = "A porta já está aberta."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 32 AND LOCOBJ(32) <> -999 THEN ' 32=Mala
    MENSAGEM$ = "Você não a tem."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 32 AND LOCOBJ(34) = 0 THEN ' 32=Mala, 34=Passagem
    MENSAGEM$ = "Há uma passagem de ônibus nela. Você a pega imediatamente."
    GOSUB MostraMensagem
    LOCOBJ(34) = -999 ' 34=Passagem
    GOSUB AtualizaPainelObjetos
    RETURN
  END IF
  IF OBJ = 32 THEN MENSAGEM$ = "Está vazia." : GOSUB MostraMensagem : RETURN ' Mala
  IF SALA = 57 AND OBJ = 35 AND LOCOBJ(34) = -999 THEN ' 57=Agencia, 35=Porta, 34=Passagem
    MENSAGEM$ = "Você coloca a passagem na abertura ao lado da porta, e " + _
        "ela se abre."
    GOSUB MostraMensagem
    PORTAABERTA = 1
    SAIDALESTE = 67 ' GaragemDeOnibus
    LOCOBJ(34) = -998 ' 34=Passagem; -998 e não 0, senão a Mala devolveria a passagem
    GOSUB AtualizaPainelObjetos
    GOSUB AtualizaPainelDirecoes
    RETURN
  END IF
  IF SALA = 57 AND OBJ = 35 THEN ' 57=Agencia, 35=Porta
    MENSAGEM$ = "Não dá. Ela é automática, e só abre se você tiver a passagem."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 45 THEN MENSAGEM$ = "Já está aberto." : GOSUB MostraMensagem : RETURN ' Cofre
  MENSAGEM$ = "Não posso abrir isso." : GOSUB MostraMensagem
  RETURN

' BEIJAR, ABRACAR
Verbo16Beijar:
  IF OBJ = 82 THEN GOTO Verbo6Pegar ' Soquete
  IF OBJ = 36000 THEN
    MENSAGEM$ = "Muito bem ! Agora digite o número da tela desejada:"
    GOSUB MostraMensagem
    GOSUB LeComando
    IF VAL(COMANDO$) = 999 THEN GOTO FimDeJogoFinal
    DESTINO = VAL(COMANDO$)
    IF DESTINO < 1 OR DESTINO > 66 THEN
      MENSAGEM$ = "Nada feito."
      GOSUB MostraMensagem
      RETURN
    END IF
    SALA = DESTINO
    RETURN
  END IF
  IF ABS(LOCOBJ(OBJ)) <> SALA AND LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Não está aqui..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 14 OR OBJ = 30 OR OBJ = 50 THEN ' 14=Balconista, 30=Secretaria, 50=Recepcionista
    MENSAGEM$ = "Vá com calma..."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Freud explica..." : GOSUB MostraMensagem
  RETURN

' MENU
Verbo17Menu:
  TECLAMENU$ = ""
  OPCAO = 1
  LOCATE 21, 16
  PRINT SPACE$(64);
  LOCATE 22, 16
  PRINT SPACE$(64);
  WHILE TECLAMENU$ <> CHR$(13)
    COLOR 15, (OPCAO <> 1) * -10
    LOCATE 21, 16
    PRINT " Gravar   "
    COLOR 15, (OPCAO <> 2) * -10
    LOCATE 22, 16
    PRINT " Carregar "
    COLOR 15, (OPCAO <> 3) * -10
    LOCATE 21, 36
    PRINT " Ajuda    "
    COLOR 15, (OPCAO <> 4) * -10
    LOCATE 22, 36
    PRINT " Notas    "
    COLOR 15, (OPCAO <> 5) * -10
    LOCATE 21, 56
    PRINT " Reinício "
    COLOR 15, (OPCAO <> 6) * -10
    LOCATE 22, 56
    PRINT " Fim      "
    COLOR 15, 10
    TECLAMENU$ = ""
    WHILE TECLAMENU$ = "" : TECLAMENU$ = INKEY$ : WEND
    OPCAO = OPCAO - (OPCAO < 6 AND (TECLAMENU$ = CHR$(0) + "P" OR _
        TECLAMENU$ = " " OR TECLAMENU$ = CHR$(9))) + (OPCAO > 1 AND _
        TECLAMENU$ = CHR$(0) + "H")
    OPCAO = OPCAO - 2 * (TECLAMENU$ = CHR$(0) + "M") + _
        2 * (TECLAMENU$ = CHR$(0) + "K")
    IF OPCAO > 6 THEN OPCAO = OPCAO - 6
    IF OPCAO < 1 THEN OPCAO = OPCAO + 6
    POSTECLA = INSTR("GgCcAaNnRrFf", TECLAMENU$)
    IF POSTECLA <> 0 THEN
      OPCAO = INT((POSTECLA + 1) / 2)
      TECLAMENU$ = CHR$(13)
    END IF
    IF TECLAMENU$ = CHR$(27) THEN
      LOCATE 21, 16
      PRINT SPACE$(64);
      LOCATE 22, 16
      PRINT SPACE$(64);
      RETURN
    END IF
  WEND
  LOCATE 21, 16
  PRINT SPACE$(64);
  LOCATE 22, 16
  PRINT SPACE$(64);
  IF OPCAO = 1 THEN GOSUB GravaJogo
  IF OPCAO = 2 THEN GOSUB CarregaJogo
  IF OPCAO = 3 THEN GOSUB MostraAjuda
  IF OPCAO = 4 THEN GOSUB MostraNotas
  IF OPCAO = 5 THEN
    AVISO$ = "Digite «S» para reinciar ou outra tecla para continuar..."
    GOSUB MostraAviso
    IF TECLA$ = "S" OR TECLA$ = "s" THEN CLEAR : GOTO Inicio
  END IF
  IF OPCAO = 6 THEN GOSUB Verbo20Sair
  RETURN

' CHUPAR
Verbo18Chupar:
  IF LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Você não tem isso !"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ <> 78 THEN ' Bala
    MENSAGEM$ = "Isso pode ser muito perigoso. Melhor evitar..."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Você abre a bala e joga fora o papel. A bala está meio " + _
      "passada, mas mesmo assim a sensação é refrescante."
  GOSUB MostraMensagem
  LOCOBJ(78) = 0 ' 78=Bala
  LOCOBJ(79) = SALA ' Embalagem
  GOSUB AtualizaPainelObjetos
  RETURN

' QUEBRAR, DETONAR, ARREBENTAR, DESTRUIR
Verbo19Quebrar:
  IF (OBJ = 43 OR OBJ = 44) AND SALA = 31 THEN ' 43=Madeira, 44=Parede, 31=BanheiroFeminino
    MENSAGEM$ = "É muito forte para você. Tente usar algum instrumento " + _
        "para isso..."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Você não tem isso !"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ <> 74 THEN ' NOZ
    MENSAGEM$ = "Você não é homem o suficiente..."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Você quebra a noz, ansioso para comê-la, mas na verdade só " + _
      "encontra uma chave ali."
  GOSUB MostraMensagem
  LOCOBJ(74) = 0 ' 74=NOZ
  LOCOBJ(76) = -999 ' 76=Chave
  GOSUB AtualizaPainelObjetos
  RETURN

' SAIR, ABANDONAR
Verbo20Sair:
  AVISO$ = "Digite «S» para sair ao DOS ou outra tecla para jogar..."
  GOSUB MostraAviso
  IF TECLA$ = "S" OR TECLA$ = "s" THEN GOTO SaiParaODos
  RETURN

' DIZER
Verbo21Dizer:
  IF OBJ <> 81 THEN ' NI
    MENSAGEM$ = "Engraçado, ninguém responde..."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Oh, mas aonde este mundo foi parar, se nobres cavaleiros " + _
      "ficam dizendo 'ni' a torto e direito por aí..."
  GOSUB MostraMensagem
  RETURN

' FECHAR, DESLIGAR
Verbo22Fechar:
  IF OBJ = 21 AND LANTERNA$ = "ligada" THEN ' Lanterna
    MENSAGEM$ = "Ah, agora que você ligou, deixe assim."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Não perca tempo fechando ou desligando as coisas neste " + _
      "jogo. É inútil e muito educado para você."
  GOSUB MostraMensagem
  RETURN

' ROSQUEAR
Verbo23Rosquear:
  IF LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Não posso rosquear o que não tenho."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ <> 77 THEN MENSAGEM$ = "Cê pirou ?" : GOSUB MostraMensagem : RETURN ' Lampada
  IF PAPELALUM THEN GOTO FimDeJogoFinal
  MENSAGEM$ = "Ok."
  LOCOBJ(77) = 66 ' 77=Lampada, 66=Esconderijo
  GOSUB MostraMensagem
  RETURN

' DESROSQUEAR
Verbo24Desrosquear:
  IF OBJ <> 77 THEN ' Lampada
    MENSAGEM$ = "Como vou desrosquear esta biromba ?"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF SALA <> 66 THEN ' Esconderijo
    MENSAGEM$ = "Não está aqui."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF LOCOBJ(OBJ) = -999 THEN
    MENSAGEM$ = "Já está desrosqueada e nas suas mãos."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF LOCOBJ(OBJ) = 0 THEN
    MENSAGEM$ = "Agora é tarde. Você a destruiu, palerma."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Ok."
  LOCOBJ(77) = -999 ' 77=Lampada
  GOSUB MostraMensagem
  RETURN

' VOAR
Verbo25Voar:
  MENSAGEM$ = "Você sai, livre como um pássaro, atravessa vales e " + _
      "montanhas, mas logo acorda e retorna ao jogo."
  GOSUB MostraMensagem
  RETURN

' MORDER, XINGAR, BATER, ESPANCAR, LAMBER
Verbo26Morder:
  MENSAGEM$ = "Você não é tão animal assim." : GOSUB MostraMensagem
  RETURN

' COMER
Verbo27Comer:
  IF LOCOBJ(OBJ) <> -999 THEN
    MENSAGEM$ = "Não posso comer o que não tenho."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 74 AND AVISOUSOBRENOZ = 0 THEN ' 74=NOZ
    MENSAGEM$ = "Melhor não. Ela pode lhe ser útil se você não a comer."
    AVISOUSOBRENOZ = 1
    GOSUB MostraMensagem
    RETURN
  END IF
  IF OBJ = 74 THEN ' NOZ
    MENSAGEM$ = "Já que você insiste... Você a engole. Ela fica engasgada " + _
        "na sua garganta. Você começa a tossir, e ver o mundo ficar verde, " + _
        "rosa, azul, amarelo, branco com bolinhas vermelhas, e, " + _
        "finalmente, negro..."
    GOSUB MostraMensagem
    GOTO FimDeJogoMorte
  END IF
  MENSAGEM$ = "Isso não é muito digestivo. Talvez com um sal de frutas vá, " + _
      "mas como você não o tem..."
  GOSUB MostraMensagem
  RETURN

' CHEIRAR
Verbo28Cheirar:
  IF SALA = 6 THEN ' Balcao
    MENSAGEM$ = "O aroma é agradável."
    GOSUB MostraMensagem
    RETURN
  END IF
  IF SALA = 32 THEN MENSAGEM$ = "ECA !" : GOSUB MostraMensagem : RETURN ' BanheiroMasculino
  MENSAGEM$ = "Não sinto nada de anormal no cheiro." : GOSUB MostraMensagem
  RETURN

' ATRAVESSAR
Verbo29Atravessar:
  IF OBJ <> 86 THEN ' RUA
    MENSAGEM$ = "Como vou atravessar isso ?"
    GOSUB MostraMensagem
    RETURN
  END IF
  IF SALA <> 3 AND SALA <> 56 THEN ' 3=Calcada, 56=Bairro
    MENSAGEM$ = "Não existe nenhuma rua aqui que possa ser atravessada."
    GOSUB MostraMensagem
    RETURN
  END IF
  MENSAGEM$ = "Você decide tomar coragem. Após achar a faixa de pedestres " + _
      "e aguardar sua vez no farol, olha para a esquerda. Nada."
  GOSUB MostraMensagem
  MENSAGEM$ = "Olhando para a direita, também não vê nada. É seguro. É " + _
      "tranqüilo. Você se prepara e dá o primeiro passo."
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  MENSAGEM$ = "Neste instante, uma JAMANTA 246 avança sobre você. Você sai " + _
      "numa corrida desenfreada, e cai na outra mão. Na outra mão, o " + _
      "ônibus Terminal São Mateus (vulgo 'Trovão Azul') o persegue, " + _
      "deixando-o sem saída."
  GOSUB MostraMensagem
  MENSAGEM$ = "Você pula num bueiro, derrubando a placa de 'HOMENS " + _
      "TRABALHANDO'. Ufa, que alívio ! Você escapou da morte nas mãos de " + _
      "motoristas irresponsáveis."
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  MENSAGEM$ = "Mas, infelizmente, você foi mordido por um rato e morreu de " + _
      "peste bubônica, instantaneamente (?!?!?). É a vida..."
  GOSUB MostraMensagem
  GOTO FimDeJogoMorte

' PULAR
Verbo30Pular:
  MENSAGEM$ = "Você pensa em pular, como um cervo alegre e radiante " + _
      "atravessando campos e plantações, mas deixa de frescura e desiste " + _
      "da idéia"
  GOSUB MostraMensagem
  RETURN

' JOGAR, BRINCAR, PASSEAR, DORMIR, CAVALGAR, MASTURBAR
Verbo31Jogar:
  MENSAGEM$ = "Não estou com disposição para isso por enquanto."
  GOSUB MostraMensagem
  RETURN

' ARREMESSAR, LANCAR
Verbo32Arremessar:
  MENSAGEM$ = "Não é uma boa idéia..." : GOSUB MostraMensagem
  RETURN

' SENTAR, DEITAR
Verbo33Sentar:
  MENSAGEM$ = "Aqui ? Nada feito, chapa." : GOSUB MostraMensagem
  RETURN

' APAGAR
Verbo34Apagar:
  MENSAGEM$ = "Não entendo quais são seus planos. Tente fazer algo mais " + _
      "coerente..."
  GOSUB MostraMensagem
  RETURN

' **************************************************************
' USO GERAL
' Avisos, mensagens e painéis.
' **************************************************************
MostraAviso:
  IF LEN(AVISO$) > 63 THEN AVISO$ = LEFT$(AVISO$, 63)
  LOCATE 21, 16
  PRINT SPACE$(64);
  LOCATE 21, 16
  PRINT AVISO$;
  COLOR 31
  PRINT "■";
  COLOR 11
  LOCATE 1, 1
  TECLA$ = INPUT$(1)
  LOCATE 21, 16
  PRINT SPACE$(64);
  RETURN

MostraMensagem:
  COL = 1
  MENSAGEM$ = MENSAGEM$ + " "
  WHILE MENSAGEM$ <> ""
    TRECHO$ = LEFT$(MENSAGEM$, INSTR(MENSAGEM$, " "))
    COL = COL + LEN(TRECHO$)
    IF COL > 58 THEN GOSUB RolaJanelaDeMensagens : COL = LEN(TRECHO$) + 1
    LINHAMSG$ = LINHAMSG$ + TRECHO$
    MENSAGEM$ = MID$(MENSAGEM$, INSTR(MENSAGEM$, " ") + 1)
    IF INKEY$ = "X" THEN PRINT MENSAGEM$,LEN(MENSAGEM$) : END
  WEND
  GOSUB RolaJanelaDeMensagens
  GOSUB RolaJanelaDeMensagens
  RETURN

' Acrescenta LINHAMSG$ no fim da janela, empurrando as outras para cima.
RolaJanelaDeMensagens:
  COLOR 15
  FOR I = 1 TO 10
    JANELA$(I) = JANELA$(I + 1)
    LOCATE I + 4, 2
    PRINT SPACE$(58);
    LOCATE I + 4, 2
    PRINT JANELA$(I);
  NEXT I
  JANELA$(11) = LINHAMSG$
  LOCATE 15, 2
  PRINT SPACE$(58)
  LOCATE 15, 2
  PRINT JANELA$(11)
  LINHAMSG$ = ""
  COLOR 11
  RETURN

MostraObjetosDaSala:
  OBJSALA$ = ""
  FOR I = 1 TO NUMOBJ
    IF ABS(LOCOBJ(I)) = SALA AND AQUI$(I) <> "" THEN
      OBJSALA$ = OBJSALA$ + AQUI$(I) + " "
    END IF
  NEXT I
  MENSAGEM$ = OBJSALA$
  IF OBJSALA$ <> "" THEN GOSUB MostraMensagem
  RETURN

AtualizaPainelObjetos:
  SEMESPERA = 1
  GOSUB Verbo7Listar
  SEMESPERA = 0
  RETURN

AtualizaPainelDirecoes:
  COLOR 8
  IF SAIDANORTE THEN COLOR 15
  LOCATE 19, 6
  PRINT "N"
  COLOR 8
  IF SAIDASUL THEN COLOR 15
  LOCATE 21, 6
  PRINT "S"
  COLOR 8
  IF SAIDALESTE THEN COLOR 15
  LOCATE 20, 8
  PRINT "L"
  COLOR 8
  IF SAIDAOESTE THEN COLOR 15
  LOCATE 20, 4
  PRINT "O"
  COLOR 8
  IF SAIDACIMA THEN COLOR 15
  LOCATE 19, 12
  PRINT "C"
  COLOR 8
  IF SAIDABAIXO THEN COLOR 15
  LOCATE 21, 12
  PRINT "B"
  COLOR 11
  RETURN

' Vai para a rotina da sala atual (SALA).
DescreveSala:
  IF SALA <= 10 THEN
    ON SALA GOSUB Sala1Escritorio, Sala2Recepcao, Sala3Calcada, Sala4Calcadao, _
        Sala5Biblioteca, Sala6Balcao, Sala7Deposito, Sala8Viela, Sala9Praca, _
        Sala10OutraPraca
  END IF
  IF SALA > 10 AND SALA <= 20 THEN
    ON SALA - 10 GOSUB Sala11Faculdade, Sala12Estacionamento, _
        Sala13Secretaria, Sala14SalaDeAula, Sala15Quadra, Sala16Ginasio, _
        Sala17Almoxarifado, Sala18Cpd, Sala19DepositoDePapel, _
        Sala20BairroPerigoso
  END IF
  IF SALA > 20 AND SALA <= 30 THEN
    ON SALA - 20 GOSUB Sala21Rua, Sala22Beco, Sala23Loja, Sala24Quarto, _
        Sala25Corredor, Sala26FimDaRua, Sala27Fliperama, Sala28Entrada, _
        Sala29Hall, Sala30Elevador
  END IF
  IF SALA > 30 AND SALA <= 40 THEN
    ON SALA - 30 GOSUB Sala31BanheiroFeminino, Sala32BanheiroMasculino, _
        Sala33Poco, Sala34Fabrica, Sala35Salinha, Sala36Esgotos, _
        Sala37Mafiosos, Sala38Escadaria, Sala39FrenteDaBucanoWare, _
        Sala40Recepcao
  END IF
  IF SALA > 40 AND SALA <= 50 THEN
    ON SALA - 40 GOSUB Sala41Hall, Sala42Elevador, Sala43Elevador, _
        Sala44Escritorio, Sala45Cpd, Sala46Recepcao, Sala47SalaDeSecretaria, _
        Sala48SalaDeSecretaria, Sala49SalaDeSecretaria, Sala50Corredor
  END IF
  IF SALA > 50 AND SALA <= 60 THEN
    ON SALA - 50 GOSUB Sala51Lavabo, Sala52PortaAberta, Sala53SalaDoSrL, _
        Sala54Garagem, Sala55Almoxarifado, Sala56Bairro, Sala57Agencia, _
        Sala58Portaria, Sala59Pista, Sala60Area
  END IF
  IF SALA > 60 AND SALA <= 67 THEN
    ON SALA - 60 GOSUB Sala61Bar, Sala62Mesa, Sala63Sacada, _
        Sala64BanheiroMasculino, Sala65PassagemSecreta, Sala66Esconderijo, _
        Sala67GaragemDeOnibus
  END IF
  RETURN

' **************************************************************
' SALAS
' Uma sub-rotina por sala, escolhida por ON SALA GOSUB.
' **************************************************************
' Você está no escritório do chefe.
Sala1Escritorio:
  NOMESALA$ = "ESCRITORIO"
  IF VISITADA(SALA) = 0 THEN
    AVISO$ = "Digite qualquer tecla..."
    MENSAGEM$ = "Você está no escritório do chefe. Não é a primeira vez " + _
        "que você aparece nesta sala, mas você sente que está ferrado."
    GOSUB MostraMensagem
    MENSAGEM$ = "De repente, a porta se abre. Aquele cara grandão, que " + _
        "você conhece apenas e tão somente como 'O Chefe' aparece na porta."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Então é VOCE !!!', ele diz, enquanto você se despede " + _
        "mentalmente do seu emprego. 'Nem tente me enrolar. Onde está o " + _
        "disquete ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Que disquete ???', você responde, surpreso por não saber " + _
        "do que ele está falando."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Não venha com essa. EU QUERO ESTE DISQUETE. VÁ " + _
        "PROCURÁ-LO AGORA, IMBECIL !!!'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Sim, senhor !', você responde, enquanto o babaca sai e " + _
        "bate a porta."
    GOSUB MostraMensagem
    MENSAGEM$ = "Parece que você está bem encrencado agora. Vê se acha " + _
        "este disquete logo. Afinal de contas, este deve ser o objetivo do " + _
        "jogo..."
    GOSUB MostraMensagem
    GOSUB MostraAviso
  ELSE
    MENSAGEM$ = "Você está no escritório do chefe." : GOSUB MostraMensagem
  END IF
  SAIDANORTE = 2 ' Recepcao
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está na recepção do escritório.
Sala2Recepcao:
  NOMESALA$ = "RECEPCAO"
  MENSAGEM$ = "Você está na recepção do escritório. Você vê a rua ao " + _
      "norte, o que lhe causa um enorme desejo de sair desta pocilga."
  GOSUB MostraMensagem
  SAIDANORTE = 3 ' Calcada
  SAIDASUL = 1 ' Escritorio
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está na calçada de uma rua bastante movimentada.
Sala3Calcada:
  NOMESALA$ = "CALCADA"
  MENSAGEM$ = "Você está na calçada de uma rua bastante movimentada. E' " + _
      "realmente inacreditável o 'coeficiente animal' dos motoristas deste " + _
      "bairro."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 2 ' Recepcao
  SAIDALESTE = 4 ' Calcadao
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você se encontra num calçadão.
Sala4Calcadao:
  NOMESALA$ = "CALCADAO"
  MENSAGEM$ = "Você se encontra num calçadão. Ao sul pode-se ver um salão " + _
      "bastante bonito (considerando o muquifo de bairro no qual você se " + _
      "encontra...)"
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 5 ' Biblioteca
  SAIDALESTE = 0
  SAIDAOESTE = 3 ' Calcada
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos na biblioteca.
Sala5Biblioteca:
  NOMESALA$ = "BIBLIOTECA"
  MENSAGEM$ = "Estamos na biblioteca. Este é um lugar interessante. As " + _
      "prateleiras dos livros ficam atrás do balcão, e não ao acesso do " + _
      "público.."
  GOSUB MostraMensagem
  SAIDANORTE = 4 ' Calcadao
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' O balcão é apertado, mas deu para entrar (agora que você se...
Sala6Balcao:
  NOMESALA$ = "BALCAO"
  MENSAGEM$ = "O balcão é apertado, mas deu para entrar (agora que você se " + _
      "arrepende de não ter feito aquele regime). O perfume da balconista " + _
      "ainda é bastante forte."
  GOSUB MostraMensagem
  SAIDANORTE = 5 ' Biblioteca
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 7 ' Deposito
  RETURN

' A escada te levou até um depósito.
Sala7Deposito:
  NOMESALA$ = "DEPOSITO"
  MENSAGEM$ = "A escada te levou até um depósito. Agora, basta subir que " + _
      "você pode sair do balcão."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 5 ' Biblioteca
  SAIDABAIXO = 0
  RETURN

' Você está numa viela totalmente deserta.
Sala8Viela:
  NOMESALA$ = "VIELA"
  MENSAGEM$ = "Você está numa viela totalmente deserta." : GOSUB MostraMensagem
  SAIDANORTE = 9 ' Praca
  SAIDASUL = 11 ' Faculdade
  SAIDALESTE = 57 ' Agencia
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos numa praça.
Sala9Praca:
  NOMESALA$ = "PRACA"
  IF VISITADA(9) = 0 THEN ' 9=Praca
    AVISO$ = "Digite qualquer tecla..."
    MENSAGEM$ = "Estamos numa praça. Um fato curioso é que ninguém aqui " + _
        "tem um fio de cabelo, e muitos usam uma argola no nariz."
    GOSUB MostraMensagem
    MENSAGEM$ = "De repente, o povo se aglomera à sua volta. Todos começam " + _
        "a gritar."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Olá, amigos. Tudo bem com vocês ? Mas que dia lindo está " + _
        "hoje, não é mesmo ?' - você diz."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Ih, moçada, esse mané é Mauricinho. Olha que frufru' - " + _
        "diz um deles aos outros, debochando. Ele fica sério e olha para você."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Aí, loque, esse barato é território dos carecas. Que é " + _
        "que cê tá fazendo aqui ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'N-N-N-Nada. Só passeando...' - você responde, pensando " + _
        "no seu testamento."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Mas, apesar de tudo, gostei de você. Aliás, te achei " + _
        "super-gostosinho. Uma graça. EI, GENTE, QUE TAL SE ELE FOR UM DOS " + _
        "NOSSOS ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'YEAH ! YEAH ! YEAH !' - diz a galera. E o cara continua " + _
        "- 'Vamo nessa. Pega a maquininha zero'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Ei, o que vocês vão fazer. Espere aí, esse cabelo é meu " + _
        "!!! Meu cabelo ! Meu cabelinho !' - você grita, enquanto eles " + _
        "raspam sua cabeça."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Muito bem' - diz o grandão, quando o serviço termina - " + _
        "'Agora você também é um careca. Pode circular aqui à vontade'. " + _
        "Ele se retira do local, gritando e pulando."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "Você olha para o chão e vê aquilo que um dia foi seu " + _
        "cabelo. Mas ainda assim agradeça por estar vivo..."
  ELSE
    MENSAGEM$ = "Você está na praça dos carecas. Seus últimos momentos " + _
        "aqui não foram muito agradáveis, mas você nota que tem total " + _
        "liberdade por aqui como um careca."
    GOSUB MostraMensagem
  END IF
  SAIDANORTE = 10 ' OutraPraca
  SAIDASUL = 8 ' Viela
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos em outra praça.
Sala10OutraPraca:
  AVISO$ = "Digite qualquer tecla..."
  MENSAGEM$ = "Estamos em outra praça. Mais tipos estranhos aparecem, não " + _
      "exatamente carecas, 'mas devem ser do mesmo clubinho', você pensa."
  GOSUB MostraMensagem
  MENSAGEM$ = "Muito feliz por ser um deles, você começa a pular e gritar: " + _
      "'EI, GENTE, VEJAM TODOS, EU SOU UM CARECA. VIVA A NOSSA GANGUE. " + _
      "SEREI CARECA ATÉ MORRER. VAMOS LÁ, AMIGOS !!!'"
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "A multidão vem eufórica em sua direção, e você delira por " + _
      "estar tão a salvo e em segurança no meio dos seus companheiros. Um " + _
      "deles chega e grita:"
  GOSUB MostraMensagem
  MENSAGEM$ = "'Você é um dos carecas, mesmo ?', e você responde: 'Sim ! E " + _
      "vocês, irmãos'"
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "'SOMOS PUNKS. NóS ODIAMOS OS CARECAS !!!!!!' - grita a " + _
      "multidão, enquanto avançam para cima de você, triturando-o"
  GOSUB MostraMensagem
  GOTO FimDeJogoMorte

' Você está na entrada de uma faculdade.
Sala11Faculdade:
  NOMESALA$ = "FACULDADE"
  MENSAGEM$ = "Você está na entrada de uma faculdade. Não é nenhuma " + _
      "Oxford, mas dá para o gasto. Dá para ver muitos estudantes indo " + _
      "para todos os lados, e eles não devem estar interessados em conversar."
  GOSUB MostraMensagem
  SAIDANORTE = 8 ' Viela
  SAIDASUL = 13 ' Secretaria
  SAIDALESTE = 12 ' Estacionamento
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você se encontra num estacionamento.
Sala12Estacionamento:
  NOMESALA$ = "ESTACIONAMENTO"
  MENSAGEM$ = "Você se encontra num estacionamento. Não há nenhum carro, o " + _
      "que lhe deixa muito decepcionado."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 11 ' Faculdade
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos na secretaria da faculdade.
Sala13Secretaria:
  NOMESALA$ = ""
  MENSAGEM$ = "Estamos na secretaria da faculdade. É uma salinha bem " + _
      "mixuruca, caindo aos pedaços."
  GOSUB MostraMensagem
  IF NOT AULAUSADA THEN SAIDALESTE = 14 ELSE SAIDALESTE = 0 ' 14=SalaDeAula
  SAIDANORTE = 11 ' Faculdade
  SAIDASUL = 16 ' Ginasio
  SAIDAOESTE = 18 ' Cpd
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Ei, esta é uma sala de aula.
Sala14SalaDeAula:
  MENSAGEM$ = "Ei, esta é uma sala de aula. Os alunos e o professor olham " + _
      "para você com desprezo."
  GOSUB MostraMensagem
  MENSAGEM$ = "De repente, o professor grita: 'ATACAR !!!', e os alunos " + _
      "lançam toda sorte de projéteis sobre você, desde papeis até " + _
      "apontadores de metal. Você sai da classe e o professor tranca a porta."
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  AULAUSADA = -1
  LOCOBJ(28) = 13 ' 28=Borracha, 13=Secretaria
  SALA = 13 ' Secretaria
  GOTO Sala13Secretaria

' Esta é a quadra de esportes.
Sala15Quadra:
  NOMESALA$ = "QUADRA"
  MENSAGEM$ = "Esta é a quadra de esportes. Nada de anormal aqui."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 16 ' Ginasio
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está no ginásio de esportes.
Sala16Ginasio:
  NOMESALA$ = "GINASIO"
  MENSAGEM$ = "Você está no ginásio de esportes. O lugar está acabado. Na " + _
      "parede, uma pichação: 'CHESTER NÃO ESTEVE AQUI'. Você se pergunta " + _
      "até que ponto a degradação humana pode chegar."
  GOSUB MostraMensagem
  SAIDANORTE = 13 ' Secretaria
  SAIDASUL = 0
  SAIDALESTE = 15 ' Quadra
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está no almoxarifado.
Sala17Almoxarifado:
  NOMESALA$ = "ALMOXARIFADO"
  MENSAGEM$ = "Você está no almoxarifado. O cheiro do local não é nada " + _
      "agradável, podendo-se dizer o mesmo do seu aspecto."
  GOSUB MostraMensagem
  SAIDANORTE = 18 ' Cpd
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 19 ' DepositoDePapel
  RETURN

' Este é o Centro de Processamento de Dados da faculdade.
Sala18Cpd:
  NOMESALA$ = "CPD"
  MENSAGEM$ = "Este é o Centro de Processamento de Dados da faculdade. " + _
      "Examinando mais profundamente, você observa o poderoso equipamento " + _
      "do pessoal: Um TK82C, conectado a um gravador CCE. Pena que não dá " + _
      "para utilizá-lo, pois ele está sem a fonte."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 17 ' Almoxarifado
  SAIDALESTE = 13 ' Secretaria
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está num depósito de papel.
Sala19DepositoDePapel:
  NOMESALA$ = ""
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 17 ' Almoxarifado
  SAIDABAIXO = 0
  IF LANTERNA$ = "ligada" AND LOCOBJ(21) = -999 AND LOCOBJ(22) = -999 THEN ' 21=Lanterna, 22=Pilhas
    NOMESALA$ = "DEPOSITO"
    MENSAGEM$ = "Você está num depósito de papel." : GOSUB MostraMensagem
    IF LOCOBJ(32) = 0 THEN LOCOBJ(32) = 19 ' 32=Mala, 19=DepositoDePapel
    RETURN
  END IF
  MENSAGEM$ = "Estamos num lugar escuro, muito escuro. Não dá nem para " + _
      "enxergar as saídas."
  GOSUB MostraMensagem
  SAIDACIMA = 0
  RETURN

' Meu Deus, que lugar horrível.
Sala20BairroPerigoso:
  MENSAGEM$ = "Meu Deus, que lugar horrível. Não dá para andar um minuto " + _
      "sem que um marreteiro, traficante ou bicheiro venha lhe atazanar."
  GOSUB MostraMensagem
  MENSAGEM$ = "Um corrózinho vem lhe pedir uma grana. Você dá a ele tudo o " + _
      "que suas possibilidades econômicas lhe permitem. Ele se enfurece e " + _
      "mete a faca."
  GOSUB MostraMensagem
  GOTO FimDeJogoMorte

' Estamos em (mais) uma ruazinha louca, no sentido de norte a...
Sala21Rua:
  NOMESALA$ = "RUA"
  MENSAGEM$ = "Estamos em (mais) uma ruazinha louca, no sentido de norte a " + _
      "sul, que parece ser uma rua central do bairro. A oeste se vê um " + _
      "prédio, enquanto que ao leste há um escritório."
  GOSUB MostraMensagem
  SAIDANORTE = 22 ' Beco
  SAIDASUL = 26 ' FimDaRua
  SAIDALESTE = 23 ' Loja
  SAIDAOESTE = 28 ' Entrada
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos num beco sem saída.
Sala22Beco:
  NOMESALA$ = "BECO"
  MENSAGEM$ = "Estamos num beco sem saída." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 21 ' Rua
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você entra na loja, que parece negociar peças de automóveis.
Sala23Loja:
  NOMESALA$ = "LOJA"
  AVISO$ = "Digite qualquer tecla..."
  IF VISITADA(SALA) = 0 THEN
    VISITADA(SALA) = 1
    MENSAGEM$ = "Você entra na loja, que parece negociar peças de " + _
        "automóveis. Um vendedor aborda você."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Em que posso servi-lo ?' - ele pergunta."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Bem, eu gostaria de saber aonde procurar um disquete " + _
        "roubado...' - você diz, sem esperanças."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Oh, mas isso é óBVIO ! Procure o Sr. L !!!"
    GOSUB MostraMensagem
    MENSAGEM$ = "'SR. L ? Quem é o tipo ?" : GOSUB MostraMensagem
    MENSAGEM$ = "'Ele está há tempos tentando controlar os negócios da " + _
        "cidade ilegalmente. Já tentou arruinar o mercado de autopeças, e " + _
        "agora dizem que partiu para a informática..."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'BELEZA ! Vou atrás do salafrário !!!' - você diz, eufórico."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Calma aí, rapaz' - ele diz - 'Em primeiro lugar, você " + _
        "precisa achá-lo. Em segundo, é impossível atingi-lo. Ele é muito " + _
        "esperto, e não tem ficha na polícia.'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Hmm...'" : GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Mas eu posso levá-lo até a sede das Indústrias L & L Ltda...'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'MESMO ???':GOSUB P"
    MENSAGEM$ = "'...mediante um módico preço.'" : GOSUB MostraMensagem
    MENSAGEM$ = "'Hmm...' - você diz, abrindo sua carteira e exibindo seus" + _
        STR$(GRANA) + " paus."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    IF GRANA >= 5000 THEN GOTO Sala23LojaX1
    MENSAGEM$ = "'Ei, isso não dá nem pro cheiro. Nada feito.' - Ele diz, " + _
        "e lhe aponta a porta. Você percebe a derrota e sai."
    GOSUB MostraMensagem
    GOTO Sala23LojaX2
  END IF
  MENSAGEM$ = "Estamos na loja de autopeças. O vendedor nos aborda."
  GOSUB MostraMensagem
  IF GRANA < 5000 THEN
    MENSAGEM$ = "'Trouxe a grana ?' - ele diz, ao que você responde " + _
        "negativamente - 'Então vá embora !!!' - ele diz, virando as " + _
        "costas enquanto você sai."
    GOSUB MostraMensagem
    GOTO Sala23LojaX2
  END IF
Sala23LojaX1:
  MENSAGEM$ = "'Ah, vejo que sua carteira está recheada' - ele diz, nos " + _
      "tomando a carteira e quase toda a grana. 'Fique com o troco'."
  GOSUB MostraMensagem
  GRANA = GRANA - 5000
  MENSAGEM$ = "'Vai me levar agora ?' - você diz, nervoso por perder toda " + _
      "aquela grana por causa de um mísero disquete."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Claro. Venha comigo'" : GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Vocês se dirigem a uma garagem no fundo da loja, enquanto " + _
      "ele lhe enche o saco - 'Você verá agora que belezinha. Este bólido " + _
      "provido de motor superior com carburação "
  MENSAGEM$ = MENSAGEM$ + " poderosa de países inimagináveis, que " + _
      "pertenceu a pouquíssima gente, com marchas poderosas...'"
  GOSUB MostraMensagem
  MENSAGEM$ = "Finalmente ele chega ao falado carro. Ele lhe lembra " + _
      "vagamente o desenho animado da 'Super Motoca'. Após 243 tentativas " + _
      "frustradas de dar a partida, vocês finalmente saem (ou quase)."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "O carro vai, sacolejando, enquanto você imagina se, em caso " + _
      "de acidente, morrerá com o impacto ou de tétano, considerando a " + _
      "idade do maquinário."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Aqui', ele diz, apontando para o prédio aonde vocês param, " + _
      "'é o seu lugar. Esta é a BucanoWare Inc., a firma do Sr. L. Em " + _
      "matéria de sacanagem e cópia dos outros, eles são os melhores."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Você sai do carro, e ele vai embora, cantando os pneus (ou " + _
      "melhor, o escapamento e o para-lamas, visto que a única coisa " + _
      "naquele carro que não produzia absolutamente nenhum ruído era a buzina)."
  GOSUB MostraMensagem
  SALA = 39 ' FrenteDaBucanoWare
  GOSUB MostraAviso
  RETURN
Sala23LojaX2:
  SALA = 21 ' Rua
  MENSAGEM$ = "Estamos de volta à rua central." : GOSUB MostraMensagem
  SAIDANORTE = 22 ' Beco
  SAIDASUL = 26 ' FimDaRua
  SAIDALESTE = 23 ' Loja
  SAIDAOESTE = 28 ' Entrada
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos num quarto.
Sala24Quarto:
  NOMESALA$ = "QUARTO"
  MENSAGEM$ = "Estamos num quarto. Na cama, um casal faz o que lhe é " + _
      "direito neste local. Graças à sua sutileza, eles não notaram. " + _
      "Aliás, acho que não notariam nem um terremoto."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 25 ' Corredor
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está num corredor estreito dentro do quarto.
Sala25Corredor:
  NOMESALA$ = "CORREDOR"
  MENSAGEM$ = "Você está num corredor estreito dentro do quarto. Não " + _
      "parece ser uma casa de excelente reputação."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDAOESTE = 26 ' FimDaRua
  SAIDALESTE = 24 ' Quarto
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos no fim da rua.
Sala26FimDaRua:
  NOMESALA$ = "FIM DA RUA"
  MENSAGEM$ = "Estamos no fim da rua. Ao leste se vê um desses quartos " + _
      "baratos, e ao oeste um fliperama."
  GOSUB MostraMensagem
  SAIDANORTE = 21 ' Rua
  SAIDASUL = 0
  SAIDALESTE = 25 ' Corredor
  SAIDAOESTE = 27 ' Fliperama
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos numa casa de fliperama.
Sala27Fliperama:
  NOMESALA$ = "FLIPERAMA"
  MENSAGEM$ = "Estamos numa casa de fliperama. Uma máquina de Street " + _
      "Fighter 2 olha apaixonada para você, mas você tem que ir atrás do " + _
      "disquete, e não gastar seu dinheiro com fliperama."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 26 ' FimDaRua
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Esta é a entrada do prédio.
Sala28Entrada:
  NOMESALA$ = "ENTRADA"
  MENSAGEM$ = "Esta é a entrada do prédio. Um local exalando um cheiro " + _
      "nauseante está a oeste, enquanto que ao norte se vê o hall."
  GOSUB MostraMensagem
  SAIDANORTE = 29 ' Hall
  SAIDASUL = 0
  SAIDALESTE = 21 ' Rua
  SAIDAOESTE = 32 ' BanheiroMasculino
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' A mulherada que havia saído do banheiro avança sobre você, e o...
Sala29Hall:
  NOMESALA$ = "HALL"
  IF VISITADA(31) <> 0 THEN ' 31=BanheiroFeminino
    MENSAGEM$ = "A mulherada que havia saído do banheiro avança sobre " + _
        "você, e o lincha em segundos, sob gritos de 'TARADO', " + _
        "'PERVERTIDO' e similares."
    GOSUB MostraMensagem
    GOTO FimDeJogoMorte
  END IF
  MENSAGEM$ = "Você está no hall do prédio. Não há onde sentar-se, e mesmo " + _
      "que houvesse, você não tem tempo para isso. O banheiro feminino é a " + _
      "oeste."
  GOSUB MostraMensagem
  SAIDANORTE = 30 ' Elevador
  SAIDASUL = 28 ' Entrada
  SAIDALESTE = 0
  SAIDAOESTE = 31 ' BanheiroFeminino
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos no elevador.
Sala30Elevador:
  MENSAGEM$ = "Estamos no elevador." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 29 ' Hall
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Entramos no banheiro feminino.
Sala31BanheiroFeminino:
  NOMESALA$ = "BANHEIRO"
  IF VISITADA(31) = 0 THEN ' 31=BanheiroFeminino
    MENSAGEM$ = "Entramos no banheiro feminino. A mulherada sai gritando " + _
        "com as saias na mão."
  ELSE
    MENSAGEM$ = "Estamos no banheiro feminino."
  END IF
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 29 ' Hall
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Este é o banheiro masculino.
Sala32BanheiroMasculino:
  NOMESALA$ = "BANHEIRO"
  MENSAGEM$ = "Este é o banheiro masculino. Nem pense em fazer nada aqui, " + _
      "pois o lugar é horrível."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 28 ' Entrada
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está num poço.
Sala33Poco:
  NOMESALA$ = "POCO"
  MENSAGEM$ = "Você está num poço." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 34 ' Fabrica
  RETURN

' Estamos num lugar, que, pelo maquinário, parece ser uma fábrica de bebidas
' clandestina.
Sala34Fabrica:
  NOMESALA$ = "FABRICA"
  MENSAGEM$ = "Estamos num lugar, que, pelo maquinário, parece ser uma " + _
      "fábrica de bebidas clandestina."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 35 ' Salinha
  SAIDALESTE = 37 ' Mafiosos
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos numa salinha apertada.
Sala35Salinha:
  MENSAGEM$ = "Estamos numa salinha apertada." : GOSUB MostraMensagem
  SAIDANORTE = 34 ' Fabrica
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 36 ' Esgotos
  RETURN

' Caímos numa rede de esgotos.
Sala36Esgotos:
  NOMESALA$ = "ESGOTOS"
  MENSAGEM$ = "Caímos numa rede de esgotos. Após tatear muito, encontramos " + _
      "uma saída."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 38 ' Escadaria
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Abrimos uma portinhola e eis o que aparece: metade do elenco de...
Sala37Mafiosos:
  MENSAGEM$ = "Abrimos uma portinhola e eis o que aparece: metade do " + _
      "elenco de 'O Poderoso Chefão', embora com aspecto latino, está " + _
      "fumando charuto e jogando baralho, quando olha para você. Um deles diz:"
  GOSUB MostraMensagem
  MENSAGEM$ = "'¿ Como te chamas ?'" : GOSUB MostraMensagem
  MENSAGEM$ = "'E-E-Epaminondas.'." : GOSUB MostraMensagem
  MENSAGEM$ = "'TE CHAMABAS !!!!' - dizem todos eles, ao fuzilá-lo."
  GOSUB MostraMensagem
  GOTO FimDeJogoMorte

' Ahá !
Sala38Escadaria:
  NOMESALA$ = "ESCADARIA"
  MENSAGEM$ = "Ahá ! Uma escadaria." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 27 ' Fliperama
  SAIDABAIXO = 0
  RETURN

' Estamos na frente da BucanoWare INC.
Sala39FrenteDaBucanoWare:
  MENSAGEM$ = "Estamos na frente da BucanoWare INC. Não parece haver outro " + _
      "lugar a ir, senão a própria."
  GOSUB MostraMensagem
  SAIDANORTE = 40 ' Recepcao
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  VISITADA(40) = 0 ' 40=Recepcao
  RETURN

' Você entra na recepçao.
Sala40Recepcao:
  NOMESALA$ = "RECEPCAO"
  IF VISITADA(40) = 0 THEN ' 40=Recepcao
    MENSAGEM$ = "Você entra na recepçao. A recepcionista sorri e diz:"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Bom dia. O que o senhor deseja ?'" : GOSUB MostraMensagem
    MENSAGEM$ = "'Bem, eu, aham, precisava conversar com o Sr. L'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Infelizmente, o Sr. L. hoje está muito ocupado. A não " + _
        "ser que seja algo importante, o senhor deveria se retirar...'"
    GOSUB MostraMensagem
    AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  ELSE
    MENSAGEM$ = "Estamos na recepção." : GOSUB MostraMensagem
  END IF
  SAIDANORTE = 0
  SAIDASUL = 39 ' FrenteDaBucanoWare
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos no hall do edifício.
Sala41Hall:
  NOMESALA$ = "HALL"
  MENSAGEM$ = "Estamos no hall do edifício. Ao sul está a mesa da " + _
      "secretária, que provavelmente não vai nos deixar voltar se formos " + _
      "até lá. A leste e a oeste temos elevadores."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 40 ' Recepcao
  SAIDALESTE = 43 ' Elevador
  SAIDAOESTE = 42 ' Elevador
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está num elevador.
Sala42Elevador:
  NOMESALA$ = "ELEVADOR"
  MENSAGEM$ = "Você está num elevador."
  IF ELEVMOVEU THEN
    MENSAGEM$ = MENSAGEM$ + " Ele desce automaticamente até o térreo."
    ELEVMOVEU = 0
  END IF
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 41 ' Hall
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está num elevador.
Sala43Elevador:
  NOMESALA$ = "ELEVADOR"
  MENSAGEM$ = "Você está num elevador."
  IF ELEVMOVEU THEN
    MENSAGEM$ = MENSAGEM$ + " Ele sobe automaticamente até o térreo."
    ELEVMOVEU = 0
  END IF
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 41 ' Hall
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Ao sair do elevador, você chegou num belíssimo escritório com...
Sala44Escritorio:
  NOMESALA$ = "ESCRITORIO"
  MENSAGEM$ = "Ao sair do elevador, você chegou num belíssimo escritório " + _
      "com móveis de cerejeira, decorado com pinturas expressionistas e " + _
      "tudo o mais. O elevador está a oeste."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 42 ' Elevador
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está no CPD da firma.
Sala45Cpd:
  NOMESALA$ = "CPD"
  MENSAGEM$ = "Você está no CPD da firma. Ninguém nota sua chegada."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 42 ' Elevador
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos na recepção da administração.
Sala46Recepcao:
  NOMESALA$ = "RECEPCAO"
  MENSAGEM$ = "Estamos na recepção da administração." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 47 ' SalaDeSecretaria
  SAIDAOESTE = 42 ' Elevador
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos numa sala que parece pertencer a alguma secretária.
Sala47SalaDeSecretaria:
  NOMESALA$ = "SALA"
  MENSAGEM$ = "Estamos numa sala que parece pertencer a alguma secretária."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 48 ' SalaDeSecretaria
  SAIDALESTE = 0
  SAIDAOESTE = 46 ' Recepcao
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Eis OUTRA sala de secretária.
Sala48SalaDeSecretaria:
  NOMESALA$ = "SALA"
  IF VISITADA(SALA) = 0 THEN
    MENSAGEM$ = "Eis OUTRA sala de secretária."
  ELSE
    MENSAGEM$ = "Você está numa (outra) salinha de secretária."
  END IF
  GOSUB MostraMensagem
  SAIDANORTE = 47 ' SalaDeSecretaria
  SAIDASUL = 49 ' SalaDeSecretaria
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Eis MAIS UMA sala de secretária (esse Sr. L é bom mesmo).
Sala49SalaDeSecretaria:
  NOMESALA$ = "SALA"
  IF VISITADA(SALA) = 0 THEN
    MENSAGEM$ = "Eis MAIS UMA sala de secretária (esse Sr. L é bom mesmo). " + _
        "Pena que o andar parece estar em férias coletivas, caso contrário " + _
        "você nem pensaria mais no disquete..."
  ELSE
    MENSAGEM$ = "Estamos numa salinha pertencente a alguma secretária."
  END IF
  GOSUB MostraMensagem
  SAIDANORTE = 48 ' SalaDeSecretaria
  SAIDASUL = 50 ' Corredor
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos num corredor no sentido de leste a oeste.
Sala50Corredor:
  NOMESALA$ = "CORREDOR"
  MENSAGEM$ = "Estamos num corredor no sentido de leste a oeste."
  GOSUB MostraMensagem
  SAIDANORTE = 49 ' SalaDeSecretaria
  SAIDASUL = 0
  SAIDALESTE = 51 ' Lavabo
  SAIDAOESTE = 52 ' PortaAberta
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos num pequeno lavabo.
Sala51Lavabo:
  NOMESALA$ = "LAVABO"
  MENSAGEM$ = "Estamos num pequeno lavabo." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 50 ' Corredor
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos em frente a uma porta.
Sala52PortaAberta:
  MENSAGEM$ = "Estamos em frente a uma porta. Ela está aberta."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 50 ' Corredor
  SAIDAOESTE = 53 ' SalaDoSrL
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos na sala do Sr. L.
Sala53SalaDoSrL:
  NOMESALA$ = "SALA"
  MENSAGEM$ = "Estamos na sala do Sr. L. O local é bastante incrementado, " + _
      "o que mostra quanto dinheiro ele anda ganhando sobre os outros. " + _
      "(Agora você para para pensar quanto deverá valer este disquete, " + _
      "para que seu patrão te chute assim...)."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 52 ' PortaAberta
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos na garagem do edifício.
Sala54Garagem:
  NOMESALA$ = "GARAGEM"
  MENSAGEM$ = "Estamos na garagem do edifício." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 43 ' Elevador
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos no almoxarifado.
Sala55Almoxarifado:
  NOMESALA$ = "ALMOXARIFADO"
  MENSAGEM$ = "Estamos no almoxarifado. Valendo-se de sua inteligência " + _
      "superior, você chega à brilhante conclusão de que o disquete pode " + _
      "estar aqui."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 43 ' Elevador
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos num bairro pior do que todos os outros já vistos.
Sala56Bairro:
  NOMESALA$ = "BAIRRO"
  MENSAGEM$ = "Estamos num bairro pior do que todos os outros já vistos. " + _
      "Ao norte temos uma danceteria, e a rua vai no sentido de leste a " + _
      "oeste. Mas, sinceramente, eu não recomendaria passear nela. Aliás, " + _
      "eu não recomendaria entrar na danceteria, muito"
  MENSAGEM$ = MENSAGEM$ + " embora ficar aí marcando bobeira não seja uma " + _
      "boa..."
  GOSUB MostraMensagem
  SAIDANORTE = 58 ' Portaria
  SAIDASUL = 0
  SAIDALESTE = 20 ' BairroPerigoso
  SAIDAOESTE = 20 ' BairroPerigoso
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Estamos numa agência de viagens.
Sala57Agencia:
  NOMESALA$ = "AGENCIA"
  MENSAGEM$ = "Estamos numa agência de viagens. Todos os guichês estão " + _
      "fechados, e não parece haver ninguém além de você aqui."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 8 ' Viela
  SAIDACIMA = 0
  SAIDABAIXO = 0
  IF PORTAABERTA THEN SAIDALESTE = 67 ' GaragemDeOnibus
  RETURN

' 'Boa noite, cavalheiro', lhe diz o engomadinho, enquanto você passa pela
' portaria.
Sala58Portaria:
  NOMESALA$ = "PORTARIA"
  IF VISITADA(59) <> 0 THEN ' 59=Pista
    MENSAGEM$ = "'Boa noite, cavalheiro', lhe diz o engomadinho, enquanto " + _
        "você passa pela portaria."
    GOSUB MostraMensagem
    GOTO Sala58PortariaX1
  END IF
  MENSAGEM$ = "Entramos numa passagem. Um indivíduo engravatadinho e " + _
      "engomadinho, pronto para ser modelo de enfeite de geladeira, barra " + _
      "a sua passagem."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Você é sócio ?'" : GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  IF LOCOBJ(38) <> -999 THEN ' 38=Cartao
    MENSAGEM$ = "'Não, mas...'" : GOSUB MostraMensagem
    MENSAGEM$ = "'Então terá que comprar o convite.'" : GOSUB MostraMensagem
    MENSAGEM$ = "Você mostra a ele seus $5, e ele dá uma risadinha. 'Ah, " + _
        "claro' - ele diz - 'Escute, sr., está vendo aquela janela ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Sim, claro' - você diz, virando-se para a janela ao sul " + _
        "- 'Por quê ?'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'VAI NESSA, PALHAÇO !!!' - diz ele, chutando o seu " + _
        "traseiro e te colocando para fora através dela."
    GOSUB MostraMensagem
    SALA = 56 ' Bairro
    GOTO Sala56Bairro
    GOTO Sala58PortariaX1  ' inalcançável
  END IF
  MENSAGEM$ = "Você pega o cartão 'emprestado' do cara do quarto e mostra " + _
      "ao rapaz."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Ah, claro. Desculpe não tê-lo reconhecido antes, Sr. " + _
      "Elbestáquio Josiclélio Alves de Calógeras e Mello. Pode entrar' - " + _
      "diz o engomadinho."
  GOSUB MostraMensagem
Sala58PortariaX1:
  SAIDANORTE = 59 ' Pista
  SAIDASUL = 56 ' Bairro
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está na pista de dança.
Sala59Pista:
  NOMESALA$ = "PISTA"
  MENSAGEM$ = "Você está na pista de dança." : GOSUB MostraMensagem
  SAIDANORTE = 62 ' Mesa
  SAIDASUL = 58 ' Portaria
  SAIDALESTE = 61 ' Bar
  SAIDAOESTE = 60 ' Area
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está no que se pode chamar de 'área privada' da danceteria.
Sala60Area:
  NOMESALA$ = "AREA"
  MENSAGEM$ = "Você está no que se pode chamar de 'área privada' da danceteria."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 59 ' Pista
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está no bar.
Sala61Bar:
  NOMESALA$ = "BAR"
  MENSAGEM$ = "Você está no bar." : GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 59 ' Pista
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você está em frente à mesa de som, perto do acesso que dá na sacada.
Sala62Mesa:
  NOMESALA$ = "MESA"
  MENSAGEM$ = "Você está em frente à mesa de som, perto do acesso que dá " + _
      "na sacada."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 59 ' Pista
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 63 ' Sacada
  SAIDABAIXO = 0
  IF LOCOBJ(72) = 0 THEN SAIDANORTE = 65 ' 72=DJ, 65=PassagemSecreta
  RETURN

' Esta é a sacada.
Sala63Sacada:
  NOMESALA$ = "SACADA"
  MENSAGEM$ = "Esta é a sacada. Daqui dá para ver todo o movimento do local."
  GOSUB MostraMensagem
  SAIDANORTE = 64 ' BanheiroMasculino
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 62 ' Mesa
  RETURN

' Estamos no banheiro masculino (poderíamos ter entrado no...
Sala64BanheiroMasculino:
  NOMESALA$ = "BANHEIRO"
  MENSAGEM$ = "Estamos no banheiro masculino (poderíamos ter entrado no " + _
      "feminino, mas as experiências anteriores não recomendam isso)."
  GOSUB MostraMensagem
  SAIDANORTE = 0
  SAIDASUL = 63 ' Sacada
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Ao dar a volta pela mesa de som, você entrou neste lugar sombrio.
Sala65PassagemSecreta:
  MENSAGEM$ = "Ao dar a volta pela mesa de som, você entrou neste lugar " + _
      "sombrio. Cheio de teias de aranha, o local é totalmente desolado."
  GOSUB MostraMensagem
  MENSAGEM$ = "Um silêncio sepulcral assola o local, até que uma voz se " + _
      "faz ouvir ao longe."
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  MENSAGEM$ = "'Ei, Mike, que história é essa de abrir a passagem com a " + _
      "danceteria aberta ? Isso pode causar graves conseqüências caso " + _
      "alguém...'"
  GOSUB MostraMensagem
  MENSAGEM$ = "Você se vira para a saída, mas eis que de repente a " + _
      "passagem se fecha. Uh-oh..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "'Ahá ! Vejo que temos um espião aqui ! NÃO SE MOVA, MALDITO !!!"
  GOSUB MostraMensagem
  MENSAGEM$ = "Mas você não vai se entregar sem luta ! Agora você se " + _
      "lembra de todos os ensinamentos de seu mestre e prepara-se para o " + _
      "combate corpo-a-corpo. Você se vira em direção ao inimigo e " + _
      "prepara-se para um salto mortal, quando..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "...você escorrega numa casca de banana (isso mesmo, numa " + _
      "casca de banana, dessas que sempre aparecem nos desenhos animados) " + _
      "e cai pateticamente no chão, perdendo a consciência."
  GOSUB MostraMensagem
  SALA = 66 ' Esconderijo
  GOTO Sala66Esconderijo

' Você recupera lentamente a consciência.
Sala66Esconderijo:
  MENSAGEM$ = ""
  IF VISITADA(66) = 0 THEN ' 66=Esconderijo
    MENSAGEM$ = "Você recupera lentamente a consciência. "
  END IF
  MENSAGEM$ = MENSAGEM$ + "Estamos num fétido local que sugere um " + _
      "esconderijo. É realmente nauseante o cheiro do local."
  GOSUB MostraMensagem
  IF VISITADA(66) = 0 THEN ' 66=Esconderijo
    GOSUB MostraAviso
    MENSAGEM$ = "A porta se abre, rangendo. Uma figura, que você vê " + _
        "vagamente, vai se aproximando. Ao vê-la de perto, você reconhece " + _
        "a silhueta do cara que queria te atacar. Mas a iluminação ainda é " + _
        "muito fraca para ver seu rosto."
    GOSUB MostraMensagem
    MENSAGEM$ = "'Eu já vi idiotas de todo tipo, Epaminondas, mas você me " + _
        "surpreende.'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Como você sabe o meu...' - você diz, mas imagina que ele " + _
        "deve ter visto seus documentos ao trazê-lo para cá."
    GOSUB MostraMensagem
    MENSAGEM$ = "Você pensa em atacar, mas o instrumento metálico nas maõs " + _
        "do seu antagonista o demove da idéia."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Achei que você se mataria na cidade para encontrar o " + _
        "disquete. Mas você foi mais longe do que imaginei. Não importa. " + _
        "Cedo ou tarde um erro infantil seu iria deixá-lo em minhas mãos.'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Ei, cara, que tal fazermos um trato ? Eu nem quero saber " + _
        "deste disquete. Fica com ele, eu vou embora e tá tudo certo. Eu...'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'CHEGA ! Não há motivos para mais mistérios !' - diz ele, " + _
        "acendendo a luz repentinamente. O impacto é enorme. 'VOCE !! " + _
        "MAS... MAS... O QUE... POR QUE...'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Chefinho, então você trabalha para o Sr. L ????"
    GOSUB MostraMensagem
    MENSAGEM$ = "'NÃO, SEU IDIOTA !!! Eu SOU o Sr. L. ! HAHAHAHAHAAAA !!!'"
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "'Mas... por quê roubar seu próprio disquete ? E o que EU " + _
        "tenho a ver com isso ?'"
    GOSUB MostraMensagem
    MENSAGEM$ = "'Você ia descobrir, mais cedo ou mais tarde. Ia mexer nas " + _
        "minhas coisas. Ia achar a mensagem que eu recebi do serviço " + _
        "secreto e tirá-la de mim !!! Mas eu não deixei ! Meu plano foi " + _
        "magistral ! Só teve uma falha: você sobreviveu. Mas vou"
    MENSAGEM$ = MENSAGEM$ + " corrigí-la logo, logo..." : GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "Ele sai da sala, gargalhando, mas não fecha a porta. Em " + _
        "vez disso, enche o lugar de tijolos e cimenta-os, deixando-o sem " + _
        "saídas."
    GOSUB MostraMensagem
  END IF
  SAIDANORTE = 0
  SAIDASUL = 0
  SAIDALESTE = 0
  SAIDAOESTE = 0
  SAIDACIMA = 0
  SAIDABAIXO = 0
  RETURN

' Você atravessa a porta e entra numa garagem, aonde um ônibus de viagem aguarda
' você.
Sala67GaragemDeOnibus:
  AVISO$ = "Digite qualquer tecla..."
  MENSAGEM$ = "Você atravessa a porta e entra numa garagem, aonde um " + _
      "ônibus de viagem aguarda você."
  GOSUB MostraMensagem
  MENSAGEM$ = "O motorista cita algumas passagens da vida da sua mãe, por " + _
      "você estar demorando, e você entra no ônibus, apressado."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "O ônibus segue viagem, e só agora você se pergunta aonde " + _
      "está indo, e volta a pensar no disquete e no seu emprego."
  GOSUB MostraMensagem
  MENSAGEM$ = "Eis o final. Você desce, e volta para o jogo, perdido como " + _
      "sempre"
  GOSUB MostraMensagem
  GOSUB MostraAviso
  SALA = 21 ' Rua
  GOTO Sala21Rua

' **************************************************************
' ARQUIVOS, AJUDA, NOTAS E FINAIS
' **************************************************************
' Pede o nome do arquivo e grava o estado do jogo em NOME.CA1.
GravaJogo:
  LOCATE 21, 16
  PRINT "Digite o nome do arquivo:"
  TECLA$ = ""
  NOMEARQ$ = ""
  WHILE TECLA$ <> CHR$(13)
    LOCATE 21, 42
    COLOR 7
    PRINT NOMEARQ$;
    COLOR 31
    PRINT "■";
    COLOR 11
    PRINT " ";
    LOCATE 18, 16 + LEN(NOMEARQ$)
    LOCATE 1, 1
    TECLA$ = ""
    WHILE TECLA$ = "" : TECLA$ = INKEY$ : WEND
    IF TECLA$ >= "a" AND TECLA$ <= "z" THEN TECLA$ = CHR$(ASC(TECLA$) - 32)
    IF ((ASC(TECLA$) >= 65 AND ASC(TECLA$) <= 90) OR (ASC(TECLA$) >= 48 AND _
        ASC(TECLA$) <= 57)) AND LEN(NOMEARQ$) < 8 THEN
      NOMEARQ$ = NOMEARQ$ + TECLA$
    END IF
    IF TECLA$ = CHR$(8) AND NOMEARQ$ <> "" THEN
      NOMEARQ$ = LEFT$(NOMEARQ$, LEN(NOMEARQ$) - 1)
    END IF
    IF TECLA$ = CHR$(27) THEN TECLA$ = CHR$(13) : NOMEARQ$ = ""
  WEND
  LOCATE 21, 16
  PRINT SPACE$(64);
  IF NOMEARQ$ = "" THEN RETURN
  ON ERROR GOTO ErroDeDisco
  OPEN NOMEARQ$ + ".CA1" FOR OUTPUT AS #1
  FOR I = 1 TO NUMSALAS
    PRINT #1, VISITADA(I)
  NEXT I
  FOR I = 1 TO 11
    PRINT #1, JANELA$(I)
  NEXT I
  FOR I = 1 TO NUMOBJ
    PRINT #1, LOCOBJ(I)
  NEXT I
  PRINT #1, NOMESALA$
  PRINT #1, AULAUSADA
  PRINT #1, SALA
  PRINT #1, SALAANT
  PRINT #1, GRANA
  PRINT #1, PORTAABERTA
  PRINT #1, BARMAN
  PRINT #1, PAPELALUM
  PRINT #1, EXAME$(60)
  PRINT #1, EXAME$(64)
  PRINT #1, EXAME$(65)
  PRINT #1, EXAME$(66)
  PRINT #1, LANTERNA$
  PRINT #1, PAGINA
  PRINT #1, SAIDANORTE
  PRINT #1, SAIDASUL
  PRINT #1, SAIDALESTE
  PRINT #1, SAIDAOESTE
  PRINT #1, SAIDACIMA
  PRINT #1, SAIDABAIXO
  PRINT #1, AQUI$(64)
  PRINT #1, AQUI$(65)
  PRINT #1, AQUI$(66)
  CLOSE #1
  ON ERROR GOTO 0
  RETURN

' Tratador de ON ERROR de GravaJogo e CarregaJogo.
ErroDeDisco:
  BEEP
  AVISO$ = "ERRO DE DISCO" + STR$(ERR) + " ! OPERAÇÃO CANCELADA."
  GOSUB MostraAviso
  RESUME CancelaOperacaoDeDisco
CancelaOperacaoDeDisco:
  ON ERROR GOTO 0
  RETURN

' Pede o nome do arquivo e lê o estado do jogo de NOME.CA1.
CarregaJogo:
  LOCATE 21, 16
  PRINT "Digite o nome do arquivo:"
  TECLA$ = ""
  NOMEARQ$ = ""
  WHILE TECLA$ <> CHR$(13)
    LOCATE 21, 42
    COLOR 7
    PRINT NOMEARQ$;
    COLOR 31
    PRINT "■";
    COLOR 11
    PRINT " ";
    LOCATE 18, 16 + LEN(NOMEARQ$)
    LOCATE 1, 1
    TECLA$ = ""
    WHILE TECLA$ = "" : TECLA$ = INKEY$ : WEND
    IF TECLA$ >= "a" AND TECLA$ <= "z" THEN TECLA$ = CHR$(ASC(TECLA$) - 32)
    IF ((ASC(TECLA$) >= 65 AND ASC(TECLA$) <= 90) OR (ASC(TECLA$) >= 48 AND _
        ASC(TECLA$) <= 57)) AND LEN(NOMEARQ$) < 8 THEN
      NOMEARQ$ = NOMEARQ$ + TECLA$
    END IF
    IF TECLA$ = CHR$(8) AND NOMEARQ$ <> "" THEN
      NOMEARQ$ = LEFT$(NOMEARQ$, LEN(NOMEARQ$) - 1)
    END IF
    IF TECLA$ = CHR$(27) THEN TECLA$ = CHR$(13) : NOMEARQ$ = ""
  WEND
  LOCATE 21, 16
  PRINT SPACE$(64);
  IF NOMEARQ$ = "" THEN RETURN
  ON ERROR GOTO ErroDeDisco
  OPEN NOMEARQ$ + ".CA1" FOR INPUT AS #1
  FOR I = 1 TO NUMSALAS
    INPUT #1, VISITADA(I)
  NEXT I
  FOR I = 1 TO 11
    LINE INPUT #1, JANELA$(I)
  NEXT I
  FOR I = 1 TO NUMOBJ
    INPUT #1, LOCOBJ(I)
  NEXT I
  LINE INPUT #1, NOMESALA$
  INPUT #1, AULAUSADA
  INPUT #1, SALA
  INPUT #1, SALAANT
  INPUT #1, GRANA
  INPUT #1, PORTAABERTA
  INPUT #1, BARMAN
  INPUT #1, PAPELALUM
  LINE INPUT #1, EXAME$(60)
  LINE INPUT #1, EXAME$(64)
  LINE INPUT #1, EXAME$(65)
  LINE INPUT #1, EXAME$(66)
  LINE INPUT #1, LANTERNA$
  INPUT #1, PAGINA
  INPUT #1, SAIDANORTE
  INPUT #1, SAIDASUL
  INPUT #1, SAIDALESTE
  INPUT #1, SAIDAOESTE
  INPUT #1, SAIDACIMA
  INPUT #1, SAIDABAIXO
  LINE INPUT #1, AQUI$(64)
  LINE INPUT #1, AQUI$(65)
  LINE INPUT #1, AQUI$(66)
  CLOSE #1
  GOSUB AtualizaPainelDirecoes
  ON ERROR GOTO 0
  GOSUB AtualizaPainelObjetos
  GOSUB AtualizaPainelDirecoes
  COLOR 15
  FOR I = 1 TO 11
    LOCATE I + 4, 2
    PRINT SPACE$(58);
    LOCATE I + 4, 2
    PRINT JANELA$(I);
  NEXT I
  COLOR 11
  RETURN

' Telas de ajuda: uma tecla passa para a próxima, ESC volta ao jogo.
MostraAjuda:
  AVISO$ = "Digite uma tecla p/ outra tela, ou ESC para jogar..."
  FOR I = 1 TO 11
    BACKUP$(I) = JANELA$(I)
  NEXT I
  MENSAGEM$ = "▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀ TELA DE AJUDA  1 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
  GOSUB MostraMensagem
  MENSAGEM$ = "Este é um jogo do tipo 'adventure', aonde você tem que " + _
      "controlar um personagem, digitando comandos para cumprir os objetivos."
  MENSAGEM$ = MENSAGEM$ + " Neste aqui, o personagem é Epaminondas. O " + _
      "objetivo, você já deve ter visto (se não, recomece o jogo)."
  GOSUB MostraMensagem
  MENSAGEM$ = "Esta janela é a janela de mensagens. Todo o texto da " + _
      "história passa aqui."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  IF TECLA$ <> CHR$(27) THEN
    MENSAGEM$ = "▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀ TELA DE AJUDA  2 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
    GOSUB MostraMensagem
    MENSAGEM$ = "Todos os comandos são digitados na janela de Comando. " + _
        "Apenas digite quando o cursor (■) estiver lá."
    GOSUB MostraMensagem
    MENSAGEM$ = "Os comandos consistem em verbo e objeto. Ex.: PEGAR " + _
        "CHAVE, OLHAR HOMEM. Artigos e complementos podem ser usados, mas " + _
        "serão ignorados. Ex.: PEGAR NOZ = PEGAR A NOZ, CONVERSAR BARMAN = " + _
        "CONVERSAR COM O BARMAN, etc." + " " + "A tecla F1 repete um " + _
        "caractere, e F3 o último comando."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    IF TECLA$ <> CHR$(27) THEN
      MENSAGEM$ = "▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀ TELA DE AJUDA  3 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
      GOSUB MostraMensagem
      MENSAGEM$ = "A janela no canto inferior direito (Direções) indica " + _
          "para onde você pode ir (Norte, Sul, Leste, Oeste, Cima e " + _
          "Baixo). Basta ver se a letra está clara ou escura."
      GOSUB MostraMensagem
      MENSAGEM$ = "Para se mover, digamos, para o Norte, digite IR PARA O " + _
          "NORTE, IR NORTE ou simplesmente N."
      GOSUB MostraMensagem
      MENSAGEM$ = ""
      GOSUB MostraMensagem
      GOSUB MostraAviso
      IF TECLA$ <> CHR$(27) THEN
        MENSAGEM$ = "▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀ TELA DE AJUDA  4 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
        GOSUB MostraMensagem
        MENSAGEM$ = "Todos os avisos do jogo serão dados na janela de " + _
            "Avisos. Para obter o menu principal nesta janela, digite ESC " + _
            "quando estiver na janela de Comando."
        GOSUB MostraMensagem
        MENSAGEM$ = "ESC novamente retorna à janela de Comando. " + _
            "O menu principal é composto de seis opções: Gravar, Carregar, " + _
            "Ajuda, Opções, Reinício e Fim. Estas opções são descritas com " + _
            "mais detalhes na tela seguinte."
        GOSUB MostraMensagem
        GOSUB MostraAviso
        IF TECLA$ <> CHR$(27) THEN
          MENSAGEM$ = "▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀ TELA DE AJUDA  5 " + _
              "▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄                      "
          GOSUB MostraMensagem
          MENSAGEM$ = "Gravar:   Salva a situação do jogo em disco."
          MENSAGEM$ = MENSAGEM$ + " Carregar: Lê uma situação já gravada."
          MENSAGEM$ = MENSAGEM$ + " Ajuda:    Esta tela.               "
          MENSAGEM$ = MENSAGEM$ + " Notas:    Observações desta versão."
          MENSAGEM$ = MENSAGEM$ + " Reinício: Começa novamente o jogo."
          MENSAGEM$ = MENSAGEM$ + " Fim:      Sai do jogo."
          GOSUB MostraMensagem
          LINHAMSG$ = ""
          GOSUB RolaJanelaDeMensagens
          GOSUB MostraAviso
          IF TECLA$ <> CHR$(27) THEN
            MENSAGEM$ = "▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀ TELA DE AJUDA  6 ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
            GOSUB MostraMensagem
            MENSAGEM$ = "A janela de Objetos mostra tudo o que você está " + _
                "carregando. Quando ela não couber mais na tela, digite " + _
                "LISTAR e use as setas  e  para 'passear' nela."
            GOSUB MostraMensagem
            MENSAGEM$ = "O resto é por sua conta. Procure examinar tudo, e " + _
                "raciocinar as pistas dadas pelo jogo."
            GOSUB MostraMensagem
            LINHAMSG$ = ""
            GOSUB RolaJanelaDeMensagens
            GOSUB RolaJanelaDeMensagens
            AVISO$ = "Digite qualquer tecla para jogar"
            GOSUB MostraAviso
          END IF
        END IF
      END IF
    END IF
  END IF

' Devolve à janela as linhas guardadas em BACKUP$ (usado ao sair de Ajuda e
' Notas).
RestauraJanelaDeMensagens:
  FOR LINBAK = 1 TO 11
    LINHAMSG$ = BACKUP$(LINBAK)
    GOSUB RolaJanelaDeMensagens
  NEXT LINBAK
  RETURN

' Minhas notas e agradecimentos.
MostraNotas:
  FOR I = 1 TO 11
    BACKUP$(I) = JANELA$(I)
  NEXT I
  AVISO$ = "Digite qualquer tecla..."
  MENSAGEM$ = "Este programa foi desenvolvido em Turbo Basic, e é bastante " + _
      "propenso a 'dar pau' em certas configurações. Vá por sua própria " + _
      "conta e risco..."
  GOSUB MostraMensagem
  MENSAGEM$ = "A única coisa que deverá ser observada é que, para dar um " + _
      "objeto a alguém, ex., o dinheiro ao caixa, use DEIXAR DINHEIRO. O " + _
      "caixa 'entenderá' que você quer entregar a ele, e não larga-lo no chão."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Agradecimentos:" : GOSUB MostraMensagem
  MENSAGEM$ = "Ao Ken Williams, ao Al Lowe e à toda a equipe da " + _
      "Sierra-On-Line, por todos os adventures que já fizeram e vierem a fazer."
  GOSUB MostraMensagem
  MENSAGEM$ = "Aos Stone Age Scanners, pelo incentivo a este e outros " + _
      "programas, bem como pelos beta-testes."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Ao Fábio (F.M.K.), pelas sugestões finais, pelo help na " + _
      "música e por tambem testar, e a todos os que também testaram e " + _
      "ajudaram a criar o programa."
  GOSUB MostraMensagem
  MENSAGEM$ = "Obs.: É verdade que faltam neste adventure algumas " + _
      "características interessantes, mas eu queria que ele rodasse bem, " + _
      "mesmo no XT monocromático (ergh !)."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Obs. (2): O programa é um pouco mal-educado, jogue por sua " + _
      "conta e risco. Não me processem se sentirem-se ofendidos. Estão " + _
      "avisados."
  GOSUB MostraMensagem
  MENSAGEM$ = "Obs. (3): Qualquer semelhança entre algum diálogo deste " + _
      "jogo e algum filme (Monty Pyton) e/ou desenho animado NÃO é mera " + _
      "coincidência..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Obs. (4): Se você, como eu, não gostar da música de " + _
      "abertura, ou tiver um XT barulhento como o meu, basta manter a " + _
      "tecla <ALT> pressionada até que a abertura se inicie."
  GOSUB MostraMensagem
  MENSAGEM$ = "Eu até diria que, para entrar no programa, basta digitar " + _
      "AVENTURA <ENTER>, mas se você está lendo isto, é óbvio que já sabe. " + _
      "Se você quiser pular a abertura e ir direto ao jogo, digite CA1 " + _
      "<ENTER> no nosso querido e iconográfico prompt do DOS."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Obs. (Final): Para acessar a documentação, digite LEIAME " + _
      "quando estiver no DOS. E boa sorte..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  GOTO RestauraJanelaDeMensagens
  ' Trecho que nada chama: centraliza TEXTO$ em 80 colunas (S é só temporária)
  S = (80 + -LEN(TEXTO$)) / 2
  TEXTO$ = SPACE$(S) + TEXTO$
  PRINT TEXTO$
  RETURN

' Mostra o aviso de que o jogo acabou e recomeça.
FimDeJogoMorte:
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  MENSAGEM$ = "Você falhou em sua missão de recuperar seu emprego. Aliás, " + _
      "você morreu. Mas, como isso é um adventure, este fato é " + _
      "irrelevante. Basta recomeçar ou carregar um jogo gravado."
  GOSUB MostraMensagem
  MENSAGEM$ = "Vamos lá ! Não se desespere ! O Papai Smurf está contando " + _
      "com você ! E, afinal de contas, você não quer saber o que raios tem " + _
      "neste disquete ? Levante a cabeça..."
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla para reiniciar o jogo..." : GOSUB MostraAviso
  CLEAR
  GOTO Inicio
  END  ' inalcançável
  END  ' inalcançável

' Final do jogo: a lâmpada estoura, os bombeiros chegam, o cofre é aberto.
FimDeJogoFinal:
  MENSAGEM$ = "Você coloca a lâmpada no soquete, e ouve um estouro. As " + _
      "poucas frestas que emanavam alguma luz não são mais visíveis. Tudo " + _
      "indica que você causou um curto-circuito."
  GOSUB MostraMensagem
  MENSAGEM$ = "Algumas horas se passam na escuridão. De repente, algumas " + _
      "vozes se fazem ouvir do lado de fora"
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla..." : GOSUB MostraAviso
  MENSAGEM$ = "'Ei, me tirem daqui !!!!', você grita, enquanto bate " + _
      "desesperado na parede."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Você aí dentro', diz uma das vozes, 'afaste-se desta parede !'"
  GOSUB MostraMensagem
  MENSAGEM$ = "Você obedece, e um barulho de metal batendo no concreto " + _
      "começa a ficar mais e mais alto, até que um bombeiro adentra o " + _
      "local com uma máquina de demolição."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Ao ver os bombeiros, você logo grita: 'Foi o Sr. L. ! É " + _
      "tudo culpa dele !'."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Sim, nós já sabemos. Fomos chamados para conter o tumulto " + _
      "do blecaute, e acabamos vistoriando o local e descobrindo suas " + _
      "ligações com o Serviço Secreto de Ohio."
  GOSUB MostraMensagem
  MENSAGEM$ = "Você é retirado do local, e após algumas horas de " + _
      "interrogatório e investigação, e um breve descanso na sua casa, " + _
      "você vai até o escritório."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Ao chegar lá, você descobre que o gerente assumiu o posto " + _
      "do seu chefe, e seu emprego está a salvo. Vocês trocam algumas " + _
      "informações, até que chegam 'naquele' assunto:"
  GOSUB MostraMensagem
  MENSAGEM$ = "'E o disquete, o que tinha ?'" : GOSUB MostraMensagem
  MENSAGEM$ = "'Não se sabe. A polícia procurou em todo lugar, e não " + _
      "encontrou nada. Só sobrou este cofre, totalmente selado..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  IF LOCOBJ(76) <> -999 THEN ' 76=Chave
    MENSAGEM$ = "Sem solução para isso, você continua a trabalhar até o " + _
        "fim de seus dias, sem jamais saber o que havia neste cofre " + _
        "(arrombá-lo seria perigoso, nunca se sabe o que o Sr. L. colocou " + _
        "como segurança)."
    GOSUB MostraMensagem
    MENSAGEM$ = "Acho que o jogo termina por aqui. Muito embora não tenha " + _
        "capturado o Sr. L, você cumpriu um dos objetivos básicos do jogo: " + _
        "recuperou seu emprego. Mas..."
    GOSUB MostraMensagem
    GOSUB MostraAviso
    MENSAGEM$ = "O que haveria no cofre ? Seria o disquete ? Se não, aonde " + _
        "está o disquete ? O que havia dentro dele ? Quem matou Odete " + _
        "Roytmann ? Quantas vezes por segundo uma andorinha africana bate " + _
        "as asas contra o vento para se manter voando ?"
    GOSUB MostraMensagem
    MENSAGEM$ = "Você jamais saberá a resposta destas perguntas. No " + _
        "entanto, você chegou no fim do jogo. Que tal voltar agora e " + _
        "tentar jogar de novo, só que procurando a chave e o disquete ? " + _
        "Vai lá, meu garoto !!!"
    GOSUB MostraMensagem
    AVISO$ = "Digite qualquer tecla para recomeçar..." : GOSUB MostraAviso
    CLEAR
    GOTO Inicio
    GOTO SaiParaODos  ' inalcançável
  END IF
  MENSAGEM$ = "'Ei, eu tenho uma chave !!!', você diz, eufórico."
  GOSUB MostraMensagem
  MENSAGEM$ = "'Duvido que sirva para algo, mas... EI, ESTA É UMA CHAVE " + _
      "MESTRA !!!'"
  GOSUB MostraMensagem
  MENSAGEM$ = "Vocês correm na direção do cofre, tiram as fitas que a " + _
      "perícia pôs sobre ele e assopram a poeira."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Você dá a chave ao gerente. Ele coloca-a dentro do buraco. " + _
      "Ele vira a chave para a esquerda, depois para a direita, e NADA !!!"
  GOSUB MostraMensagem
  MENSAGEM$ = "'QUE DROGA !!!!' - você diz, enquanto pensa em voltar à sua " + _
      "vida de aventuras para procurar a chave."
  GOSUB MostraMensagem
  MENSAGEM$ = "Você pega um cinzeiro da mesa e atira na direção do cofre, " + _
      "raivoso. De repente..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "...CLIC ! O cinzeiro pressionou a chave no ponto correto, o " + _
      "que destravou o cofre. Você e o gerente olham abismados para a " + _
      "porta que se abre automaticamente."
  GOSUB MostraMensagem
  MENSAGEM$ = "Uma névoa densa é revelada (que o Sr. L deve ter importado " + _
      "do show do Prince, só para dar um clima), até que ele se encontra " + _
      "totalmente aberto."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "'É O DISQUETE !!!', você grita, enquanto vai pulando com " + _
      "ele até a mesa do Sr. L. Vocês ligam o computador dele (nunca " + _
      "demorou tanto para aparecer o cursor quanto agora), e inserem o " + _
      "disquete."
  GOSUB MostraMensagem
  MENSAGEM$ = "O gerente digita o comando para acessar o disquete. A luz " + _
      "do drive acende, enquanto vocês, pasmos, observam a tela escura. De " + _
      "repente, o disco para. O micro solta um bip, e então..."
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Uma mensagem aparece no monitor. Abismado, você verifica " + _
      "que ela diz:"
  GOSUB MostraMensagem
  MENSAGEM$ = "           Felicitações pelo dia da Páscoa !!!"
  GOSUB MostraMensagem
  MENSAGEM$ = "			Ass.:Serviço Secreto de Ohio." : GOSUB MostraMensagem
  MENSAGEM$ = "ESSA NÃO !!! VOCE PASSOU POR TUDO ISSO POR CAUSA DE UMA " + _
      "CARTA DE FELICITAÇÕES ?!?!?!?!"
  GOSUB MostraMensagem
  GOSUB MostraAviso
  MENSAGEM$ = "Parabéns ! Você chegou ao fim do jogo ! Todos os objetivos " + _
      "foram cumpridos, mas o Sr. L. escapou. Não se preocupe. Ou melhor, " + _
      "se preocupe com a seqüência desta aventura. Ela estará disponível " + _
      "em breve."
  GOSUB MostraMensagem
  MENSAGEM$ = "Como em todo episódio do Jaspion, você terminou exatamente " + _
      "onde começou, não capturou nenhum bandido, e o que fugiu promete " + _
      "vingança. "
  MENSAGEM$ = MENSAGEM$ + "Não esquente com isso. Acontece nas melhores " + _
      "famílias. De qualquer forma, você já tem algo para contar aos seus " + _
      "netinhos. Adiós !!!"
  GOSUB MostraMensagem
  AVISO$ = "Digite qualquer tecla para ir ao DOS..." : GOSUB MostraAviso
  GOTO SaiParaODos

' Limpa a tela e termina.
SaiParaODos:
  COLOR 15, 0, 0
  CLS
  END
