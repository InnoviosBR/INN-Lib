#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH"
#INCLUDE "INNLIB.CH"

Function distanciaPontosGPS(np1LA, np1LO, np2LA, np2LO) 
	
	Local nRaio := 6371
	   
	np1LA := np1LA * PI / 180
	np1LO := np1LO * PI / 180
	np2LA := np2LA * PI / 180
	np2LO := np2LO * PI / 180
	   
	ndLat := np2LA - np1LA
	ndLong := np2LO - np1LO
	   
	nA := sin(ndLat / 2) * sin(ndLat / 2) + cos(np1LA) * cos(np2LA) * sin(ndLong / 2) * sin(ndLong / 2)
	nC := 2 * Atn2(SQRT(nA), SQRT(1 - nA))
	   
Return round(nRaio * nC * 1000,0) // resultado em metros.

Function RetNumSem(dData)

	Local dAno
	Local nDIA
	Local nRet
	
	dAno := CTOD([01/01/]+SUBS(DTOC(dData),7))
	nDIA := DOW(dAno)
	
	nRet := INT(((dData-dANO+nDIA-1)/7)+1)  // a Subtração acima causa erro em todos dias 01 dos meses em  
												   // que o 1° dia do ano inicia no sabado.

Return(nRet)

Function zVal2Hora(nValor, cSepar)

Return StrTran(Transform(nValor, "@E 999999.99"), ',', cSepar)

Function B1Cust(cB1Cod)

	Local nVal := 0
	
	Local aAreaSB2 := SB2->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	if SB1->(dbSeek(xFilial("SB1")+cB1Cod))
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		if SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))	
			nVal := SB2->B2_CM1
		endif
	endif
	
	SB2->(RestArea(aAreaSB2))	
	SB1->(RestArea(aAreaSB1))

Return(nVal)

Function fGetEmp()
	
	Local aAreaEmp := {}
	
	aAdd(aAreaEmp, SM0->(Recno()))
	aAdd(aAreaEmp, cFilAnt)
	aAdd(aAreaEmp, cNumEmp)
	
Return aAreaEmp

Function fRestEmp(aAreaEmp)

	Local aArea := GetArea()
	
	SM0->(dbGoTo(aAreaEmp[1]))
	cFilAnt := aAreaEmp[2]
	cNumEmp := aAreaEmp[3]
	
	RestArea(aArea)

Return

Function fGoEmp(cCodEmp, cCodFil)
	
	Local aArea := GetArea()
	
	cFilAnt := cCodFil
	If !SM0->(dbSeek(cCodEmp+cFilAnt))
	     Final("Problema função U_fGoEmp(). Empresa: " + cCodEmp + " Filial: " + cCodFil)
	EndIf
	cNumEmp := SM0->M0_Codigo+SM0->M0_CodFil
	
	RestArea(aArea)

Return

Function ListPilha()
	
	Local n := 1
	Local cLista := ""
	 
	Do While !Empty( ProcName( n ) )
		cLista += iif(!Empty(cLista),"/","")
		cLista += AllTrim( ProcName( n++ ) ) 
	EndDo
	 
Return( cLista )

Function QtdComp(nQtdOrig)

	Local nDecimais  := 3
	Local nQtdDest   := Round(0,nDecimais)
	Local cQtdDest   := ""
	
	If nQtdOrig # Nil .And. ValType(nQtdOrig) == 'N'
		nQtdDest := Round(nQtdOrig, nDecimais)
		cQtdDest := Str(nQtdDest,30,nDecimais)
		nQtdDest := Val(cQtdDest)
	EndIf
               
Return nQtdDest

Function aUnique(aArray,nCol)

	Local aAux := aClone(aArray)
	Local nY := 0
	
	aArray := {}	
		
	for nY := 1 To Len(aAux)
		if aScan(aArray,{|x| x[nCol] == aAux[nY][nCol] }) == 0
			aadd(aArray,aClone(aAux[nY]))
		endif
	next 
	
Return(aArray)

Function UGrpIn(cUsuario,cGrupo)  
	
	Local aDados := nil
	Local lRet    := .F.		
	Local nY

	if Empty(cUsuario) .or. Empty(cGrupo)
		Return(.F.)
	endif

	if MpdicInDb()

		aDados := UsrRetGrp(,cUsuario)

		for nY := 1 To Len(aDados)
		
			if aDados[nY] $ cGrupo .or. aDados[nY] == "000000"
				lRet := .T.
			endif
			
		Next

	else

		PswOrder(1)//1 - ID do usuário/grupo
		if !PswSeek(cUsuario, .T. )
			Return(.F.)
		endif
		
		aDados := PSWRET()
		for nY := 1 To Len(aDados[1][10])
		
			if aDados[1][10][nY] $ cGrupo .or. aDados[1][10][nY] == "000000"
				lRet := .T.
			endif
			
		Next

	endif



	
