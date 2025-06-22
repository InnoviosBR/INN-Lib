#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH"
#INCLUDE "INNLIB.CH"

/*/{Protheus.doc} CFGINN
Executador de fonte
@author Clemilson Pena
@since 01/02/2013
@version 1.0
/*/
                              
User Function CFGINN()

	Local nOk       := 0
	Local cExecProg := Space(10)
	Local oDlgExe, oGrp1, oLBox1, oGrp2, oSay1, oSay2, oExecProg, oBtn1
	Local nItemEsco := 0
	Local aProgra   := {"Contra Prova",;
						"Criador de Tabelas",;
						"Extrator de Dados",;
						"SQL Exeqtor",;
						"Analise de tabelas"} 

	Private cCadastro := "Executador de Fonte - V2.6"
													
	oDlgExe    := MSDialog():New( 224,385,551,917,cCadastro,,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 004,004,152,124," Rotinas Internas ",oDlgExe,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oLBox1     := TListBox():New( 016,008,,aProgra,112,132,,oGrp1,,CLR_BLACK,CLR_WHITE,.T.,,{||  nOk := 1 , nItemEsco := oLBox1:GetPos() , oDlgExe:End() },,"",,,,,,, )
	
	oGrp2      := TGroup():New( 004,136,152,256," Execute Fontes ",oDlgExe,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oExecProg  := TGet():New( 020,148,{|u| If(PCount()>0,cExecProg:=u,cExecProg)},oGrp2,096,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cExecProg",,)
	oBtn1      := TButton():New( 040,155,"User Function",oGrp2,{|| nOk := 2 , oDlgExe:End() },037,012,,,,.T.,,,,,,.F. )
	oBtn1      := TButton():New( 040,195,"Nativa",oGrp2,{|| nOk := 3 , oDlgExe:End() },037,012,,,,.T.,,,,,,.F. )
	oSay1      := TSay():New( 115,140,{||"_____________________________________________________"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
	oSay2      := TSay():New( 125,140,{||"Powered by INNOVIOS"+chr(13)+chr(10)+"innovios.com.br"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,052)

	oDlgExe:Activate(,,,.T.) 
	
	IF nOk == 1 .and. nItemEsco != 0

		do case
			case nItemEsco == 1
				MsgRun("Aguarde.... Executando...",,{|| CONTPROV() }) 
			case nItemEsco == 2
				MsgRun("Aguarde.... Executando...",,{|| CRIATAB() }) 
			case nItemEsco == 3
				MsgRun("Aguarde.... Executando...",,{|| TAKE() })
			case nItemEsco == 4
				MsgRun("Aguarde.... Executando...",,{|| SQLEXE() })
			case nItemEsco == 5
				MsgRun("Aguarde.... Executando...",,{|| fExitSx2() })
		end case
		
	ENDIF  
	
	IF nOk == 2 .and. !empty(cExecProg)
			
		if ExistBlock(ALLTRIM(cExecProg))
					
			ExecBlock(ALLTRIM(cExecProg),.F.,.F.)
			
		endif
		
	ENDIF

	IF nOk == 3 .and. !empty(cExecProg)

		cExecProg := strtran(cExecProg,"(","")
		cExecProg := strtran(cExecProg,")","")			
		cExecProg := upper(Alltrim(cExecProg))+"()"
		Eval({|| &(cExecProg) })
		
	ENDIF
	
Return(.T.)

Static Function CRIATAB()

	//Local nCont := 0
	//Private cPerg := "CRIATAB"
	//Private aPerg := {}
	
	//Aadd(aPerg,{cPerg,"Tabela","C",3,0,"G","NaoVazio()","","","","","","","@!"}) 

	//TestSX1(cPerg,aPerg)
	
	/*
	if !Pergunte(cPerg,.T.)
		Return("Abortado!")
	end if
	*/
	aParamBox := {}
	aRet := {}
	aAdd(aParamBox,{1,"Tabela"	,Space(3),"@!","","","",100,.T.}) //mv_par01	
	
	if !ParamBox(aParamBox,"Cria Tabela",@aRet,{|| (.T.)},{},,,,,"",.F.,.F.)
		Return
	endif
	
	mv_par01 := aRet[1]
	
	if empty(mv_par01)
		Return("Abortado!")
	endif
	
	iif(select(mv_par01) <> 0,(mv_par01)->(dbCloseArea()),NIL)	
	                                           
	DbSelectArea(mv_par01)
	AxCadastro(mv_par01, mv_par01, , )
	
	MSGINFO("TABELA CRIADA")
	
Return(.T.)

Static Function CONTPROV() 

	Local aArea := getArea()
	Local aAreax3 := SX3->(getArea())
	Local cAps := '"'
	
	Local cMemhis := ""
	//Local cPerg := "CONTPROV"
	//Local aPerg := {} 
	Local cDiv := " |"
	Local cGatilh := ""
	Local cX2Unico := ""
	Local aParamBox := {}
	Local aRet := {}	
	
	aAdd(aParamBox,{1,"Tabela"	,Space(3),"@!","","","",100,.T.}) //mv_par01	
	aAdd(aParamBox,{2,"Modo"	,"2",{"1=RecLock","2=Extrato","3=Compatibilizador"},100,"",.T.}) //mv_par02
	
	if !ParamBox(aParamBox,"Contra Prova",@aRet,{|| (.T.)},{},,,,,"",.F.,.F.)
		Return
	endif
	
	mv_par01 := aRet[1]
	mv_par02 := aRet[2]
	
	DbSelectArea("SX2")
	SX2->(DbSetOrder(1))
	SX2->(DbSeek(mv_par01))
		
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(mv_par01))
	
	if mv_par02 == "1"
		cMemhis += "RecLock('" + SX2->X2_CHAVE + "',.T.)//" + SX2->X2_NOME + CRLF
	endif
	if mv_par02 == "2"
		cMemhis += "Tabela " + SX2->X2_CHAVE + " (" + SX2->X2_MODO + SX2->X2_MODOUN + SX2->X2_MODOEMP + ") -> " + SX2->X2_NOME + CRLF
	endif
	if mv_par02 == "3"
		cMemhis += "aAdd(aSX2,{"
		cMemhis += cAps + SX2->X2_CHAVE + cAps + " , "
		cMemhis += cAps + SX2->X2_NOME + cAps + " , "
		cMemhis += cAps + SX2->X2_NOMESPA + cAps + " , "
		cMemhis += cAps + SX2->X2_NOMEENG + cAps + " , "
		cMemhis += cAps + SX2->X2_MODO + cAps + " , "
		cMemhis += cAps + Alltrim(SX2->X2_ROTINA) + cAps + " , "
		cMemhis += cAps + Alltrim(SX2->X2_UNICO) + cAps + " , "
		cMemhis += cAps + SX2->X2_MODOUN + cAps + " , "
		cMemhis += cAps + SX2->X2_MODOEMP + cAps + " , "
		cMemhis += cAps + Alltrim(SX2->X2_DISPLAY) + cAps + " } "
		cMemhis += CRLF
		cMemhis += CRLF
		cMemhis += CRLF
	endif
			

	
	WHILE !SX3->(EOF()) .AND. ALLTRIM(SX3->X3_ARQUIVO) == mv_par01
		if mv_par02 == "1"
			if SX3->X3_CONTEXT != "V"// .and. X3USO(SX3->X3_USADO)
				cMemhis += '	Replace '+SX3->X3_CAMPO+" with"
				if "_FILIAL" $ SX3->X3_CAMPO
					cMemhis += " xFilial('"+mv_par01+"')"
				else
					//cMemhis += " CAMPO"+SX3->X3_ORDEM
					cMemhis += " M->"+SX3->X3_CAMPO
				endif
				cMemhis += " // "+Alltrim(SX3->X3_TITULO)
				cMemhis += " ("+SX3->X3_TIPO+","+TRANSFORM(SX3->X3_TAMANHO, '@E 999')+","+TRANSFORM(SX3->X3_DECIMAL, '@E 999')+")"
				if !X3USO(SX3->X3_USADO)
					cMemhis += "* Campo não usado"
				endif
				cMemhis += CRLF				
			endif
		endif
		if mv_par02 == "2"

			cMemhis += SX3->X3_ORDEM	+ cDiv
			cMemhis += SX3->X3_CAMPO	+ cDiv
			cMemhis += SX3->X3_TIPO		+ cDiv
			cMemhis += SX3->X3_PROPRI	+ cDiv
			cMemhis += SX3->X3_CONTEXT	+ cDiv
			cMemhis += TRANSFORM(SX3->X3_TAMANHO, '@E 999')	+ cDiv
			cMemhis += TRANSFORM(SX3->X3_DECIMAL, '@E 999')	+ cDiv
			cMemhis += SX3->X3_TITULO	+ cDiv
			cMemhis += SX3->X3_DESCRIC	+ cDiv
			cMemhis += SX3->X3_PICTURE	+ cDiv
			cMemhis += SX3->X3_F3		+ cDiv
			cMemhis += fFolder(SX2->X2_CHAVE,SX3->X3_FOLDER) + cDiv
			IF EMPTY(SX3->X3_GRPSXG)
				cMemhis += Space(36) + cDiv
			ELSE
				cMemhis += SX3->X3_GRPSXG
				cMemhis += " - "
				cMemhis += POSICIONE("SXG",1,SX3->X3_GRPSXG,"XG_DESCRI")
				cMemhis += cDiv
			endif
			cMemhis += ALLTRIM(SX3->X3_VLDUSER)	+ cDiv
			cMemhis += ALLTRIM(SX3->X3_CBOX)	+ cDiv
			if !X3USO(SX3->X3_USADO)
				cMemhis += "* Campo não usado"	+ cDiv
			endif
			cMemhis += CRLF

			DbSelectArea("SX7")
			SX7->(DbSetOrder(1))
			SX7->(dbseek(SX3->X3_CAMPO))
			While SX7->(!eof()) .and. SX3->X3_CAMPO == SX7->X7_CAMPO
				cGatilh += SX7->X7_CAMPO + cDiv
				cGatilh += SX7->X7_SEQUENC + cDiv 
				cGatilh += alltrim(SX7->X7_REGRA) + cDiv
				cGatilh += alltrim(SX7->X7_CDOMIN) + cDiv 
				cGatilh += alltrim(SX7->X7_ALIAS) + cDiv
				cGatilh += TRANSFORM(SX7->X7_ORDEM, '@E 999') + cDiv
				cGatilh += alltrim(SX7->X7_CHAVE) + cDiv
				cGatilh += alltrim(SX7->X7_CONDIC) + cDiv
				cGatilh += CRLF
				SX7->(dbSkip())
			ENDDO 
		endif
		if mv_par02 == "3"
			cMemhis += "aadd(aSX3,{	"
			cMemhis += cAps + SX3->X3_ARQUIVO + cAps + " , "
			cMemhis += cAps + SX3->X3_ORDEM + cAps + " , "
			cMemhis += cAps + SX3->X3_CAMPO + cAps + " , "
			cMemhis += cAps + SX3->X3_TIPO + cAps + " , "
			cMemhis += cValToChar(SX3->X3_TAMANHO) + " , "
			cMemhis += cValToChar(SX3->X3_DECIMAL) + " , "
			cMemhis += cAps + Alltrim(OEMToANSI(SX3->X3_TITULO)) + cAps + " , "
			cMemhis += cAps + Alltrim(OEMToANSI(SX3->X3_TITSPA)) + cAps + " , "
			cMemhis += cAps + Alltrim(OEMToANSI(SX3->X3_TITENG)) + cAps + " , "
			cMemhis += cAps + Alltrim(OEMToANSI(SX3->X3_DESCRIC)) + cAps + " , "
			cMemhis += cAps + Alltrim(OEMToANSI(SX3->X3_DESCSPA)) + cAps + " , "
			cMemhis += cAps + Alltrim(OEMToANSI(SX3->X3_DESCENG)) + cAps + " , "
			cMemhis += " ; " + CRLF 
			cMemhis += "            "
			cMemhis += cAps + Alltrim(SX3->X3_PICTURE) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_VALID) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_USADO) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_RELACAO) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_F3) + cAps + " , "
			cMemhis += Alltrim(cValToChar(SX3->X3_NIVEL)) + " , "
			cMemhis += cAps + Alltrim(SX3->X3_RESERV) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_CHECK) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_TRIGGER) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_PROPRI) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_BROWSE) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_VISUAL) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_CONTEXT) + cAps + " , "
			cMemhis += cAps + /*Alltrim(SX3->X3_OBRIGAT) +*/ cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_VLDUSER) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_CBOX) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_CBOXSPA) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_CBOXENG) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_PICTVAR) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_WHEN) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_INIBRW) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_GRPSXG) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_FOLDER) + cAps + " , "
			cMemhis += cAps + Alltrim(SX3->X3_PYME) + cAps + " }) "
			cMemhis += CRLF
			cMemhis += CRLF						
		endif
		SX3->(dbSkip())
	ENDDO 

	if mv_par02 == "1"
		cMemhis += "MsUnLock('"+mv_par01+"')" + CRLF
	endif
	if mv_par02 == "2"
		cMemhis += CRLF + "Indice" + CRLF
		dbSelectArea("SIX")
		SIX->(DbSetOrder(1))
		SIX->(dbSeek(mv_par01))
				
		WHILE !SIX->(EOF()) .and. ALLTRIM(SIX->INDICE) == mv_par01
			cMemhis += SIX->ORDEM + cDiv
			cMemhis += alltrim(SIX->CHAVE) + cDiv + ALLTRIM(SIX->DESCRICAO) + cDiv
			cMemhis += alltrim(SIX->NICKNAME) + cDiv
			cMemhis += CRLF
			SIX->(dbSkip())
		ENDDO 
		
		cMemhis += CRLF + "Gatilho" + CRLF	
		
		if empty(cGatilh)
			cMemhis += "nenhum" + CRLF	
		else
			cMemhis += cGatilh
		endif
		
		cMemhis += CRLF + "Chave unica" + CRLF	
		
		cX2Unico := POSICIONE("SX2",1,mv_par01,"X2_UNICO")
		if empty(cX2Unico)
			cMemhis += "nenhum" + CRLF	
		else
			cMemhis += alltrim(cX2Unico)
		endif
	endif
	
	SX3->(RestArea(aAreax3))
	RestArea(aArea)

	U_INNPT2(cMemhis,/*cDir*/,"Contra Prova",/*lTela*/,.F.)
		
