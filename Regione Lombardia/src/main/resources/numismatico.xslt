<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 <xsl:param name="datestamp"><xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>T00:00:00Z</xsl:param>
 
 <xsl:template match="row">
  <xsl:variable name="TSKK" select="cell[@name='TSK']"/>
  
  <record>
   <header>
    <xsl:element name="identifier">
     <xsl:value-of select="cell[@name='IDK'][1]"/>
    </xsl:element>
    <datestamp><xsl:value-of select="$datestamp"/></datestamp>
   </header>
   <metadata>
    <schede>
    
     <xsl:element name="{$TSKK}">
      <xsl:attribute name="version">3.00</xsl:attribute>
      
      <!-- CD: CODICI -->
      <xsl:element name="CD">
       <xsl:attribute name="hint">CODICI</xsl:attribute>
       <xsl:element name="TSK">
        <xsl:attribute name="hint">Tipo scheda</xsl:attribute>
        <xsl:value-of select="$TSKK"/>
       </xsl:element>
       
       <xsl:element name="NCT">
        <xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
        <xsl:element name="NCTR">
         <xsl:attribute name="hint">Codice regione</xsl:attribute>
         <xsl:if test="string-length(cell[@name='NCTR'][1])=1">0</xsl:if>
         <xsl:value-of select="cell[@name='NCTR'][1]"/>
        </xsl:element>
        <xsl:if test="cell[@name='NCTN'] and normalize-space(cell[@name='NCTN'][1]) != ''">
         <xsl:element name="NCTN">
          <xsl:attribute name="hint">Numero catalogo generale</xsl:attribute>
          <xsl:value-of select="cell[@name='NCTN'][1]"/>
         </xsl:element>
        </xsl:if>
       </xsl:element>
       
       <xsl:if test="cell[@name='ESC'] and normalize-space(cell[@name='ESC'][1]) != ''">
        <xsl:element name="ESC">
         <xsl:attribute name="hint">Ente schedatore</xsl:attribute>
         <xsl:value-of select="cell[@name='ESC'][1]"/>
        </xsl:element>
       </xsl:if>
      </xsl:element>
   
      <!-- AC: ALTRI CODICI -->
      <xsl:element name="AC">
       <xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
       <xsl:element name="ACC">
        <xsl:attribute name="hint">Altro codice bene</xsl:attribute>
        <xsl:value-of select="cell[@name='IDK'][1]"/> /R03</xsl:element>
      </xsl:element>

      <!-- OG: OGGETTO -->
      <xsl:element name="OG">
       <xsl:attribute name="hint">OGGETTO</xsl:attribute>
       <xsl:element name="OGT">
        <xsl:attribute name="hint">OGGETTO</xsl:attribute>
        <xsl:element name="OGTD">
         <xsl:attribute name="hint">Definizione</xsl:attribute>
         <xsl:value-of select="cell[@name='OGTD'][1]"/>
        </xsl:element>
        <xsl:if test="cell[@name='OGTT'] and normalize-space(cell[@name='OGTT'][1]) != ''">
         <xsl:element name="OGTT">
          <xsl:attribute name="hint">Classificazione tipologica</xsl:attribute>
          <xsl:value-of select="cell[@name='OGTT'][1]"/>
         </xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='OGTH'] and normalize-space(cell[@name='OGTH'][1]) != ''">
         <xsl:element name="OGTH">
          <xsl:attribute name="hint">Classificazione funzionale</xsl:attribute>
          <xsl:value-of select="cell[@name='OGTH'][1]"/>
         </xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='OGTL'] and normalize-space(cell[@name='OGTL'][1]) != ''">
         <xsl:element name="OGTL">
          <xsl:attribute name="hint">Legenda tipo</xsl:attribute>
          <xsl:value-of select="cell[@name='OGTL'][1]"/>
         </xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='OGTO'] and normalize-space(cell[@name='OGTO'][1]) != ''">
         <xsl:element name="OGTO">
          <xsl:attribute name="hint">Nominale</xsl:attribute>
          <xsl:value-of select="cell[@name='OGTO'][1]"/>
         </xsl:element>
        </xsl:if>