Return(lRet)

Function ValTime(cTime)
	
	if ValType(cTime) != "C"
		Return(.F.)
	endif

	if Len(cTime) <= 5
		cTime += ":00"
	endif
	
	if val(substr(cTime,1,2)) > 23
		Return(.F.)
	endif
	
	if val(substr(cTime,1,2)) < 0
		Return(.F.)
	endif
	
	if val(substr(cTime,3,2)) > 59
		Return(.F.)
	endif
	
	if val(substr(cTime,3,2)) < 0
		Return(.F.)
	endif
	
	if val(substr(cTime,6,2)) > 59
		Return(.F.)
	endif
	
	if val(substr(cTime,6,2)) < 0
		Return(.F.)
	endif
	
Return(.T.)

Function implode(aArray,cSeparador)  
	
	Local nY   := 0
	Local cRet := ""
	
	for nY := 1 To Len(aArray)		
		if ValType(aArray[nY]) == "C"
			cRet += aArray[nY] + cSeparador
		endif
	next
	
Return(cRet)

Function dToSQL(dData)
	dData := dToS(dData)
	dData := SubStr(dData,1,4) + "-" + SubStr(dData,5,2) + "-" + SubStr(dData,7,2)
Return(dData)

Function fVOpcBox(cIndex,cOpcoes,cCampo)

	Local aReturn := {}
	Local nLinha := 0
	Local aTemp
	Local aSaveArea		 := getArea()
	Local aSaveSX3		 := SX3->(getArea())

	if empty(cIndex)
		Return("")
	endif
		
	if empty(cOpcoes)
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		if SX3->(dbSeek(SUBSTR(cCampo+SPACE(10),1,10)))
		
			if SubStr(X3CBox(),1,1) == "#"
				cOpcoes := &(SubStr(X3CBox(),2))
			else
				cOpcoes := X3CBox()	
			endif
			
		endif	
	endif
	
	if empty(cOpcoes)
		Return("")
	endif

	aReturn := STRTOKARR(cOpcoes,";")
		
	for nLinha := 1 to len(aReturn)
	
		aReturn[nLinha] := ALLTRIM(aReturn[nLinha])
		
	NEXT
		
	for nLinha := 1 to len(aReturn)
		
		aTemp := StrTokArr(aReturn[nLinha],"=")
		
		if len(aTemp) == 1
			aTemp := {aTemp,aTemp}
		endif
	
		IF alltrim(aTemp[1]) == alltrim(cIndex)
			Return(" - " + aTemp[2])
		ENDIF
		
	NEXT
	
	SX3->(RestArea(aSaveSX3))
	RestArea(aSaveArea)
	
Return("")

Function FMEXCEL(nNumero)

	if valtype(nNumero) != "N"
		if valtype(nNumero) == "C"
			nNumero := val(nNumero)
		else
			nNumero := 0   
		endif
	endif
	cNumero := cValToChar(Round(nNumero,2))
	aNumero := StrTokArr(cNumero,".")
	aNumero[1] := Numtrac(aNumero[1])
	if len(aNumero) < 2
		cSoNum := aNumero[1]+",0"
	else 
		aNumero[2] := Numtrac(aNumero[2])
		cSoNum := aNumero[1]+","+aNumero[2]
	endif
		
Return(cSoNum)

Function FMHORA(cReb1)

	nMinuto := 0
	cString := ""
	nHora   := 0
	
	if valtype(cReb1) != "N"
		cReb1 := val(cReb1)
	endif
	nMinuto := cReb1
	
	while nMinuto >= 60
		nHora += 1
		nMinuto -= 60
	enddo
	
	if nHora > 9
		cString := cValToChar(nHora)	
	else
		cString := strzero(nHora,2)	
	endif
		
	cString += ":" + strzero(nMinuto,2)

Return(cString)