Return(.T.)

Static Function fFolder(cAlias,cPasta)

	Local cRet := Space(34)

	dbSelectArea("SXA")
	SXA->(DbSetOrder(1))
	if SXA->(dbSeek(cAlias+cPasta+Space(3)))
		cRet := cPasta
		cRet += " - "
		cRet += SXA->XA_DESCRIC
	endif

Return(cRet)

Static Function TAKE()                       

	Private oButton1
	Private oButton2
	Private oFont1 := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
	Private oGroup1
	Private oGroup2
	Private oMultiGe1
	Private cMultiGe1 := "SELECT * FROM "+RetSqlName("SB1")
	Private oSay1
	Private oSButton1
	Private oSButton2
	Private oSButton3
	Private oSButton4
	Private oSButton7
	Private oSButton8
	Private oOk := LoadBitmap( GetResources(), "LBOK")
	Private oNo := LoadBitmap( GetResources(), "LBNO")
	Private oWBrowse1
	Private aWBrowse1 := {}
	Static oDlg
	
	DEFINE MSDIALOG oDlg TITLE "Extrator de Dados" FROM 000, 000  TO 440, 500 COLORS 0, 15461355 PIXEL
	
	    @ 002, 059 SAY "Extrair dados de uma Query para Excel" SIZE 126, 008 OF oDlg FONT oFont1 COLORS CLR_BLACK PIXEL
	    @ 019, 000 GROUP oGroup1 TO 086, 248 PROMPT " Digite aqui sua Query " OF oDlg COLOR CLR_BLACK PIXEL
	    @ 029, 005 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 239, 051 COLORS CLR_BLACK HSCROLL PIXEL
	    DEFINE SBUTTON oSButton1 FROM 087, 190 TYPE 01 OF oDlg ONSTOP "Confirmar Select" ENABLE ACTION MsgRun("Gerando Estrutudas da Query, Aguarde...","",{|| CursorWait(), fGeraSQL() ,CursorArrow()})
	    DEFINE SBUTTON oSButton2 FROM 087, 219 TYPE 11 OF oDlg ONSTOP "Limpar Memo Select" ENABLE ACTION fLimpaMem()
	    DEFINE SBUTTON oSButton3 FROM 087, 002 TYPE 14 OF oDlg ONSTOP "Abrir Query" ENABLE ACTION fAbrirQry()
	    DEFINE SBUTTON oSButton4 FROM 087, 031 TYPE 13 OF oDlg ONSTOP "Salvar Query" ENABLE ACTION fSalvaQry()
	    @ 102, 000 GROUP oGroup2 TO 200, 248 PROMPT " Selecione os Campos para Gerar o Excel " OF oDlg COLOR CLR_BLACK PIXEL
	    fWBrowse1()
	    @ 187, 003 BUTTON oButton1 PROMPT "Marcar Todos" SIZE 040, 010 OF oDlg ACTION fMarca() PIXEL
	    @ 187, 044 BUTTON oButton2 PROMPT "Desmarcar Todos" SIZE 045, 010 OF oDlg ACTION fDesmarca() PIXEL
	    DEFINE SBUTTON oSButton7 FROM 202, 190 TYPE 01 OF oDlg ONSTOP "Gerar Excel" ENABLE ACTION Processa({||fGeraExcel()},"Aguarde...","Gerando Excel...")
	    DEFINE SBUTTON oSButton8 FROM 202, 219 TYPE 02 OF oDlg ONSTOP "Finalizar Aplicacao" ENABLE ACTION fFechar()
	    
	    //TBitMap():New(000,000,280,1500,"ProjetoAP",,.T.,oDlg,,,,,,,,,.T.)
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return