<!--		<xsl:for-each select="cell[@name='OGTS']">
         <xsl:element name="OGTS">
          <xsl:attribute name="hint">Specifiche</xsl:attribute>
          <xsl:value-of select="."/>
         </xsl:element>
        </xsl:for-each>-->
		<xsl:if test="cell[@name='OGTS'] and normalize-space(cell[@name='OGTS'][1]) != ''">
         <xsl:element name="OGTS">
          <xsl:attribute name="hint">Specifiche</xsl:attribute>
		  <xsl:value-of select="replace(cell[@name='OGTS'][1],'\|\|','; ')"/>
         </xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='OGTR'] and normalize-space(cell[@name='OGTR'][1]) != ''">
         <xsl:element name="OGTR">
          <xsl:attribute name="hint">Serie</xsl:attribute>
          <xsl:value-of select="cell[@name='OGTR'][1]"/>
         </xsl:element>
        </xsl:if>
       </xsl:element>
      </xsl:element>
   
      <!-- LC: LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA -->
      <xsl:element name="LC">
       <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
       <xsl:element name="PVC">
        <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
        <xsl:element name="PVCS">
         <xsl:attribute name="hint">Stato</xsl:attribute><xsl:value-of select="cell[@name='PVCS'][1]"/></xsl:element>
        <xsl:element name="PVCR">
         <xsl:attribute name="hint">Regione</xsl:attribute><xsl:value-of select="cell[@name='PVCR'][1]"/></xsl:element>
        <xsl:element name="PVCP">
         <xsl:attribute name="hint">Provincia</xsl:attribute><xsl:value-of select="cell[@name='PVCP'][1]"/></xsl:element>
        <xsl:element name="PVCC">
         <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="cell[@name='PVCC'][1]"/></xsl:element>
       </xsl:element>
       
       <xsl:element name="LDC">
        <xsl:attribute name="hint">COLLOCAZIONE SPECIFICA</xsl:attribute>
        <xsl:if test="cell[@name='LDCT'] and normalize-space(cell[@name='LDCT'][1]) != ''">
         <xsl:element name="LDCT">
          <xsl:attribute name="hint">Tipologia</xsl:attribute><xsl:value-of select="cell[@name='LDCT'][1]"/></xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='LDCN'] and normalize-space(cell[@name='LDCN'][1]) != ''">
         <xsl:element name="LDCN">
          <xsl:attribute name="hint">Denominazione</xsl:attribute><xsl:value-of select="cell[@name='LDCN'][1]"/></xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='LDCU'] and normalize-space(cell[@name='LDCU'][1]) != ''">
         <xsl:element name="LDCU">
          <xsl:attribute name="hint">Denominazione spazio viabilistico</xsl:attribute><xsl:value-of select="cell[@name='LDCU'][1]"/></xsl:element>
        </xsl:if>
        <xsl:if test="(cell[@name='LDCM'] and normalize-space(cell[@name='LDCM'][1]) != '') or (cell[@name='LDCI'] and normalize-space(cell[@name='LDCI'][1]) != '')">
         <xsl:element name="LDCM">
          <xsl:attribute name="hint">Denominazione raccolta</xsl:attribute>
          <xsl:value-of select="cell[@name='LDCM'][1]"/>
          <xsl:if test="cell[@name='LDCI'] and normalize-space(cell[@name='LDCI'][1]) != ''">. <xsl:value-of select="cell[@name='LDCI'][1]"/></xsl:if>
         </xsl:element>
        </xsl:if>
       </xsl:element>
	  </xsl:element>
   
      <!-- DT: CRONOLOGIA -->
      <xsl:if test="cell[@name='DTZG']|cell[@name='DTZS']|cell[@name='DTSI']|cell[@name='DTSV']|cell[@name='DTSF']|cell[@name='DTSL']">
       <xsl:variable name="dtzgCells" select="cell[@name='DTZG']"/>
       <xsl:variable name="dtzsCells" select="cell[@name='DTZS']"/>
       <xsl:variable name="dtsiCells" select="cell[@name='DTSI']"/>
       <xsl:variable name="dtsvCells" select="cell[@name='DTSV']"/>
       <xsl:variable name="dtsfCells" select="cell[@name='DTSF']"/>
       <xsl:variable name="dtslCells" select="cell[@name='DTSL']"/>
      
        <xsl:element name="DT">
         <xsl:attribute name="hint">CRONOLOGIA</xsl:attribute>
         
         <xsl:if test="$dtzgCells|$dtzsCells">
          <xsl:element name="DTZ">
           <xsl:attribute name="hint">CRONOLOGIA GENERICA</xsl:attribute>
           <xsl:if test="$dtzgCells">
            <xsl:element name="DTZG">
             <xsl:attribute name="hint">Fascia cronologica di riferimento</xsl:attribute>
             <xsl:value-of select="replace($dtzgCells,'\|\|','; ')"/>
            </xsl:element>
           </xsl:if>
           <xsl:if test="$dtzsCells">
            <xsl:element name="DTZS">
             <xsl:attribute name="hint">Frazione cronologica</xsl:attribute>
             <xsl:value-of select="replace($dtzsCells,'\|\|','; ')"/>
            </xsl:element>
           </xsl:if>
          </xsl:element>
         </xsl:if>
         
         <xsl:if test="$dtsiCells|$dtsvCells|$dtsfCells|$dtslCells">
          <xsl:element name="DTS">
           <xsl:attribute name="hint">CRONOLOGIA SPECIFICA</xsl:attribute>
           <xsl:if test="$dtsiCells">
            <xsl:element name="DTSI">
             <xsl:attribute name="hint">Da</xsl:attribute>
             <xsl:value-of select="replace($dtsiCells,'\|\|','; ')"/>
            </xsl:element>
           </xsl:if>
           <xsl:if test="$dtsvCells">
            <xsl:element name="DTSV">
             <xsl:attribute name="hint">Validità</xsl:attribute>
             <xsl:value-of select="replace($dtsvCells,'\|\|','; ')"/>
            </xsl:element>
           </xsl:if>
           <xsl:if test="$dtsfCells">
            <xsl:element name="DTSF">
             <xsl:attribute name="hint">A</xsl:attribute>
             <xsl:value-of select="replace($dtsfCells,'\|\|','; ')"/>
            </xsl:element>
           </xsl:if>
           <xsl:if test="$dtslCells">
            <xsl:element name="DTSL">
             <xsl:attribute name="hint">Validità</xsl:attribute>
             <xsl:value-of select="replace($dtslCells,'\|\|','; ')"/>
            </xsl:element>
           </xsl:if>
          </xsl:element>
         </xsl:if>
        </xsl:element>
      </xsl:if>
   
      <!-- AU: DEFINIZIONE CULTURALE -->
      <xsl:if test="cell[@name='AUTN'] or cell[@name='AUTA'] or cell[@name='AUTS'] or cell[@name='ATBD']">
       <xsl:element name="AU">
        <xsl:attribute name="hint">DEFINIZIONE CULTURALE</xsl:attribute>

        <xsl:if test="cell[@name='AUTN'] or cell[@name='AUTA'] or cell[@name='AUTS']">
         <xsl:variable name="maxAut" select="max((count(cell[@name='AUTN']), count(cell[@name='AUTS']), count(cell[@name='AUTA']), count(cell[@name='AUTS'])))"/>
         <xsl:variable name="autnCells" select="cell[@name='AUTN']"/>
         <xsl:variable name="autaCells" select="cell[@name='AUTA']"/>
         <xsl:variable name="autsCells" select="cell[@name='AUTS']"/>
		
		 <xsl:for-each select="1 to $maxAut">
           <xsl:variable name="pos" select="."/>
		   
         <xsl:element name="AUT">
          <xsl:attribute name="hint">AUTORE</xsl:attribute>
          
           <xsl:if test="$autsCells[$pos] and normalize-space($autsCells[$pos]) != ''">
            <xsl:element name="AUTS">
             <xsl:attribute name="hint">Riferimento all'autore</xsl:attribute>
             <xsl:value-of select="$autsCells[$pos]"/>
            </xsl:element>
           </xsl:if>
           <xsl:if test="$autnCells[$pos] and normalize-space($autnCells[$pos]) != ''">
            <xsl:element name="AUTN">
             <xsl:attribute name="hint">Nome scelto</xsl:attribute>
             <xsl:value-of select="$autnCells[$pos]"/>
            </xsl:element>
           </xsl:if>
           <xsl:if test="$autaCells[$pos] and normalize-space($autaCells[$pos]) != ''">
            <xsl:element name="AUTA">
             <xsl:attribute name="hint">Dati anagrafici</xsl:attribute>
             <xsl:value-of select="$autaCells[$pos]"/>
            </xsl:element>
           </xsl:if>
          
         </xsl:element>
		 </xsl:for-each>
        </xsl:if>

        <xsl:if test="cell[@name='ATBD']!= ''">
         
         <xsl:element name="ATB">
          <xsl:attribute name="hint">AMBITO CULTURALE</xsl:attribute>
            <xsl:element name="ATBD">
             <xsl:attribute name="hint">Denominazione</xsl:attribute>
             <xsl:value-of select="replace(cell[@name='ATBD'],'\|\|','; ')"/>
            </xsl:element>
         </xsl:element>
        </xsl:if>
		
       </xsl:element>
      </xsl:if>
   
      <!-- MT: DATI TECNICI -->
      <xsl:element name="MT">
       <xsl:attribute name="hint">DATI TECNICI</xsl:attribute>
	   <xsl:for-each select="cell[@name='MTC']">
        <xsl:element name="MTC">
         <xsl:attribute name="hint">Materia e tecnica</xsl:attribute>
         <xsl:value-of select="."/>
        </xsl:element>
	   </xsl:for-each>
       
       <xsl:if test="cell[@name='MISU']|cell[@name='MISA']|cell[@name='MISL']|cell[@name='MISD']|cell[@name='MISN']">
        <xsl:variable name="max" select="max((count(cell[@name='MISU']), count(cell[@name='MISA']), count(cell[@name='MISL']), count(cell[@name='MISD']), count(cell[@name='MISN'])))"/>
        <xsl:variable name="misuCells" select="cell[@name='MISU']"/>
        <xsl:variable name="misaCells" select="cell[@name='MISA']"/>
        <xsl:variable name="mislCells" select="cell[@name='MISL']"/>
        <xsl:variable name="misdCells" select="cell[@name='MISD']"/>
        <xsl:variable name="misnCells" select="cell[@name='MISN']"/>
        
        <xsl:for-each select="1 to $max">
         <xsl:variable name="pos" select="."/>
         <xsl:element name="MIS">
          <xsl:attribute name="hint">MISURE</xsl:attribute>
          <xsl:if test="$misuCells[$pos] and normalize-space($misuCells[$pos]) != ''">
           <xsl:element name="MISU">
            <xsl:attribute name="hint">Unità</xsl:attribute>
            <xsl:value-of select="$misuCells[$pos]"/>
           </xsl:element>
          </xsl:if>
          <xsl:if test="$misaCells[$pos] and normalize-space($misaCells[$pos]) != ''">
           <xsl:element name="MISA">
            <xsl:attribute name="hint">Altezza</xsl:attribute>
            <xsl:value-of select="$misaCells[$pos]"/>
           </xsl:element>
          </xsl:if>
          <xsl:if test="$mislCells[$pos] and normalize-space($mislCells[$pos]) != ''">
           <xsl:element name="MISL">
            <xsl:attribute name="hint">Larghezza</xsl:attribute>
            <xsl:value-of select="$mislCells[$pos]"/>
           </xsl:element>
          </xsl:if>
          <xsl:if test="$misdCells[$pos] and normalize-space($misdCells[$pos]) != ''">
           <xsl:element name="MISD">
            <xsl:attribute name="hint">Diametro</xsl:attribute>
            <xsl:value-of select="$misdCells[$pos]"/>
           </xsl:element>
          </xsl:if>
          <xsl:if test="$misnCells[$pos] and normalize-space($misnCells[$pos]) != ''">
           <xsl:element name="MISN">
            <xsl:attribute name="hint">Lunghezza</xsl:attribute>
            <xsl:value-of select="$misnCells[$pos]"/>
           </xsl:element>
          </xsl:if>
         </xsl:element>
        </xsl:for-each>
       </xsl:if>
      </xsl:element>
   
      <!-- DA: DATI ANALITICI -->
      <xsl:if test="cell[@name='DESA'] or cell[@name='DESL'] or cell[@name='DESN'] or cell[@name='DESF'] or cell[@name='DESM'] or cell[@name='DESG'] or cell[@name='DESR'] or cell[@name='DEST'] or cell[@name='DESV'] or cell[@name='DESD'] or cell[@name='DESU'] or cell[@name='AUEE'] or cell[@name='AUES'] or cell[@name='AUEZ'] or cell[@name='ZEC']">
       <xsl:element name="DA">
        <xsl:attribute name="hint">DATI ANALITICI</xsl:attribute>
        
        <xsl:if test="cell[@name='DESA'] or cell[@name='DESL'] or cell[@name='DESN'] or cell[@name='DESF'] or cell[@name='DESM'] or cell[@name='DESG'] or cell[@name='DESR'] or cell[@name='DEST'] or cell[@name='DESV'] or cell[@name='DESD'] or cell[@name='DESU']">
         <xsl:element name="DES">
          <xsl:attribute name="hint">DESCRIZIONE</xsl:attribute>
          <xsl:if test="cell[@name='DESA'] and normalize-space(cell[@name='DESA'][1]) != ''">
           <xsl:element name="DESA">
            <xsl:attribute name="hint">Dritto</xsl:attribute><xsl:value-of select="cell[@name='DESA'][1]"/></xsl:element>
          </xsl:if>
          <xsl:if test="cell[@name='DESL'] and normalize-space(cell[@name='DESL'][1]) != ''">
           <xsl:element name="DESL">
            <xsl:attribute name="hint">Legenda dritto</xsl:attribute><xsl:value-of select="cell[@name='DESL'][1]"/></xsl:element>
          </xsl:if>
          <xsl:for-each select="cell[@name='DESN']">
           <xsl:if test="normalize-space(.) != ''">
            <xsl:element name="DESN">
             <xsl:attribute name="hint">Lingua dritto</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
           </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="cell[@name='DESF']">
           <xsl:if test="normalize-space(.) != ''">
           <xsl:element name="DESF">
            <xsl:attribute name="hint">Alfabeto/scrittura dritto</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
          </xsl:if>
          </xsl:for-each>
          <xsl:if test="cell[@name='DESM'] and normalize-space(cell[@name='DESM'][1]) != ''">
           <xsl:element name="DESM">
            <xsl:attribute name="hint">Rovescio</xsl:attribute><xsl:value-of select="cell[@name='DESM'][1]"/></xsl:element>
          </xsl:if>
          <xsl:if test="cell[@name='DESG'] and normalize-space(cell[@name='DESG'][1]) != ''">
           <xsl:element name="DESG">
            <xsl:attribute name="hint">Legenda rovescio</xsl:attribute><xsl:value-of select="cell[@name='DESG'][1]"/></xsl:element>
          </xsl:if>
          <xsl:for-each select="cell[@name='DESR']">
           <xsl:if test="normalize-space(.) != ''">
            <xsl:element name="DESR">
             <xsl:attribute name="hint">Lingua rovescio</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
           </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="cell[@name='DEST']">
           <xsl:if test="normalize-space(.) != ''">
           <xsl:element name="DEST">
            <xsl:attribute name="hint">Alfabeto/scrittura rovescio</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
          </xsl:if>
		  </xsl:for-each>
          <xsl:if test="cell[@name='DESV'] and normalize-space(cell[@name='DESV'][1]) != ''">
           <xsl:element name="DESV">
            <xsl:attribute name="hint">Taglio</xsl:attribute><xsl:value-of select="cell[@name='DESV'][1]"/></xsl:element>
          </xsl:if>
          <xsl:if test="cell[@name='DESD'] and normalize-space(cell[@name='DESD'][1]) != ''">
           <xsl:element name="DESD">
            <xsl:attribute name="hint">Descrizione bene paramonetale</xsl:attribute><xsl:value-of select="cell[@name='DESD'][1]"/></xsl:element>
          </xsl:if>
          <xsl:for-each select="cell[@name='DESU']">
           <xsl:if test="normalize-space(.) != ''">
            <xsl:element name="DESU">
             <xsl:attribute name="hint">Soggetto</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
           </xsl:if>
          </xsl:for-each>
         </xsl:element>
        </xsl:if>
        
        <!-- AUE: EMITTENTI (RIP=*) -->
        <xsl:if test="cell[@name='AUEE'] or cell[@name='AUES'] or cell[@name='AUEZ']">
         <xsl:variable name="maxAue" select="max((count(cell[@name='AUEE']), count(cell[@name='AUES']), count(cell[@name='AUEZ'])))"/>
         <xsl:variable name="aueeCells" select="cell[@name='AUEE']"/>
         <xsl:variable name="auesCells" select="cell[@name='AUES']"/>
         <xsl:variable name="auezCells" select="cell[@name='AUEZ']"/>
         
         <xsl:for-each select="1 to $maxAue">
          <xsl:variable name="pos" select="."/>
          <xsl:element name="AUE">
           <xsl:attribute name="hint">EMITTENTI</xsl:attribute>
           <xsl:if test="$aueeCells[$pos] and normalize-space($aueeCells[$pos]) != ''">
            <xsl:element name="AUEE">
             <xsl:attribute name="hint">Emittenti</xsl:attribute><xsl:value-of select="normalize-space($aueeCells[$pos])"/></xsl:element>
           </xsl:if>
           <xsl:if test="$auesCells[$pos] and normalize-space($auesCells[$pos]) != ''">
            <xsl:element name="AUES">
             <xsl:attribute name="hint">Stato</xsl:attribute><xsl:value-of select="normalize-space($auesCells[$pos])"/></xsl:element>
           </xsl:if>
           <xsl:if test="$auezCells[$pos] and normalize-space($auezCells[$pos]) != ''">
            <xsl:element name="AUEZ">
             <xsl:attribute name="hint">Zecchieri/Monetieri</xsl:attribute><xsl:value-of select="normalize-space($auezCells[$pos])"/></xsl:element>
           </xsl:if>
          </xsl:element>
         </xsl:for-each>
        </xsl:if>
        
		<xsl:for-each select="cell[@name='ZEC']">
          <xsl:if test="normalize-space(.) != ''">
			<xsl:element name="ZEC">
			<xsl:attribute name="hint">Zecca</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
		  </xsl:if>
		</xsl:for-each>
       </xsl:element>
      </xsl:if>
   
      <!-- CO: CONSERVAZIONE -->
      <xsl:if test="cell[@name='STCC'] and normalize-space(cell[@name='STCC'][1]) != ''">
       <xsl:element name="CO">
        <xsl:attribute name="hint">CONSERVAZIONE</xsl:attribute>
        <xsl:element name="STC">
         <xsl:attribute name="hint">STATO DI CONSERVAZIONE</xsl:attribute>
         <xsl:if test="cell[@name='STCC'] and normalize-space(cell[@name='STCC'][1]) != ''">
          <xsl:element name="STCC">
           <xsl:attribute name="hint">Stato di conservazione</xsl:attribute>
           <xsl:value-of select="cell[@name='STCC']"/>
          </xsl:element>
         </xsl:if>
        </xsl:element>
       </xsl:element>
      </xsl:if>
   
      <!-- TU: CONDIZIONE GIURIDICA E VINCOLI -->
      <xsl:if test="cell[@name='CDGG'] and normalize-space(cell[@name='CDGG'][1]) != ''">
       <xsl:element name="TU">
        <xsl:attribute name="hint">CONDIZIONE GIURIDICA E VINCOLI</xsl:attribute>
        <xsl:element name="CDG">
         <xsl:attribute name="hint">CONDIZIONE GIURIDICA</xsl:attribute>
         <xsl:element name="CDGG">
          <xsl:attribute name="hint">Indicazione generica</xsl:attribute>
          <xsl:value-of select="cell[@name='CDGG'][1]"/>
         </xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:if>
   
      <!-- CM: COMPILAZIONE -->
      <xsl:element name="CM">
       <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
       <xsl:if test="(cell[@name='CMPD'] and normalize-space(cell[@name='CMPD'][1]) != '') or (cell[@name='CMPN'] and normalize-space(cell[@name='CMPN'][1]) != '') or (cell[@name='CMPE'] and normalize-space(cell[@name='CMPE'][1]) != '')">
        <xsl:element name="CMP">
         <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
         <xsl:if test="cell[@name='CMPD'] and normalize-space(cell[@name='CMPD'][1]) != ''">
          <xsl:element name="CMPD">
           <xsl:attribute name="hint">Data</xsl:attribute><xsl:value-of select="cell[@name='CMPD'][1]"/></xsl:element>
         </xsl:if>
         <xsl:if test="cell[@name='CMPN'] and normalize-space(cell[@name='CMPN'][1]) != ''">
          <xsl:element name="CMPN">
           <xsl:attribute name="hint">Nome</xsl:attribute><xsl:value-of select="cell[@name='CMPN'][1]"/></xsl:element>
         </xsl:if>
        </xsl:element>
       </xsl:if>
       <xsl:if test="cell[@name='RSR'] and normalize-space(cell[@name='RSR'][1]) != ''">
        <xsl:element name="RSR">
         <xsl:attribute name="hint">Referente scientifico</xsl:attribute><xsl:value-of select="cell[@name='RSR'][1]"/></xsl:element>
       </xsl:if>
       <xsl:if test="cell[@name='FUR'] and normalize-space(cell[@name='FUR'][1]) != ''">
        <xsl:element name="FUR">
         <xsl:attribute name="hint">Funzionario responsabile</xsl:attribute><xsl:value-of select="cell[@name='FUR'][1]"/></xsl:element>
       </xsl:if>
       <xsl:if test="(cell[@name='RVMD'] and normalize-space(cell[@name='RVMD'][1]) != '') or (cell[@name='RVMN'] and normalize-space(cell[@name='RVMN'][1]) != '')">
        <xsl:element name="RVM">
         <xsl:attribute name="hint">TRASCRIZIONE PER INFORMATIZZAZIONE</xsl:attribute>
         <xsl:if test="cell[@name='RVMD'] and normalize-space(cell[@name='RVMD'][1]) != ''">
          <xsl:element name="RVMD">
           <xsl:attribute name="hint">Data</xsl:attribute><xsl:value-of select="cell[@name='RVMD'][1]"/></xsl:element>
         </xsl:if>
         <xsl:if test="cell[@name='RVMN'] and normalize-space(cell[@name='RVMN'][1]) != ''">
          <xsl:element name="RVMN">
           <xsl:attribute name="hint">Nome</xsl:attribute><xsl:value-of select="cell[@name='RVMN'][1]"/></xsl:element>
         </xsl:if>
        </xsl:element>
       </xsl:if>
       <xsl:if test="(cell[@name='AGGD'] and normalize-space(cell[@name='AGGD'][1]) != '') or (cell[@name='AGGN'] and normalize-space(cell[@name='AGGN'][1]) != '') or (cell[@name='AGGE'] and normalize-space(cell[@name='AGGE'][1]) != '') or (cell[@name='AGGR'] and normalize-space(cell[@name='AGGR'][1]) != '') or (cell[@name='AGGF'] and normalize-space(cell[@name='AGGF'][1]) != '')">
        <xsl:element name="AGG">
         <xsl:attribute name="hint">AGGIORNAMENTO REVISIONE</xsl:attribute>
         <xsl:if test="cell[@name='AGGD'] and normalize-space(cell[@name='AGGD'][1]) != ''">
          <xsl:element name="AGGD">
           <xsl:attribute name="hint">Data</xsl:attribute><xsl:value-of select="replace(cell[@name='AGGD'][1],'\|\|','; ')"/></xsl:element>
         </xsl:if>
         <xsl:if test="cell[@name='AGGN'] and normalize-space(cell[@name='AGGN'][1]) != ''">
          <xsl:element name="AGGN">
           <xsl:attribute name="hint">Nome</xsl:attribute><xsl:value-of select="replace(cell[@name='AGGN'][1],'\|\|','; ')"/></xsl:element>
         </xsl:if>
         <xsl:if test="cell[@name='AGGE'] and normalize-space(cell[@name='AGGE'][1]) != ''">
          <xsl:element name="AGGE">
           <xsl:attribute name="hint">Ente</xsl:attribute><xsl:value-of select="replace(cell[@name='AGGE'][1],'\|\|','; ')"/></xsl:element>
         </xsl:if>
         <xsl:if test="cell[@name='AGGR'] and normalize-space(cell[@name='AGGR'][1]) != ''">
          <xsl:element name="AGGR">
           <xsl:attribute name="hint">Referente scientifico</xsl:attribute><xsl:value-of select="replace(cell[@name='AGGR'][1],'\|\|','; ')"/></xsl:element>
         </xsl:if>
         <xsl:if test="cell[@name='AGGF'] and normalize-space(cell[@name='AGGF'][1]) != ''">
          <xsl:element name="AGGF">
           <xsl:attribute name="hint">Funzionario responsabile</xsl:attribute><xsl:value-of select="replace(cell[@name='AGGF'][1],'\|\|','; ')"/></xsl:element>
         </xsl:if>
        </xsl:element>
       </xsl:if>
      </xsl:element>
   
      <!-- GP: GEOREFERENZIAZIONE -->
      <xsl:if test="cell[(@name='GPDPX' or @name='GPDX') and normalize-space(.) != ''] and cell[(@name='GPDPY' or @name='GPDY') and normalize-space(.) != '']">
       <xsl:element name="GP">
        <xsl:attribute name="hint">GEOREFERENZIAZIONE TRAMITE PUNTO</xsl:attribute>
        <xsl:element name="GPD">
         <xsl:attribute name="hint">DESCRIZIONE DEL PUNTO</xsl:attribute>
         <xsl:element name="GPDP">
          <xsl:attribute name="hint">PUNTO</xsl:attribute>
          <xsl:if test="cell[@name='GPDX'] and normalize-space(cell[@name='GPDX'][1]) != ''">
           <xsl:element name="GPDPX">
            <xsl:attribute name="hint">Coordinata X</xsl:attribute><xsl:value-of select="cell[@name='GPDX'][1]"/></xsl:element>
          </xsl:if>
          <xsl:if test="cell[@name='GPDY'] and normalize-space(cell[@name='GPDY'][1]) != ''">
           <xsl:element name="GPDPY">
            <xsl:attribute name="hint">Coordinata Y</xsl:attribute><xsl:value-of select="cell[@name='GPDY'][1]"/></xsl:element>
          </xsl:if>
         </xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:if>

     </xsl:element>
     
     <!-- HARVESTING GEOCODING -->
     <xsl:choose>
      <xsl:when test="cell[@name='WGS84_X'] and cell[@name='WGS84_Y']">
       <xsl:element name="harvesting">
        <xsl:element name="geocoding">
         <xsl:element name="x"><xsl:value-of select="cell[@name='WGS84_X'][1]"/></xsl:element>    
         <xsl:element name="y"><xsl:value-of select="cell[@name='WGS84_Y'][1]"/></xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:when>
      <xsl:when test="cell[@name='GPDX'] and cell[@name='GPDY']">
       <xsl:element name="harvesting">
        <xsl:element name="geocoding">
         <xsl:element name="x"><xsl:value-of select="cell[@name='GPDX'][1]"/></xsl:element>    
         <xsl:element name="y"><xsl:value-of select="cell[@name='GPDY'][1]"/></xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:when>
     </xsl:choose>

    </schede>
   </metadata>
  </record>
 </xsl:template>

</xsl:stylesheet>