Function FMCGC(cPalavra)

	c1part := ""
	c2part := ""
	c3part := ""
	c4part := ""
	c5part := ""

	IF EMPTY(cPalavra)
		Return(cPalavra)
	ENDIF

	if valtype(cPalavra) != "C"
		cPalavra := cvaltochar(cPalavra)
	endif

	cPalavra := ALLTRIM(NUMTRAC(cPalavra))

	IF LEN(cPalavra) == 11

		c1part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-10,3)+space(3),3)
		c2part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-7,3)+space(3),3)
		c3part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-4,3)+space(3),3)
		c4part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-1,2)+space(2),2)

		cPalavra := c1part+"."+c2part+"."+c3part+"-"+c4part

	ELSEIF LEN(cPalavra) == 14

		c1part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-13,2)+space(2),2)
		c2part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-11,3)+space(3),3)
		c3part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-8,3)+space(3),3)
		c4part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-5,4)+space(4),4)
		c5part := LEFT(SUBSTR(cPalavra,LEN(cPalavra)-1,2)+space(2),2)

		cPalavra := c1part+"."+c2part+"."+c3part+"/"+c4part+"-"+c5part

	ENDIF

Return(cPalavra)

Function FmCEP(cPalavra)

	if valtype(cPalavra) != "C"
		cPalavra := cvaltochar(cPalavra)
	endif

	cPalavra := ALLTRIM(Numtrac(cPalavra))
	
	c1part := STRZERO(val(substr(cPalavra,1,2)),2)
	c2part := STRZERO(val(substr(cPalavra,3,3)),3)
	c3part := STRZERO(val(substr(cPalavra,6,3)),3)
	
	cPalavra := c1part+"."+c2part+"-"+c3part

Return(cPalavra)

Function FmTel(cPalavra)

	if valtype(cPalavra) != "C"
		cPalavra := cvaltochar(cPalavra)
	endif

	cPalavra := ALLTRIM(Numtrac(cPalavra))
	
	cddd   := Space(2)
	c1part := left(substr(cPalavra,len(cPalavra)-7,4)+space(4),4)
	c2part := left(substr(cPalavra,len(cPalavra)-3,4)+space(4),4)
	
	IF len(cPalavra) > 8
		cddd := substr(cPalavra,1,2)
	endif
	
	cPalavra := "("+cddd+") "+c1part+"-"+c2part
	
Return(cPalavra)

Function Alftrac(cPalavra)

	Local nx
	Local cAlfabeto
	
	cPalavra := Rtrac(cPalavra)
	cSoNum := ''
	cAlfabeto := "0123456789"
	cAlfabeto += "abcdefghijklmnopqrstuvwxyz"
	cAlfabeto += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	cAlfabeto += space(1)
	cAlfabeto += ",.:-"

	for nx := 1 to len(trim(cPalavra))
		if substr(cPalavra,nx,1) $ cAlfabeto
	    	cSoNum += substr(cPalavra,nx,1)
		endif
	Next

Return(cSoNum) 

Function AtNum(cPalavra)
	Local nx
	cPosNum := 0
	for nx := 1 to LEN(ALLTRIM(cPalavra))
		if substr(cPalavra,nx,1) $ "123456789"
	    	cPosNum := nx
	    	exit
		endif
	Next
Return(cPosNum)

Function Numtrac(cPalavra)
	Local nx
	Local cSoNum := ''
	for nx := 1 to LEN(ALLTRIM(cPalavra))
		if substr(cPalavra,nx,1) $ "1234567890"
	    	cSoNum += substr(cPalavra,nx,1)
		endif
	Next
Return(cSoNum)

Function Rtrac(cPalavra)

	Local nTam := Len(cPalavra)
	Local nx
	
	for nx := 1 to len(trim(cPalavra))
		Do Case
			Case substr(cPalavra,nx,1) $ "ç"
				cPalavra := substr(cPalavra,1,nx-1)+"c"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "áàâã"                                               
				cPalavra := substr(cPalavra,1,nx-1)+"a"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "óòôõ"
				cPalavra := substr(cPalavra,1,nx-1)+"o"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "éèê"
				cPalavra := substr(cPalavra,1,nx-1)+"e"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "íìî"
				cPalavra := substr(cPalavra,1,nx-1)+"i"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "úùû"
				cPalavra := substr(cPalavra,1,nx-1)+"u"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "Ç"
				cPalavra := substr(cPalavra,1,nx-1)+"C"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "ÁÀÂÃ"                                               
				cPalavra := substr(cPalavra,1,nx-1)+"A"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "ÓÒÔÕ"
				cPalavra := substr(cPalavra,1,nx-1)+"O"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "ÉÈÊ"
				cPalavra := substr(cPalavra,1,nx-1)+"E"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "ÍÌÎ"
				cPalavra := substr(cPalavra,1,nx-1)+"I"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case substr(cPalavra,nx,1) $ "ÚÙÛ"
				cPalavra := substr(cPalavra,1,nx-1)+"U"+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case ASC(substr(cPalavra,nx,1)) == 39
				cPalavra := substr(cPalavra,1,nx-1)+substr(cPalavra,nx+1,len(cPalavra)-nx)
			Case ASC(substr(cPalavra,nx,1)) == 34
				cPalavra := substr(cPalavra,1,nx-1)+substr(cPalavra,nx+1,len(cPalavra)-nx)
		endcase
	Next
	
	cPalavra := SubStr(cPalavra,1,nTam)
	