//------------------------------------------------ 
Static Function fWBrowse1()
//------------------------------------------------ 

    // Insert items here 
    Aadd(aWBrowse1,{.F.,"","","","",""})
   
    @ 111, 003 LISTBOX oWBrowse1 Fields HEADER "","Cod.Campo","Descricao","Tipo","Tamanho","Decimal" SIZE 240, 074 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],;
      aWBrowse1[oWBrowse1:nAt,5],;
      aWBrowse1[oWBrowse1:nAt,6];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}

Return
        

Static Function fGeraSQL()
	*************************************
	*** Gerar Query Executada
	********
	Local cQuery 	:= AllTrim(Upper(cMultiGe1))
	Local aStrut  	:= {}
	//Local nRec		:= 0
	Local nX
	                         
	fCloseArea("TMPQRY")
	
	nRet := TCSQLExec(AllTrim(Upper(cMultiGe1)))
	If (nRet < 0)
	  APMsgStop("Erro na Query!!")
	  Return
	EndIf  
	
	aWBrowse1 := {}
	
	TCQUERY cQuery NEW ALIAS "TMPQRY"
	TMPQRY->(dbGoTop())
	
	aStrut	:= TMPQRY->(dbstruct()) 
	
	For nX := 1 To Len(aStrut)
	     dbSelectArea("SX3")
	     dbSetOrder(2)
	     If dbSeek(ALLTRIM(aStrut[nX,1]),.t.)
	          Aadd(aWBrowse1, {.T.,Alltrim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
	     Else                                                                
	     	Aadd(aWBrowse1, {.T.,Alltrim(aStrut[nX,1]), Alltrim(aStrut[nX,1]), aStrut[nX,2], aStrut[nX,3], aStrut[nX,4]})
	     EndIf
	Next    
	
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	      aWBrowse1[oWBrowse1:nAt,2],;
	      aWBrowse1[oWBrowse1:nAt,3],;
	      aWBrowse1[oWBrowse1:nAt,4],;
	      aWBrowse1[oWBrowse1:nAt,5],;
	      aWBrowse1[oWBrowse1:nAt,6]}}
	   
