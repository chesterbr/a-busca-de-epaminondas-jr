10 ' CA1.BAS gerado por basic/gerar.py a partir do CA1.EXE. As linhas `REM ???` sÑo instruáîes ainda sem traduáÑo.
20 ' Nomes de vari†veis e de r¢tulos sÑo nossos (o execut†vel nÑo guarda nenhum); os n£meros de linha tambÇm; com --rotulos, Lxxxxx = endereáo da imagem do .EXE.
30 ' **************************************************************
40 ' INICIALIZACAO
50 ' Titulo, mensagens, tabelas (DATA) e estado inicial do jogo.
60 ' **************************************************************
100 CLEAR : RESTORE
110 ' T°tulo do jogo: lido de DATA e decodificado (cada n£mero Ç o c¢digo ASCII mais a posiáÑo), para dificultar a ediáÑo com um editor bin†rio
120 TITULO$ = ""
130 FOR I = 1 TO 70
140   READ C
150   TITULO$ = TITULO$ + CHR$(C - I)
160 NEXT I
1000 DATA 66,34,69,121,120,105,104,40,109,111
1010 DATA 43,81,125,111,124,121,127,129,129,120
1020 DATA 118,137,55,98,139,72,59,114,78,76
1030 DATA 84,64,78,66,75,135,78,70,88,97
1040 DATA 98,92,75,156,156,160,79,115,121,119
1050 DATA 134,136,122,136,87,96,124,155,173,168
1060 DATA 172,177,95,132,182,163,181,184,170,111
2000 ' Mensagens do jogo: AVENTURA.MSG, uma por linha, em MSG$(1) a MSG$(NUMMSG)
2010 NUMMSG = 327
2020 DIM MSG$(NUMMSG)
2030 OPEN "AVENTURA.MSG" FOR INPUT AS #1
2040 FOR I = 1 TO 327
2050   LINE INPUT #1, MSG$(I)
2060 NEXT I
2070 CLOSE #1
2080 ' Visitas Ös salas e dicion†rio de sinìnimos de verbos (palavra, n£mero do verbo, parÉmetros: 0 nenhum, 1 opcional, 2 obrigat¢rio)
2090 NUMSALAS = 67
2100 NUMSINONIMOS = 74
2110 DIM VISITADA(NUMSALAS)
2120 DIM SINONIMOVERBO$(NUMSINONIMOS), VERBO(NUMSINONIMOS), PARAM(NUMSINONIMOS)
2130 FOR I = 1 TO NUMSINONIMOS
2140   READ SINONIMOVERBO$(I), VERBO(I), PARAM(I)
2150 NEXT I
3000 DATA "NORTE",1,0
3010 DATA "N",1,0
3020 DATA "SUL",2,0
3030 DATA "S",2,0
3040 DATA "LESTE",3,0
3050 DATA "L",3,0
3060 DATA "OESTE",4,0
3070 DATA "O",4,0
3080 DATA "IR",5,2
3090 DATA "ENTRAR",5,2
3100 DATA "PEGAR",6,2
3110 DATA "CATAR",6,2
3120 DATA "APANHAR",6,2
3130 DATA "TOMAR",6,2
3140 DATA "LISTAR",7,0
3150 DATA "INVENTARIO",7,0
3160 DATA "OBJETOS",7,0
3170 DATA "LARGAR",8,2
3180 DATA "DEIXAR",8,2
3190 DATA "SOLTAR",8,2
3200 DATA "OLHAR",9,2
3210 DATA "VER",9,2
3220 DATA "EXAMINAR",9,2
3230 DATA "OBSERVAR",9,2
3240 DATA "VERIFICAR",9,2
3250 DATA "FALAR",10,2
3260 DATA "CONVERSAR",10,2
3270 DATA "CIMA",11,0
3280 DATA "C",11,0
3290 DATA "SUBIR",11,0
3300 DATA "BAIXO",12,0
3310 DATA "B",12,0
3320 DATA "DESCER",12,0
3330 DATA "LER",13,2
3340 DATA "LIGAR",14,2
3350 DATA "USAR",14,2
3360 DATA "ACENDER",14,2
3370 DATA "ABRIR",15,2
3380 DATA "BEIJAR",16,2
3390 DATA "ABRACAR",16,2
3400 DATA "MENU",17,0
3410 DATA "CHUPAR",18,2
3420 DATA "QUEBRAR",19,2
3430 DATA "DETONAR",19,2
3440 DATA "ARREBENTAR",19,2
3450 DATA "DESTRUIR",19,2
3460 DATA "SAIR",20,0
3470 DATA "ABANDONAR",20,0
3480 DATA "DIZER",21,2
3490 DATA "FECHAR",22,2
3500 DATA "DESLIGAR",22,2
3510 DATA "ROSQUEAR",23,2
3520 DATA "DESROSQUEAR",24,2
3530 DATA "VOAR",25,0
3540 DATA "MORDER",26,2
3550 DATA "XINGAR",26,2
3560 DATA "BATER",26,2
3570 DATA "ESPANCAR",26,2
3580 DATA "LAMBER",26,2
3590 DATA "COMER",27,2
3600 DATA "CHEIRAR",28,0
3610 DATA "ATRAVESSAR",29,2
3620 DATA "PULAR",30,1
3630 DATA "JOGAR",31,1
3640 DATA "BRINCAR",31,1
3650 DATA "PASSEAR",31,1
3660 DATA "DORMIR",31,1
3670 DATA "CAVALGAR",31,1
3680 DATA "MASTURBAR",31,1
3690 DATA "ARREMESSAR",32,2
3700 DATA "LANCAR",32,2
3710 DATA "SENTAR",33,1
3720 DATA "DEITAR",33,1
3730 DATA "APAGAR",34,2
4000 ' Objetos: nome, local inicial (negativo: fixo no local), texto que a sala mostra com o objeto e texto do EXAMINAR
4010 NUMOBJ = 88
4020 DIM OBJ$(NUMOBJ), LOCOBJ(NUMOBJ), AQUI$(NUMOBJ), EXAME$(NUMOBJ), INV$(NUMOBJ)
4030 FOR I = 1 TO NUMOBJ
4040   READ OBJ$(I), LOCOBJ(I), AQUI$(I), EXAME$(I)
4050 NEXT I
5000 DATA "NORTE",0,"",""
5010 DATA "SUL",0,"",""
5020 DATA "LESTE",0,"",""
5030 DATA "OESTE",0,"",""
5040 DATA "LISTA",2,"H† uma lista telefìnica jogada num canto.",""
5050 DATA "AZULEJO",1,"Vocà nota um azulejo solto no chÑo."
5060 DATA "O azulejo tem um desenho bastante trabalhado. No verso est† escrito algo sobre o estilo, o autor e o material utilizado e aquele bl†-bl†-bl† caracter°stico do seu professor de literatura..."
5070 DATA "COFRE",-1,"Um grande cofre de metal jaz na parede.","Cheio de trancas e travas, este cofre somente pode ser aberto por quem tiver a chave. NÑo perca tempo. VAI PROCURAR, SEU PULHA !!!"
5080 DATA "HOMEM",-3,"Um homem mal-encarado est† apoiado num poste.","'QualÇ, nunca viu, ì palhaáo ?', ele diz, enquanto polui a caláada cuspindo algo extremamente nojento para que possa ser descrito neste jogo."
5090 DATA "POSTE",-3,"","Ali diz: 'PONTO DE ìNIBUS'"
5100 DATA "LOCAL",0,"",""
5110 DATA "SALAO",-4,"","A porta est† aberta. H† uma placa no topo da mesma"
5120 DATA "PLACA",-4,"","Ela diz: 'BIBLIOTECA'"
5130 DATA "PORTA",-4,"","Ela est† aberta."
5140 DATA "BALCONISTA",-5,"Uma linda balconista devora um exemplar da revista 'Capricho' atr†s do balcÑo.","Ela Ç totalmente DEMAIS. Ela nota seu olhar insistente, e responde da mesma forma."
5150 DATA "LIVRO",0,"Um livro atrapalha a passagem","ê um exemplar de 'OperaáÑo Cavalo de Tr¢ia III'."
5160 DATA "PAPEL",0,"","Ali diz: ' 442-8093 '."
5170 DATA "BALCAO",-5,"O balcÑo lhe chama a atenáÑo, pois ocupa metade da biblioteca.","A £nica coisa not†vel Ç que s¢ se pode pegar livros de dentro dele."
5180 DATA "ESCADA",-6,"H† uma escada aqui.","Nada de especial nela."
5190 DATA "CIMA",0,"","Nada a declarar."
5200 DATA "BAIXO",0,"","Nada de novo que chame a atenáÑo."
5210 DATA "LANTERNA",7,"Uma lanterna est† no chÑo.","Ela est† sem pilhas"
5220 DATA "PILHAS",15,"Algumas pilhas estÑo jogadas no chÑo.","As pilhas servem bem na lanterna."
5230 DATA "SALA",0,"",""
5240 DATA "AREA",0,"",""
5250 DATA "ONIBUS",-4,"","V†rios deles passam por aqui, e PEGAR um ONIBUS seria uma idÇia bastante interessante..."
5260 DATA "GRANA",-999,"",""
5270 DATA "VIGIA",-11,"Um vigia est† te encarando, rapaz.","O homem nÑo Ç tÑo forte para exercer a profissÑo de vigia, mas sua autoridade se concentra num ˙38 que ele tem na cintura."
5280 DATA "BORRACHA",0,"Uma borracha est† largada no chÑo.","Nada de especial nela"
5290 DATA "MESA",-13,"","Nem pense em mexer nela. Vocà poderia acordar a secret†ria, e ser preso por invasÑo e roubo. Vocà j† tem problemas demais, como, por exemplo, AQUELE disquete (lembra?). PROCURE-O !!!"
5300 DATA "SECRETARIA",-13,"A secret†ria 'puxa um ronco' sobre sua mesa.","Ela nÑo Ç nada de que se diga 'OH, mas que secret†ria SUPIMPA', mas nÑo Ç de se jogar fora"
5310 DATA "FOSFOROS",-999,""
5320 DATA "Cada um dos f¢sforos consiste em uma haste de madeira e uma concentraáÑo de material combust°vel na ponta. Ao utiliz†-los, eles devem acender, e, nÑo antes, nem durante, mas depois, eles devem apagar."
5330 DATA "MALA",0,"Uma mala lhe chama a atenáÑo.","Deve haver algo interessante dentro dela."
5340 DATA "PAPEIS",0,"H† um bolo de papÇis aqui.","SÑo apenas papÇis em branco"
5350 DATA "PASSAGEM",0,"Uma passagem perdida repousa no chÑo.","'Destino: Baz†rgada'"
5360 DATA "PORTA",-57,"H† uma porta autom†tica ao leste.",""
5370 DATA "AKIRA",0,"",""
5380 DATA "CARTEIRA",24,"Uma carteira est† largada no chÑo.","Nada de especial."
5390 DATA "CARTAO",0,"H† um cartÑo aqui.","Ele diz: 'JADER DANCING POINT - ÆAØ Danceteria - Permanente'"
5400 DATA "VELHINHO",-27,"Um velhinho est† jogando uma m†quina qualquer","Ele Ç, sem d£vida, um bom velhinho."
5410 DATA "ELEVADOR",-30,"","Nada a declarar."
5420 DATA "BISPO",29,"Uma figura imponente se destaca do cen†rio. ê um bispo. Todos os que passam olham para este, com aquele olhar que s¢ os muito crentes tàm.","ê um bispo como outro qualquer."
5430 DATA "MARRETA",0,"Eis uma marreta no chÑo.","NÑo pode destruir uma parede, mas quem sabe algo menos forte..."
5440 DATA "MADEIRA",-31,"","ê apenas madeira."
5450 DATA "PAREDE",-31,"","ê feita de madeira."
5460 DATA "COFRE",-35,"H† um cofre aqui.","Est† vazio."
5470 DATA "TUBO",-35,"Um tubo abaixo de vocà d† acesso a alguma coisa.","Est† bem escuro l† embaixo."
5480 DATA "TAXISTA",-39,"Um taxista est† apoiado em seu taxi.","O cara nÑo parece ser daqui."
5490 DATA "TAXI",-39,"","NÑo Ç o MACH 5, mas depois do carro do vendedor, qualquer eca serve."
5500 DATA "ENVELOPE",12,"Tem um envelope marrom no chÑo.","O envelope Ç daqueles comerciais, que costumam conter documentos importantes. Infelizmente, este est† vazio."
5510 DATA "RECEPCIONISTA",-40,"","Ela Ç muito bonita, mas precisa de um bom truque para ser dobrada e nos deixar passar."
5520 DATA "ELEVADOR",-42,"","NÑo Ç o que se possa chamar de 'estado-da-arte' em termos de elevadores, mas vocà j† viu coisa pior. H† uma placa nele."
5530 DATA "ELEVADOR",-43,"","Ele s¢ conduz aos sub-solos inferiores (1 e 2)"
5540 DATA "PLACA",-42,"","ê uma tabela que diz: 	1ßAndar.........................Analistas 	2ßAndar............................C.P.D. 	3ßAndar..........................Gerància"
5550 DATA "ANALISTAS",-44,"Alguns analistas de sistemas passam por vocà."
5560 DATA "NÑo parecem ser as pessoas mais amig†veis do mundo, nem as mais trabalhadoras, pois muitos estÑo massageando seus ¢rgÑos genitais (com pomadinha Hippolgr¢s, Ç claro)."
5570 DATA "PROGRAMADORES",-45,"Alguns programadores estÑo com o nariz colado nos monitores.","Eles parecem muito interessados no que estÑo fazendo"
5580 DATA "DISQUETES",-55,"H† uma pilha de disquetes bem presa ao chÑo."
5590 DATA "Hum... vejamos... imagens digitalizadas... Space Quest III... Digger (amasse este)... Nenhum deles Ç o nosso disquete. Mas mesmo que fosse, eles foram presos ao chÑo com arame farpado, o que os inutilizou."
5600 DATA "COMPUTADORES",-45,"Os computadores estÑo todos sendo usados por eles."
5610 DATA "Agora vocà và o que eles estÑo fazendo. ê melhor nÑo incomod†-los. Afinal, quem seria tÑo cruel a ponto de interromper uma partida de 'Leisure Suit Larry' ?"
5620 DATA "ARAME",-55,"","Isso pode ser £til num adventure, especialmente quando vocà precisar de uma corda..."
5630 DATA "PAINEL",-50,"H† um grande painel na parede.","Um desenho bastante incrementado, e uma frase do Laerte: 'Neste local, quem nÑo vive para servir nÑo serve para viver.'"
5640 DATA "PIA",-51,"Tem uma pia aqui.","Olhe, alguÇm deixou uma bala aqui..."
5650 DATA "PORTA",-52,"","Ela est† aberta."
5660 DATA "MESA",-53,"A mesa do Sr. L. est† cheia de coisinhas.","NÑo prima muito pela organizaáÑo. As coisas estÑo caindo pelos cantos, quando nÑo vÑo parar no cesto de lixo, caem no chÑo e ali ficam para sempre."
5670 DATA "DOCUMENTOS",53,"Estes documentos a° podem ser importantes.","Nada que lhe fascine. Apenas coisas corriqueiras da firma, como subornos, transaáîes il°citas e tudo o que se encontra numa firma assim."
5680 DATA "CESTO",-53,"","Ele est† cheio de lixo."
5690 DATA "LIXO",-53,"","O que vocà espera encontrar ?"
5700 DATA "AGENDA",0,"","Vejamos as anotaáîes recentes... A caligrafia Ç boa, mas nÑo d† para entender uma palavra. Hmm..."
5710 DATA "GRUPO",-59,"Um grupo de danáa est† fazendo seu showzinho","O grupo Ç organizado, mas nada de incr°vel"
5720 DATA "BALCAO",-61,"NÑo h† ninguÇm no balcÑo.","Nada de especial."
5730 DATA "BARMAN",-61,"O Barman est† olhando para vocà.","A £nica funáÑo dele Ç servir bebidas. Ele nÑo serve para mais nada."
5740 DATA "MESAS",-60,"As mesas estÑo espalhadas pelo lugar","EstÑo todas ocupadas, e o pessoal parece nÑo querer ser incomodado. Nem tente mexer com eles."
5750 DATA "CD",53,"Tem um CD aqui no chÑo.","ê um disco laser do Bomb the Bass"
5760 DATA "DJ",-62,"O DJ vai selecionando as m£sicas.","Ele parece curtir o que faz."
5770 DATA "TETO",0,"","Nada ali em cima vai lhe ajudar"
5780 DATA "NOZ",30,"Tem uma noz aqui.","ê uma noz comum."
5790 DATA "CHAO",0,"","Levante a cabeáa, rapaz !!!"
5800 DATA "CHAVE",0,"Tem uma chave aqui.","Parece ser uma chave de cofre..."
5810 DATA "LAMPADA",66,"","A lÉmpada faz parte de uma ligaáÑo elÇtrica bastante ruim."
5820 DATA "BALA",51,"","ê uma bala comum."
5830 DATA "EMBALAGEM",0,"H† uma embalagem de bala no chÑo.","A embalagem da bala Ç de papel-alum°nio"
5840 DATA "MESA",-62,"","Atr†s da mesa de som (e do DJ, obviamente) tem uma porta. Mas nÑo d† para passar sem que o DJ saia de l†"
5850 DATA "NI",0,"",""
5860 DATA "SOQUETE",-66,"","Geralmente Ç utilizado para segurar lÉmpadas no teto, impedindo que elas caiam."
5870 DATA "PERFUME",0,"","Talvez isso seja um pouco dif°cil..."
5880 DATA "BANHEIRO",0,"",""
5890 DATA "LIVROS",-6,"","SÑo muitos volumes, mas nÑo d† para alcaná†-los."
5900 DATA "RUA",-3,"","Est† bastante movimentada, com todos os tipos de ve°culos imagin†veis. Nem pense em atravess†-la."
5910 DATA "COMPUTADOR",-18,"","Est† firmemente preso Ö mesa. Uma preciosidade dessas nÑo pode ser levada tÑo facilmente."
5920 DATA "GRAVADOR",-18,"","Como vocà j† deve ter suposto, ele nÑo funciona. Nem tente lev†-lo."
6000 GOSUB 42000
6010 ' Palavras ignoradas na an†lise do comando
6020 NUMFILTRO = 21
6030 DIM FILTRO$(NUMFILTRO)
6040 FILTRO$(1) = " COM "
6050 FILTRO$(2) = " A "
6060 FILTRO$(3) = " O "
6070 FILTRO$(4) = " PARA "
6080 FILTRO$(5) = " DE "
6090 FILTRO$(6) = " POR "
6100 FILTRO$(7) = " PRA "
6110 FILTRO$(8) = " PRO "
6120 FILTRO$(9) = " QUE "
6130 FILTRO$(10) = " AO "
6140 FILTRO$(11) = " ATE "
6150 FILTRO$(12) = " OS "
6160 FILTRO$(13) = " AS "
6170 FILTRO$(14) = " UM "
6180 FILTRO$(15) = " UMA "
6190 FILTRO$(16) = " UNS "
6200 FILTRO$(17) = " UMAS "
6210 FILTRO$(18) = " EM "
6220 FILTRO$(19) = " NO "
6230 FILTRO$(20) = " NA "
6240 FILTRO$(21) = " DO "
6250 SALA = 1
6260 GOSUB 13100
6270 ' Palavrîes (quando digitados como verbo, o jogo reage)
6280 NUMPALAVROES = 16
6290 DIM PALAVROES$(NUMPALAVROES)
6300 FOR I = 1 TO NUMPALAVROES
6310   READ PALAVROES$(I)
6320 NEXT I
7000 DATA "MERDA","BOSTA","CU","CARALHO","PORRA","BICHA","VEADO","VIADO","CACETE","BOCETA"
7010 DATA "BUCETA","PUTA","SE FODER","FODA","FODA-SE","CUZAO"
8000 ' P†ginas da lista telefìnica (cada OLHAR LISTA mostra a seguinte)
8010 DIM JANELA$(11), BACKUP$(11), DESCLISTA$(4)
8020 DESCLISTA$(1) = "Existem muitas informaáîes nesta lista. Uma delas Ç 'Acesso ao VideoTexto'. Vocà passa batido."
8030 DESCLISTA$(2) = "Outra coisa quase interessante na lista: 'Como adquirir seu telefone'."
8040 DESCLISTA$(3) = "Olhe s¢, um mapa de ruas. Pena estar todo esburacado. Mas j† Ç mais interessante..."
8050 DESCLISTA$(4) = "Opa, um guia de 'Itiner†rio de ìnibus'. Interessante Ç que a frase 'Linha 4283 - Vila Inhang¢zinho' est† sublinhada. Hum..."
8060 ' Estado do jogo: valores que mudam com o progresso (o que veio antes sÑo tabelas)
8070 LANTERNA$ = "desligada"
8080 NOZAVISO = 0
8090 GRANA = 500
8100 PORTAABERTA = 0
8110 GOSUB 42500
8120 BARMAN = 0
8130 PAPELALUM = 0
10000 ' **************************************************************
10010 ' LOOP PRINCIPAL
10020 ' Mostra a sala quando muda, le e analisa o comando e executa o verbo.
10030 ' **************************************************************
10040 IF SALAANT <> SALA THEN GOSUB 42900 : GOSUB 42400 : GOSUB 42600   ' Executa a rotina da sala; Mostra os objetos da sala; Atualiza as direáîes poss°veis
10050 SALAANT = SALA
10060 VISITADA(SALA) = 1
10070 FLAG4D6 = 1
10080 IF FLAG4D6 THEN GOSUB 12100 : GOSUB 12500 : GOTO 10080   ' Là o comando digitado; Analisa o comando (verbo e objeto)
10090 IF VERBO(INDICEVERBO) <> 27 THEN NOZAVISO = 0
10100 IF VERBO(INDICEVERBO) = 9 AND SALA = 58 THEN MENSAGEM$ = "ê melhor sair da portaria, antes que o engomadinho venha lhe encher o saco de novo." : GOSUB 42000 : GOTO 10040
10110 ON VERBO(INDICEVERBO) GOSUB 20100, 20200, 20300, 20400, 20500, 20700, 20900, 21200, 21600, 21900, 22700, 22800, 22900, 23000, 23600, 23800, 24000, 24600, 24700, 24800, 24900, 25000, 25100, 25200, 25300, 25400,_
      25500, 25600, 25700, 25900, 26000, 26100, 26200, 26300