Return(cPalavra)

Function fGetCol(cCampo,aHeader)

	Local nCol := Ascan(aHeader,{|aAux| ALLTRIM(UPPER(aAux[2])) == ALLTRIM(UPPER(cCampo)) })

Return(nCol)

Function fGetField(cCampo,nLinha,aHeader,aCols)

	Local nCol := Ascan(aHeader,{|aAux| ALLTRIM(UPPER(aAux[2])) == ALLTRIM(UPPER(cCampo)) })

	if nCol > 0
		if nLinha <= len(aCols)
			if ValType(aCols[nLinha][nCol]) == aHeader[nCol][8]
				Return(aCols[nLinha][nCol])
			endif
		endif
	endif

Return(nil)

Function fPutField(cCampo,xValor,nLinha,aHeader,aCols)	

	Local nCol := Ascan(aHeader,{|aAux| ALLTRIM(UPPER(aAux[2])) == ALLTRIM(UPPER(cCampo)) })
	
	if nCol > 0
		if nLinha <= len(aCols)
			if ValType(aCols[nLinha][nCol]) == aHeader[nCol][8]
				aCols[nLinha][nCol] := xValor
			endif
		endif
	endif
	
Return(nil)

Function fAddLine(aHeader,aCols)

	Local aLinha := {}
	Local nY := 1
	Local xDado

	Local aSX3 := SX3->(GetArea())

	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))

	for nY := 1 To Len(aHeader)

		if SX3->(dbSeek(aHeader[nY][2]))
			xDado := CriaVar(aHeader[nY][2])
		else
			if aHeader[nY][8] == "D"    
				xDado := ctod("  /  /  ")
			elseif aHeader[nY][8] == "N"
				xDado := 0
			elseif aHeader[nY][8] == "L"
				xDado := .F.
			else
				xDado := Space(aHeader[nY][4])
			endif
		endif

		aadd(aLinha,xDado)

	next nY
	aadd(aLinha,.F.)
	
	aadd(aCols,aLinha)

	SX3->(RestArea(aSX3))
	
Return(.T.)

Function fGetRam(nTamanho)

	Local aOpcoes	:= {}
	Local nOpcoes	:= 0
	Local cRet		:= ""
	Local nY		:= 0
	
	aadd(aOpcoes,"A")
	aadd(aOpcoes,"B")
	aadd(aOpcoes,"C")
	aadd(aOpcoes,"D")
	aadd(aOpcoes,"E")
	aadd(aOpcoes,"F")
	aadd(aOpcoes,"G")
	aadd(aOpcoes,"H")
	//aadd(aOpcoes,"I")
	aadd(aOpcoes,"J")
	aadd(aOpcoes,"K")
	//aadd(aOpcoes,"L")
	aadd(aOpcoes,"M")
	aadd(aOpcoes,"N")
	//aadd(aOpcoes,"O")
	aadd(aOpcoes,"P")
	aadd(aOpcoes,"Q")
	aadd(aOpcoes,"R")
	aadd(aOpcoes,"S")
	aadd(aOpcoes,"T")
	aadd(aOpcoes,"U")
	aadd(aOpcoes,"V")
	aadd(aOpcoes,"W")
	aadd(aOpcoes,"X")
	aadd(aOpcoes,"Y")
	aadd(aOpcoes,"Z") 
	/*
	aadd(aOpcoes,"a")
	aadd(aOpcoes,"b")
	aadd(aOpcoes,"c")
	aadd(aOpcoes,"d")
	aadd(aOpcoes,"e")
	aadd(aOpcoes,"f")
	aadd(aOpcoes,"g")
	aadd(aOpcoes,"h")
	aadd(aOpcoes,"i")
	aadd(aOpcoes,"j")
	aadd(aOpcoes,"k")
	aadd(aOpcoes,"l")
	aadd(aOpcoes,"m")
	aadd(aOpcoes,"n")
	aadd(aOpcoes,"o")
	aadd(aOpcoes,"p")
	aadd(aOpcoes,"q")
	aadd(aOpcoes,"r")
	aadd(aOpcoes,"s")
	aadd(aOpcoes,"t")
	aadd(aOpcoes,"u")
	aadd(aOpcoes,"v")
	aadd(aOpcoes,"w")
	aadd(aOpcoes,"x")
	aadd(aOpcoes,"y")
	aadd(aOpcoes,"z")
	*/ 

	//aadd(aOpcoes,"0")
	aadd(aOpcoes,"1")
	aadd(aOpcoes,"2")
	aadd(aOpcoes,"3")
	aadd(aOpcoes,"4")
	aadd(aOpcoes,"5")
	aadd(aOpcoes,"6")
	aadd(aOpcoes,"7")
	aadd(aOpcoes,"8")
	aadd(aOpcoes,"9")
	
	nOpcoes := Len(aOpcoes)+1
	for nY := 1 To nTamanho
		cRet += aOpcoes[Randomize(1,nOpcoes)]
	next
	