Return


Static Function fLimpaMem()
	*************************************
	*** Limpar o campo Memo
	********
	//Limpa o Memo
	cMultiGe1	:= ""
	oMultiGe1:Refresh()
	
	//Limpar ListBox
	aWBrowse1 := {}
	Aadd(aWBrowse1,{.F.,"","","","",""})
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	      aWBrowse1[oWBrowse1:nAt,2],;
	      aWBrowse1[oWBrowse1:nAt,3],;
	      aWBrowse1[oWBrowse1:nAt,4],;
	      aWBrowse1[oWBrowse1:nAt,5],;
	      aWBrowse1[oWBrowse1:nAt,6]}}
	
	//Fecha Select caso ja tenha executado
	fCloseArea("TMPQRY")
Return

Static Function fGeraExcel()

	Local nTotReg := 0
	Local nLidos  := 0
	Local nCont
	Local cArquivo    := GetTempPath()+'zTstExc1.xml'

	oFWMsExcel := FWMSExcel():New()
	oFWMsExcel:AddworkSheet("planilha 1")
	oFWMsExcel:AddTable("planilha 1","tabela 1")

	For nCont := 1 To Len(aWBrowse1)
		If(aWBrowse1[nCont,1])
			//aadd( _aStru , {AllTrim(aWBrowse1[nCont,3])   , AllTrim(aWBrowse1[nCont,4]) , aWBrowse1[nCont,5] , aWBrowse1[nCont,6] } )		
			if AllTrim(aWBrowse1[nCont,4]) == "N"
				oFWMsExcel:AddColumn("planilha 1","tabela 1",AllTrim(aWBrowse1[nCont,2]),2,2) //2 = Valor sem R$
			else
				oFWMsExcel:AddColumn("planilha 1","tabela 1",AllTrim(aWBrowse1[nCont,2]),1,1) //1 = Modo Texto
			endif
		EndIf
	Next 

	While !TMPQRY->(EOF())
	 	IncProc("Aguarde... Processando Registro " + Alltrim(Str(nLidos)) + " de " + Alltrim(Str(nTotReg)))

		aLinha := {}
	    For nCont := 1 To Len(aWBrowse1)    
	    	cVariavel := AllTrim(aWBrowse1[nCont,3])
	    	
	    	If ValType(TMPQRY->&cVariavel) == "D"
				//TMP->&cVariavel := STOD(TMPQRY->&cVariavel)
				aadd(aLinha,STOD(TMPQRY->&cVariavel))
			Else
				//TMP->&cVariavel := TMPQRY->&cVariavel
				aadd(aLinha,TMPQRY->&cVariavel)
			EndIf
		Next
	
		oFWMsExcel:AddRow("planilha 1","tabela 1",aLinha)
		TMPQRY->(dbSkip())
		nLidos++ 
	EndDo

	//Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
	