10120 GOTO 10040
12000 ' **************************************************************
12010 ' SUB-ROTINAS (1/5): ENTRADA E TELA
12020 ' Ler e analisar o comando, desenhar a tela.
12030 ' **************************************************************
12100 ' ===== sub-rotina: là o comando @ 08c10 =====
12110 TECLA$ = ""
12120 COMANDO$ = ""
12130 LOCATE 18, 16
12140 PRINT SPACE$(64);
12150 WHILE TECLA$ <> CHR$(13)
12160   LOCATE 18, 16
12170   COLOR 7
12180   PRINT COMANDO$;
12190   COLOR 31
12200   PRINT "˛";
12210   COLOR 11
12220   PRINT " ";
12230   LOCATE 18, 16 + LEN(COMANDO$)
12240   LOCATE 21, 16
12250   COLOR 7
12260   PRINT "Digite um comando, ou ÆESCØ para menu..."
12270   LOCATE 1, 1
12280   TECLA$ = ""
12290   WHILE TECLA$ = "" : TECLA$ = INKEY$ : WEND
12300   IF TECLA$ >= "a" AND TECLA$ <= "z" THEN TECLA$ = CHR$(ASC(TECLA$) - 32)
12310   IF ASC(TECLA$) >= 32 AND ASC(TECLA$) <= 127 AND LEN(COMANDO$) < 60 THEN COMANDO$ = COMANDO$ + TECLA$
12320   IF TECLA$ = CHR$(8) AND COMANDO$ <> "" THEN COMANDO$ = LEFT$(COMANDO$, LEN(COMANDO$) - 1)
12330   IF TECLA$ = CHR$(27) THEN ANTERIOR$ = COMANDO$ : COMANDO$ = "" : LOCATE 18, 16 : PRINT SPACE$(64); : GOSUB 24000
12340   IF TECLA$ = CHR$(0) + CHR$(59) AND LEN(COMANDO$) < LEN(ANTERIOR$) THEN COMANDO$ = COMANDO$ + MID$(ANTERIOR$, LEN(COMANDO$) + 1, 1)
12350   IF TECLA$ = CHR$(0) + CHR$(61) AND LEN(COMANDO$) < LEN(ANTERIOR$) THEN COMANDO$ = COMANDO$ + RIGHT$(ANTERIOR$, LEN(ANTERIOR$) - LEN(COMANDO$))
12360 WEND
12370 LOCATE 18, 16
12380 PRINT SPACE$(64);
12390 LOCATE 21, 16
12400 PRINT SPACE$(64);
12410 LOCATE 18, 16
12420 COLOR 7
12430 PRINT COMANDO$;
12440 COLOR 11
12450 IF COMANDO$ = "" THEN GOTO 12100
12460 ANTERIOR$ = COMANDO$
12470 RETURN
12500 ' ===== sub-rotina: analisa o comando @ 08f7e =====
12510 GOSUB 13000
12520 ESPACO = INSTR(COMANDO$, " ")
12530 IF ESPACO = 0 THEN PALAVRA$ = COMANDO$ : NOME$ = "" ELSE PALAVRA$ = LEFT$(COMANDO$, ESPACO - 1) : NOME$ = MID$(COMANDO$, ESPACO + 1)
12540 PALAVRAO = 0
12550 FOR I = 1 TO NUMPALAVROES
12560   IF PALAVROES$(I) = PALAVRA$ OR PALAVROES$(I) = NOME$ THEN QTDEPALAVROESDITOS = QTDEPALAVROESDITOS + 1 : PALAVRAO = 1
12570 NEXT I
12580 IF QTDEPALAVROESDITOS > 10 THEN
12590   COLOR 15, 0, 0
12600   CLS
12610   COLOR 31
12620   PLAY "O2L2C"
12630   PRINT "ERRO INTERNO # 143 ! FALTA DE BONS COSTUMES ! ABORTAR..."
12640   COLOR 15
12650   PRINT "Seja mais educado na pr¢xima vez..."
12660   FOR J = 1 TO 10
12670     TECLALISTA$ = RIGHT$(TIME$, 2)
12680     WHILE TECLALISTA$ = RIGHT$(TIME$, 2)
12690     WEND
12700   NEXT J
12710   CLS
12720   END
12730 END IF
12740 IF PALAVRAO THEN MENSAGEM$ = "Vocà nÑo deveria ser tÑo mal-educado com um jogo como este." : GOSUB 42000 : GOSUB 12100 : GOTO 12500   ' Là o comando digitado
12750 INDICEVERBO = 0
12760 FOR I = 1 TO NUMSINONIMOS
12770   IF PALAVRA$ = SINONIMOVERBO$(I) THEN INDICEVERBO = I
12780 NEXT I
12790 IF INDICEVERBO = 0 THEN AVISO$ = "NÑo entendi o verbo " + PALAVRA$ : GOSUB 41000 : FLAG4D6 = 1 : RETURN
12800 IF NOME$ = "" AND PARAM(INDICEVERBO) = 2 THEN AVISO$ = PALAVRA$ + " O QUE ?" : GOSUB 41000 : FLAG4D6 = 1 : RETURN
12810 OBJ = 0
12820 OBJACHADO = 0
12830 IF NOME$ = "LISTA TELEFONICA" THEN NOME$ = "LISTA"
12840 FOR I = 1 TO NUMOBJ
12850   IF NOME$ = OBJ$(I) AND OBJACHADO AND ABS(LOCOBJ(I)) = SALA THEN OBJ = I
12860   IF NOME$ = OBJ$(I) AND NOT OBJACHADO THEN OBJ = I : OBJACHADO = -1
12870 NEXT I
12880 IF NOME$ = "DINHEIRO" THEN OBJ = 26
12890 IF (NOME$ = "LUGAR" OR NOME$ = NOMESALA$) AND OBJ = 0 THEN OBJ = 10
12900 IF OBJ = 0 AND PARAM(INDICEVERBO) = 2 THEN AVISO$ = "O que vocà quer dizer com " + NOME$ + " ?" : GOSUB 41000 : FLAG4D6 = 1 : RETURN
12910 IF NOME$ <> "" AND PARAM(INDICEVERBO) = 0 THEN AVISO$ = PALAVRA$ + " nÑo combina com " + NOME$ : GOSUB 41000 : FLAG4D6 = 1 : RETURN
12920 FLAG4D6 = 0
12930 RETURN
13000 ' ===== sub-rotina: limpa o comando: espaáos repetidos e palavras de FILTRO$ @ 09648 =====
13010 DUPLO = INSTR(COMANDO$, "  ")
13020 IF DUPLO <> 0 THEN COMANDO$ = LEFT$(COMANDO$, DUPLO) + MID$(COMANDO$, DUPLO + 2) : GOTO 13000
13030 IF LEFT$(COMANDO$, 1) = " " THEN COMANDO$ = MID$(COMANDO$, 2) : GOTO 13000
13040 IF RIGHT$(COMANDO$, 1) = " " THEN COMANDO$ = LEFT$(COMANDO$, LEN(COMANDO$) - 1) : GOTO 13000
13050 FOR K = 1 TO NUMFILTRO
13060   POSFILTRO = INSTR(COMANDO$, FILTRO$(K))
13070   IF POSFILTRO <> 0 THEN COMANDO$ = LEFT$(COMANDO$, POSFILTRO - 1) + MID$(COMANDO$, POSFILTRO + LEN(FILTRO$(K)) - 1)
13080 NEXT K
13090 RETURN
13100 ' ===== sub-rotina: desenha o estado inicial da tela: moldura, t°tulo e janelas (que depois s¢ sÑo atualizadas) @ 09818 =====
13110 LOCATE 1, 1
13120 COLOR 11, 10, 2
13130 CLS
13140 PRINT "…"; STRING$(78, "Õ"); "ª"; "∫    ";
13150 COLOR 15
13160 PRINT TITULO$;
13170 COLOR 11
13180 PRINT "    ∫"; "»"; STRING$(78, "Õ"); "º"; "…"; STRING$(58, "Õ"); "ª…"; STRING$(18, "Õ"); "ª";
13190 FOR LIN = 5 TO 15
13200   LOCATE LIN, 1
13210   PRINT "∫";
13220   LOCATE LIN, 60
13230   PRINT "∫∫";
13240   LOCATE LIN, 80
13250   PRINT "∫";
13260 NEXT LIN
13270 PRINT "»"; STRING$(58, "Õ"); "º»"; STRING$(18, "Õ"); "º"; "…"; STRING$(12, "Õ"); "ª…"; STRING$(64, "Õ"); "ª"; "∫    ";
13280 COLOR 8
13290 PRINT "";
13300 COLOR 11
13310 PRINT "       ∫∫"; SPACE$(64); "∫"; "∫";
13320 COLOR 8
13330 PRINT "    N     C ";
13340 COLOR 11
13350 PRINT "∫»"; STRING$(64, "Õ"); "º"; "∫";
13360 COLOR 8
13370 PRINT " O   L " + CHR$(26) + "  ";
13380 COLOR 11
13390 PRINT "∫…"; STRING$(64, "Õ"); "ª"; "∫";
13400 COLOR 8
13410 PRINT "    S     B ";
13420 COLOR 11
13430 PRINT "∫∫"; SPACE$(64); "∫"; "∫";
13440 COLOR 8
13450 PRINT "           ";
13460 COLOR 11
13470 PRINT "∫∫"; SPACE$(64); "∫"; "»"; STRING$(12, "Õ"); "º»"; STRING$(64, "Õ"); "º";
13480 COLOR 15, 0
13490 LOCATE 4, 26
13500 PRINT " Mensagens "
13510 LOCATE 4, 67
13520 PRINT " Objetos "
13530 LOCATE 17, 3
13540 PRINT " Direáîes "
13550 LOCATE 17, 42
13560 PRINT " Comando "
13570 LOCATE 20, 38
13580 PRINT " Avisos e Extras "
13590 COLOR 11, 10
13600 RETURN
20000 ' **************************************************************
20010 ' SUB-ROTINAS (2/5): VERBOS
20020 ' Uma sub-rotina por verbo, escolhida por ON ... GOTO.
20030 ' **************************************************************
20100 ' ===== verbo 1 NORTE/N @ 09bc9 =====
20110 IF N = 0 THEN AVISO$ = "SUA ANTA ! Vocà nÑo pode ir para o norte !!!" : GOSUB 41000 : GOSUB 42600 : RETURN
20120 SALA = N
20130 RETURN
20200 ' ===== verbo 2 SUL/S @ 09bf8 =====
20210 IF SALA = 11 AND VISITADA(9) = 0 THEN MENSAGEM$ = MSG$(1) : GOSUB 42000 : RETURN   ' msg 0: O vigia barra seu caminho. 'Esta passagem Ç apenas para alun
20220 IF SALA = 11 THEN MENSAGEM$ = MSG$(2) : GOSUB 42000   ' msg 1: O vigia olha para vocà com desprezo e diz 'Pode passar. Com 
20230 IF S = 0 THEN AVISO$ = "SUA ANTA ! Vocà nÑo pode ir para o sul !!!" : GOSUB 41000 : GOSUB 42600 : RETURN
20240 SALA = S
20250 RETURN
20300 ' ===== verbo 3 LESTE/L @ 09c98 =====
20310 IF L = 0 THEN AVISO$ = "SUA ANTA ! Vocà nÑo pode ir para o leste !!!" : GOSUB 41000 : GOSUB 42600 : RETURN
20320 SALA = L
20330 RETURN
20400 ' ===== verbo 4 OESTE/O @ 09cc7 =====
20410 IF O = 0 THEN AVISO$ = "SUA ANTA ! Vocà nÑo pode ir para o oeste !!!" : GOSUB 41000 : GOSUB 42600 : RETURN
20420 SALA = O
20430 RETURN
20500 ' ===== verbo 5 IR/ENTRAR @ 09cf6 =====
20510 ON OBJ GOTO 20100, 20200, 20300, 20400
20520 IF OBJ = 11 AND SALA = 4 THEN SALA = 5 : RETURN
20530 IF OBJ = 19 THEN GOTO 22700
20540 IF OBJ = 20 THEN GOTO 22800
20550 IF OBJ = 13 AND SALA = 4 THEN GOTO 20200
20560 IF OBJ = 46 AND SALA = 35 THEN GOTO 22800
20570 IF OBJ = 17 AND SALA <> 5 THEN MENSAGEM$ = "NÑo posso." : GOSUB 42000 : RETURN
20580 IF OBJ = 17 AND LOCOBJ(14) <> 0 THEN MENSAGEM$ = MSG$(3) : GOSUB 42000 : RETURN   ' msg 2: 'Sinto muito, mas esta †rea Ç restrita a funcion†rios...' - 
20590 IF OBJ = 17 THEN SALA = 6 : RETURN
20600 IF OBJ = 18 AND SALA = 6 THEN SALA = 7 : RETURN
20610 IF OBJ = 35 AND SALA = 57 AND PORTAABERTA = 0 THEN MENSAGEM$ = MSG$(4) : GOSUB 42000 : RETURN   ' msg 3: Ela est† fechada...
20620 IF OBJ = 35 AND SALA = 57 THEN GOTO 20300
20630 MENSAGEM$ = MSG$(5) : GOSUB 42000   ' msg 4: Vocà nÑo pode ir atÇ isso !
20640 RETURN
20700 ' ===== verbo 6 PEGAR/CATAR/APANHAR/TOMAR @ 09f9e =====
20710 IF OBJ = 82 AND SALA = 66 THEN MENSAGEM$ = "ZZZZZZAAAP !!! Um choque de 220V escurece o local e a vocà, que morre carbonizado." : GOSUB 42000 : GOTO 61780
20720 IF OBJ = 77 AND SALA = 66 AND LOCOBJ(77) = 66 THEN MENSAGEM$ = "Tente desrosque†-la." : GOSUB 42000 : RETURN
20730 IF OBJ = 25 THEN GOTO 23000
20740 IF OBJ = 58 THEN MENSAGEM$ = MSG$(6) : GOSUB 42000 : RETURN   ' msg 5: NÑo d†. Ele est† firmemente preso ao chÑo. A nÑo ser que voc
20750 IF LOCOBJ(OBJ) = -999 THEN MENSAGEM$ = MSG$(7) : GOSUB 42000 : RETURN   ' msg 6: NÑo seja est£pido ! Vocà j† tem isso !!!
20760 IF ABS(LOCOBJ(OBJ)) <> SALA THEN MENSAGEM$ = MSG$(8) : GOSUB 42000 : RETURN   ' msg 7: Este objeto nÑo est† aqui...
20770 IF OBJ = 78 THEN EXAME$(60) = "Nem pense em fazer nada a°. Esta pia Ç nojenta."
20780 IF OBJ = 65 THEN MENSAGEM$ = MSG$(9) : GOSUB 42000 : LOCOBJ(66) = SALA : EXAME$(64) = "Tem uma agenda aqui dentro." : RETURN   ' msg 8: Nem pense em levar isso. Eu nÑo sou tÑo porco assim. Vou ape
20790 IF OBJ = 66 THEN AQUI$(66) = "Tem uma agenda aqui." : EXAME$(64) = "NÑo tem nada aqui."
20800 IF LOCOBJ(OBJ) < 0 THEN MENSAGEM$ = MSG$(10) : GOSUB 42000 : RETURN   ' msg 9: NÑo posso pegar isso.
20810 IF OBJ = 41 THEN MENSAGEM$ = MSG$(11) ELSE MENSAGEM$ = "Ok."   ' msg 10: Vocà pega o bispo sem constrangimento, pois ninguÇm daria pe
20820 LOCOBJ(OBJ) = -999
20830 GOSUB 42000
20840 GOSUB 42500
20850 RETURN
20900 ' ===== verbo 7 LISTAR/INVENTARIO/OBJETOS @ 0a23e =====
20910 NINV = 0
20920 FOR I = 1 TO NUMOBJ
20930   IF LOCOBJ(I) = -999 THEN NINV = NINV + 1 : INV$(NINV) = OBJ$(I)
20940 NEXT I
20950 IF NINV = 0 THEN NINV = 1 : INV$(1) = "NADA"
20960 TOPO = 1
20970 WHILE 1 = 1
20980   FOR I = 1 TO 11
20990     LOCATE 4 + I, 62
21000     PRINT SPACE$(16)
21010     LOCATE 4 + I, 62
21020     IF TOPO + I - 1 <= NINV THEN PRINT INV$(TOPO + I - 1)
21030   NEXT I
21040   IF SEMESPERA = 1 THEN RETURN
21050   LOCATE 21, 16
21060   PRINT "Digite " + CHR$(24) + " e " + CHR$(25) + " p/ ver objetos ou ENTER p/ continuar...";
21070   COLOR 31
21080   PRINT "˛";
21090   COLOR 11
21100   TECLALISTA$ = ""
21110   WHILE TECLALISTA$ = "" : TECLALISTA$ = INKEY$ : WEND
21120   IF TECLALISTA$ = CHR$(0) + CHR$(72) AND TOPO <> 1 THEN TOPO = TOPO - 1
21130   IF TECLALISTA$ = CHR$(0) + CHR$(80) AND TOPO < NINV THEN TOPO = TOPO + 1
21140   IF TECLALISTA$ = CHR$(13) THEN LOCATE 21, 16 : PRINT SPACE$(54) : RETURN
21150 WEND
21200 ' ===== verbo 8 LARGAR/DEIXAR/SOLTAR @ 0a5a1 =====
21210 IF OBJ = 77 AND LOCOBJ(77) = -999 THEN MENSAGEM$ = "Seu desastrado ! Vocà largou a lÉmpada e ela se espatifou !" : GOSUB 42000 : LOCOBJ(77) = 0 : RETURN
21220 IF OBJ = 49 AND LOCOBJ(49) = -999 AND SALA = 40 THEN
21230   LOCOBJ(49) = 0
21240   MENSAGEM$ = MSG$(12) : GOSUB 42000   ' msg 11: Vocà d† o envelope Ö secret†ria.
21250   GOSUB 42500
21260   MENSAGEM$ = MSG$(13) : GOSUB 42000   ' msg 12: 'Ah, pelo seu estilo capilar logo imaginei que era um office
21270   MENSAGEM$ = MSG$(14) : GOSUB 42000   ' msg 13: (suspiro)
21280   AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
21290   MENSAGEM$ = MSG$(15) : GOSUB 42000   ' msg 14: 'Venha comigo. Vou lev†-lo ao hall' - diz ela, tomando-o pel
21300   N = 41
21310   GOTO 20100
21320 END IF
21330 IF OBJ = 31 THEN MENSAGEM$ = MSG$(16) : GOSUB 42000 : RETURN   ' msg 15: Pra que ? Apesar de vocà nÑo fumar, eles podem ser £teis par
21340 IF LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = MSG$(17) : GOSUB 42000 : RETURN   ' msg 16: Vocà nÑo pode largar o que nÑo tem...
21350 IF OBJ = 71 AND SALA = 62 THEN MENSAGEM$ = MSG$(18) : GOSUB 42000 : MENSAGEM$ = "'Oh, MUITO OBRIGADO ! DEUS LHE PAGUE !', diz ele." : GOSUB 42000 : LOCOBJ(71) = 0 : RETURN   ' msg 17: Vocà tira o CD do bolso e, imediatamente, o disk
21360 IF OBJ = 71 AND SALA = 59 THEN MENSAGEM$ = MSG$(19) : GOSUB 42000 : LOCOBJ(71) = 0 : LOCOBJ(72) = 0 : GOSUB 42500 : RETURN   ' msg 18: O DJ sai da mesa l† no fundo e vem pegar o CD que vocà coloc
21370 IF OBJ = 26 THEN MENSAGEM$ = MSG$(20) : GOSUB 42000 : RETURN   ' msg 19: Sem essa de Papai Noel. Nada feito.
21380 IF OBJ = 41 AND SALA = 27 THEN MENSAGEM$ = MSG$(21) : GOSUB 42000 : MENSAGEM$ = MSG$(22) : GOSUB 42000 : MENSAGEM$ = MSG$(23) : GOSUB 42000 : LOCOBJ(39) = 0 : LOCOBJ(41) = 0 : LOCOBJ(42) = -999 : GOSUB 42500 : RETURN
21390 IF OBJ = 66 AND SALA = 39 THEN
21400   MENSAGEM$ = MSG$(24) : GOSUB 42000   ' msg 23: O homem do taxi pega a agenda que vocà entregou a ele. Ele a
21410   AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
21420   MENSAGEM$ = MSG$(25)   ' msg 24: Vocàs entram. A viagem nÑo Ç longa, pois o cara parece conhe
21430   MENSAGEM$ = MENSAGEM$ + " l°ngua. Ele seria de grande ajuda..." : GOSUB 42000
21440   MENSAGEM$ = MSG$(26) : GOSUB 42000   ' msg 25: O taxi para. Vocà desce e lhe d† quase todo o seu dinheiro. 
21450   GRANA = 5
21460   AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
21470   MENSAGEM$ = MSG$(27) : GOSUB 42000   ' msg 26: Antes de sumir, ele pîe a cabeáa para fora e grita: 'Valeu, 
21480   MENSAGEM$ = MSG$(28) : GOSUB 42000   ' msg 27: (suspiro)
21490   GOSUB 41000
21500   SALA = 56
21510   RETURN
21520 END IF
21530 IF (OBJ = 21 OR OBJ = 22) AND LANTERNA$ = "ligada" THEN MENSAGEM$ = "Desligue a lanterna antes" : GOSUB 42000 : RETURN
21540 LOCOBJ(OBJ) = SALA
21550 MENSAGEM$ = MSG$(29) : GOSUB 42000   ' msg 28: Ok.
21560 GOSUB 42500
21570 RETURN
21600 ' ===== verbo 9 OLHAR/VER/EXAMINAR/OBSERVAR/VERIFICAR @ 0aa4a =====
21610 IF OBJ = 44 AND SALA <> 31 THEN MENSAGEM$ = "Nada ali vai lhe ajudar..." : GOSUB 42000 : RETURN
21620 IF (OBJ = 73 OR OBJ = 19) AND SALA = 66 AND LOCOBJ(77) <> 66 THEN MENSAGEM$ = "H† um soquete de lÉmpada no teto." : GOSUB 42000 : RETURN
21630 IF (OBJ = 73 OR OBJ = 19) AND SALA = 66 THEN MENSAGEM$ = MSG$(30) : GOSUB 42000 : RETURN   ' msg 29: Tem uma lÉmpada no teto.
21640 IF OBJ = 73 OR OBJ = 75 OR OBJ = 19 OR OBJ = 20 THEN MENSAGEM$ = EXAME$(OBJ) : GOSUB 42000 : RETURN
21650 IF OBJ = 26 THEN MENSAGEM$ = MSG$(31) + MID$(STR$(GRANA), 2) : GOSUB 42000 : RETURN   ' msg 30: Vocà tem $
21660 IF OBJ = 12 AND SALA <> 4 THEN MENSAGEM$ = MSG$(32) : GOSUB 42000 : RETURN   ' msg 31: NÑo estou vendo nada parecido aqui.
21670 IF OBJ = 10 OR OBJ = 23 OR OBJ = 24 THEN GOSUB 42900 : GOSUB 42400 : GOSUB 42600 : RETURN   ' Executa a rotina da sala; Mostra os objetos da sala
21680 IF OBJ >= 1 AND OBJ <= 4 THEN MENSAGEM$ = MSG$(33) : GOSUB 42000 : RETURN   ' msg 32: Deixe de ser preguiáoso e ande atÇ l† !!!
21690 IF ABS(LOCOBJ(OBJ)) <> SALA AND LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = MSG$(34) : GOSUB 42000 : RETURN   ' msg 33: NÑo estou vendo nada parecido aqui.
21700 IF SALA = 19 AND NOMESALA$ = "" AND (OBJ = 5 OR OBJ = 6 OR OBJ = 15 OR OBJ = 16 OR OBJ = 26 OR OBJ = 49 OR OBJ = 28) THEN MENSAGEM$ = "NÑo consigo ver nada." : GOSUB 42000 : RETURN
21710 IF OBJ = 5 AND LOCOBJ(5) = -999 THEN PAGINA = 1 - PAGINA * (PAGINA <> 4) : MENSAGEM$ = DESCLISTA$(PAGINA) : GOSUB 42000 : RETURN
21720 IF OBJ = 5 THEN MENSAGEM$ = MSG$(35) : GOSUB 42000 : RETURN   ' msg 34: NÑo a tenho.
21730 IF OBJ = 9 THEN MENSAGEM$ = MSG$(36) : GOSUB 42000 : RETURN   ' msg 35: ê um ponto de ìnibus.
21740 IF OBJ = 21 AND LOCOBJ(22) = -999 THEN MENSAGEM$ = MSG$(37) + LANTERNA$ : GOSUB 42000 : RETURN   ' msg 36: Ela est† 
21750 IF OBJ = 35 AND PORTAABERTA = 1 THEN MENSAGEM$ = MSG$(38) : GOSUB 42000 : RETURN   ' msg 37: Ela est† aberta.
21760 IF OBJ = 35 AND PORTAABERTA = 0 THEN MENSAGEM$ = MSG$(39) : GOSUB 42000 : RETURN   ' msg 38: Ela est† fechada.
21770 IF OBJ = 37 AND LOCOBJ(OBJ) = -999 AND LOCOBJ(38) = 0 THEN MENSAGEM$ = MSG$(40) : GOSUB 42000 : LOCOBJ(38) = -999 : GOSUB 42500 : RETURN   ' msg 39: Temos um cartÑo aqui.
21780 IF OBJ = 45 AND SALA = 35 AND GRANA < 5000 THEN MENSAGEM$ = MSG$(41) : GRANA = GRANA + 5000 : GOSUB 42000 : RETURN   ' msg 40: Temos uns $5000 aqui. Nem precisa mandar pegar o dinheiro.
21790 MENSAGEM$ = EXAME$(OBJ) : GOSUB 42000
21800 RETURN
21900 ' ===== verbo 10 FALAR/CONVERSAR @ 0b1ce =====
21910 IF ABS(LOCOBJ(OBJ)) <> SALA THEN MENSAGEM$ = MSG$(42) : GOSUB 42000 : RETURN   ' msg 41: Aonde vocà và isso ?
21920 IF OBJ = 72 THEN
21930   MENSAGEM$ = MSG$(43) : GOSUB 42000   ' msg 42: 'Ei, vocà conhece este local ?'
21940   MENSAGEM$ = MSG$(44) : GOSUB 42000   ' msg 43: 'O quà'
21950   MENSAGEM$ = MSG$(45) : GOSUB 42000   ' msg 44: 'Eu perguntei se vocà conhece isto aqui ?'
21960   MENSAGEM$ = MSG$(46) : GOSUB 42000   ' msg 45: 'O QUE ?'
21970   AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
21980   MENSAGEM$ = MSG$(47) : GOSUB 42000   ' msg 46: 'EU PERGUNTEI SE VOCE CONHECE ESTA POCILGA !!!!!!
21990   MENSAGEM$ = MSG$(48) : GOSUB 42000   ' msg 47: 'COMO ê ?'
22000   MENSAGEM$ = MSG$(49) : GOSUB 42000   ' msg 48: Vocà desiste. Com este som alto nÑo vai ter jeito.
22010   RETURN
22020 END IF
22030 IF OBJ = 67 THEN MENSAGEM$ = MSG$(50) : GOSUB 42000 : RETURN   ' msg 49: Eles s¢ se interessam em danáar. Ali†s, acho que nÑo pararia
22040 IF OBJ = 69 AND BARMAN = 1 THEN MENSAGEM$ = MSG$(51) : GOSUB 42000 : RETURN   ' msg 50: 'Nada disso' - diz Moe - 'Vocà j† passou da cota esta noite'
22050 IF OBJ = 69 THEN
22060   MENSAGEM$ = MSG$(52) : GOSUB 42000   ' msg 51: 'Ol†, Moe (vocà j† supìs que todo garáom de danceteria se ch
22070   MENSAGEM$ = MSG$(53) : GOSUB 42000   ' msg 52: 'E entÑo, chefe. Vai o de sempre ?'
22080   MENSAGEM$ = MSG$(54) : GOSUB 42000   ' msg 53: 'Claro' - vocà diz, feliz de ter sido confundido com algum d
22090   AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
22100   MENSAGEM$ = MSG$(55) : GOSUB 42000   ' msg 54: 'Aqui est†. ê por conta da casa, outro dia vocà acerta...'
22110   MENSAGEM$ = MSG$(56) : GOSUB 42000   ' msg 55: 'Obrigado'. Ao olhar para a massa no copo, vocà diz: 'Ei, o 
22120   MENSAGEM$ = MSG$(57) : GOSUB 42000   ' msg 56: 'O seu milk-shake. Como sempre foi seu pedido. Lembro bem do
22130   GOSUB 41000
22140   MENSAGEM$ = MSG$(58) : GOSUB 42000   ' msg 57: 'Grunf', vocà diz, tomando o milk-shake. Em certo momento, v
22150   MENSAGEM$ = MSG$(59) : GOSUB 42000   ' msg 58: 'Obrigado', diz Moe, tirando o copo na metade. 'Volte sempre
22160   BARMAN = 1
22170   RETURN
22180 END IF
22190 IF OBJ = 8 THEN MENSAGEM$ = MSG$(60) : GOSUB 42000 : RETURN   ' msg 59: Talvez isso nÑo v† fazer muito bem Ö sua sa£de. Ele nÑo Ç o 
22200 IF OBJ = 27 THEN
22210   MENSAGEM$ = MSG$(61) : GOSUB 42000   ' msg 60: 'Bom dia. Por favor, eu gostaria de procurar meu disquete po
22220   MENSAGEM$ = MSG$(62) : GOSUB 42000   ' msg 61: 'E eu com isso ?', diz ele, enquanto comeáa a roer a unha.
22230   MENSAGEM$ = MSG$(63) : GOSUB 42000   ' msg 62: (suspiro)
22240   RETURN
22250 END IF
22260 IF OBJ = 54 THEN MENSAGEM$ = MSG$(64) : GOSUB 42000 : RETURN   ' msg 63: Vocà fica falando sozinho, pois todos o ignoram. Afinal de c
22270 IF OBJ = 55 THEN MENSAGEM$ = MSG$(65) : GOSUB 42000 : RETURN   ' msg 64: In£til. Eles estÑo muito ocupados com o jogo.
22280 IF OBJ = 14 THEN
22290   AVISO$ = "Digite qualquer tecla..."
22300   MENSAGEM$ = MSG$(66) : GOSUB 42000   ' msg 65: 'Bom dia. Em que posso servi-lo ?'
22310   MENSAGEM$ = MSG$(67) : GOSUB 42000   ' msg 66: 'Seu sorriso j† o fez...' - vocà responde, e ela d† uma risa
22320   GOSUB 41000
22330   MENSAGEM$ = MSG$(68) : GOSUB 42000   ' msg 67: 'Leve este aqui' - ela diz. Neste momento, um homem adentra 
22340   LOCOBJ(14) = 0
22350   LOCOBJ(15) = -999
22360   LOCOBJ(16) = -999
22370   GOSUB 42500
22380   MENSAGEM$ = MSG$(69) : GOSUB 42000   ' msg 68: 'Mais alguma coisa ?' - ela diz, suspirando quando o homem s
22390   GOSUB 41000
22400   MENSAGEM$ = MSG$(70) : GOSUB 42000   ' msg 69: 'Por enquanto nÑo. Mas quem sabe em outra oportunidade...' -
22410   MENSAGEM$ = MSG$(71) : GOSUB 42000   ' msg 70: 'Essa foi boa' - vocà pensa, enquanto observa ela sair pela 
22420   RETURN
22430 END IF
22440 IF OBJ = 30 THEN MENSAGEM$ = MSG$(72) : GOSUB 42000 : RETURN   ' msg 71: Esquece. Ela nÑo vai acordar, e mesmo que o fizesse, cinco m
22450 IF OBJ = 39 THEN
22460   MENSAGEM$ = MSG$(73) : GOSUB 42000   ' msg 72: 'Bom dia, ¢ bom velhinho !' - vocà diz, alegremente.
22470   MENSAGEM$ = MSG$(74) : GOSUB 42000   ' msg 73: 'XADREZZZZZ !' - ele responde - 'Traga o XADREZZZZZ !'
22480   MENSAGEM$ = MSG$(75) : GOSUB 42000   ' msg 74: Vocà o fita por alguns segundos, e ele se vira novamente par
22490   RETURN
22500 END IF
22510 IF OBJ = 47 THEN
22520   MENSAGEM$ = MSG$(76) : GOSUB 42000   ' msg 75: 'Bom dia. O senhor anda bastante por aqui ?'
22530   MENSAGEM$ = MSG$(77) : GOSUB 42000   ' msg 76: Ele diz: 'Chucrutz WolksVagen MercedesBens Kibe HeilHitler',
22540   MENSAGEM$ = MSG$(78) : GOSUB 42000   ' msg 77: 'ê, tio, acho que vocà nÑo fala a minha l°ngua...', vocà diz
22550   RETURN
22560 END IF
22570 IF OBJ = 50 AND SALA = 40 THEN MENSAGEM$ = MSG$(79) : GOSUB 42000 : MENSAGEM$ = "'Isto o QUE ? Vocà nÑo tem nada a oferecer ao Sr. L, logo explique-se ou retire-se, por favor.'" : GOSUB 42000 : RETURN   ' msg 78: 'Escute, srta., ist
22580 IF OBJ = 41 AND (SALA = 29 OR LOCOBJ(41) = -999) THEN MENSAGEM$ = MSG$(80) : GOSUB 42000 : RETURN   ' msg 79: Talvez ele nÑo tenha muito o que falar.
22590 MENSAGEM$ = MSG$(81) : GOSUB 42000   ' msg 80: Vocà deveria se sentir rid°culo conversando com isso.
22600 RETURN
22700 ' ===== verbo 11 CIMA/C/SUBIR @ 0b715 =====
22710 IF C = 0 THEN AVISO$ = "SUA ANTA ! Vocà nÑo pode ir para cima !!!" : GOSUB 41000 : GOSUB 42600 : RETURN
22720 SALA = C
22730 RETURN
22800 ' ===== verbo 12 BAIXO/B/DESCER @ 0b744 =====
22810 IF B = 0 THEN AVISO$ = "SUA ANTA ! Vocà nÑo pode ir para baixo !!!" : GOSUB 41000 : GOSUB 42600 : RETURN
22820 SALA = B
22830 RETURN
22900 ' ===== verbo 13 LER @ 0b773 =====
22910 IF ABS(LOCOBJ(OBJ)) <> SALA AND LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = MSG$(82) : GOSUB 42000 : RETURN   ' msg 81: Aonde est† isso ?
22920 IF SALA = 19 AND NOMESALA$ = "" THEN MENSAGEM$ = "O ministÇrio da sa£de adverte: Ler no escuro Ç prejudicial Ö sa£de." : GOSUB 42000 : RETURN
22930 IF OBJ = 12 OR OBJ = 16 OR OBJ = 66 THEN GOTO 21600
22940 IF OBJ = 15 THEN MENSAGEM$ = MSG$(83) : GOSUB 42000 : RETURN   ' msg 82: Cà pirou ? Isso vai levar o màs inteiro, cara, e vocà tem um
22950 MENSAGEM$ = MSG$(84) : GOSUB 42000   ' msg 83: NÑo posso ler isso
22960 RETURN
23000 ' ===== verbo 14 LIGAR/USAR/ACENDER @ 0b8cf =====
23010 IF OBJ <> 21 AND PALAVRA$ = "LIGAR" THEN MENSAGEM$ = "Como diabos vocà vai ligar isso ?" : GOSUB 42000 : RETURN
23020 IF OBJ = 60 THEN GOTO 21600
23030 IF (OBJ = 40 AND SALA = 30) OR (OBJ = 51 AND SALA = 42) OR (OBJ = 52 AND SALA = 43) THEN
23040   IF SALA = 43 THEN MENSAGEM$ = MSG$(85) ELSE MENSAGEM$ = "Digite o n£mero do andar:"   ' msg 84: Digite o n£mero do sub-solo:
23050   GOSUB 42000
23060   GOSUB 12100
23070   IF OBJ = 40 THEN MENSAGEM$ = MSG$(86) : GOSUB 42000 : RETURN   ' msg 85: O elevador nÑo se move.
23080   IF OBJ = 51 THEN
23090     IF LEN(COMANDO$) <> 1 OR INSTR("123", COMANDO$) = 0 THEN MENSAGEM$ = MSG$(87) : GOSUB 42000 : RETURN   ' msg 86: O elevador nÑo se move.
23100     SALA = INSTR("123", COMANDO$) + 43
23110     ELEVMOVEU = 1
23120     RETURN
23130   END IF
23140   IF OBJ = 52 THEN
23150     IF LEN(COMANDO$) <> 1 OR INSTR("12", COMANDO$) = 0 THEN MENSAGEM$ = MSG$(88) : GOSUB 42000 : RETURN   ' msg 87: O elevador nÑo se move.
23160     SALA = INSTR("12", COMANDO$) + 53
23170     ELEVMOVEU = 1
23180     RETURN
23190   END IF
23200 END IF
23210 IF OBJ = 34 AND LOCOBJ(34) = -999 AND SALA = 57 THEN OBJ = 35 : GOTO 23600
23220 IF OBJ = 21 THEN
23230   IF LOCOBJ(21) <> -999 THEN MENSAGEM$ = MSG$(89) : GOSUB 42000 : RETURN   ' msg 88: NÑo a tenho.
23240   IF LOCOBJ(22) <> -999 THEN MENSAGEM$ = MSG$(90) : GOSUB 42000 : RETURN   ' msg 89: Sem pilhas. Nada feito.
23250   IF LANTERNA$ = "ligada" THEN MENSAGEM$ = "Ela j† est† ligada, toupeira !" : GOSUB 42000 : RETURN
23260   IF SALA = 19 THEN MENSAGEM$ = "Est† muito escuro. NÑo consigo ach†-la. Que tal iluminar o local com outra coisa ?" : GOSUB 42000 : RETURN
23270   IF SALA <> 17 THEN MENSAGEM$ = MSG$(91) : GOSUB 42000 : RETURN   ' msg 90: Melhor vocà economizar pilhas. Elas nÑo durarÑo muito. NÑo v
23280   MENSAGEM$ = MSG$(92) : GOSUB 42000   ' msg 91: Vocà coloca as pilhas na lanterna e acende.
23290   LANTERNA$ = "ligada"
23300   RETURN
23310 END IF
23320 IF OBJ = 31 AND SALA = 19 THEN MENSAGEM$ = MSG$(93) : GOSUB 42000 : GOTO 61780   ' msg 92: Muito bem ! O local est† mais iluminado. Veja esta caixa Ö s
23330 IF OBJ = 31 AND SALA = 31 THEN MENSAGEM$ = MSG$(94) : GOSUB 42000 : GOTO 61780   ' msg 93: Vocà pîe fogo na madeira. Seria uma boa idÇia, se o fogo nÑo
23340 IF OBJ = 31 THEN MENSAGEM$ = MSG$(95) : GOSUB 42000 : RETURN   ' msg 94: Vocà acende um f¢sforo. Ele deve ser especial, pois ilumina 
23350 IF OBJ = 42 AND SALA = 31 AND LOCOBJ(42) = -999 THEN MENSAGEM$ = MSG$(96) : GOSUB 42000 : SALA = 33 : RETURN   ' msg 95: Vocà destr¢i a parede e pula no buraco. Misteriosamente, um 
23360 IF OBJ = 29 THEN GOTO 21600
23370 IF OBJ = 25 AND SALA <> 3 THEN MENSAGEM$ = MSG$(97) : GOSUB 42000 : RETURN   ' msg 96: NÑo aqui.
23380 IF OBJ = 25 THEN
23390   MENSAGEM$ = MSG$(98) : GOSUB 42000   ' msg 97: Digite o nß da linha do ìnibus:
23400   GOSUB 12100
23410   IF VAL(COMANDO$) = 0 THEN MENSAGEM$ = MSG$(99) : GOSUB 42000 : RETURN   ' msg 98: NÑo entendi. Nada feito.
23420   AVISO$ = "Digite qualquer tecla..."
23430   MENSAGEM$ = MSG$(100) : GOSUB 42000   ' msg 99: Vocà entra no ìnibus. Este meio sem-vergonha de transporte c
23440   MENSAGEM$ = MSG$(101) : GOSUB 42000   ' msg 100: Ao chegar na metade do mesmo, depara com um indiv°duo que te
23450   GOSUB 41000
23460   GRANA = GRANA - 200
23470   MENSAGEM$ = MSG$(102) : GOSUB 42000   ' msg 101: O ìnibus para. Este Ç o ponto final. Todos descem, inclusive
23480   IF COMANDO$ <> "4283" THEN SALA = 20 ELSE SALA = 8
23490   RETURN
23500 END IF
23510 IF OBJ = 79 AND LOCOBJ(79) = -999 AND LOCOBJ(77) = -999 THEN MENSAGEM$ = MSG$(103) : GOSUB 42000 : LOCOBJ(79) = 0 : PAPELALUM = 1 : GOSUB 42500 : RETURN   ' msg 102: Vocà coloca o papel-alum°nio da bala em volta da lÉmpada.
23520 MENSAGEM$ = MSG$(104) : GOSUB 42000   ' msg 103: Vocà nÑo pode usar isso !
23530 RETURN
23600 ' ===== verbo 15 ABRIR @ 0bfd9 =====
23610 IF OBJ = 37 THEN GOTO 21600
23620 IF OBJ = 61 THEN MENSAGEM$ = MSG$(105) : GOSUB 42000 : RETURN   ' msg 104: J† est† aberta
23630 IF OBJ = 35 AND SALA = 57 AND PORTAABERTA = 1 THEN MENSAGEM$ = MSG$(106) : GOSUB 42000 : RETURN   ' msg 105: A porta j† est† aberta.
23640 IF OBJ = 32 AND LOCOBJ(32) <> -999 THEN MENSAGEM$ = "Vocà nÑo a tem." : GOSUB 42000 : RETURN
23650 IF OBJ = 32 AND LOCOBJ(34) = 0 THEN MENSAGEM$ = MSG$(107) : GOSUB 42000 : LOCOBJ(34) = -999 : GOSUB 42500 : RETURN   ' msg 106: H† uma passagem de ìnibus nela. Vocà a pega imediatamente.
23660 IF OBJ = 32 THEN MENSAGEM$ = MSG$(108) : GOSUB 42000 : RETURN   ' msg 107: Est† vazia.
23670 IF SALA = 57 AND OBJ = 35 AND LOCOBJ(34) = -999 THEN MENSAGEM$ = MSG$(109) : GOSUB 42000 : PORTAABERTA = 1 : L = 67 : LOCOBJ(34) = -998 : GOSUB 42500 : GOSUB 42600 : RETURN   ' msg 108: Vocà coloca a passagem na abertura ao lado
23680 IF SALA = 57 AND OBJ = 35 THEN MENSAGEM$ = MSG$(110) : GOSUB 42000 : RETURN   ' msg 109: NÑo d†. Ela Ç autom†tica, e s¢ abre se vocà tiver a passagem
23690 IF OBJ = 45 THEN MENSAGEM$ = MSG$(111) : GOSUB 42000 : RETURN   ' msg 110: J† est† aberto.
23700 MENSAGEM$ = MSG$(112) : GOSUB 42000   ' msg 111: NÑo posso abrir isso.
23710 RETURN
23800 ' ===== verbo 16 BEIJAR/ABRACAR @ 0c289 =====
23810 IF OBJ = 82 THEN GOTO 20700
23820 IF OBJ = 36000 THEN
23830   MENSAGEM$ = MSG$(113) : GOSUB 42000   ' msg 112: Muito bem ! Agora digite o n£mero da tela desejada:
23840   GOSUB 12100
23850   IF VAL(COMANDO$) = 999 THEN GOTO 61860
23860   DESTINO = VAL(COMANDO$)
23870   IF DESTINO < 1 OR DESTINO > 66 THEN MENSAGEM$ = MSG$(114) : GOSUB 42000 : RETURN   ' msg 113: Nada feito.
23880   SALA = DESTINO
23890   RETURN
23900 END IF
23910 IF ABS(LOCOBJ(OBJ)) <> SALA AND LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = MSG$(115) : GOSUB 42000 : RETURN   ' msg 114: NÑo est† aqui...
23920 IF OBJ = 14 OR OBJ = 30 OR OBJ = 50 THEN MENSAGEM$ = MSG$(116) : GOSUB 42000 : RETURN   ' msg 115: V† com calma...
23930 MENSAGEM$ = MSG$(117) : GOSUB 42000   ' msg 116: Freud explica...
23940 RETURN
24000 ' ===== verbo 17 MENU @ 0c449 =====
24010 TECLAMENU$ = ""
24020 OPCAO = 1
24030 LOCATE 21, 16
24040 PRINT SPACE$(64);
24050 LOCATE 22, 16
24060 PRINT SPACE$(64);
24070 WHILE TECLAMENU$ <> CHR$(13)
24080   COLOR 15, (OPCAO <> 1) * -10
24090   LOCATE 21, 16
24100   PRINT " Gravar   "
24110   COLOR 15, (OPCAO <> 2) * -10
24120   LOCATE 22, 16
24130   PRINT " Carregar "
24140   COLOR 15, (OPCAO <> 3) * -10
24150   LOCATE 21, 36
24160   PRINT " Ajuda    "
24170   COLOR 15, (OPCAO <> 4) * -10
24180   LOCATE 22, 36
24190   PRINT " Notas    "
24200   COLOR 15, (OPCAO <> 5) * -10
24210   LOCATE 21, 56
24220   PRINT " Rein°cio "
24230   COLOR 15, (OPCAO <> 6) * -10
24240   LOCATE 22, 56
24250   PRINT " Fim      "
24260   COLOR 15, 10
24270   TECLAMENU$ = ""
24280   WHILE TECLAMENU$ = "" : TECLAMENU$ = INKEY$ : WEND
24290   OPCAO = OPCAO - (OPCAO < 6 AND (TECLAMENU$ = CHR$(0) + "P" OR TECLAMENU$ = " " OR TECLAMENU$ = CHR$(9))) + (OPCAO > 1 AND TECLAMENU$ = CHR$(0) + "H")
24300   OPCAO = OPCAO - 2 * (TECLAMENU$ = CHR$(0) + "M") + 2 * (TECLAMENU$ = CHR$(0) + "K")
24310   IF OPCAO > 6 THEN OPCAO = OPCAO - 6
24320   IF OPCAO < 1 THEN OPCAO = OPCAO + 6
24330   POSTECLA = INSTR("GgCcAaNnRrFf", TECLAMENU$)
24340   IF POSTECLA <> 0 THEN OPCAO = INT((POSTECLA + 1) / 2) : TECLAMENU$ = CHR$(13)
24350   IF TECLAMENU$ = CHR$(27) THEN LOCATE 21, 16 : PRINT SPACE$(64); : LOCATE 22, 16 : PRINT SPACE$(64); : RETURN
24360 WEND
24370 LOCATE 21, 16
24380 PRINT SPACE$(64);
24390 LOCATE 22, 16
24400 PRINT SPACE$(64);
24410 IF OPCAO = 1 THEN GOSUB 53300
24420 IF OPCAO = 2 THEN GOSUB 60500
24430 IF OPCAO = 3 THEN GOSUB 61300
24440 IF OPCAO = 4 THEN GOSUB 61500
24450 IF OPCAO = 5 THEN
24460   AVISO$ = "Digite ÆSØ para reinciar ou outra tecla para continuar..." : GOSUB 41000
24470   IF TECLA$ = "S" OR TECLA$ = "s" THEN CLEAR : GOTO 100
24480 END IF
24490 IF OPCAO = 6 THEN GOSUB 24800
24500 RETURN
$INCLUDE "CA1A.INC"
$INCLUDE "CA1B.INC"
