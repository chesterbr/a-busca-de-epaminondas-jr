10 ' CA1.BAS gerado por basic/gerar.py a partir do CA1.EXE. As linhas `REM ???` sÑo instruáîes ainda sem traduáÑo.
20 ' Nomes de vari†veis e de r¢tulos foram adicionados durante a engenharia reversa (o execut†vel nÑo guarda nenhum); os n£meros de linha tambÇm; com --rotulos, Lxxxxx = endereáo da imagem do .EXE.
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
24600 ' ===== verbo 18 CHUPAR @ 0c921 =====
24610 IF LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = MSG$(118) : GOSUB 42000 : RETURN   ' msg 117: Vocà nÑo tem isso !
24620 IF OBJ <> 78 THEN MENSAGEM$ = MSG$(119) : GOSUB 42000 : RETURN   ' msg 118: Isso pode ser muito perigoso. Melhor evitar...
24630 MENSAGEM$ = MSG$(120) : GOSUB 42000   ' msg 119: Vocà abre a bala e joga fora o papel. A bala est† meio passa
24640 LOCOBJ(78) = 0
24650 LOCOBJ(79) = SALA
24660 GOSUB 42500
24670 RETURN
24700 ' ===== verbo 19 QUEBRAR/DETONAR/ARREBENTAR/DESTRUIR @ 0c9c0 =====
24710 IF (OBJ = 43 OR OBJ = 44) AND SALA = 31 THEN MENSAGEM$ = "ê muito forte para vocà. Tente usar algum instrumento para isso..." : GOSUB 42000 : RETURN
24720 IF LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = MSG$(121) : GOSUB 42000 : RETURN   ' msg 120: Vocà nÑo tem isso !
24730 IF OBJ <> 74 THEN MENSAGEM$ = MSG$(122) : GOSUB 42000 : RETURN   ' msg 121: Vocà nÑo Ç homem o suficiente...
24740 MENSAGEM$ = MSG$(123) : GOSUB 42000   ' msg 122: Vocà quebra a noz, ansioso para comà-la, mas na verdade s¢ e
24750 LOCOBJ(74) = 0
24760 LOCOBJ(76) = -999
24770 GOSUB 42500
24780 RETURN
24800 ' ===== verbo 20 SAIR/ABANDONAR @ 0cac1 =====
24810 AVISO$ = "Digite ÆSØ para sair ao DOS ou outra tecla para jogar..." : GOSUB 41000
24820 IF TECLA$ = "S" OR TECLA$ = "s" THEN GOTO 62360
24830 RETURN
24900 ' ===== verbo 21 DIZER @ 0cb01 =====
24910 IF OBJ <> 81 THEN MENSAGEM$ = "Engraáado, ninguÇm responde..." : GOSUB 42000 : RETURN
24920 MENSAGEM$ = "Oh, mas aonde este mundo foi parar, se nobres cavaleiros ficam dizendo 'ni' a torto e direito por a°..." : GOSUB 42000
24930 RETURN
25000 ' ===== verbo 22 FECHAR/DESLIGAR @ 0cb30 =====
25010 IF OBJ = 21 AND LANTERNA$ = "ligada" THEN MENSAGEM$ = "Ah, agora que vocà ligou, deixe assim." : GOSUB 42000 : RETURN
25020 MENSAGEM$ = "NÑo perca tempo fechando ou desligando as coisas neste jogo. ê in£til e muito educado para vocà." : GOSUB 42000
25030 RETURN
25100 ' ===== verbo 23 ROSQUEAR @ 0cb82 =====
25110 IF LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = "NÑo posso rosquear o que nÑo tenho." : GOSUB 42000 : RETURN
25120 IF OBJ <> 77 THEN MENSAGEM$ = "Cà pirou ?" : GOSUB 42000 : RETURN
25130 IF PAPELALUM THEN GOTO 61860
25140 MENSAGEM$ = "Ok."
25150 LOCOBJ(77) = 66
25160 GOSUB 42000
25170 RETURN
25200 ' ===== verbo 24 DESROSQUEAR @ 0cc1b =====
25210 IF OBJ <> 77 THEN MENSAGEM$ = "Como vou desrosquear esta biromba ?" : GOSUB 42000 : RETURN
25220 IF SALA <> 66 THEN MENSAGEM$ = "NÑo est† aqui." : GOSUB 42000 : RETURN
25230 IF LOCOBJ(OBJ) = -999 THEN MENSAGEM$ = "J† est† desrosqueada e nas suas mÑos." : GOSUB 42000 : RETURN
25240 IF LOCOBJ(OBJ) = 0 THEN MENSAGEM$ = "Agora Ç tarde. Vocà a destruiu, palerma." : GOSUB 42000 : RETURN
25250 MENSAGEM$ = "Ok."
25260 LOCOBJ(77) = -999
25270 GOSUB 42000
25280 RETURN
25300 ' ===== verbo 25 VOAR @ 0ccfc =====
25310 MENSAGEM$ = "Vocà sai, livre como um p†ssaro, atravessa vales e montanhas, mas logo acorda e retorna ao jogo." : GOSUB 42000
25320 RETURN
25400 ' ===== verbo 26 MORDER/XINGAR/BATER/ESPANCAR/LAMBER @ 0cd0a =====
25410 MENSAGEM$ = "Vocà nÑo Ç tÑo animal assim." : GOSUB 42000
25420 RETURN
25500 ' ===== verbo 27 COMER @ 0cd18 =====
25510 IF LOCOBJ(OBJ) <> -999 THEN MENSAGEM$ = "NÑo posso comer o que nÑo tenho." : GOSUB 42000 : RETURN
25520 IF OBJ = 74 AND NOZAVISO = 0 THEN MENSAGEM$ = "Melhor nÑo. Ela pode lhe ser £til se vocà nÑo a comer." : NOZAVISO = 1 : GOSUB 42000 : RETURN
25530 IF OBJ = 74 THEN MENSAGEM$ = "J† que vocà insiste... Vocà a engole. Ela fica engasgada na sua garganta. Vocà comeáa a tossir, e ver o mundo ficar verde, rosa, azul, amarelo, branco com bolinhas vermelhas, e, finalmente, negro..." : _
      GOSUB 42000 : GOTO 61780
