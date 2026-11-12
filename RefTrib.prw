#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE CRLF chr(13)+chr(10)
#DEFINE cTitulo "Facilitador Configurador Tributos"

User Function RefTrib

    Private cWsEmp
    Private cWsFil
    Private aTblBase := {"CIS","CIT","CIU","CIX","CIY","F20","F21","F22","F23","F24","F25","F26","CIO","SB1"}
    Private nCBFil
    Private aCBFil := {}
    
    MyOpenSM0()

    RPCClearEnv()
    RPCSetType(3)
    RPCSetEnv(cWsEmp,cWsFil,"","","EST",,aTblBase) 

    nCBFil := cWsEmp

    if Select("SM0") == 0 .or. Select("SB1") == 0
        MessageBox("Nao foi possivel abrir a tabela de empresas (SM0) ou a tabela de produtos (SB1).",ctitulo,0)
        RPCClearEnv()
        Return nil
    endif

    oDlg1      := MSDialog():New( 131,413,353,643,cTitulo,,,.F.,,,,,,.T.,,,.T. )
    oCBFil     := TComboBox():New( 016,036,{|u| If(PCount()>0,nCBFil:=u,nCBFil)},aCBFil,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBFil )
    oBtn1      := TButton():New( 032,036,"Extrato",oDlg1,{|| fExtrato() },037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 048,036,"Operacoes",oDlg1,{|| fOperacoes() },037,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 064,036,"Acesso",oDlg1,{|| fAcesso() },037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

Return

Static Function fExtrato()

    Local cExtrato := ""
    Local nY

    cWsEmp := nCBFil

    RPCSetEnv( cWsEmp , cWsFil )
	RPCSetEmpFil( cWsEmp , cWsFil )

    for nY := 1 to Len(aTblBase)

        cExtrato += aTblBase[nY]
        cExtrato += "|"

        DbSelectArea("SX2")
        SX2->(DbSetOrder(1))
        SX2->(DbSeek(aTblBase[nY]))
        
        cExtrato += SX2->X2_NOME
        cExtrato += "|"

        cExtrato += SX2->X2_MODO
        cExtrato += SX2->X2_MODOUN
        cExtrato += SX2->X2_MODOEMP
        cExtrato += "|"

        cExtrato += PADL(cValToChar(MpSysExecScalar(ChangeQuery("SELECT COUNT(*) QTD FROM " + RetSqlName(aTblBase[nY])),"QTD")),15)
        cExtrato += "|"

        cExtrato += CRLF

    next nY

    cExtrato += CRLF + CRLF
    cExtrato += RetSqlName("SA1") + ": "
    cExtrato += PADL(cValToChar(MpSysExecScalar(ChangeQuery("SELECT COUNT(*) QTD FROM " + RetSqlName("SA1")),"QTD")),15) +  CRLF
    cExtrato += RetSqlName("SA2") + ": "
    cExtrato += PADL(cValToChar(MpSysExecScalar(ChangeQuery("SELECT COUNT(*) QTD FROM " + RetSqlName("SA2")),"QTD")),15) +  CRLF
    cExtrato += RetSqlName("SF4") + ": "
    cExtrato += PADL(cValToChar(MpSysExecScalar(ChangeQuery("SELECT COUNT(*) QTD FROM " + RetSqlName("SF4")),"QTD")),15) +  CRLF

    fTela(cExtrato)

Return

Static Function fOperacoes()

    Local cRelatorio := ""
    Local cQuery
    Local aCampos := {}
    Local nY

	aadd(aCampos,{"FT_FILIAL  ","C"})
	aadd(aCampos,{"FT_ESTADO  ","C"})
	aadd(aCampos,{"FT_CFOP    ","C"})
	aadd(aCampos,{"FT_CODISS  ","C"})
	aadd(aCampos,{"FT_TIPO    ","C"})
	aadd(aCampos,{"FT_CFOEXT  ","C"})
	aadd(aCampos,{"FT_ESPECIE ","C"})
	aadd(aCampos,{"FT_TIPOMOV ","C"})
	aadd(aCampos,{"FT_FORMUL  ","C"})
	aadd(aCampos,{"FT_CNAE    ","C"})
	aadd(aCampos,{"FT_TRIBMUN ","C"})
	aadd(aCampos,{"FT_CTIPI   ","C"})
	aadd(aCampos,{"FT_POSIPI  ","C"})
    aadd(aCampos,{"B1_GRPTI   ","C"})
    aadd(aCampos,{"B1_GRTRIB  ","C"})
    aadd(aCampos,{"FT_ALIQICM ","N"})
	//aadd(aCampos,{"FT_ALQIMP1 ","N"})
	//aadd(aCampos,{"FT_ALQIMP2 ","N"})
	//aadd(aCampos,{"FT_ALQIMP3 ","N"})
	//aadd(aCampos,{"FT_ALQIMP4 ","N"})
	//aadd(aCampos,{"FT_ALQIMP5 ","N"})
	//aadd(aCampos,{"FT_ALQIMP6 ","N"})
	aadd(aCampos,{"FT_ALIQIPI ","N"})
	aadd(aCampos,{"FT_ALIQIRR ","N"})
	aadd(aCampos,{"FT_ALIQINS ","N"})
	aadd(aCampos,{"FT_ALIQPIS ","N"})
	aadd(aCampos,{"FT_ALIQCOF ","N"})
	//aadd(aCampos,{"FT_ALIQCSL ","N"})
	//aadd(aCampos,{"FT_ALIQPS3 ","N"})
	//aadd(aCampos,{"FT_ALIQCF3 ","N"})
	//aadd(aCampos,{"FT_ALIQTST ","N"})
	aadd(aCampos,{"FT_ALIQSOL ","N"})
	//aadd(aCampos,{"FT_ALQFECP ","N"})
	//aadd(aCampos,{"FT_ALQFET  ","N"})
	//aadd(aCampos,{"FT_ALQFAB  ","N"})
	//aadd(aCampos,{"FT_ALQFUM  ","N"})
	//aadd(aCampos,{"FT_ALSENAR ","N"})
	//aadd(aCampos,{"FT_ALFECRN ","N"})
	aadd(aCampos,{"FT_ARETPIS ","N"})
	aadd(aCampos,{"FT_ARETCOF ","N"})
	aadd(aCampos,{"FT_ARETCSL ","N"})
	//aadd(aCampos,{"FT_MALQCOF ","N"})
	//aadd(aCampos,{"FT_MALQPIS ","N"})
	//aadd(aCampos,{"FT_ALQCIDE ","N"})
	//aadd(aCampos,{"FT_ALQCPM  ","N"})
	//aadd(aCampos,{"FT_ALQFMD  ","N"})
	//aadd(aCampos,{"FT_ALQFMP  ","N"})
	//aadd(aCampos,{"FT_ALFECMT ","N"})
	//aadd(aCampos,{"FT_ALFECMG ","N"})
	//aadd(aCampos,{"FT_ALQFEEF ","N"})
	//aadd(aCampos,{"FT_ALIFASE ","N"})
	//aadd(aCampos,{"FT_ALIFUND ","N"})
	//aadd(aCampos,{"FT_ALIIMA  ","N"})
	//aadd(aCampos,{"FT_ALCP15  ","N"})
	//aadd(aCampos,{"FT_ALCP25  ","N"})
	//aadd(aCampos,{"FT_ALQNDES ","N"})
	//aadd(aCampos,{"FT_ALFCPST ","N"})
	//aadd(aCampos,{"FT_AFCPANT ","N"})
	//aadd(aCampos,{"FT_PFCANTS ","N"})
	//aadd(aCampos,{"FT_ALIQFUN ","N"})

    for nY := 1 To Len(aCampos)
        cRelatorio += Alltrim(RetTitle(aCampos[nY][1]))
        cRelatorio += ";"
    next nY

    cRelatorio += "Tipo vinculo;Grp.Clientes;Tipo do Cliente;Grp.Fornecedores;Tipo do Fornecedor;"
    cRelatorio += "QTD;FT_TOTAL"
    cRelatorio += CRLF

	if select("TMP") <> 0
		TMP->(dbCloseArea())
	endif 

	cQuery := " SELECT "
    for nY := 1 To Len(aCampos)
        cQuery += aCampos[nY][1] + ", "
    next nY
    
	cQuery += "         CASE "
	cQuery += "           WHEN ( (FT_TIPOMOV = 'S' AND FT_TIPO NOT IN ('B', 'D')) OR (FT_TIPOMOV = 'E' AND FT_TIPO IN ('B', 'D')) ) THEN 'CLIENTE' "
	cQuery += "           WHEN ( (FT_TIPOMOV = 'E' AND FT_TIPO NOT IN ('B', 'D')) OR (FT_TIPOMOV = 'S' AND FT_TIPO IN ('B', 'D')) ) THEN 'FORNECEDOR' "
	cQuery += "           ELSE 'OUTROS' "
	cQuery += "         END FT_TPVINC, 
    

    cQuery += "         A1_GRPTRIB, A1_TIPO, A2_GRPTRIB, A2_TIPO, "
	cQuery += "         COUNT(*) AS QTD , "
	cQuery += "         SUM(FT_TOTAL) AS FT_TOTAL "

	cQuery += " FROM " + RetSqlName("SFT") + " SFT "

    cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON FT_PRODUTO = B1_COD "
    cQuery += "        AND "+FWJoinFilial("SFT", "SB1", "SFT", "SB1", .T.,,.T.)

    cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON FT_CLIEFOR = A1_COD AND FT_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += "        AND "+FWJoinFilial("SFT", "SA1", "SFT", "SA1", .T.,,.T.)
    cQuery += "        AND ( (FT_TIPOMOV = 'S' AND FT_TIPO NOT IN ('B', 'D')) OR (FT_TIPOMOV = 'E' AND FT_TIPO IN ('B', 'D')) ) "

    cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 ON FT_CLIEFOR = A2_COD AND FT_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
    cQuery += "        AND "+FWJoinFilial("SFT", "SA2", "SFT", "SA2", .T.,,.T.)
    cQuery += "        AND ( (FT_TIPOMOV = 'E' AND FT_TIPO NOT IN ('B', 'D')) OR (FT_TIPOMOV = 'S' AND FT_TIPO IN ('B', 'D')) ) "

	cQuery += " WHERE FT_EMISSAO >= DATEADD(YEAR, -5, GETDATE()) "
	cQuery += "   AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += "   AND SFT.D_E_L_E_T_ = ' ' "
	cQuery += "   AND FT_OBSERV  <> 'NF CANCELADA' "

	cQuery += " GROUP BY "

    for nY := 1 To Len(aCampos)
        cQuery += aCampos[nY][1] + ", "
    next nY
    cQuery += " A1_GRPTRIB, A1_TIPO, A2_GRPTRIB, A2_TIPO "
	cQuery += " ORDER BY COUNT(*) "
    cQuery := ChangeQuery(cQuery)

    fTela(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TMP",.F.,.T.)

	DbSelectArea("TMP")
	TMP->(dbGoTop())
		
	WHILE (TMP->(!EOF()))
			
        for nY := 1 To Len(aCampos)
            if aCampos[nY][2] == "N"
                cRelatorio += fvToc(TMP->&(aCampos[nY][1]))
            else
                cRelatorio += TMP->&(aCampos[nY][1])
            endif
            cRelatorio += ";"
        next nY
        cRelatorio += TMP->FT_TPVINC + ";"
        cRelatorio += TMP->A1_GRPTRIB + ";"
        cRelatorio += TMP->A1_TIPO + ";"
        cRelatorio += TMP->A2_GRPTRIB + ";"
        cRelatorio += TMP->A2_TIPO + ";"
        cRelatorio += fvToc(TMP->QTD) + ";"
        cRelatorio += fvToc(TMP->FT_TOTAL)

        cRelatorio += CRLF

		TMP->(DbSkip())

	ENDDO  
				
	if select("TMP") <> 0
		TMP->(dbCloseArea())
	endif

    fTela(cRelatorio)

Return

Static Function fAcesso()

    Local nTamFil := FWSizeFilial()

    Private cNomFilCpo := ""
    Private cFilDest   := Space(nTamFil)
    Private cFilOrigem := Space(nTamFil)
    Private cMLog     
    Private cNomeTbl   := Space(1)
    Private cSay1      := Space(1)
    Private cSay3      := Space(1)
    Private cTabela    := Space(6)
    Private nACEmp    
    Private nACFilial 
    Private nACUnid

    SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oNomeTbl","oTabela","oMLog","oFilOrigem")
    SetPrvt("oACFilial","oACUnid","oACEmp","oFilDest","oBtn1")

    /*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±± Definicao do Dialog e todos os seus componentes.                        ±±
    Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
    oDlg1      := MSDialog():New( 144,396,569,925,cTitulo,,,.F.,,,,,,.T.,,,.T. )
    oSay1      := TSay():New( 008,004,{||"Tabela:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay2      := TSay():New( 028,004,{||"Filial Origem"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay3      := TSay():New( 048,004,{||"Ac. Filial"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay4      := TSay():New( 064,004,{||"Ac. Unidade"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay5      := TSay():New( 080,004,{||"Ac. Empresa"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay6      := TSay():New( 028,124,{||"Filial Destino"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oNomeTbl   := TSay():New( 008,124,{||cNomeTbl},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)

    oTabela    := TGet():New( 008,041,{|u| If(PCount()>0,cTabela:=u,cTabela)},oDlg1,060,008,'@!',{|| fValidTbl() },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTabela",,)
    oMLog      := TMultiGet():New( 120,008,{|u| If(PCount()>0,cMLog:=u,cMLog)},oDlg1,244,080,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
    oFilOrigem := TGet():New( 028,041,{|u| If(PCount()>0,cFilOrigem:=u,cFilOrigem)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFilOrigem",,)
    oFilDest   := TGet():New( 028,160,{|u| If(PCount()>0,cFilDest:=u,cFilDest)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFilDest",,)

    oACFilial  := TComboBox():New( 048,041,{|u| If(PCount()>0,nACFilial:=u,nACFilial)},{"C=Compartilhado","E=Exclusivo"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nACFilial )
    oACUnid    := TComboBox():New( 063,041,{|u| If(PCount()>0,nACUnid:=u,nACUnid)},{"C=Compartilhado","E=Exclusivo"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nACUnid )
    oACEmp     := TComboBox():New( 079,041,{|u| If(PCount()>0,nACEmp:=u,nACEmp)},{"C=Compartilhado","E=Exclusivo"},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nACEmp )

    oBtn1      := TButton():New( 100,212,"Processar",oDlg1,{|| Processa({|| fProcessa() }) },037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 100,172,"Limpar log",oDlg1,{|| cMLog := "" },037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

Return

Static Function fValidTbl()

    Local cAliTmp := Left(cTabela,3)

    if empty(cTabela)
        Return(.T.)
    endif

    DbSelectArea("SX2")
    SX2->(DbSetOrder(1))
    IF !SX2->(DbSeek(cAliTmp))
        MessageBox("Tabela nao encontrada!", cTitulo, 0)
        Return(.F.)
    ENDIF

    DbSelectArea(cAliTmp)
    (cAliTmp)->(DbSetOrder(1))

    cNomeTbl := Alltrim(SX2->X2_NOME)

    CfilOrigem := xFilial(cAliTmp)

    nACFilial := SX2->X2_MODO
    nACUnid   := SX2->X2_MODOUN
    nACEmp    := SX2->X2_MODOEMP

    cNomeTbl += " (" + SX2->X2_MODO + SX2->X2_MODOUN + SX2->X2_MODOEMP + ")"

Return(.T.)


Static Function MyOpenSM0()

	Local lOpen := .F.
	Local nLoop := 0

	If FindFunction( "OpenSM0" )
		For nLoop := 1 To 20
			OpenSM0()
			If Select("SM0") != 0 
				lOpen := .T.
				Exit
			EndIf
			Sleep( 500 )
		Next nLoop
	Else
		Final( "Nao foi possivel a abertura da tabela de empresas (OpenSM0).")
	EndIf
	
	If !lOpen
		Final( "Nao foi possivel a abertura da tabela de empresas (SM0).")
	EndIf
	
	SM0->(dbGoTop())

    cWsEmp := SM0->M0_CODIGO
	cWsFil := SM0->M0_CODFIL

    While !(SM0->(EOF()))
        if aScan(aCBFil,{|x| x == SM0->M0_CODIGO}) <= 0
            AAdd(aCBFil, SM0->M0_CODIGO)
        endif
        SM0->(DbSkip())
    EndDo

    SM0->(dbGoTop())

Return lOpen

Static Function fBackup()

    Local cQUpdate
    Local nRet
    Local cNomeTabela := ""

    cNomeTabela := RetSqlName(cTabela)
    cNomeTabela += "_BKP_"
    cNomeTabela += dToS(Date())
    cNomeTabela += "_"
    cNomeTabela += StrTran(Time(),":","")

    cMLog += "Backup da tabela " + cTabela + " com nome de " + cNomeTabela + CRLF

    cQUpdate := "SELECT * INTO " + cNomeTabela + " FROM " + cTabela

    cMLog += cQUpdate + CRLF

    nRet := TCSqlExec(cQUpdate)
    If nRet != 0
        UserException( TcSqlError() )
    EndIf

Return(.T.)


Static Function fDeletaOutraFilial()

    Local cQUpdate

    cMLog += "Limpando outras filiais diferentes da (" + cFilOrigem + ")" + CRLF

    cQUpdate := "DELETE FROM " + cTabela + " WHERE " + cNomFilCpo + " != '" + cFilOrigem + "' "

    cMLog += cQUpdate + CRLF

    nRet := TCSqlExec(cQUpdate)
    If nRet != 0
        UserException( TcSqlError() )
    EndIf

Return

Static Function fMudaFilial()

    Local cQUpdate

    cMLog += "Mudando filial de (" + cFilOrigem + ") para: (" + cFilDest + ")" + CRLF

    cQUpdate := "UPDATE " + cTabela + " SET " + cNomFilCpo + " = '" + cFilDest + "' WHERE " + cNomFilCpo + " = '" + cFilOrigem + "' AND D_E_L_E_T_ = ' ' "

    cMLog += cQUpdate + CRLF

    nRet := TCSqlExec(cQUpdate)
    If nRet != 0
        UserException( TcSqlError() )
    EndIf

Return

Static Function fMudaAcesso()

    Local cAliTmp := Left(cTabela,3)

    if empty(cTabela)
        Return(.T.)
    endif

    DbSelectArea("SX2")
    SX2->(DbSetOrder(1))
    IF !SX2->(DbSeek(cAliTmp))
        MessageBox("Tabela nao encontrada!", cTitulo, 0)
        Return(.F.)
    ENDIF

    RecLock("SX2",.F.)
        Replace X2_MODO     with nACFilial
        Replace X2_MODOUN   with nACUnid
        Replace X2_MODOEMP  with nACEmp
    MsUnLock('SR3')

Return(.T.)

Static Function fProcessa()

    Local cAliTmp := Left(cTabela,3)
    Local cGruEmp := Left(Right(cTabela,3),2)

    IF Empty(cTabela)// .OR. !fValidTbl() // .or. Empty(cFilOrigem) .or. Empty(cFilDest)
        MessageBox("Dados incompletos para processamento!", cTitulo, 0)
        Return
    ENDIF

    cMLog += "Processado..." + CRLF
    
    cNomFilCpo := Left(PrefixoCpo(cAliTmp) + "_FILIAL", 10)

    cMLog += "Grupo de empresas: " + cGruEmp + CRLF
    cMLog += "Campo de filial identificado: " + cNomFilCpo + CRLF

    cWsEmp := cGruEmp

    RPCSetEnv( cGruEmp , cWsFil )
	RPCSetEmpFil( cGruEmp , cWsFil )

    cMLog += "Iremos trabalhar na tabela: " + RetSqlName(cAliTmp) + CRLF + CRLF

    cMLog += "Acesso ORIGEM"
    cMLog += "Acesso de filial: " + SX2->X2_MODO + CRLF
    cMLog += "Acesso de Unidade: " + SX2->X2_MODOUN + CRLF
    cMLog += "Acesso de Empresa: " + SX2->X2_MODOEMP + CRLF

    cMLog += "Acesso DESTINO"
    cMLog += "Acesso de filial: " + nACFilial + CRLF
    cMLog += "Acesso de Unidade: " + nACUnid + CRLF
    cMLog += "Acesso de Empresa: " + nACEmp + CRLF + CRLF

    cMLog += "Filial origem: (" + cFilOrigem + ")" + CRLF
    cMLog += "Filial destino: (" + cFilDest + ")" + CRLF + CRLF

    fBackup()
    fDeletaOutraFilial()
    fMudaFilial()
    fMudaAcesso()

    cMLog += CRLF + "Finalizado" + CRLF + CRLF

    cMLog += CRLF + "-------------------------------------------" + CRLF + CRLF

Return

Static Function fTela(cTexto)

    oDlgTela      := MSDialog():New( 095,196,571,1323,cTitulo,,,.F.,,,,,,.T.,,,.T. )
    oMTexto    := TMultiGet():New( 004,008,{|u| If(PCount()>0,cTexto:=u,cTexto)},oDlgTela,544,232,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

    oDlgTela:Activate(,,,.T.)

Return

Static Function fvToc(nValor)

Return ( alltrim(Transform(nValor,"@E 99,999,999,999.99")) )