Return(cRet)

Function fGetRamNum(nTamanho)


	Local aOpcoes := {}
	Local cRet    := ""
	Local nY := 0
	
	aadd(aOpcoes,"0")
	aadd(aOpcoes,"1")
	aadd(aOpcoes,"2")
	aadd(aOpcoes,"3")
	aadd(aOpcoes,"4")
	aadd(aOpcoes,"5")
	aadd(aOpcoes,"6")
	aadd(aOpcoes,"7")
	aadd(aOpcoes,"8")
	aadd(aOpcoes,"9")
	
	for nY := 1 To nTamanho
		cRet += aOpcoes[Randomize(1,Len(aOpcoes)+1)]
	next
	
Return(cRet)

User Function ConvTmpStp(nTimeStamp)

	Local nTemp  := 0
	Local nNumDias := 0
	Local nResto := 0
	Local nRefSeg := 86400 //=24Hrs * 60Min * 60Seg (SEGUNDOS TOTAIS EM UM DIA)
	Local dDtRef := STOD("19700101")
	Local cHora  := ""

	nTimeStamp := nTimeStamp - ( 3 * 60 * 60 ) //America/Sao Paulo (GMT-03:00)
	nTemp  := nTimeStamp / nRefSeg
	nNumDias := Int(nTemp)
	nResto  := ((nTemp - Int(nTemp)) * 24)

	cHora  := u_CentHr(nResto)
	dDtRef  := dDtRef + nNumDias

Return(DTOC(dDtRef) + " - " + cHora)

User Function CentHr(nHora)

	_nHora := nHora   //Hora em Cenesimal
	_nMin := (_nHora - Int(_nHora))
	_nMin := _nMin * 60

	If(Int(_nHora) == 0)
		_nHora := StrZero(Int(_nHora), 2)
	Else
		_nHora := cValToChar(Int(_nHora))
	EndIf

	_cHora := PadL(AllTrim(_nHora + ":" + StrZero(_nMin, 2)),5,'0')

Return(_cHora)

User Function ConvTpHr(nDifTimeStamp)

	Local nHoras    := 0
	Local nMinutos  := 0
	//Local nSegundos := 0
	Local cRetorno  := ""

	While nDifTimeStamp > 3600
		nHoras += 1
		nDifTimeStamp -= 3600
	EndDo

	While nDifTimeStamp > 60
		nMinutos += 1
		nDifTimeStamp -= 60
	EndDo

	if nHoras > 0
		cRetorno += CValToChar(nHoras) + "(h) "
	endif

	if nMinutos > 0
		cRetorno += CValToChar(nMinutos) + "(m) "
	endif

	if nDifTimeStamp > 0 .or. (nHoras==0 .and. nMinutos==0)
		cRetorno += CValToChar(nDifTimeStamp) + "(s) "
	endif

	cRetorno := AllTrim(cRetorno)

Return(cRetorno)

Function INNGetSX5(cTable,cKey)

	Local cRet := ""
	Local xRetFun := {}
	
	if !Empty(cKey) .and. !Empty(cTable)
		
		xRetFun := FWGetSX5(cTable,cKey)

		If len(xRetFun) > 0
			If len(xRetFun[1]) > 0
				If len(xRetFun[1][4]) > 0
					cRet := " - " + xRetFun[1][4]
				EndIf
			EndIf
		EndIf

	endif

Return(cRet)

Function Ret2Title(cCampo)

	Local cAlias	 := Alias()
	Local nSx3Order  := SX3->(IndexOrd())
	Local nTamanho   := 26
	Local cTitulo	 := Space(nTamanho)

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	If ( SX3->(MSSeek(cCampo)) )
		cTitulo := SX3->X3_DESCRIC + Space(nTamanho)
	EndIf

	cTitulo := Substr(cTitulo,1,nTamanho)

	SX3->(DbSetOrder(nSX3Order))
	if !Empty(cAlias)
		DbSelectArea(cAlias)
	endif

	cTitulo := OemToAnsi(cTitulo)

Return cTitulo