25540 MENSAGEM$ = "Isso nÑo Ç muito digestivo. Talvez com um sal de frutas v†, mas como vocà nÑo o tem..." : GOSUB 42000
25550 RETURN
25600 ' ===== verbo 28 CHEIRAR @ 0cdd8 =====
25610 IF SALA = 6 THEN MENSAGEM$ = "O aroma Ç agrad†vel." : GOSUB 42000 : RETURN
25620 IF SALA = 32 THEN MENSAGEM$ = "ECA !" : GOSUB 42000 : RETURN
25630 MENSAGEM$ = "NÑo sinto nada de anormal no cheiro." : GOSUB 42000
25640 RETURN
25700 ' ===== verbo 29 ATRAVESSAR @ 0ce28 =====
25710 IF OBJ <> 86 THEN MENSAGEM$ = "Como vou atravessar isso ?" : GOSUB 42000 : RETURN
25720 IF SALA <> 3 AND SALA <> 56 THEN MENSAGEM$ = "NÑo existe nenhuma rua aqui que possa ser atravessada." : GOSUB 42000 : RETURN
25730 MENSAGEM$ = "Vocà decide tomar coragem. Ap¢s achar a faixa de pedestres e aguardar sua vez no farol, olha para a esquerda. Nada." : GOSUB 42000
25740 MENSAGEM$ = "Olhando para a direita, tambÇm nÑo và nada. ê seguro. ê tranqÅilo. Vocà se prepara e d† o primeiro passo." : GOSUB 42000
25750 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
25760 MENSAGEM$ = "Neste instante, uma JAMANTA 246 avanáa sobre vocà. Vocà sai numa corrida desenfreada, e cai na outra mÑo. Na outra mÑo, o ìnibus Terminal SÑo Mateus (vulgo 'TrovÑo Azul') o persegue, deixando-o sem sa°da." : GOSUB 42000
25770 MENSAGEM$ = "Vocà pula num bueiro, derrubando a placa de 'HOMENS TRABALHANDO'. Ufa, que al°vio ! Vocà escapou da morte nas mÑos de motoristas irrespons†veis." : GOSUB 42000
25780 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
25790 MENSAGEM$ = "Mas, infelizmente, vocà foi mordido por um rato e morreu de peste bubìnica, instantaneamente (?!?!?). ê a vida..." : GOSUB 42000
25800 GOTO 61780
25900 ' ===== verbo 30 PULAR @ 0ceed =====
25910 MENSAGEM$ = "Vocà pensa em pular, como um cervo alegre e radiante atravessando campos e plantaáîes, mas deixa de frescura e desiste da idÇia" : GOSUB 42000
25920 RETURN
26000 ' ===== verbo 31 JOGAR/BRINCAR/PASSEAR/DORMIR/CAVALGAR/MASTURBAR @ 0cefb =====
26010 MENSAGEM$ = "NÑo estou com disposiáÑo para isso por enquanto." : GOSUB 42000
26020 RETURN
26100 ' ===== verbo 32 ARREMESSAR/LANCAR @ 0cf09 =====
26110 MENSAGEM$ = "NÑo Ç uma boa idÇia..." : GOSUB 42000
26120 RETURN
26200 ' ===== verbo 33 SENTAR/DEITAR @ 0cf17 =====
26210 MENSAGEM$ = "Aqui ? Nada feito, chapa." : GOSUB 42000
26220 RETURN
26300 ' ===== verbo 34 APAGAR @ 0cf25 =====
26310 MENSAGEM$ = "NÑo entendo quais sÑo seus planos. Tente fazer algo mais coerente..." : GOSUB 42000
26320 RETURN
40000 ' **************************************************************
40010 ' SUB-ROTINAS (3/5): USO GERAL
40020 ' Avisos, mensagens e paineis.
40030 ' **************************************************************
41000 ' ===== sub-rotina: aviso: AVISO$ na janela de avisos e espera uma tecla @ 0cf33 =====
41010 IF LEN(AVISO$) > 63 THEN AVISO$ = LEFT$(AVISO$, 63)
41020 LOCATE 21, 16
41030 PRINT SPACE$(64);
41040 LOCATE 21, 16
41050 PRINT AVISO$;
41060 COLOR 31
41070 PRINT "˛";
41080 COLOR 11
41090 LOCATE 1, 1
41100 TECLA$ = INPUT$(1)
41110 LOCATE 21, 16
41120 PRINT SPACE$(64);
41130 RETURN
42000 ' ===== sub-rotina: mensagem: MENSAGEM$ na janela de mensagens @ 0cfbc =====
42010 COL = 1
42020 MENSAGEM$ = MENSAGEM$ + " "
42030 WHILE MENSAGEM$ <> ""
42040   TRECHO$ = LEFT$(MENSAGEM$, INSTR(MENSAGEM$, " "))
42050   COL = COL + LEN(TRECHO$)
42060   IF COL > 58 THEN GOSUB 42200 : COL = LEN(TRECHO$) + 1
42070   LINHAMSG$ = LINHAMSG$ + TRECHO$
42080   MENSAGEM$ = MID$(MENSAGEM$, INSTR(MENSAGEM$, " ") + 1)
42090   IF INKEY$ = "X" THEN PRINT MENSAGEM$,LEN(MENSAGEM$) : END
42100 WEND
42110 GOSUB 42200
42120 GOSUB 42200
42130 RETURN
42200 ' ===== sub-rotina: rola a janela de mensagens (JANELA$) uma linha @ 0d0c5 =====
42210 COLOR 15
42220 FOR I = 1 TO 10
42230   JANELA$(I) = JANELA$(I + 1)
42240   LOCATE I + 4, 2
42250   PRINT SPACE$(58);
42260   LOCATE I + 4, 2
42270   PRINT JANELA$(I);
42280 NEXT I
42290 JANELA$(11) = LINHAMSG$
42300 LOCATE 15, 2
42310 PRINT SPACE$(58)
42320 LOCATE 15, 2
42330 PRINT JANELA$(11)
42340 LINHAMSG$ = ""
42350 COLOR 11
42360 RETURN
42400 ' ===== sub-rotina: mostra os objetos que estÑo na sala (AQUI$) @ 0d215 =====
42410 OBJSALA$ = ""
42420 FOR I = 1 TO NUMOBJ
42430   IF ABS(LOCOBJ(I)) = SALA AND AQUI$(I) <> "" THEN OBJSALA$ = OBJSALA$ + AQUI$(I) + " "
42440 NEXT I
42450 MENSAGEM$ = OBJSALA$
42460 IF OBJSALA$ <> "" THEN GOSUB 42000
42470 RETURN
42500 ' ===== sub-rotina: atualiza o painel de objetos (LISTAR sem esperar tecla) @ 0d342 =====
42510 SEMESPERA = 1
42520 GOSUB 20900
42530 SEMESPERA = 0
42540 RETURN
42600 ' ===== sub-rotina: atualiza a janela de direáîes (acende as sa°das) @ 0d35a =====
42610 COLOR 8
42620 IF N THEN COLOR 15
42630 LOCATE 19, 6
42640 PRINT "N"
42650 COLOR 8
42660 IF S THEN COLOR 15
42670 LOCATE 21, 6
42680 PRINT "S"
42690 COLOR 8
42700 IF L THEN COLOR 15
42710 LOCATE 20, 8
42720 PRINT "L"
42730 COLOR 8
42740 IF O THEN COLOR 15
42750 LOCATE 20, 4
42760 PRINT "O"
42770 COLOR 8
42780 IF C THEN COLOR 15
42790 LOCATE 19, 12
42800 PRINT "C"
42810 COLOR 8
42820 IF B THEN COLOR 15
42830 LOCATE 21, 12
42840 PRINT "B"
42850 COLOR 11
42860 RETURN
42900 ' ===== sub-rotina: escolhe a rotina da sala (ON SALA GOSUB) @ 0d4df =====
42910 IF SALA <= 10 THEN ON SALA GOSUB 45100, 45300, 45400, 45500, 45600, 45700, 45800, 45900, 46000, 46300
42920 IF SALA > 10 AND SALA <= 20 THEN ON SALA - 10 GOSUB 46400, 46500, 46600, 46700, 46800, 46900, 47000, 47100, 47200, 47400
42930 IF SALA > 20 AND SALA <= 30 THEN ON SALA - 20 GOSUB 47500, 47600, 47700, 48300, 48400, 48500, 48600, 48700, 48800, 48900
42940 IF SALA > 30 AND SALA <= 40 THEN ON SALA - 30 GOSUB 49000, 49100, 49200, 49300, 49400, 49500, 49600, 49700, 49800, 49900
42950 IF SALA > 40 AND SALA <= 50 THEN ON SALA - 40 GOSUB 50100, 50200, 50300, 50400, 50500, 50600, 50700, 50800, 50900, 51000
42960 IF SALA > 50 AND SALA <= 60 THEN ON SALA - 50 GOSUB 51100, 51200, 51300, 51400, 51500, 51600, 51700, 51800, 52100, 52200
42970 IF SALA > 60 AND SALA <= 67 THEN ON SALA - 60 GOSUB 52300, 52400, 52500, 52600, 52700, 52900, 53200
42980 RETURN
45000 ' **************************************************************
45010 ' SUB-ROTINAS (4/5): SALAS
45020 ' Uma sub-rotina por sala, escolhida por ON SALA GOSUB.
45030 ' **************************************************************
45100 ' ===== sala 1: Vocà est† no escrit¢rio do chefe. NÑo Ç a prim @ 0d807 =====
45110 NOMESALA$ = "ESCRITORIO"
45120 IF VISITADA(SALA) = 0 THEN
45130   AVISO$ = "Digite qualquer tecla..."
45140   MENSAGEM$ = MSG$(124) : GOSUB 42000   ' msg 123: Vocà est† no escrit¢rio do chefe. NÑo Ç a primeira vez que v
45150   MENSAGEM$ = MSG$(125) : GOSUB 42000   ' msg 124: De repente, a porta se abre. Aquele cara grandÑo, que vocà c
45160   GOSUB 41000
45170   MENSAGEM$ = MSG$(126) : GOSUB 42000   ' msg 125: 'EntÑo Ç VOCE !!!', ele diz, enquanto vocà se despede mental
45180   MENSAGEM$ = MSG$(127) : GOSUB 42000   ' msg 126: 'Que disquete ???', vocà responde, surpreso por nÑo saber do
45190   MENSAGEM$ = MSG$(128) : GOSUB 42000   ' msg 127: 'NÑo venha com essa. EU QUERO ESTE DISQUETE. Vè PROCURè-LO A
45200   GOSUB 41000
45210   MENSAGEM$ = MSG$(129) : GOSUB 42000   ' msg 128: 'Sim, senhor !', vocà responde, enquanto o babaca sai e bate
45220   MENSAGEM$ = MSG$(130) : GOSUB 42000   ' msg 129: Parece que vocà est† bem encrencado agora. Và se acha este d
45230   GOSUB 41000
45240 ELSE
45250   MENSAGEM$ = MSG$(131) : GOSUB 42000   ' msg 130: Vocà est† no escrit¢rio do chefe.
45260 END IF
45270 N = 2 : S = 0 : L = 0 : O = 0 : C = 0 : B = 0
45280 RETURN
45300 ' ===== sala 2: Vocà est† na recepáÑo do escrit¢rio. Vocà và a @ 0d91f =====
45310 NOMESALA$ = "RECEPCAO"
45320 MENSAGEM$ = MSG$(132) : GOSUB 42000   ' msg 131: Vocà est† na recepáÑo do escrit¢rio. Vocà và a rua ao norte,
45330 N = 3 : S = 1 : L = 0 : O = 0 : C = 0 : B = 0
45340 RETURN
45400 ' ===== sala 3: Vocà est† na caláada de uma rua bastante movim @ 0d979 =====
45410 NOMESALA$ = "CALCADA"
45420 MENSAGEM$ = MSG$(133) : GOSUB 42000   ' msg 132: Vocà est† na caláada de uma rua bastante movimentada. E' rea
45430 N = 0 : S = 2 : L = 4 : O = 0 : C = 0 : B = 0
45440 RETURN
45500 ' ===== sala 4: Vocà se encontra num caláadÑo. Ao sul pode-se  @ 0d9d5 =====
45510 NOMESALA$ = "CALCADAO"
45520 MENSAGEM$ = MSG$(134) : GOSUB 42000   ' msg 133: Vocà se encontra num caláadÑo. Ao sul pode-se ver um salÑo b
45530 N = 0 : S = 5 : L = 0 : O = 3 : C = 0 : B = 0
45540 RETURN
45600 ' ===== sala 5: Estamos na biblioteca. Este Ç um lugar interes @ 0da31 =====
45610 NOMESALA$ = "BIBLIOTECA"
45620 MENSAGEM$ = MSG$(135) : GOSUB 42000   ' msg 134: Estamos na biblioteca. Este Ç um lugar interessante. As prat
45630 N = 4 : S = 0 : L = 0 : O = 0 : C = 0 : B = 0
45640 RETURN
45700 ' ===== sala 6: O balcÑo Ç apertado, mas deu para entrar (agor @ 0da8b =====
45710 NOMESALA$ = "BALCAO"
45720 MENSAGEM$ = MSG$(136) : GOSUB 42000   ' msg 135: O balcÑo Ç apertado, mas deu para entrar (agora que vocà se 
45730 N = 5 : S = 0 : L = 0 : O = 0 : C = 0 : B = 7
45740 RETURN
45800 ' ===== sala 7: A escada te levou atÇ um dep¢sito. Agora, bast @ 0dae7 =====
45810 NOMESALA$ = "DEPOSITO"
45820 MENSAGEM$ = MSG$(137) : GOSUB 42000   ' msg 136: A escada te levou atÇ um dep¢sito. Agora, basta subir que vo
45830 N = 0 : S = 0 : L = 0 : O = 0 : C = 5 : B = 0
45840 RETURN
45900 ' ===== sala 8: Vocà est† numa viela totalmente deserta. @ 0db41 =====
45910 NOMESALA$ = "VIELA"
45920 MENSAGEM$ = MSG$(138) : GOSUB 42000   ' msg 137: Vocà est† numa viela totalmente deserta.
45930 N = 9 : S = 11 : L = 57 : O = 0 : C = 0 : B = 0
45940 RETURN
46000 ' ===== sala 9: Estamos numa praáa. Um fato curioso Ç que ning @ 0db9f =====
46010 NOMESALA$ = "PRACA"
46020 IF VISITADA(9) = 0 THEN
46030   AVISO$ = "Digite qualquer tecla..."
46040   MENSAGEM$ = MSG$(139) : GOSUB 42000   ' msg 138: Estamos numa praáa. Um fato curioso Ç que ninguÇm aqui tem u
46050   MENSAGEM$ = MSG$(140) : GOSUB 42000   ' msg 139: De repente, o povo se aglomera Ö sua volta. Todos comeáam a 
46060   GOSUB 41000
46070   MENSAGEM$ = MSG$(141) : GOSUB 42000   ' msg 140: 'Ol†, amigos. Tudo bem com vocàs ? Mas que dia lindo est† ho
46080   MENSAGEM$ = MSG$(142) : GOSUB 42000   ' msg 141: 'Ih, moáada, esse manÇ Ç Mauricinho. Olha que frufru' - diz 
46090   GOSUB 41000
46100   MENSAGEM$ = MSG$(143) : GOSUB 42000   ' msg 142: 'A°, loque, esse barato Ç territ¢rio dos carecas. Que Ç que 
46110   MENSAGEM$ = MSG$(144) : GOSUB 42000   ' msg 143: 'N-N-N-Nada. S¢ passeando...' - vocà responde, pensando no s
46120   GOSUB 41000
46130   MENSAGEM$ = MSG$(145) : GOSUB 42000   ' msg 144: 'Mas, apesar de tudo, gostei de vocà. Ali†s, te achei super-
46140   MENSAGEM$ = MSG$(146) : GOSUB 42000   ' msg 145: 'YEAH ! YEAH ! YEAH !' - diz a galera. E o cara continua - '
46150   GOSUB 41000
46160   MENSAGEM$ = MSG$(147) : GOSUB 42000   ' msg 146: 'Ei, o que vocàs vÑo fazer. Espere a°, esse cabelo Ç meu !!!
46170   MENSAGEM$ = MSG$(148) : GOSUB 42000   ' msg 147: 'Muito bem' - diz o grandÑo, quando o serviáo termina - 'Ago
46180   GOSUB 41000
46190   MENSAGEM$ = MSG$(149)   ' msg 148: Vocà olha para o chÑo e và aquilo que um dia foi seu cabelo.
46200 ELSE
46210   MENSAGEM$ = MSG$(150) : GOSUB 42000   ' msg 149: Vocà est† na praáa dos carecas. Seus £ltimos momentos aqui n
46220 END IF
46230 N = 10 : S = 8 : L = 0 : O = 0 : C = 0 : B = 0
46240 RETURN
46300 ' ===== sala 10: Estamos em outra praáa. Mais tipos estranhos a @ 0dced =====
46310 AVISO$ = "Digite qualquer tecla..."
46320 MENSAGEM$ = MSG$(151) : GOSUB 42000   ' msg 150: Estamos em outra praáa. Mais tipos estranhos aparecem, nÑo e
46330 MENSAGEM$ = MSG$(152) : GOSUB 42000   ' msg 151: Muito feliz por ser um deles, vocà comeáa a pular e gritar: 
46340 GOSUB 41000
46350 MENSAGEM$ = MSG$(153) : GOSUB 42000   ' msg 152: A multidÑo vem euf¢rica em sua direáÑo, e vocà delira por es
46360 MENSAGEM$ = MSG$(154) : GOSUB 42000   ' msg 153: 'Vocà Ç um dos carecas, mesmo ?', e vocà responde: 'Sim ! E 
46370 GOSUB 41000
46380 MENSAGEM$ = MSG$(155) : GOSUB 42000   ' msg 154: 'SOMOS PUNKS. N¢S ODIAMOS OS CARECAS !!!!!!' - grita a multi
46390 GOTO 61780
46400 ' ===== sala 11: Vocà est† na entrada de uma faculdade. NÑo Ç n @ 0dd55 =====
46410 NOMESALA$ = "FACULDADE"
46420 MENSAGEM$ = MSG$(156) : GOSUB 42000   ' msg 155: Vocà est† na entrada de uma faculdade. NÑo Ç nenhuma Oxford,
46430 N = 8 : S = 13 : L = 12 : O = 0 : C = 0 : B = 0
46440 RETURN
46500 ' ===== sala 12: Vocà se encontra num estacionamento. NÑo h† ne @ 0ddb3 =====
46510 NOMESALA$ = "ESTACIONAMENTO"
46520 MENSAGEM$ = MSG$(157) : GOSUB 42000   ' msg 156: Vocà se encontra num estacionamento. NÑo h† nenhum carro, o 
46530 N = 0 : S = 0 : L = 0 : O = 11 : C = 0 : B = 0
46540 RETURN
46600 ' ===== sala 13: Estamos na secretaria da faculdade. ê uma sali @ 0de0d =====
46610 NOMESALA$ = ""
46620 MENSAGEM$ = MSG$(158) : GOSUB 42000   ' msg 157: Estamos na secretaria da faculdade. ê uma salinha bem mixuru
46630 IF NOT AULAUSADA THEN L = 14 ELSE L = 0
46640 N = 11 : S = 16 : O = 18 : C = 0 : B = 0
46650 RETURN
46700 ' ===== sala 14: Ei, esta Ç uma sala de aula. Os alunos e o pro @ 0de94 =====
46710 MENSAGEM$ = MSG$(159) : GOSUB 42000   ' msg 158: Ei, esta Ç uma sala de aula. Os alunos e o professor olham p
46720 MENSAGEM$ = MSG$(160) : GOSUB 42000   ' msg 159: De repente, o professor grita: 'ATACAR !!!', e os alunos lan
46730 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
46740 AULAUSADA = -1
46750 LOCOBJ(28) = 13
46760 SALA = 13
46770 GOTO 46600
46800 ' ===== sala 15: Esta Ç a quadra de esportes. Nada de anormal a @ 0def7 =====
46810 NOMESALA$ = "QUADRA"
46820 MENSAGEM$ = MSG$(161) : GOSUB 42000   ' msg 160: Esta Ç a quadra de esportes. Nada de anormal aqui.
46830 N = 0 : S = 0 : L = 0 : O = 16 : C = 0 : B = 0
46840 RETURN
46900 ' ===== sala 16: Vocà est† no gin†sio de esportes. O lugar est† @ 0df51 =====
46910 NOMESALA$ = "GINASIO"
46920 MENSAGEM$ = MSG$(162) : GOSUB 42000   ' msg 161: Vocà est† no gin†sio de esportes. O lugar est† acabado. Na p
46930 N = 13 : S = 0 : L = 15 : O = 0 : C = 0 : B = 0
46940 RETURN
47000 ' ===== sala 17: Vocà est† no almoxarifado. O cheiro do local n @ 0dfad =====
47010 NOMESALA$ = "ALMOXARIFADO"
47020 MENSAGEM$ = MSG$(163) : GOSUB 42000   ' msg 162: Vocà est† no almoxarifado. O cheiro do local nÑo Ç nada agra
47030 N = 18 : S = 0 : L = 0 : O = 0 : C = 0 : B = 19
47040 RETURN
47100 ' ===== sala 18: Este Ç o Centro de Processamento de Dados da f @ 0e009 =====
47110 NOMESALA$ = "CPD"
47120 MENSAGEM$ = MSG$(164) : GOSUB 42000   ' msg 163: Este Ç o Centro de Processamento de Dados da faculdade. Exam
47130 N = 0 : S = 17 : L = 13 : O = 0 : C = 0 : B = 0
47140 RETURN
47200 ' ===== sala 19: Vocà est† num dep¢sito de papel. @ 0e065 =====
47210 NOMESALA$ = ""
47220 N = 0 : S = 0 : L = 0 : O = 0 : C = 17 : B = 0
47230 IF LANTERNA$ = "ligada" AND LOCOBJ(21) = -999 AND LOCOBJ(22) = -999 THEN
47240   NOMESALA$ = "DEPOSITO"
47250   MENSAGEM$ = MSG$(165) : GOSUB 42000   ' msg 164: Vocà est† num dep¢sito de papel.
47260   IF LOCOBJ(32) = 0 THEN LOCOBJ(32) = 19
47270   RETURN
47280 END IF
47290 MENSAGEM$ = MSG$(166) : GOSUB 42000   ' msg 165: Estamos num lugar escuro, muito escuro. NÑo d† nem para enxe
47300 C = 0
47310 RETURN
47400 ' ===== sala 20: Meu Deus, que lugar horr°vel. NÑo d† para anda @ 0e181 =====
47410 MENSAGEM$ = MSG$(168) : GOSUB 42000   ' msg 167: Meu Deus, que lugar horr°vel. NÑo d† para andar um minuto se
47420 MENSAGEM$ = MSG$(169) : GOSUB 42000   ' msg 168: Um corr¢zinho vem lhe pedir uma grana. Vocà d† a ele tudo o 
47430 GOTO 61780
47500 ' ===== sala 21: Estamos em (mais) uma ruazinha louca, no senti @ 0e1a6 =====
47510 NOMESALA$ = "RUA"
47520 MENSAGEM$ = MSG$(170) : GOSUB 42000   ' msg 169: Estamos em (mais) uma ruazinha louca, no sentido de norte a 
47530 N = 22 : S = 26 : L = 23 : O = 28 : C = 0 : B = 0
47540 RETURN
47600 ' ===== sala 22: Estamos num beco sem sa°da. @ 0e206 =====
47610 NOMESALA$ = "BECO"
47620 MENSAGEM$ = MSG$(171) : GOSUB 42000   ' msg 170: Estamos num beco sem sa°da.
47630 N = 0 : S = 21 : L = 0 : O = 0 : C = 0 : B = 0
47640 RETURN
47700 ' ===== sala 23: Vocà entra na loja, que parece negociar peáas  @ 0e260 =====
47710 NOMESALA$ = "LOJA"
47720 AVISO$ = "Digite qualquer tecla..."
47730 IF VISITADA(SALA) = 0 THEN
47740   VISITADA(SALA) = 1
47750   MENSAGEM$ = MSG$(172) : GOSUB 42000   ' msg 171: Vocà entra na loja, que parece negociar peáas de autom¢veis.
47760   MENSAGEM$ = MSG$(173) : GOSUB 42000   ' msg 172: 'Em que posso servi-lo ?' - ele pergunta.
47770   MENSAGEM$ = MSG$(174) : GOSUB 42000   ' msg 173: 'Bem, eu gostaria de saber aonde procurar um disquete roubad
47780   GOSUB 41000
47790   MENSAGEM$ = MSG$(175) : GOSUB 42000   ' msg 174: 'Oh, mas isso Ç ¢BVIO ! Procure o Sr. L !!!
47800   MENSAGEM$ = MSG$(176) : GOSUB 42000   ' msg 175: 'SR. L ? Quem Ç o tipo ?
47810   MENSAGEM$ = MSG$(177) : GOSUB 42000   ' msg 176: 'Ele est† h† tempos tentando controlar os neg¢cios da cidade
47820   GOSUB 41000
47830   MENSAGEM$ = MSG$(178) : GOSUB 42000   ' msg 177: 'BELEZA ! Vou atr†s do salafr†rio !!!' - vocà diz, euf¢rico.
47840   MENSAGEM$ = MSG$(179) : GOSUB 42000   ' msg 178: 'Calma a°, rapaz' - ele diz - 'Em primeiro lugar, vocà preci
47850   MENSAGEM$ = MSG$(180) : GOSUB 42000   ' msg 179: 'Hmm...'
47860   GOSUB 41000
47870   MENSAGEM$ = MSG$(181) : GOSUB 42000   ' msg 180: 'Mas eu posso lev†-lo atÇ a sede das Ind£strias L & L Ltda..
47880   MENSAGEM$ = MSG$(182)   ' msg 181: 'MESMO ???':GOSUB P
47890   MENSAGEM$ = MSG$(183) : GOSUB 42000   ' msg 182: '...mediante um m¢dico preáo.'
47900   MENSAGEM$ = MSG$(184) + STR$(GRANA) + " paus." : GOSUB 42000   ' msg 183: 'Hmm...' - vocà diz, abrindo sua carteira e exibindo seus
47910   GOSUB 41000
47920   IF GRANA >= 5000 THEN GOTO 48010
47930   MENSAGEM$ = MSG$(185) : GOSUB 42000   ' msg 184: 'Ei, isso nÑo d† nem pro cheiro. Nada feito.' - Ele diz, e l
47940   GOTO 48170
47950 END IF
47960 MENSAGEM$ = MSG$(186) : GOSUB 42000   ' msg 185: Estamos na loja de autopeáas. O vendedor nos aborda.
47970 IF GRANA < 5000 THEN
47980   MENSAGEM$ = MSG$(187) : GOSUB 42000   ' msg 186: 'Trouxe a grana ?' - ele diz, ao que vocà responde negativam
47990   GOTO 48170
48000 END IF
48010 MENSAGEM$ = MSG$(188) : GOSUB 42000   ' msg 187: 'Ah, vejo que sua carteira est† recheada' - ele diz, nos tom
48020 GRANA = GRANA - 5000
48030 MENSAGEM$ = MSG$(189) : GOSUB 42000   ' msg 188: 'Vai me levar agora ?' - vocà diz, nervoso por perder toda a
48040 MENSAGEM$ = MSG$(190) : GOSUB 42000   ' msg 189: 'Claro. Venha comigo'
48050 GOSUB 41000
48060 MENSAGEM$ = MSG$(191)   ' msg 190: Vocàs se dirigem a uma garagem no fundo da loja, enquanto el
48070 MENSAGEM$ = MENSAGEM$ + " poderosa de pa°ses inimagin†veis, que pertenceu a pouqu°ssima gente, com marchas poderosas...'" : GOSUB 42000
48080 MENSAGEM$ = MSG$(192) : GOSUB 42000   ' msg 191: Finalmente ele chega ao falado carro. Ele lhe lembra vagamen
48090 GOSUB 41000
48100 MENSAGEM$ = MSG$(193) : GOSUB 42000   ' msg 192: O carro vai, sacolejando, enquanto vocà imagina se, em caso 
48110 MENSAGEM$ = MSG$(194) : GOSUB 42000   ' msg 193: 'Aqui', ele diz, apontando para o prÇdio aonde vocàs param, 
48120 GOSUB 41000
48130 MENSAGEM$ = MSG$(195) : GOSUB 42000   ' msg 194: Vocà sai do carro, e ele vai embora, cantando os pneus (ou m
48140 SALA = 39
48150 GOSUB 41000
48160 RETURN
48170 SALA = 21
48180 MENSAGEM$ = MSG$(196) : GOSUB 42000   ' msg 195: Estamos de volta Ö rua central.
48190 N = 22 : S = 26 : L = 23 : O = 28 : C = 0 : B = 0
48200 RETURN
48300 ' ===== sala 24: Estamos num quarto. Na cama, um casal faz o qu @ 0e54c =====
48310 NOMESALA$ = "QUARTO"
48320 MENSAGEM$ = MSG$(197) : GOSUB 42000   ' msg 196: Estamos num quarto. Na cama, um casal faz o que lhe Ç direit
48330 N = 0 : S = 0 : L = 0 : O = 25 : C = 0 : B = 0
48340 RETURN
48400 ' ===== sala 25: Vocà est† num corredor estreito dentro do quar @ 0e5a6 =====
48410 NOMESALA$ = "CORREDOR"
48420 MENSAGEM$ = MSG$(198) : GOSUB 42000   ' msg 197: Vocà est† num corredor estreito dentro do quarto. NÑo parece
48430 N = 0 : S = 0 : O = 26 : L = 24 : C = 0 : B = 0
48440 RETURN
48500 ' ===== sala 26: Estamos no fim da rua. Ao leste se và um desse @ 0e602 =====
48510 NOMESALA$ = "FIM DA RUA"
48520 MENSAGEM$ = MSG$(199) : GOSUB 42000   ' msg 198: Estamos no fim da rua. Ao leste se và um desses quartos bara
48530 N = 21 : S = 0 : L = 25 : O = 27 : C = 0 : B = 0
48540 RETURN
48600 ' ===== sala 27: Estamos numa casa de fliperama. Uma m†quina de @ 0e660 =====
48610 NOMESALA$ = "FLIPERAMA"
48620 MENSAGEM$ = MSG$(200) : GOSUB 42000   ' msg 199: Estamos numa casa de fliperama. Uma m†quina de Street Fighte
48630 N = 0 : S = 0 : L = 26 : O = 0 : C = 0 : B = 0
48640 RETURN
48700 ' ===== sala 28: Esta Ç a entrada do prÇdio. Um local exalando  @ 0e6ba =====
48710 NOMESALA$ = "ENTRADA"
48720 MENSAGEM$ = MSG$(201) : GOSUB 42000   ' msg 200: Esta Ç a entrada do prÇdio. Um local exalando um cheiro naus
48730 N = 29 : S = 0 : L = 21 : O = 32 : C = 0 : B = 0
48740 RETURN
48800 ' ===== sala 29: A mulherada que havia sa°do do banheiro avanáa @ 0e718 =====
48810 NOMESALA$ = "HALL"
48820 IF VISITADA(31) <> 0 THEN MENSAGEM$ = MSG$(202) : GOSUB 42000 : GOTO 61780   ' msg 201: A mulherada que havia sa°do do banheiro avanáa sobre vocà, e
48830 MENSAGEM$ = MSG$(203) : GOSUB 42000   ' msg 202: Vocà est† no hall do prÇdio. NÑo h† onde sentar-se, e mesmo 
48840 N = 30 : S = 28 : L = 0 : O = 31 : C = 0 : B = 0
48850 RETURN
48900 ' ===== sala 30: Estamos no elevador. @ 0e7a0 =====
48910 MENSAGEM$ = MSG$(204) : GOSUB 42000   ' msg 203: Estamos no elevador.
48920 N = 0 : S = 29 : L = 0 : O = 0 : C = 0 : B = 0
48930 RETURN
49000 ' ===== sala 31: Entramos no banheiro feminino. A mulherada sai @ 0e7f0 =====
49010 NOMESALA$ = "BANHEIRO"
49020 IF VISITADA(31) = 0 THEN
49030   MENSAGEM$ = MSG$(205)   ' msg 204: Entramos no banheiro feminino. A mulherada sai gritando com 
49040 ELSE
49050   MENSAGEM$ = "Estamos no banheiro feminino."
49060 END IF
49070 GOSUB 42000
49080 N = 0 : S = 0 : L = 29 : O = 0 : C = 0 : B = 0
49090 RETURN
49100 ' ===== sala 32: Este Ç o banheiro masculino. Nem pense em faze @ 0e875 =====
49110 NOMESALA$ = "BANHEIRO"
49120 MENSAGEM$ = MSG$(206) : GOSUB 42000   ' msg 205: Este Ç o banheiro masculino. Nem pense em fazer nada aqui, p
49130 N = 0 : S = 0 : L = 28 : O = 0 : C = 0 : B = 0
49140 RETURN
49200 ' ===== sala 33: Vocà est† num poáo. @ 0e8cf =====
49210 NOMESALA$ = "POCO"
49220 MENSAGEM$ = MSG$(207) : GOSUB 42000   ' msg 206: Vocà est† num poáo.
49230 N = 0 : S = 0 : L = 0 : O = 0 : C = 0 : B = 34
49240 RETURN
49300 ' ===== sala 34: Estamos num lugar, que, pelo maquin†rio, parec @ 0e929 =====
49310 NOMESALA$ = "FABRICA"
49320 MENSAGEM$ = MSG$(208) : GOSUB 42000   ' msg 207: Estamos num lugar, que, pelo maquin†rio, parece ser uma f†br
49330 N = 0 : S = 35 : L = 37 : O = 0 : C = 0 : B = 0
49340 RETURN
49400 ' ===== sala 35: Estamos numa salinha apertada. @ 0e985 =====
49410 MENSAGEM$ = MSG$(209) : GOSUB 42000   ' msg 208: Estamos numa salinha apertada.
49420 N = 34 : S = 0 : L = 0 : O = 0 : C = 0 : B = 36
49430 RETURN
49500 ' ===== sala 36: Ca°mos numa rede de esgotos. Ap¢s tatear muito @ 0e9d7 =====
49510 NOMESALA$ = "ESGOTOS"
49520 MENSAGEM$ = MSG$(210) : GOSUB 42000   ' msg 209: Ca°mos numa rede de esgotos. Ap¢s tatear muito, encontramos 
49530 N = 0 : S = 0 : L = 0 : O = 38 : C = 0 : B = 0
49540 RETURN
49600 ' ===== sala 37: Abrimos uma portinhola e eis o que aparece: me @ 0ea31 =====
49610 MENSAGEM$ = MSG$(211) : GOSUB 42000   ' msg 210: Abrimos uma portinhola e eis o que aparece: metade do elenco
49620 MENSAGEM$ = MSG$(212) : GOSUB 42000   ' msg 211: '® Como te chamas ?'
49630 MENSAGEM$ = MSG$(213) : GOSUB 42000   ' msg 212: 'E-E-Epaminondas.'.
49640 MENSAGEM$ = MSG$(214) : GOSUB 42000   ' msg 213: 'TE CHAMABAS !!!!' - dizem todos eles, ao fuzil†-lo.
49650 GOTO 61780
49700 ' ===== sala 38: Ah† ! Uma escadaria. @ 0ea78 =====
49710 NOMESALA$ = "ESCADARIA"
49720 MENSAGEM$ = MSG$(215) : GOSUB 42000   ' msg 214: Ah† ! Uma escadaria.
49730 N = 0 : S = 0 : L = 0 : O = 0 : C = 27 : B = 0
49740 RETURN
49800 ' ===== sala 39: Estamos na frente da BucanoWare INC. NÑo parec @ 0ead2 =====
49810 MENSAGEM$ = MSG$(216) : GOSUB 42000   ' msg 215: Estamos na frente da BucanoWare INC. NÑo parece haver outro 
49820 N = 40 : S = 0 : L = 0 : O = 0 : C = 0 : B = 0
49830 VISITADA(40) = 0
49840 RETURN
49900 ' ===== sala 40: Vocà entra na recepáao. A recepcionista sorri  @ 0eb31 =====
49910 NOMESALA$ = "RECEPCAO"
49920 IF VISITADA(40) = 0 THEN
49930   MENSAGEM$ = MSG$(217) : GOSUB 42000   ' msg 216: Vocà entra na recepáao. A recepcionista sorri e diz:
49940   MENSAGEM$ = MSG$(218) : GOSUB 42000   ' msg 217: 'Bom dia. O que o senhor deseja ?'
49950   MENSAGEM$ = MSG$(219) : GOSUB 42000   ' msg 218: 'Bem, eu, aham, precisava conversar com o Sr. L'
49960   MENSAGEM$ = MSG$(220) : GOSUB 42000   ' msg 219: 'Infelizmente, o Sr. L. hoje est† muito ocupado. A nÑo ser q
49970   AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
49980 ELSE
49990   MENSAGEM$ = MSG$(221) : GOSUB 42000   ' msg 220: Estamos na recepáÑo.
50000 END IF
50010 N = 0 : S = 39 : L = 0 : O = 0 : C = 0 : B = 0
50020 RETURN
50100 ' ===== sala 41: Estamos no hall do edif°cio. Ao sul est† a mes @ 0ebfd =====
50110 NOMESALA$ = "HALL"
50120 MENSAGEM$ = MSG$(222) : GOSUB 42000   ' msg 221: Estamos no hall do edif°cio. Ao sul est† a mesa da secret†ri
50130 N = 0 : S = 40 : L = 43 : O = 42 : C = 0 : B = 0
50140 RETURN
50200 ' ===== sala 42: Vocà est† num elevador. @ 0ec5b =====
50210 NOMESALA$ = "ELEVADOR"
50220 MENSAGEM$ = MSG$(223)   ' msg 222: Vocà est† num elevador.
50230 IF ELEVMOVEU THEN MENSAGEM$ = MENSAGEM$ + " Ele desce automaticamente atÇ o tÇrreo." : ELEVMOVEU = 0
50240 GOSUB 42000
50250 N = 0 : S = 0 : L = 41 : O = 0 : C = 0 : B = 0
50260 RETURN
50300 ' ===== sala 43: Vocà est† num elevador. @ 0ece8 =====
50310 NOMESALA$ = "ELEVADOR"
50320 MENSAGEM$ = MSG$(224)   ' msg 223: Vocà est† num elevador.
50330 IF ELEVMOVEU THEN MENSAGEM$ = MENSAGEM$ + " Ele sobe automaticamente atÇ o tÇrreo." : ELEVMOVEU = 0
50340 GOSUB 42000
50350 N = 0 : S = 0 : L = 0 : O = 41 : C = 0 : B = 0
50360 RETURN
50400 ' ===== sala 44: Ao sair do elevador, vocà chegou num bel°ssimo @ 0ed75 =====
50410 NOMESALA$ = "ESCRITORIO"
50420 MENSAGEM$ = MSG$(225) : GOSUB 42000   ' msg 224: Ao sair do elevador, vocà chegou num bel°ssimo escrit¢rio co
50430 N = 0 : S = 0 : L = 0 : O = 42 : C = 0 : B = 0
50440 RETURN
50500 ' ===== sala 45: Vocà est† no CPD da firma. NinguÇm nota sua ch @ 0edcf =====
50510 NOMESALA$ = "CPD"
50520 MENSAGEM$ = MSG$(226) : GOSUB 42000   ' msg 225: Vocà est† no CPD da firma. NinguÇm nota sua chegada.
50530 N = 0 : S = 0 : L = 0 : O = 42 : C = 0 : B = 0
50540 RETURN
50600 ' ===== sala 46: Estamos na recepáÑo da administraáÑo. @ 0ee29 =====
50610 NOMESALA$ = "RECEPCAO"
50620 MENSAGEM$ = MSG$(227) : GOSUB 42000   ' msg 226: Estamos na recepáÑo da administraáÑo.
50630 N = 0 : S = 0 : L = 47 : O = 42 : C = 0 : B = 0
50640 RETURN
50700 ' ===== sala 47: Estamos numa sala que parece pertencer a algum @ 0ee85 =====
50710 NOMESALA$ = "SALA"
50720 MENSAGEM$ = MSG$(228) : GOSUB 42000   ' msg 227: Estamos numa sala que parece pertencer a alguma secret†ria.
50730 N = 0 : S = 48 : L = 0 : O = 46 : C = 0 : B = 0
50740 RETURN
50800 ' ===== sala 48: Eis OUTRA sala de secret†ria. @ 0eee1 =====
50810 NOMESALA$ = "SALA"
50820 IF VISITADA(SALA) = 0 THEN MENSAGEM$ = MSG$(229) ELSE MENSAGEM$ = "Vocà est† numa (outra) salinha de secret†ria."   ' msg 228: Eis OUTRA sala de secret†ria.
50830 GOSUB 42000
50840 N = 47 : S = 49 : L = 0 : O = 0 : C = 0 : B = 0
50850 RETURN
50900 ' ===== sala 49: Eis MAIS UMA sala de secret†ria (esse Sr. L Ç  @ 0ef73 =====
50910 NOMESALA$ = "SALA"
50920 IF VISITADA(SALA) = 0 THEN
50930   MENSAGEM$ = MSG$(230)   ' msg 229: Eis MAIS UMA sala de secret†ria (esse Sr. L Ç bom mesmo). Pe
50940 ELSE
50950   MENSAGEM$ = MSG$(231)   ' msg 230: Estamos numa salinha pertencente a alguma secret†ria.
50960 END IF
50970 GOSUB 42000
50980 N = 48 : S = 50 : L = 0 : O = 0 : C = 0 : B = 0
50990 RETURN
51000 ' ===== sala 50: Estamos num corredor no sentido de leste a oes @ 0f011 =====
51010 NOMESALA$ = "CORREDOR"
51020 MENSAGEM$ = MSG$(232) : GOSUB 42000   ' msg 231: Estamos num corredor no sentido de leste a oeste.
51030 N = 49 : S = 0 : L = 51 : O = 52 : C = 0 : B = 0
51040 RETURN
51100 ' ===== sala 51: Estamos num pequeno lavabo. @ 0f06f =====
51110 NOMESALA$ = "LAVABO"
51120 MENSAGEM$ = MSG$(233) : GOSUB 42000   ' msg 232: Estamos num pequeno lavabo.
51130 N = 0 : S = 0 : L = 0 : O = 50 : C = 0 : B = 0
51140 RETURN
51200 ' ===== sala 52: Estamos em frente a uma porta. Ela est† aberta @ 0f0c9 =====
51210 MENSAGEM$ = MSG$(234) : GOSUB 42000   ' msg 233: Estamos em frente a uma porta. Ela est† aberta.
51220 N = 0 : S = 0 : L = 50 : O = 53 : C = 0 : B = 0
51230 RETURN
51300 ' ===== sala 53: Estamos na sala do Sr. L. O local Ç bastante i @ 0f11b =====
51310 NOMESALA$ = "SALA"
51320 MENSAGEM$ = MSG$(235) : GOSUB 42000   ' msg 234: Estamos na sala do Sr. L. O local Ç bastante incrementado, o
51330 N = 0 : S = 0 : L = 52 : O = 0 : C = 0 : B = 0
51340 RETURN
51400 ' ===== sala 54: Estamos na garagem do edif°cio. @ 0f175 =====
51410 NOMESALA$ = "GARAGEM"
51420 MENSAGEM$ = MSG$(236) : GOSUB 42000   ' msg 235: Estamos na garagem do edif°cio.
51430 N = 0 : S = 0 : L = 43 : O = 0 : C = 0 : B = 0
51440 RETURN
51500 ' ===== sala 55: Estamos no almoxarifado. Valendo-se de sua int @ 0f1cf =====
51510 NOMESALA$ = "ALMOXARIFADO"
51520 MENSAGEM$ = MSG$(237) : GOSUB 42000   ' msg 236: Estamos no almoxarifado. Valendo-se de sua inteligància supe
51530 N = 0 : S = 0 : L = 43 : O = 0 : C = 0 : B = 0
51540 RETURN
51600 ' ===== sala 56: Estamos num bairro pior do que todos os outros @ 0f229 =====
51610 NOMESALA$ = "BAIRRO"
51620 MENSAGEM$ = MSG$(238)   ' msg 237: Estamos num bairro pior do que todos os outros j† vistos. Ao
51630 MENSAGEM$ = MENSAGEM$ + " embora ficar a° marcando bobeira nÑo seja uma boa..." : GOSUB 42000
51640 N = 58 : S = 0 : L = 20 : O = 20 : C = 0 : B = 0
51650 RETURN
51700 ' ===== sala 57: Estamos numa agància de viagens. Todos os guic @ 0f298 =====
51710 NOMESALA$ = "AGENCIA"
51720 MENSAGEM$ = MSG$(239) : GOSUB 42000   ' msg 238: Estamos numa agància de viagens. Todos os guichàs estÑo fech
51730 N = 0 : S = 0 : L = 0 : O = 8 : C = 0 : B = 0
51740 IF PORTAABERTA THEN L = 67
51750 RETURN
51800 ' ===== sala 58: 'Boa noite, cavalheiro', lhe diz o engomadinho @ 0f316 =====
51810 NOMESALA$ = "PORTARIA"
51820 IF VISITADA(59) <> 0 THEN
51830   MENSAGEM$ = MSG$(240) : GOSUB 42000   ' msg 239: 'Boa noite, cavalheiro', lhe diz o engomadinho, enquanto voc
51840   GOTO 52020
51850 END IF
51860 MENSAGEM$ = MSG$(241) : GOSUB 42000   ' msg 240: Entramos numa passagem. Um indiv°duo engravatadinho e engoma
51870 MENSAGEM$ = MSG$(242) : GOSUB 42000   ' msg 241: 'Vocà Ç s¢cio ?'
51880 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
51890 IF LOCOBJ(38) <> -999 THEN
51900   MENSAGEM$ = MSG$(243) : GOSUB 42000   ' msg 242: 'NÑo, mas...'
51910   MENSAGEM$ = MSG$(244) : GOSUB 42000   ' msg 243: 'EntÑo ter† que comprar o convite.'
51920   MENSAGEM$ = MSG$(245) : GOSUB 42000   ' msg 244: Vocà mostra a ele seus $5, e ele d† uma risadinha. 'Ah, clar
51930   MENSAGEM$ = MSG$(246) : GOSUB 42000   ' msg 245: 'Sim, claro' - vocà diz, virando-se para a janela ao sul - '
51940   GOSUB 41000
51950   MENSAGEM$ = MSG$(247) : GOSUB 42000   ' msg 246: 'VAI NESSA, PALHAÄO !!!' - diz ele, chutando o seu traseiro 
51960   SALA = 56
51970   GOTO 51600
51980   GOTO 52020
51990 END IF
52000 MENSAGEM$ = MSG$(248) : GOSUB 42000   ' msg 247: Vocà pega o cartÑo 'emprestado' do cara do quarto e mostra a
52010 MENSAGEM$ = MSG$(249) : GOSUB 42000   ' msg 248: 'Ah, claro. Desculpe nÑo tà-lo reconhecido antes, Sr. Elbest
52020 N = 59 : S = 56 : L = 0 : O = 0 : C = 0 : B = 0
52030 RETURN
52100 ' ===== sala 59: Vocà est† na pista de danáa. @ 0f476 =====
52110 NOMESALA$ = "PISTA"
52120 MENSAGEM$ = MSG$(250) : GOSUB 42000   ' msg 249: Vocà est† na pista de danáa.
52130 N = 62 : S = 58 : L = 61 : O = 60 : C = 0 : B = 0
52140 RETURN
52200 ' ===== sala 60: Vocà est† no que se pode chamar de '†rea priva @ 0f4d6 =====
52210 NOMESALA$ = "AREA"
52220 MENSAGEM$ = MSG$(251) : GOSUB 42000   ' msg 250: Vocà est† no que se pode chamar de '†rea privada' da dancete
52230 N = 0 : S = 0 : L = 59 : O = 0 : C = 0 : B = 0
52240 RETURN
52300 ' ===== sala 61: Vocà est† no bar. @ 0f530 =====
52310 NOMESALA$ = "BAR"
52320 MENSAGEM$ = MSG$(252) : GOSUB 42000   ' msg 251: Vocà est† no bar.
52330 N = 0 : S = 0 : L = 0 : O = 59 : C = 0 : B = 0
52340 RETURN
52400 ' ===== sala 62: Vocà est† em frente Ö mesa de som, perto do ac @ 0f58a =====
52410 NOMESALA$ = "MESA"
52420 MENSAGEM$ = MSG$(253) : GOSUB 42000   ' msg 252: Vocà est† em frente Ö mesa de som, perto do acesso que d† na
52430 N = 0 : S = 59 : L = 0 : O = 0 : C = 63 : B = 0
52440 IF LOCOBJ(72) = 0 THEN N = 65
52450 RETURN
52500 ' ===== sala 63: Esta Ç a sacada. Daqui d† para ver todo o movi @ 0f608 =====
52510 NOMESALA$ = "SACADA"
52520 MENSAGEM$ = MSG$(254) : GOSUB 42000   ' msg 253: Esta Ç a sacada. Daqui d† para ver todo o movimento do local
52530 N = 64 : S = 0 : L = 0 : O = 0 : C = 0 : B = 62
52540 RETURN
52600 ' ===== sala 64: Estamos no banheiro masculino (poder°amos ter  @ 0f664 =====
52610 NOMESALA$ = "BANHEIRO"
52620 MENSAGEM$ = MSG$(255) : GOSUB 42000   ' msg 254: Estamos no banheiro masculino (poder°amos ter entrado no fem
52630 N = 0 : S = 63 : L = 0 : O = 0 : C = 0 : B = 0
52640 RETURN
52700 ' ===== sala 65: Ao dar a volta pela mesa de som, vocà entrou n @ 0f6be =====
52710 MENSAGEM$ = MSG$(256) : GOSUB 42000   ' msg 255: Ao dar a volta pela mesa de som, vocà entrou neste lugar som
52720 MENSAGEM$ = MSG$(257) : GOSUB 42000   ' msg 256: Um silàncio sepulcral assola o local, atÇ que uma voz se faz
52730 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
52740 MENSAGEM$ = MSG$(258) : GOSUB 42000   ' msg 257: 'Ei, Mike, que hist¢ria Ç essa de abrir a passagem com a dan
52750 MENSAGEM$ = MSG$(259) : GOSUB 42000   ' msg 258: Vocà se vira para a sa°da, mas eis que de repente a passagem
52760 GOSUB 41000
52770 MENSAGEM$ = MSG$(260) : GOSUB 42000   ' msg 259: 'Ah† ! Vejo que temos um espiÑo aqui ! NéO SE MOVA, MALDITO 
52780 MENSAGEM$ = MSG$(261) : GOSUB 42000   ' msg 260: Mas vocà nÑo vai se entregar sem luta ! Agora vocà se lembra
52790 GOSUB 41000
52800 MENSAGEM$ = MSG$(262) : GOSUB 42000   ' msg 261: ...vocà escorrega numa casca de banana (isso mesmo, numa cas
52810 SALA = 66
52820 GOTO 52900
52900 ' ===== sala 66:  @ 0f757 =====
52910 MENSAGEM$ = MSG$(263)   ' msg 262: 
52920 IF VISITADA(66) = 0 THEN MENSAGEM$ = MSG$(264)   ' msg 263: Vocà recupera lentamente a consciància. 
52930 MENSAGEM$ = MENSAGEM$ + "Estamos num fÇtido local que sugere um esconderijo. ê realmente nauseante o cheiro do local." : GOSUB 42000
52940 IF VISITADA(66) = 0 THEN
52950   GOSUB 41000
52960   MENSAGEM$ = MSG$(265) : GOSUB 42000   ' msg 264: A porta se abre, rangendo. Uma figura, que vocà và vagamente
52970   MENSAGEM$ = MSG$(266) : GOSUB 42000   ' msg 265: 'Eu j† vi idiotas de todo tipo, Epaminondas, mas vocà me sur
52980   GOSUB 41000
52990   MENSAGEM$ = MSG$(267) : GOSUB 42000   ' msg 266: 'Como vocà sabe o meu...' - vocà diz, mas imagina que ele de
53000   MENSAGEM$ = MSG$(268) : GOSUB 42000   ' msg 267: Vocà pensa em atacar, mas o instrumento met†lico nas maîs do
53010   GOSUB 41000
53020   MENSAGEM$ = MSG$(269) : GOSUB 42000   ' msg 268: 'Achei que vocà se mataria na cidade para encontrar o disque
53030   MENSAGEM$ = MSG$(270) : GOSUB 42000   ' msg 269: 'Ei, cara, que tal fazermos um trato ? Eu nem quero saber de
53040   GOSUB 41000
53050   MENSAGEM$ = MSG$(271) : GOSUB 42000   ' msg 270: 'CHEGA ! NÑo h† motivos para mais mistÇrios !' - diz ele, ac
53060   MENSAGEM$ = MSG$(272) : GOSUB 42000   ' msg 271: 'Chefinho, entÑo vocà trabalha para o Sr. L ????
53070   MENSAGEM$ = MSG$(273) : GOSUB 42000   ' msg 272: 'NéO, SEU IDIOTA !!! Eu SOU o Sr. L. ! HAHAHAHAHAAAA !!!'
53080   GOSUB 41000
53090   MENSAGEM$ = MSG$(274) : GOSUB 42000   ' msg 273: 'Mas... por quà roubar seu pr¢prio disquete ? E o que EU ten
53100   MENSAGEM$ = MSG$(275)   ' msg 274: 'Vocà ia descobrir, mais cedo ou mais tarde. Ia mexer nas mi
53110   MENSAGEM$ = MENSAGEM$ + " corrig°-la logo, logo..." : GOSUB 42000
53120   GOSUB 41000
53130   MENSAGEM$ = MSG$(276) : GOSUB 42000   ' msg 275: Ele sai da sala, gargalhando, mas nÑo fecha a porta. Em vez 
53140 END IF
53150 N = 0 : S = 0 : L = 0 : O = 0 : C = 0 : B = 0
53160 RETURN
53200 ' ===== sala 67: Vocà atravessa a porta e entra numa garagem, a @ 0f8e7 =====
53210 AVISO$ = "Digite qualquer tecla..."
53220 MENSAGEM$ = MSG$(277) : GOSUB 42000   ' msg 276: Vocà atravessa a porta e entra numa garagem, aonde um ìnibus
53230 MENSAGEM$ = MSG$(278) : GOSUB 42000   ' msg 277: O motorista cita algumas passagens da vida da sua mÑe, por v
53240 GOSUB 41000
53250 MENSAGEM$ = MSG$(279) : GOSUB 42000   ' msg 278: O ìnibus segue viagem, e s¢ agora vocà se pergunta aonde est
53260 MENSAGEM$ = MSG$(280) : GOSUB 42000   ' msg 279: Eis o final. Vocà desce, e volta para o jogo, perdido como s
53270 GOSUB 41000
53280 SALA = 21
53290 GOTO 47500
53300 ' ===== sub-rotina @ 0f94a =====
53310 LOCATE 21, 16
53320 PRINT "Digite o nome do arquivo:"
53330 TECLA$ = ""
53340 NOMEARQ$ = ""
53350 WHILE TECLA$ <> CHR$(13)
53360   LOCATE 21, 42
53370   COLOR 7
53380   PRINT NOMEARQ$;
53390   COLOR 31
53400   PRINT "˛";
53410   COLOR 11
53420   PRINT " ";
53430   LOCATE 18, 16 + LEN(NOMEARQ$)
53440   LOCATE 1, 1
53450   TECLA$ = ""
53460   WHILE TECLA$ = "" : TECLA$ = INKEY$ : WEND
53470   IF TECLA$ >= "a" AND TECLA$ <= "z" THEN TECLA$ = CHR$(ASC(TECLA$) - 32)
53480   IF ((ASC(TECLA$) >= 65 AND ASC(TECLA$) <= 90) OR (ASC(TECLA$) >= 48 AND ASC(TECLA$) <= 57)) AND LEN(NOMEARQ$) < 8 THEN NOMEARQ$ = NOMEARQ$ + TECLA$
53490   IF TECLA$ = CHR$(8) AND NOMEARQ$ <> "" THEN NOMEARQ$ = LEFT$(NOMEARQ$, LEN(NOMEARQ$) - 1)
53500   IF TECLA$ = CHR$(27) THEN TECLA$ = CHR$(13) : NOMEARQ$ = ""
53510 WEND
53520 LOCATE 21, 16
53530 PRINT SPACE$(64);
53540 IF NOMEARQ$ = "" THEN RETURN
60000 ' **************************************************************
60010 ' SUB-ROTINAS (5/5): ARQUIVOS, MENU E FINAL
60020 ' **************************************************************
60030 ON ERROR GOTO 60400
60040 OPEN NOMEARQ$ + ".CA1" FOR OUTPUT AS #1
60050 FOR I = 1 TO NUMSALAS
60060   PRINT #1, VISITADA(I)
60070 NEXT I
60080 FOR I = 1 TO 11
60090   PRINT #1, JANELA$(I)
60100 NEXT I
60110 FOR I = 1 TO NUMOBJ
60120   PRINT #1, LOCOBJ(I)
60130 NEXT I
60140 PRINT #1, NOMESALA$
60150 PRINT #1, AULAUSADA
60160 PRINT #1, SALA
60170 PRINT #1, SALAANT
60180 PRINT #1, GRANA
60190 PRINT #1, PORTAABERTA
60200 PRINT #1, BARMAN
60210 PRINT #1, PAPELALUM
60220 PRINT #1, EXAME$(60)
60230 PRINT #1, EXAME$(64)
60240 PRINT #1, EXAME$(65)
60250 PRINT #1, EXAME$(66)
60260 PRINT #1, LANTERNA$
60270 PRINT #1, PAGINA
60280 PRINT #1, N
60290 PRINT #1, S
60300 PRINT #1, L
60310 PRINT #1, O
60320 PRINT #1, C
60330 PRINT #1, B
60340 PRINT #1, AQUI$(64)
60350 PRINT #1, AQUI$(65)
60360 PRINT #1, AQUI$(66)
60370 CLOSE #1
60380 ON ERROR GOTO 0
60390 RETURN
60400 BEEP
60410 AVISO$ = "ERRO DE DISCO" + STR$(ERR) + " ! OPERAÄéO CANCELADA." : GOSUB 41000
60420 RESUME 60430
60430 ON ERROR GOTO 0
60440 RETURN
60500 ' ===== sub-rotina @ 0ff31 =====
60510 LOCATE 21, 16
60520 PRINT "Digite o nome do arquivo:"
60530 TECLA$ = ""
60540 NOMEARQ$ = ""
60550 WHILE TECLA$ <> CHR$(13)
60560   LOCATE 21, 42
60570   COLOR 7
60580   PRINT NOMEARQ$;
60590   COLOR 31
60600   PRINT "˛";
60610   COLOR 11
60620   PRINT " ";
60630   LOCATE 18, 16 + LEN(NOMEARQ$)
60640   LOCATE 1, 1
60650   TECLA$ = ""
60660   WHILE TECLA$ = "" : TECLA$ = INKEY$ : WEND
60670   IF TECLA$ >= "a" AND TECLA$ <= "z" THEN TECLA$ = CHR$(ASC(TECLA$) - 32)
60680   IF ((ASC(TECLA$) >= 65 AND ASC(TECLA$) <= 90) OR (ASC(TECLA$) >= 48 AND ASC(TECLA$) <= 57)) AND LEN(NOMEARQ$) < 8 THEN NOMEARQ$ = NOMEARQ$ + TECLA$
60690   IF TECLA$ = CHR$(8) AND NOMEARQ$ <> "" THEN NOMEARQ$ = LEFT$(NOMEARQ$, LEN(NOMEARQ$) - 1)
60700   IF TECLA$ = CHR$(27) THEN TECLA$ = CHR$(13) : NOMEARQ$ = ""
60710 WEND
60720 LOCATE 21, 16
60730 PRINT SPACE$(64);
60740 IF NOMEARQ$ = "" THEN RETURN
60750 ON ERROR GOTO 60400
60760 OPEN NOMEARQ$ + ".CA1" FOR INPUT AS #1
60770 FOR I = 1 TO NUMSALAS
60780   INPUT #1, VISITADA(I)
60790 NEXT I
60800 FOR I = 1 TO 11
60810   LINE INPUT #1, JANELA$(I)
60820 NEXT I
60830 FOR I = 1 TO NUMOBJ
60840   INPUT #1, LOCOBJ(I)
60850 NEXT I
60860 LINE INPUT #1, NOMESALA$
60870 INPUT #1, AULAUSADA
60880 INPUT #1, SALA
60890 INPUT #1, SALAANT
60900 INPUT #1, GRANA
60910 INPUT #1, PORTAABERTA
60920 INPUT #1, BARMAN
60930 INPUT #1, PAPELALUM
60940 LINE INPUT #1, EXAME$(60)
60950 LINE INPUT #1, EXAME$(64)
60960 LINE INPUT #1, EXAME$(65)
60970 LINE INPUT #1, EXAME$(66)
60980 LINE INPUT #1, LANTERNA$
60990 INPUT #1, PAGINA
61000 INPUT #1, N
61010 INPUT #1, S
61020 INPUT #1, L
61030 INPUT #1, O
61040 INPUT #1, C
61050 INPUT #1, B
61060 LINE INPUT #1, AQUI$(64)
61070 LINE INPUT #1, AQUI$(65)
61080 LINE INPUT #1, AQUI$(66)
61090 CLOSE #1
61100 GOSUB 42600
61110 ON ERROR GOTO 0
61120 GOSUB 42500
61130 GOSUB 42600
61140 COLOR 15
61150 FOR I = 1 TO 11
61160   LOCATE I + 4, 2
61170   PRINT SPACE$(58);
61180   LOCATE I + 4, 2
61190   PRINT JANELA$(I);
61200 NEXT I
61210 COLOR 11
61220 RETURN
61300 ' ===== sub-rotina @ 105bf =====
61310 AVISO$ = "Digite uma tecla p/ outra tela, ou ESC para jogar..."
61320 FOR I = 1 TO 11
61330   BACKUP$(I) = JANELA$(I)
61340 NEXT I
61350 MENSAGEM$ = MSG$(281) : GOSUB 42000   ' msg 280: ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ TELA DE AJUDA  1 ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹
61360 MENSAGEM$ = MSG$(282)   ' msg 281: Este Ç um jogo do tipo 'adventure', aonde vocà tem que contr
61370 MENSAGEM$ = MENSAGEM$ + " Neste aqui, o personagem Ç Epaminondas. O objetivo, vocà j† deve ter visto (se nÑo, recomece o jogo)." : GOSUB 42000
61380 MENSAGEM$ = MSG$(283) : GOSUB 42000   ' msg 282: Esta janela Ç a janela de mensagens. Todo o texto da hist¢ri
61390 GOSUB 41000
61400 IF TECLA$ <> CHR$(27) THEN MENSAGEM$ = MSG$(284) : GOSUB 42000 : MENSAGEM$ = MSG$(285) : GOSUB 42000 : MENSAGEM$ = MSG$(286) + " " + MSG$(287) : GOSUB 42000 : GOSUB 41000 : IF TECLA$ <> CHR$(27) THEN MENSAGEM$ = MSG$(288) : GOSUB 42000 : _
      MENSAGEM$ = MSG$(289) : GOSUB 42000 : MENSAGEM$ = MSG$(290) : GOSUB 42000 : MENSAGEM$ = MSG$(291) : GOSUB 42000 : GOSUB 41000 : IF TECLA$ <> CHR$(27) THEN MENSAGEM$ = MSG$(292) : GOSUB 42000 : MENSAGEM$ = MSG$(293) : GOSUB 42000 : _
      MENSAGEM$ = "ESC novamente retorna Ö janela de Comando. " + MSG$(294) : GOSUB 42000 : GOSUB 41000 : IF TECLA$ <> CHR$(27) THEN MENSAGEM$ = "‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ TELA DE AJUDA  5 ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ" : GOSUB 42000 : _
      MENSAGEM$ = "Gravar:ˇˇˇSalvaˇaˇsituaáÑoˇdoˇjogoˇemˇdisco." : MENSAGEM$ = MENSAGEM$ + " Carregar:ˇLàˇumaˇsituaáÑoˇj†ˇgravada." : MENSAGEM$ = MENSAGEM$ + " Ajuda:ˇˇˇˇEstaˇtela.ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ" : _
      MENSAGEM$ = MENSAGEM$ + " Notas:ˇˇˇˇObservaáîesˇdestaˇversÑo." : MENSAGEM$ = MENSAGEM$ + " Rein°cio:ˇComeáaˇnovamenteˇoˇjogo." : MENSAGEM$ = MENSAGEM$ + " Fim:ˇˇˇˇˇˇSaiˇdoˇjogo." : GOSUB 42000 : LINHAMSG$ = "" : GOSUB 42200 : _
      GOSUB 41000 : IF TECLA$ <> CHR$(27) THEN MENSAGEM$ = "‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ TELA DE AJUDA  6 ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹ﬂ‹" : GOSUB 42000 : _
      MENSAGEM$ = "A janela de Objetos mostra tudo o que vocà est† carregando. Quando ela nÑo couber mais na tela, digite LISTAR e use as setas  e  para 'passear' nela." : GOSUB 42000 : _
      MENSAGEM$ = "O resto Ç por sua conta. Procure examinar tudo, e raciocinar as pistas dadas pelo jogo." : GOSUB 42000 : LINHAMSG$ = "" : GOSUB 42200 : GOSUB 42200 : AVISO$ = "Digite qualquer tecla para jogar" : GOSUB 41000
