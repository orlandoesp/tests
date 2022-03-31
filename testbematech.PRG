* OE Changed on 03/26/22
* NOTES: Test de impresión fiscal para bematech
CLEAR 

* Funciones de Inicialización
lDebugMode = .F.
lIGTF = .T.

DECLARE INTEGER Bematech_FI_ResetaImpresora IN BemaFI32.DLL  

* Funciones de Cupon Fiscal
DECLARE INTEGER Bematech_FI_AbreCupon IN BemaFI32.DLL STRING @RIF
DECLARE INTEGER Bematech_FI_AbreComprobanteDeVentaEx IN BemaFI32.DLL STRING RIF, STRING NOMBRE, STRING DIRECCION  
DECLARE INTEGER Bematech_FI_VendeArticulo IN BemaFI32.DLL STRING, STRING, STRING, STRING, STRING , short, STRING, STRING ,STRING  
DECLARE INTEGER Bematech_FI_VendeArticuloDepartamento IN BemaFI32.DLL STRING, STRING, STRING, STRING, STRING, STRING, STRING, STRING, STRING 
DECLARE INTEGER Bematech_FI_AbreNotaDeCredito IN BemaFI32.DLL STRING Nombre, STRING NumeroSerie, STRING RIF, STRING Dia, STRING Mes, STRING Ano, STRING Hora, STRING Minuto, STRING Segundo, STRING COO 
DECLARE INTEGER Bematech_FI_DevolucionArticulo IN BemaFI32.DLL STRING Codigo, STRING Descripcion, STRING Alicuota, STRING TipoCantidad, STRING Cantidad, INTEGER CasasDecimales, STRING Valor, STRING TipoDescuento, STRING Descuento
DECLARE INTEGER Bematech_FI_AnulaArticuloAnterior IN BemaFI32.DLL  
DECLARE INTEGER Bematech_FI_AnulaArticuloGenerico IN BemaFI32.DLL STRING  
DECLARE INTEGER Bematech_FI_IniciaCierreCupon IN BemaFI32.DLL STRING , STRING ,STRING
DECLARE INTEGER Bematech_FI_EfectuaFormaPago IN BemaFI32.DLL STRING ,STRING  
DECLARE INTEGER Bematech_FI_EfectuaFormaPagoDescripcionForma IN BemaFI32.DLL STRING, STRING , STRING  
DECLARE INTEGER Bematech_FI_FinalizarCierreCupon IN BemaFI32.DLL STRING
DECLARE INTEGER Bematech_FI_CierraCupon IN BemaFI32.DLL STRING , STRING, STRING, STRING, STRING  
DECLARE INTEGER Bematech_FI_CierraCuponReducido IN BemaFI32.DLL STRING, STRING  
DECLARE INTEGER Bematech_FI_IniciaCierreCuponIGTF IN BemaFI32.DLL STRING
DECLARE INTEGER Bematech_FI_AnulaCupon IN BemaFI32.DLL  
DECLARE INTEGER Bematech_FI_ExtenderDescripcionArticulo IN BemaFI32.DLL STRING  
DECLARE INTEGER Bematech_FI_UsaUnidadMedida IN BemaFI32.DLL STRING  
DECLARE INTEGER Bematech_FI_RectficaFormasPago IN BemaFI32.DLL STRING, STRING, STRING  

DECLARE INTEGER Bematech_FI_VerificaEstadoImpresora IN BemaFI32.DLL INTEGER @n_ack, INTEGER @n_st1, INTEGER @n_st2   
DECLARE INTEGER Bematech_FI_RetornoAlicuotas IN BemaFI32.DLL STRING @ alicuotas   
DECLARE INTEGER Bematech_FI_NumeroComprobanteFiscal IN BemaFI32.DLL STRING @ c_numcomp
DECLARE INTEGER Bematech_FI_DatosUltimaReduccion IN BemaFI32.DLL STRING @ c_datosreduccion   

