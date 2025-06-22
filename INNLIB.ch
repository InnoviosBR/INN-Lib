#IFNDEF _INNLIB_CH

	#DEFINE _INNLIB_CH

	#xtranslate CriadbINN() => U_CriadbINN()
	#xtranslate RetNumSem(<dData>) => U_RetNumSem(<dData>)
	#xtranslate zVal2Hora(<nValor>, <cSepar>) => U_zVal2Hora(<nValor>, <cSepar>)
	#xtranslate B1Cust(<cB1Cod>) => U_B1Cust(<cB1Cod>)
	#xtranslate fGetEmp() => U_fGetEmp()	
	#xtranslate fRestEmp(<aAreaEmp>) => U_fRestEmp(<aAreaEmp>)
	#xtranslate fGoEmp(<cCodEmp>,<cCodFil>) => U_fGoEmp(<cCodEmp>,<cCodFil>)
	#xtranslate ListPilha() => U_ListPilha()
	#xtranslate QtdComp(<nQtdOrig>) => U_QtdComp(<nQtdOrig>)
	#xtranslate aUnique(<aArray>,<nCol>) => U_aUnique(<aArray>,<nCol>)
	#xtranslate UGrpIn(<cUsuario>,<cGrupo>) => U_UGrpIn(<cUsuario>,<cGrupo>)
	#xtranslate ValTime(<cTime>) => U_ValTime(<cTime>)	
	#xtranslate implode(<aArray>,<cSeparador>) => U_implode(<aArray>,<cSeparador>)
	#xtranslate dToSQL(<dData>) => U_dToSQL(<dData>)
	#xtranslate fVOpcBox(<cIndex>,<cOpcoes>,<cCampo>) => U_fVOpcBox(<cIndex>,<cOpcoes>,<cCampo>)
	#xtranslate MsgFull(<cMsg>) => U_MsgFull(<cMsg>)
	#xtranslate FMEXCEL(<nNumero>) => U_FMEXCEL(<nNumero>)
	#xtranslate FMHORA(<cReb1>) => U_FMHORA(<cReb1>)
	#xtranslate FMCGC(<cPalavra>) => U_FMCGC(<cPalavra>)
	#xtranslate FmCEP(<cPalavra>) => U_FmCEP(<cPalavra>)
	#xtranslate FmTel(<cPalavra>) => U_FmTel(<cPalavra>)
	#xtranslate Alftrac(<cPalavra>) => U_Alftrac(<cPalavra>)
	#xtranslate AtNum(<cPalavra>) => U_AtNum(<cPalavra>)
	#xtranslate Numtrac(<cPalavra>) => U_Numtrac(<cPalavra>)
	#xtranslate Rtrac(<cPalavra>) => U_Rtrac(<cPalavra>)
	#xtranslate fGetCol(<cCampo>,<aHeader>) => U_fGetCol(<cCampo>,<aHeader>)
	#xtranslate fGetField(<cCampo>,<nLinha>,<aHeader>,<aCols>) => U_fGetField(<cCampo>,<nLinha>,<aHeader>,<aCols>)
	#xtranslate fPutField(<cCampo>,<xValor>,<nLinha>,<aHeader>,<aCols>) => U_fPutField(<cCampo>,<xValor>,<nLinha>,<aHeader>,<aCols>)
	#xtranslate fAddLine(<aHeader>,<aCols>) => U_fAddLine(<aHeader>,<aCols>)
	#xtranslate fGetRam(<nTamanho>) => U_fGetRam(<nTamanho>)
	#xtranslate fGetRamNum(<nTamanho>) => U_fGetRamNum(<nTamanho>)
	#xtranslate distanciaPontosGPS(<np1LA>, <np1LO>, <np2LA>, <np2LO>) => U_distanciaPontosGPS(<np1LA>, <np1LO>, <np2LA>, <np2LO>)
	#xtranslate INNGetSX5(<cTable>,<cKey>) => U_INNGetSX5(<cTable>,<cKey>)
	#xtranslate Ret2Title(<cCampo>) => U_Ret2Title(<cCampo>)
	
	// ASCII Characteres
	
	#DEFINE CHR_BS    chr(8)
	#DEFINE CHR_HT    chr(9)
	#DEFINE CHR_LF    chr(10)
	#DEFINE CHR_VT    chr(11)
	#DEFINE CHR_FF    chr(12)
	#DEFINE CHR_CR    chr(13)
	#DEFINE CRLF      chr(13)+chr(10)
	#DEFINE TAB 	  Chr(09)
	
	#DEFINE PICMONEY  "@E 99,999,999,999.999999"
	#DEFINE PICQUANT  "@E 99,999,999,999.999"
	
	
	#DEFINE PI 3.1415926535898

	#IFNDEF __HARBOUR__
		#Include "Protheus.ch"
	#ELSE
		#xcommand DEFAULT <uVar1> := <uVal1> ;
			[, <uVarN> := <uValN> ] => ;
			<uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
			[ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]
		#xcommand BEGIN SEQUENCE =>
		#xcommand END SEQUENCE =>
		#xtranslate CVALTOCHAR(<nNum>) => AllTrim(str(<nNum>))
	#ENDIF

#ENDIF