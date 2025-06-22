#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH" 
#include "Fileio.ch"
#INCLUDE "INNLIB.CH"

User Function INNPT2(conteudo,cDir,cTitulo,lTela,lShow) 
  
	//Local cLinha := ""
	Local aObjects
	Local aSizeAut
	Local aInfo
	Local aPosObj
	Local oMemo1
	Local oDl001
	Local cont       

	Private oDlgcf
	Private tmpA := {}

	Default cDir 	:= ""
	Default cTitulo := "Mensagem"
	Default lTela 	:= .T.
	Default lShow	:= .T.
 
    //itens   
    if Valtype(conteudo) <> "A"
    	aadd(tmpA, ImpPart(conteudo,lShow))
    else
    	LerArray(conteudo, "",lShow)
    endif
    
	TextoArray := ''
	for cont := 1 to len(tmpA)
		TextoArray += tmpA[cont] + chr(13)+chr(10)
	next
	
	if !Empty(cDir)

		MemoWrite(cDir,TextoArray)

	elseif lTela
		
		aObjects 	:= {}
		aSizeAut	:= MsAdvSize(.T.) // retorna o tamanho da tela
		aInfo 		:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 5, 5 }
		AAdd( aObjects, { 100, 100, .T., .T. ,.T.} )	
		aPosObj := MsObjSize( aInfo, aObjects )
		
		oDl001 := MSDialog():New(aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5],cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		
			oDl001:bInit := {|| EnchoiceBar(oDl001,{||oDl001:End()},{||oDl001:End()})}//V12
			oMemo1     := TMultiGet():New( aPosObj[1,1],aPosObj[1,2],{|u| If(PCount()>0,TextoArray:=u,TextoArray)},oDl001,aPosObj[1,3],aPosObj[1,4],,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
					
		oDl001:Activate()

	endif
   	
Return(TextoArray)

Static function LerArray(conteudo, repassar, lShow) 
	local cLinha
	local cont
	//APMSGALERT(CVALTOCHAR(LEN(conteudo)) + " - "+ repassar )
	for cont := 1 to len(conteudo)
		clinha := ''     
		if !empty(repassar)
			clinha += repassar
		endif
		if  Valtype(conteudo[cont]) <> "A"
			clinha +=  "[" +cvaltochar(cont) + "] "+;
					ImpPart(conteudo[cont],lShow)
			aadd(tmpA, clinha)
		else
			LerArray(conteudo[cont], repassar + "[" +cvaltochar(cont) + "]",lShow)
		endif
	next
return

Static Function ImpPart(inCont,lShow)

	inContT := Valtype(inCont) 

	Do Case
		Case inContT == "N"
			Return iif(lShow,Valtype(inCont) + ", " + TRANSFORM(LEN(CValtochar(inCont)),"@e 999.999") + " -> ","") + CValtochar(inCont)
			
		Case inContT == "D"
			Return iif(lShow,Valtype(inCont) + ", " + TRANSFORM(LEN(DTOC(inCont)),"@e 999.999") + " -> ","") + DTOC(inCont)
			
		Case inContT == "C" .AND. LEN(inCont) < 250
			Return iif(lShow,Valtype(inCont) + ", " + TRANSFORM(LEN(inCont),"@e 999.999") + " -> ","") + inCont

		Case inContT == "C" .AND. LEN(inCont) >= 250
			Return iif(lShow,"M, " + Alltrim(cValToChar(LEN(inCont))) + " -> ","") + inCont

		Case inContT == "U"
			Return "UNDEFINED"
			
		Case inContT == "L"
			IF inCont
				Return ".T."
			ELSE
				Return ".F."
			ENDIF
			
		otherwise
			APMSGALERT("DESPREPARADO PARA TRATAR O TIPO: "+inContT)
			
	EndCase

Return
