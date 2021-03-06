/*************************************************************************
* TITULO..: ELECCIONES DEL CONSEJO DIRECTIVO                             *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: MAR 02/2001 VIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   MAR 02/2001 VIE

OBJETIVOS:

2- Retorna los Maestros Habilitados

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Voto02(aP1)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci�n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C�digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C�digo de la Empresa
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A�o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A�o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *�Detalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *�Sitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci�n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci�n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci�n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci�n Cuatro
     *�Path de Integraci�n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men� principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen�
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen�
     *�Detalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *�Detalles Acad�micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci�n de teclas
       #INCLUDE "CAMPOS\ARC-VOT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroReg := 0                   // N�mero del Registro
       LOCAL nNroFil := 0                   // N�mero de la Fila
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTcn := ''               // C�digo del Candidato
       LOCAL cCodigoTpr := ''               // C�digo del Profesor
       LOCAL cNombreTpr := ''               // Nombre del Estudiante
       LOCAL cVotConTpr := ''               // Voto Escolar del Estudiante
       LOCAL cCodigoTel := ''               // C�digo de la Elecci�n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       FileCnd := fProCnd
       FileEle := fProEle

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCnd,'CND',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileEle,'ELE',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ELE->(RECCOUNT()) == 0
	    cError('NO EXISTEN ELECCCIONES GRABADAS')

       CASE CND->(RECCOUNT()) == 0
	    cError('NO EXISTEN CANDIDATOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DISE�O DE LA PANTALLA INICIAL
       IF ISCOLOR()
	   SetColor("W+/B,N/W,B")
	   CLEAR
       ENDIF
       DISPBOX(01,00,05,78,'�ͻ���Ⱥ')
       Centrar(cNomEmp,02)
       Centrar(cNomSis+' A�0:'+cAnoUsr,03)
       Centrar('ELECCION DEL CONSEJO DIRECTIVO',04)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
*>>>>FIN DISE�O DE LA PANTALLA INICIAL

*>>>>CAPTURA DE LOS VOTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := 07
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cCodigoTpr := SPACE(08)
	    SET COLOR TO I
	    DISPBOX(10,30,15,52,"�ͻ���Ⱥ")
	    SET COLOR TO
	    @ 11,37 SAY 'POR FAVOR'
	    @ 12,33 SAY 'INGRESE SU CODIGO'
	    @ 13,38 GET cCodigoTpr PICT '99999999';
				   VALID lCorrecion(@cCodigoTpr)
	    READ
	    cCodigoTpr := SUBS(cCodigoTpr,1,6)
	    DO CASE
	    CASE LASTKEY() == K_ESC
		 EXIT
	    CASE EMPTY(cCodigoTpr)
		 LOOP
	    ENDCASE
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA DEL CODIGO

**********LOCALIZACION DEL CODIGO
	    IF !lLocCodigo('cCodigoPro','PRO',cCodigoTpr)
	       cError('EL CODIGO: '+cCodigoTpr+' NO EXISTE')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********VALIDACION DEL VOTO
	    SELECT PRO
	    nNroReg := RECNO()
	    cNombreTpr := RTRIM(PRO->cNombrePro)+' '+;
			  RTRIM(PRO->cApelliPro)
	    IF !EMPTY(PRO->cVotConPro)
	       cError(cNombreTpr+' YA VOTO')
	       LOOP
	    ENDIF
	    cVotConTpr := ''
**********FIN VALIDACION DEL VOTO

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
	    IF PRO->lRetiroPro
	       cError(cNombreTpr+' ESTA RETIRADO(A)')
	       LOOP
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

**********VALIDACION DEL COLOR
	    IF ISCOLOR()
	       SetColor("W+/B,N/W,B")
	    ENDIF
**********FIN VALIDACION DEL COLOR

**********VALIDACION DEL NOMBRE
	    cError('USTED ES '+cNombreTpr)
	    IF !lPregunta('DESEA VOTAR? Si No')
	       LOOP
	    ENDIF
	    DISPBOX(06,00,22,78,'�ͻ���Ⱥ')
	    @ 07,01 SAY 'POR FAVOR '+cNombreTpr+' INGRESE SU VOTO'
**********FIN VALIDACION DEL NOMBRE

**********LECTURA Y VALIDACION DEL VOTO
	    SELECT ELE
	    nNroFil := 09
	    GO TOP
	    DO WHILE .NOT. ELE->(EOF())

*--------------LECTURA DEL VOTO
		 cCodigoTcn := cSpaces('CND','cCodigoCnd')
		 cCodigoTel := ELE->cCodigoEle

		 @ nNroFil,01 SAY 'VOTO PARA '+ELE->cNombreEle;
			      GET cCodigoTcn PICT "999";
			      VALID cCodigoTcn # SPACE(03)
		 READ
		 cVotConTpr += cCodigoTcn
*--------------FIN LECTURA DEL VOTO

*--------------LOCALIZACION DEL CANDIDATO
		 SELECT CND
		 LOCATE FOR CND->cCodigoCnd == cCodigoTcn .AND.;
			    CND->cCodigoEle == ELE->cCodigoEle

		 IF .NOT. FOUND()
		    cError('NO EXISTE CANDIDATO PARA '+;
			   ALLTRIM(ELE->cNombreEle)+' CON EL VOTO No. '+;
			   cCodigoTcn)
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DEL CANDIDATO

*--------------ACUMULACION DEL VOTO
		 SELECT CND
		 IF CND->(lRegLock(lShared,.F.))
		    REPL CND->nTotVotEle WITH ++CND->nTotVotEle
		    CND->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
		 IF lShared
		    CND->(DBUNLOCK())
		 ENDIF
*--------------FIN ACUMULACION DEL VOTO

*--------------CONTROL DEL VOTO
		 SELECT PRO
		 GO nNroReg
		 IF PRO->(lRegLock(lShared,.F.))
		    REPL PRO->cVotConPro WITH cVotConTpr
		    PRO->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
		 IF lShared
		    PRO->(DBUNLOCK())
		 ENDIF
*--------------FIN CONTROL DEL VOTO

	       nNroFil++
	       SELECT ELE
	       ELE->(DBSKIP())

	    ENDDO
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN LECTURA Y VALIDACION DEL VOTO

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN CAPTURA DE LOS VOTOS