DECLARE INTEGER Bematech_FI_NumeroSerie IN BemaFI32.DLL STRING @ c_nserie   
DECLARE INTEGER Bematech_FI_NumeroCupon IN BemaFI32.DLL STRING @ nf   
DECLARE INTEGER Bematech_FI_NumeroCuponesAnulados IN BemaFI32.DLL STRING @ c_cuponsanulados   
DECLARE INTEGER Bematech_FI_NumeroReducciones IN BemaFI32.DLL STRING @ c_reducciones   
DECLARE INTEGER Bematech_FI_UltimoArticuloVendido IN BemaFI32.DLL STRING @ c_ultimoarticulo   
DECLARE INTEGER Bematech_FI_SimboloMoneda IN BemaFI32.DLL STRING @ c_simbolomoneda   
DECLARE INTEGER Bematech_FI_FechaHoraImpresora IN BemaFI32.DLL STRING @ c_fecha, STRING @ c_hora   
DECLARE INTEGER Bematech_FI_ContadorNotaDeCreditoMFD IN BemaFI32.DLL STRING @c_numero

* Funciones de Gaveta de Dinero 
DECLARE INTEGER Bematech_FI_VerificaImpresoraPrendida IN BemaFI32.DLL  
DECLARE INTEGER Bematech_FI_RetornoImpresora IN BemaFI32.DLL INTEGER @n_ack, INTEGER @n_st1, INTEGER @n_st2   
DECLARE INTEGER Bematech_FI_VersionDll IN BemaFI32.DLL STRING @ Version   
	

Bematech_FI_AnulaCupon()

iRetorno = Bematech_FI_AbreComprobanteDeVentaEx("V0000000","CONSUMIDOR FINAL","CARACAS")
AnalizaRetorno(iRetorno,[Bematech_FI_AbreComprobanteDeVentaEx("V0000000","CONSUMIDOR FINAL","CARACAS")])

* Producto Exento
iRetorno = Bematech_FI_VendeArticulo("1","AGUA MINERAL","II","I","1",2,"10,00","%","0000")
* Producto con IVA
* iRetorno = Bematech_FI_VendeArticulo("1","AGUA MINERAL","1600","I","1",2,"10,00","%","0000")

AnalizaRetorno(iRetorno,[Bematech_FI_VendeArticulo("1","AGUA MINERAL","II","I","1",2,"10,00","%","0000")])

* IGTF
IF lIGTF
	iRetorno = Bematech_FI_IniciaCierreCuponIGTF("10,00")
	* Opcional
	iRetorno = Bematech_FI_EfectuaFormaPago(SUBSTR("Debito",1,16),TRANSFORM(0.70,"999999999.99"))
	**********
	iRetorno = Bematech_FI_FinalizarCierreCupon("Vuelva Pronto...")
ELSE 
	iRetorno = Bematech_FI_IniciaCierreCupon("D", "%", "0000")
	iRetorno = Bematech_FI_EfectuaFormaPago("Efectivo","10,00")
	iRetorno = Bematech_FI_FinalizarCierreCupon("Vuelva Pronto...")
ENDIF

RETURN
***************************************************
* Destroy
CLEAR DLLS Bematech_FI_CambiaSimboloMoneda 
CLEAR DLLS Bematech_FI_ProgramaAliquota
*!*	CLEAR DLLS Bematech_FI_ProgramaHorarioVerao
*!*	CLEAR DLLS Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms
*!*	CLEAR DLLS Bematech_FI_ProgramaArredondamento
CLEAR DLLS Bematech_FI_ProgramaRedondeo
*!*	CLEAR DLLS Bematech_FI_ProgramaTruncamento
*!*	CLEAR DLLS Bematech_FI_NomeiaDepartamento
*!*	CLEAR DLLS Bematech_FI_LinhasEntreCupons
*!*	CLEAR DLLS Bematech_FI_EspacoEntreLinhas
*!*	CLEAR DLLS Bematech_FI_ForcaImpactoAgulhas
CLEAR DLLS Bematech_FI_ResetaImpresora

