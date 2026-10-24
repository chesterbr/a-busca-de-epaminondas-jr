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