61410 FOR LINBAK = 1 TO 11
61420   LINHAMSG$ = BACKUP$(LINBAK)
61430   GOSUB 42200
61440 NEXT LINBAK
61450 RETURN
61500 ' ===== sub-rotina @ 1090e =====
61510 FOR I = 1 TO 11
61520   BACKUP$(I) = JANELA$(I)
61530 NEXT I
61540 AVISO$ = "Digite qualquer tecla..."
61550 MENSAGEM$ = "Este programa foi desenvolvido em Turbo Basic, e Ç bastante propenso a 'dar pau' em certas configuraáîes. V† por sua pr¢pria conta e risco..." : GOSUB 42000
61560 MENSAGEM$ = "A £nica coisa que dever† ser observada Ç que, para dar um objeto a alguÇm, ex., o dinheiro ao caixa, use DEIXAR DINHEIRO. O caixa 'entender†' que vocà quer entregar a ele, e nÑo larga-lo no chÑo." : GOSUB 42000
61570 GOSUB 41000
61580 MENSAGEM$ = "Agradecimentos:" : GOSUB 42000
61590 MENSAGEM$ = "Ao Ken Williams, ao Al Lowe e Ö toda a equipe da Sierra-On-Line, por todos os adventures que j† fizeram e vierem a fazer." : GOSUB 42000
61600 MENSAGEM$ = "Aos Stone Age Scanners, pelo incentivo a este e outros programas, bem como pelos beta-testes." : GOSUB 42000
61610 GOSUB 41000
61620 MENSAGEM$ = "Ao F†bio (F.M.K.), pelas sugestîes finais, pelo help na m£sica e por tambem testar, e a todos os que tambÇm testaram e ajudaram a criar o programa." : GOSUB 42000
61630 MENSAGEM$ = "Obs.: ê verdade que faltam neste adventure algumas caracter°sticas interessantes, mas eu queria que ele rodasse bem, mesmo no XT monocrom†tico (ergh !)." : GOSUB 42000
61640 GOSUB 41000
61650 MENSAGEM$ = "Obs. (2): O programa Ç um pouco mal-educado, jogue por sua conta e risco. NÑo me processem se sentirem-se ofendidos. EstÑo avisados." : GOSUB 42000
61660 MENSAGEM$ = "Obs. (3): Qualquer semelhanáa entre algum di†logo deste jogo e algum filme (Monty Pyton) e/ou desenho animado NéO Ç mera coincidància..." : GOSUB 42000
61670 GOSUB 41000
61680 MENSAGEM$ = "Obs. (4): Se vocà, como eu, nÑo gostar da m£sica de abertura, ou tiver um XT barulhento como o meu, basta manter a tecla <ALT> pressionada atÇ que a abertura se inicie." : GOSUB 42000
61690 MENSAGEM$ = "Eu atÇ diria que, para entrar no programa, basta digitar AVENTURA <ENTER>, mas se vocà est† lendo isto, Ç ¢bvio que j† sabe. Se vocà quiser pular a abertura e ir direto ao jogo, digite CA1 <ENTER> no nosso querido e iconogr†fico prompt do DOS." : GOSUB 42000
61700 GOSUB 41000
61710 MENSAGEM$ = "Obs. (Final): Para acessar a documentaáÑo, digite LEIAME quando estiver no DOS. E boa sorte..." : GOSUB 42000
61720 GOSUB 41000
61730 GOTO 61410
61740 S = (80 + -LEN(S51E$)) / 2
61750 S51E$ = SPACE$(S) + S51E$
61760 PRINT S51E$
61770 RETURN
61780 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
61790 MENSAGEM$ = MSG$(295) : GOSUB 42000   ' msg 294: Vocà falhou em sua missÑo de recuperar seu emprego. Ali†s, v
61800 MENSAGEM$ = MSG$(296) : GOSUB 42000   ' msg 295: Vamos l† ! NÑo se desespere ! O Papai Smurf est† contando co
61810 AVISO$ = "Digite qualquer tecla para reiniciar o jogo..." : GOSUB 41000
61820 CLEAR
61830 GOTO 100
61840 END
61850 END
61860 MENSAGEM$ = MSG$(297) : GOSUB 42000   ' msg 296: Vocà coloca a lÉmpada no soquete, e ouve um estouro. As pouc
61870 MENSAGEM$ = MSG$(298) : GOSUB 42000   ' msg 297: Algumas horas se passam na escuridÑo. De repente, algumas vo
61880 AVISO$ = "Digite qualquer tecla..." : GOSUB 41000
61890 MENSAGEM$ = MSG$(299) : GOSUB 42000   ' msg 298: 'Ei, me tirem daqui !!!!', vocà grita, enquanto bate desespe
61900 MENSAGEM$ = MSG$(300) : GOSUB 42000   ' msg 299: 'Vocà a° dentro', diz uma das vozes, 'afaste-se desta parede
61910 MENSAGEM$ = MSG$(301) : GOSUB 42000   ' msg 300: Vocà obedece, e um barulho de metal batendo no concreto come
61920 GOSUB 41000
61930 MENSAGEM$ = MSG$(302) : GOSUB 42000   ' msg 301: Ao ver os bombeiros, vocà logo grita: 'Foi o Sr. L. ! ê tudo
61940 MENSAGEM$ = MSG$(303) : GOSUB 42000   ' msg 302: 'Sim, n¢s j† sabemos. Fomos chamados para conter o tumulto d
61950 MENSAGEM$ = MSG$(304) : GOSUB 42000   ' msg 303: Vocà Ç retirado do local, e ap¢s algumas horas de interrogat
61960 GOSUB 41000
61970 MENSAGEM$ = MSG$(305) : GOSUB 42000   ' msg 304: Ao chegar l†, vocà descobre que o gerente assumiu o posto do
61980 MENSAGEM$ = MSG$(306) : GOSUB 42000   ' msg 305: 'E o disquete, o que tinha ?'
61990 MENSAGEM$ = MSG$(307) : GOSUB 42000   ' msg 306: 'NÑo se sabe. A pol°cia procurou em todo lugar, e nÑo encont
62000 GOSUB 41000
62010 IF LOCOBJ(76) <> -999 THEN
62020   MENSAGEM$ = MSG$(308) : GOSUB 42000   ' msg 307: Sem soluáÑo para isso, vocà continua a trabalhar atÇ o fim d
62030   MENSAGEM$ = MSG$(309) : GOSUB 42000   ' msg 308: Acho que o jogo termina por aqui. Muito embora nÑo tenha cap
62040   GOSUB 41000
62050   MENSAGEM$ = MSG$(310) : GOSUB 42000   ' msg 309: O que haveria no cofre ? Seria o disquete ? Se nÑo, aonde es
62060   MENSAGEM$ = MSG$(311) : GOSUB 42000   ' msg 310: Vocà jamais saber† a resposta destas perguntas. No entanto, 
62070   AVISO$ = "Digite qualquer tecla para recomeáar..." : GOSUB 41000
62080   CLEAR
62090   GOTO 100
62100   GOTO 62360
62110 END IF
62120 MENSAGEM$ = MSG$(312) : GOSUB 42000   ' msg 311: 'Ei, eu tenho uma chave !!!', vocà diz, euf¢rico.
62130 MENSAGEM$ = MSG$(313) : GOSUB 42000   ' msg 312: 'Duvido que sirva para algo, mas... EI, ESTA ê UMA CHAVE MES
62140 MENSAGEM$ = MSG$(314) : GOSUB 42000   ' msg 313: Vocàs correm na direáÑo do cofre, tiram as fitas que a per°c
62150 GOSUB 41000
62160 MENSAGEM$ = MSG$(315) : GOSUB 42000   ' msg 314: Vocà d† a chave ao gerente. Ele coloca-a dentro do buraco. E
62170 MENSAGEM$ = MSG$(316) : GOSUB 42000   ' msg 315: 'QUE DROGA !!!!' - vocà diz, enquanto pensa em voltar Ö sua 
62180 MENSAGEM$ = MSG$(317) : GOSUB 42000   ' msg 316: Vocà pega um cinzeiro da mesa e atira na direáÑo do cofre, r
62190 GOSUB 41000
62200 MENSAGEM$ = MSG$(318) : GOSUB 42000   ' msg 317: ...CLIC ! O cinzeiro pressionou a chave no ponto correto, o 
62210 MENSAGEM$ = MSG$(319) : GOSUB 42000   ' msg 318: Uma nÇvoa densa Ç revelada (que o Sr. L deve ter importado d
62220 GOSUB 41000
62230 MENSAGEM$ = MSG$(320) : GOSUB 42000   ' msg 319: 'ê O DISQUETE !!!', vocà grita, enquanto vai pulando com ele
62240 MENSAGEM$ = MSG$(321) : GOSUB 42000   ' msg 320: O gerente digita o comando para acessar o disquete. A luz do
62250 GOSUB 41000
62260 MENSAGEM$ = MSG$(322) : GOSUB 42000   ' msg 321: Uma mensagem aparece no monitor. Abismado, vocà verifica que
62270 MENSAGEM$ = MSG$(323) : GOSUB 42000   ' msg 322:            Felicitaáîes pelo dia da P†scoa !!!
62280 MENSAGEM$ = MSG$(324) : GOSUB 42000   ' msg 323: 			Ass.:Serviáo Secreto de Ohio.
62290 MENSAGEM$ = MSG$(325) : GOSUB 42000   ' msg 324: ESSA NéO !!! VOCE PASSOU POR TUDO ISSO POR CAUSA DE UMA CART
62300 GOSUB 41000
62310 MENSAGEM$ = MSG$(326) : GOSUB 42000   ' msg 325: ParabÇns ! Vocà chegou ao fim do jogo ! Todos os objetivos f
62320 MENSAGEM$ = MSG$(327)   ' msg 326: Como em todo epis¢dio do Jaspion, vocà terminou exatamente o
62330 MENSAGEM$ = MENSAGEM$ + "NÑo esquente com isso. Acontece nas melhores fam°lias. De qualquer forma, vocà j† tem algo para contar aos seus netinhos. Adi¢s !!!" : GOSUB 42000
62340 AVISO$ = "Digite qualquer tecla para ir ao DOS..." : GOSUB 41000
62350 GOTO 62360
62360 COLOR 15, 0, 0
62370 CLS
62380 END