* Funciones de Cupon Fiscal
CLEAR DLLS Bematech_FI_AbreCupon
CLEAR DLLS Bematech_FI_AbreComprobanteDeVentaEx
CLEAR DLLS Bematech_FI_VendeArticulo
CLEAR DLLS Bematech_FI_VendeArticuloDepartamento 
CLEAR DLLS Bematech_FI_AnulaArticuloAnterior
CLEAR DLLS Bematech_FI_AnulaArticuloGenerico
CLEAR DLLS Bematech_FI_IniciaCierreCupon
CLEAR DLLS Bematech_FI_EfectuaFormaPago
CLEAR DLLS Bematech_FI_EfectuaFormaPagoDescripcionForma
CLEAR DLLS Bematech_FI_FinalizarCierreCupon
CLEAR DLLS Bematech_FI_CierraCupon
CLEAR DLLS Bematech_FI_CierraCuponReducido
CLEAR DLLS Bematech_FI_IniciaCierreCuponIGTF
CLEAR DLLS Bematech_FI_AnulaCupon
CLEAR DLLS Bematech_FI_ExtenderDescripcionArticulo
CLEAR DLLS Bematech_FI_UsaUnidadMedida
CLEAR DLLS Bematech_FI_RectficaFormasPago

* Funciones de Reportes Fiscales 

CLEAR DLLS Bematech_FI_ReduccionZ
CLEAR DLLS Bematech_FI_LecturaX
CLEAR DLLS Bematech_FI_LecturaXSerial
CLEAR DLLS Bematech_FI_LecturaMemoriaFiscalFecha
CLEAR DLLS Bematech_FI_LecturaMemoriaFiscalReduccion
CLEAR DLLS Bematech_FI_LecturaMemoriaFiscalSerialFecha
CLEAR DLLS Bematech_FI_LecturaMemoriaFiscalSerialReduccion

* Funciones de Operaciones NO Fiscales 

CLEAR DLLS Bematech_FI_InformeGerencial
*!*	CLEAR DLLS Bematech_FI_InformeGerencialTEF
CLEAR DLLS Bematech_FI_CierraInformeGerencial
*!*	CLEAR DLLS Bematech_FI_RecebimentoNoFiscal
*!*	CLEAR DLLS Bematech_FI_AbreComprobanteNoFiscalVinculado
*!*	CLEAR DLLS Bematech_FI_UsaComprobanteNoFiscalVinculado
*!*	CLEAR DLLS Bematech_FI_UsaComprobanteNboFiscalVinculadoTEF
*!*	CLEAR DLLS Bematech_FI_CierraComprobanteNoFiscalVinculado
*!*	CLEAR DLLS Bematech_FI_Sangria
*!*	CLEAR DLLS Bematech_FI_Provision

* Funciones de Información de la Impresora 