Return

Static Function fFechar()
	*************************************
	*** Gerar Query Executada
	********                 
	
	oDlg:End()
	
Return    
      

Static Function fMarca()
	*************************************
	*** Gerar Query Executada
	********                 
	Local nCont
	For nCont := 1 To Len(aWBrowse1)
		aWBrowse1[nCont,1] := .T.
	Next                        
	
	oWBrowse1:Refresh()
Return


Static Function fDesmarca()
	*************************************
	*** Gerar Query Executada
	********                 
	Local nCont
	For nCont := 1 To Len(aWBrowse1)
		aWBrowse1[nCont,1] := .F.
	Next                        
	
	oWBrowse1:Refresh()
Return
                         

Static Function fCloseArea(pCodTabe)
	*************************************
	*** Fecha area Selecionada
	********                 
	
	If (Select(pCodTabe)!= 0)
		dbSelectArea(pCodTabe)
		dbCloseArea()
		If File(pCodTabe+GetDBExtension())
			FErase(pCodTabe+GetDBExtension())
		EndIf
	EndIf
	
Return


Static Function fAbrirQry()
	*************************************
	*** Abrir Query ja gravada
	********                 
	
	cArqTxt := cGetFile("Arquivos Texto|*.*",OemToAnsi("Abrir Arquivo..."))
	
	nHdl    := FT_FUse(cArqTxt)
	
	If nHdl == -1
	     MsgAlert("O arquivo "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	     Return
	Endif
	
	cResult := ""
	Ft_Fgotop()
	While !FT_FEOF()
		cResult += Ft_Freadln()
		Ft_Fskip()
	EndDo
	Ft_Fuse()
	             
	cMultiGe1 := cResult  
Return


Static Function fSalvaQry()
	*************************************
	*** Salvar Query ja gravada
	********
	
	cFileOpen := cGetFile("Modelo Word | *.*","Salvar arquivo",,,.F.)
//	MemoWrite(cFileOpen,cMultiGe1)
	Aviso("Confirmação", "Select Salvo com Sucesso no Caminho,"+Space(10)+cFileOpen, {"Ok"})

Return

Static Function SQLEXE()

	Local lOk := .F.

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private cMGSQL    


	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oSay1","oMGSQL","oSBtn1","oSBtn2")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 140,292,634,987,"SQL Exeqtor",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 008,016,{||"Query"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oMGSQL     := TMultiGet():New( 016,016,{|u| If(PCount()>0,cMGSQL:=u,cMGSQL)},oDlg1,316,176,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	oSBtn1     := SButton():New( 204,260,1,{|| lOk := .T. , oDlg1:End() },oDlg1,,"", )
	oSBtn2     := SButton():New( 204,288,2,{|| lOk := .F. , oDlg1:End() },oDlg1,,"", )

	oDlg1:Activate(,,,.T.)

	if lOk
		nRet := TCSqlExec(cMGSQL)
		If nRet != 0
			Aviso("SQL Exeqtor",TcSqlError(),{"Ok"},3)
		EndIf 
	endif

Return

Static Function fExitSx2()

	Local cTabela
	Local cMemhis := ""

	dbSelectArea("SX2")
	SX2->(dbSetOrder(1))
	SX2->(dbGoTop())

	aParamBox := {}
	aRet := {}
	aAdd(aParamBox,{1,"Prefixo"	,Space(3),"@!","","","",100,.T.}) //mv_par01	
	
	if !ParamBox(aParamBox,"Analise de tabelas",@aRet,{|| (.T.)},{},,,,,"",.F.,.F.)
		Return
	endif
	
	mv_par01 := aRet[1]
	
	if empty(mv_par01)
		Return("Abortado!")
	endif

	//SX2->(dbSeek("HM0"))


	While !(SX2->(eof()))

		cTabela := Alltrim(SX2->X2_CHAVE)+mv_par01//RetSqlName(SX2->X2_CHAVE)
		//cTabela := RetSqlName(SX2->X2_CHAVE)
		cMemhis += SX2->X2_CHAVE + "|"
		cMemhis += SX2->X2_NOME + "|"

		if TcCanOpen(cTabela)
			cMemhis += cValToChar(MpSysExecScalar(" SELECT COUNT(*) QTD FROM "+cTabela,"QTD")) + "|"
		else
			cMemhis += "-1|"
		endif
		//if TcCanOpen()
		/*if MpSysExecScalar(" SELECT CASE WHEN object_id('"+cTabela+"') <= 1 THEN 0 ELSE 1 END QTD ","QTD") == 1
			cMemhis += cValToChar(MpSysExecScalar(" SELECT COUNT(*) QTD FROM "+cTabela,"QTD")) + "|"
		else
			cMemhis += "-1|"
		endif*/

		cMemhis += CRLF

		SX2->(dbSkip())

	EndDo

	U_INNPT2(cMemhis,/*cDir*/,"Analise de tabelas",/*lTela*/,.F.)

Return
