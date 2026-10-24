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