CLEAR DLLS Bematech_FI_VerificaEstadoImpresora
CLEAR DLLS Bematech_FI_RetornoAlicuotas
CLEAR DLLS Bematech_FI_NumeroComprobanteFiscal
*!*	CLEAR DLLS Bematech_FI_VerificaTotalizadoresParciales
*!*	CLEAR DLLS Bematech_FI_SubTotal
CLEAR DLLS Bematech_FI_DatosUltimaReduccion
*!*	CLEAR DLLS Bematech_FI_MonitoramentoPapel
*!*	CLEAR DLLS Bematech_FI_MinutosPrendida
*!*	CLEAR DLLS Bematech_FI_MinutosImprimiendo
CLEAR DLLS Bematech_FI_NumeroSerie
CLEAR DLLS Bematech_FI_NumeroCupon
*!*	CLEAR DLLS Bematech_FI_NumeroOperacionesNoFiscales
*!*	CLEAR DLLS Bematech_FI_NumeroCuponesAnulados
CLEAR DLLS Bematech_FI_NumeroReducciones
*!*	CLEAR DLLS Bematech_FI_NumeroIntervenciones
*!*	CLEAR DLLS Bematech_FI_NumeroSustituicionesPropietario
*!*	CLEAR DLLS Bematech_FI_NumeroCaja
*!*	CLEAR DLLS Bematech_FI_NumeroTinda
*!*	CLEAR DLLS Bematech_FI_VersionFirmware
*!*	CLEAR DLLS Bematech_FI_CGC_IE
*!*	CLEAR DLLS Bematech_FI_GranTotal
*!*	CLEAR DLLS Bematech_FI_Descuentos
*!*	CLEAR DLLS Bematech_FI_Cancelamientos
CLEAR DLLS Bematech_FI_UltimoArticuloVendido
*!*	CLEAR DLLS Bematech_FI_ClichePropietario
CLEAR DLLS Bematech_FI_SimboloMoneda
*!*	CLEAR DLLS Bematech_FI_FlagsFiscales
*!*	CLEAR DLLS Bematech_FI_VerificaModoOperacion
*!*	CLEAR DLLS Bematech_FI_VerificaEpromConectada
*!*	CLEAR DLLS Bematech_FI_ValorPagoUltimoCupon
DECLARE INTEGER Bematech_FI_FechaHoraImpresora IN BemaFI32.DLL STRING @ c_fecha, STRING @ c_hora   
*!*	CLEAR DLLS Bematech_FI_ContadoresTotalizadoresNoFiscales
*!*	CLEAR DLLS Bematech_FI_VerificaTotalizadoresNoFiscales
CLEAR DLLS Bematech_FI_FechaHoraReduccion
CLEAR DLLS Bematech_FI_FechaMovimiento
*!*	CLEAR DLLS Bematech_FI_VerificaTruncamiento
*!*	CLEAR DLLS Bematech_FI_VerificaAlicuotasIss
*!*	CLEAR DLLS Bematech_FI_Agregado
*!*	CLEAR DLLS Bematech_FI_ContadorBilletePasaje
*!*	CLEAR DLLS Bematech_FI_VerificaFormasPago
*!*	CLEAR DLLS Bematech_FI_VerificaRecebimientoNoFiscal
*!*	CLEAR DLLS Bematech_FI_VerificaDepartamentos
*!*	CLEAR DLLS Bematech_FI_VerificaTipoImpresora
*!*	CLEAR DLLS Bematech_FI_VerificaIndiceAlicuotasIss
*!*	CLEAR DLLS Bematech_FI_ValorFormaPago
*!*	CLEAR DLLS Bematech_FI_ValorTotalizadorNoFiscal
CLEAR DLLS Bematech_FI_ContadorNotaDeCreditoMFD

* Funciones de Gaveta de Dinero 

CLEAR DLLS Bematech_FI_AccionaGaveta
CLEAR DLLS Bematech_FI_VerificaEstadoGaveta

* Otras Funciones

*!*	CLEAR DLLS Bematech_FI_AbrePuertaSerial
*!*	CLEAR DLLS Bematech_FI_CierraPuertaSerial
CLEAR DLLS Bematech_FI_VerificaImpresoraPrendida
CLEAR DLLS Bematech_FI_RetornoImpresora
*!*	CLEAR DLLS Bematech_FI_AperturaDelDia
*!*	CLEAR DLLS Bematech_FI_CierreDelDia
*!*	CLEAR DLLS Bematech_FI_ImprimeDepartamentos
CLEAR DLLS Bematech_FI_ImprimeConfiguracionesImpresora
CLEAR DLLS Bematech_FI_VersionDll
*!*	CLEAR DLLS Bematech_FI_LeerArchivoRetorno


