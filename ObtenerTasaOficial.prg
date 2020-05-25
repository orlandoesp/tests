* Obtiene la tasa de cambio de la página del BVC, hasta que cambien la página :)
* Ej.
* Respuesta = GetDolarOficial()
* ? Respuesta.Dolar
* ? Respuesta.Euro
* if Respuesta.ErrorHTTP
*	   ? Respuesta.ErrorText
* endif
*************************
PROCEDURE GetDolarOficial
*************************
	LOCAL oHTTP,cRetVal
	LOCAL oRetVal AS Object 
	oResp = CREATEOBJECT("Empty")
	ADDPROPERTY(oResp,"Dolar",0)
	ADDPROPERTY(oResp,"Euro",0)
	ADDPROPERTY(oResp,"ErrorText","")
	ADDPROPERTY(oResp,"ErrorHTTP",.F.)
	IF TYPE("oApp") == "O"
		IF NOT ISNULL(oApp)
			oApp.WaitMode(.T.)
			oApp.PutMsg("Verificando tasa de cambio...")
		ENDIF
	ENDIF
	
	oHTTP = CreateObject("Microsoft.XMLHTTP")
	oHTTP.Open("GET", "http://www.bcv.org.ve", .F.)
	TRY 
		oHTTP.Send()
		DO CASE 
			CASE oHTTP.Status >= 200 .AND. oHTTP.Status <= 299
				cHTML = oHTTP.ResponseText
				
				* Dolar
				nPos = AT("Bs/USD",cHTML)
				cRetVal = SUBSTR(cHTML ,nPos + 87,11)
				cRetVal = ReplaceChar(cRetVal, ".", "")
				cRetVal = ReplaceChar(cRetVal, ",", ".")
				oResp.Dolar = VAL(cRetVal)
				
				* Euro
				nPos = AT("Bs/EUR",cHTML)
				cRetVal = SUBSTR(cHTML ,nPos + 87,10)
				cRetVal = ReplaceChar(cRetVal, ".", "")
				cRetVal = ReplaceChar(cRetVal, ",", ".")
				oResp.Euro = VAL(cRetVal)

			CASE oHTTP.Status = 500
				oResp.ErrorHTTP = .T.
				oResp.ErrorText = "Error: Error interno del servidor."

			CASE oHTTP.Status = 404
				oResp.ErrorHTTP = .T.
				oResp.ErrorText = "Error: Host no encontrado."

			OTHERWISE
				oResp.ErrorHTTP = .T.
				oResp.ErrorText = "Error: Error procesando HTTP.Request"

		ENDCASE 
		
	CATCH TO oError
		oResp.ErrorHTTP = .T.
		oResp.ErrorText = "Error: procesando consulta"
		
	ENDTRY 
	IF TYPE("oApp") == "O"
		IF NOT ISNULL(oApp)
			oApp.WaitMode(.F.)
			oApp.PutMsg("")
		ENDIF
	ENDIF

	RETURN oResp

ENDPROC


* Reemplaza todos los caracteres X en el string
* Ej. para quitar todos los . de un string:
* c = "1.2.3.4.5.6"
* ReplaceChar(c,".","")  =>  retorna "123456"

*************************************************************
FUNCTION ReplaceChar(tcString, tcCharSearched, tcReplacement)
*************************************************************
	IF tcCharSearched$tcString
		nOcurrences = OCCURS(tcCharSearched,tcString)
		FOR a = 1 TO nOcurrences
			tcString = STUFF(tcString,AT(tcCharSearched,tcString),1,tcReplacement)
		NEXT
	ENDIF
	RETURN tcString
ENDFUNC 