PROCEDURE AnalizaRetorno
	LPARAMETERS tnRetorno,tcCommand
	LOCAL lcRetVal AS String
	lcRetVal = ""

	IF  tnRetorno = 1 .Or. tnRetorno = -27
	    iACK = 0
	  	iST1 = 0
	  	iST2 = 0
	  	tnRetorno = Bematech_FI_RetornoImpresora( @iACK, @iST1, @iST2 )
	    IF iACK = 21 
			lcRetVal = "La impresora ha retornado NAK"
	    ELSE
			IF ( iST1 <> 0 ) .OR. ( iST2 <> 0 )
	       		&& Analiza ST1
	            IF ( iST1 >= 128 ) 
	                iST1 = iST1 - 128
	                lcRetVal = lcRetVal + "Fin de Papel" + CHR(13)
	                
	            ENDIF
	            IF ( iST1 >= 64 )
	               	iST1 = iST1 - 64
	               	lcRetVal  = lcRetVal + "Poco Papel" + CHR(13)
	               	
	            ENDIF
	            IF ( iST1 >= 32 ) 
	               	iST1 = iST1 - 32
	               	lcRetVal = lcRetVal + "Error en el Reloj" + chr(13)
	            ENDIF
	 		    IF ( iST1 >= 16 ) 
					iST1 = iST1 - 16
					lcRetVal = lcRetVal + 'Impresora con Error' + chr(13)
				ENDIF
				IF ( iST1 >= 8 ) 
					iST1 =  iST1 - 8 
					lcRetVal =  lcRetVal + "Primer dato del comando no fue ESC" + chr(13) 
				ENDIF
			    IF iST1 >= 4 
					iST1 =  iST1 - 4 
					lcRetVal = lcRetVal + "Comando Inexistente" + chr(13) 
				ENDIF
	 		    IF iST1 >= 2  
	                iST1 =  iST1 - 2 
	                lcRetVal =  lcRetVal + "Cupón Fiscal abierto" + chr(13)
	            ENDIF    
	            IF iST1 >= 1  
	                iST1 =  iST1 - 1 
	                lcRetVal = lcRetVal + "Número de parámetros inválidos" + chr(13) 
	            ENDIF

	            && Analiza ST2

	            IF iST2 >= 128  
	                iST2 =  iST2 - 128 
	                lcRetVal =  lcRetVal + "Tipo de parámetro de comando inválido" + chr(13) 
	            ENDIF
	            IF iST2 >= 64  
	                iST2 =  iST2 - 64 
	                lcRetVal =  lcRetVal + "Memoria fiscal llena" + chr(13) 
	                
	            ENDIF
	            IF iST2 >= 32  
	                iST2 =  iST2 - 32 
	                lcRetVal =  lcRetVal + "Error en la CMOS" + chr(13) 
	                
	            ENDIF
	            IF iST2 >= 16
	                iST2 =  iST2 - 16 
	                lcRetVal = lcRetVal + "Alicuota no programada" + chr(13) 
	                
	            ENDIF
	            IF iST2 >= 8  
	                iST2 =  iST2 - 8 
	                lcRetVal = lcRetVal + "Capacidad de Alicuota Programable llena" + chr(13) 
	            ENDIF
	            IF iST2 >= 4  
	                iST2 =  iST2 - 4 
	                lcRetVal = lcRetVal + "Cancelamiento no permitido" + chr(13) 
	            ENDIF
	            IF iST2 >= 2  
	                iST2 =  iST2 - 2 
	                lcRetVal = lcRetVal + "RIF del propietario no Programado" + chr(13) 
	            ENDIF
	            IF iST2 >= 1  
	                iST2 =  iST2 - 1 
	                lcRetVal = lcRetVal + "Comando no ejecutado" + chr(13) 
	            ENDIF
	       ENDIF
	   ENDIF
	ELSE 
		DO CASE
	        CASE tnRetorno = 0
				lcRetVal = "Error de Comunicación"
				oApp.Alert("Error de Comunicación con la Impresora.")
				
	        CASE tnRetorno = -2
				lcRetVal = "Parámetro Inválido"

	        CASE tnRetorno = -3
				lcRetVal = "Alicuota no programada"
				
	        CASE tnRetorno = -18
				lcRetVal = "No fue posible abrir el archivo INTPOS.001"
				
	        CASE tnRetorno = -19
				lcRetVal = "Parámetros diferentes"
				
	        CASE tnRetorno = -20
				lcRetVal = "Transacción cancelada por el Operador"
				
	        CASE tnRetorno = -21
				lcRetVal = "La transacción no fue aprobada"
	             
	        CASE tnRetorno = -22
				lcRetVal = "No fue posible finalizar la impresión"
				
	        CASE tnRetorno = -23
				lcRetVal = "No fue posible finalizar la operación"
				
	    ENDCASE

	ENDIF
	cLastError = lcRetVal

	IF .NOT. EMPTY(lcRetVal)
		? MLINE(lcRetVal,1) + MLINE(lcRetVal,2) + MLINE(lcRetVal,3)
		? tcCommand
	ENDIF

	IF lDebugMode 
		cFile = ADDBS(Application.DefaultFilePath) + "logs\bemafiscal.log"
		STRTOFILE(tcCommand +" | " + cLastError,cFile,1)
		
	ENDIF
	RETURN lcRetVal &&+ " - " + tcCommand
ENDPROC