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
 <!-- OGTR,SGTC,QNTN,PVCN,PVCJ,LDCZ,COLD,ATBR,STCD,CMPE campi esclusi perché non presenti in scheda RA.

   Inserita gestione dampi di gruppo (AUT, ATB): si ripetono AUT e ATB se si trovano valori ripetuti in AUTN o ATBD.
       -->
 
 <xsl:template match="row">
  <record>
   <header>
    <xsl:element name="identifier">
     <xsl:value-of select="cell[@name='IDK']"/>
    </xsl:element>
    <datestamp><xsl:value-of select="$datestamp"/></datestamp>
   </header>
   <metadata>
    <schede>
    
     <xsl:element name="RA">
      <xsl:attribute name="version">3.00</xsl:attribute>
      <xsl:element name="CD">
       <xsl:attribute name="hint">CODICI</xsl:attribute>
       <xsl:element name="TSK">
        <xsl:attribute name="hint">Tipo scheda</xsl:attribute>RA</xsl:element>
       
       <xsl:element name="NCT">
        <xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
        <xsl:element name="NCTR">
         <xsl:attribute name="hint">Codice regione</xsl:attribute><xsl:if test="string-length(cell[@name='NCTR'])=1">0</xsl:if><xsl:value-of select="cell[@name='NCTR']"/></xsl:element>
        <xsl:if test="cell[@name='NCTN']">
         <xsl:element name="NCTN">
          <xsl:attribute name="hint">Numero catalogo generale</xsl:attribute><xsl:value-of select="cell[@name='NCTN']"/></xsl:element>
        </xsl:if>
       </xsl:element>
       <xsl:element name="ESC">
        <xsl:attribute name="hint">Ente schedatore</xsl:attribute><xsl:value-of select="cell[@name='ESC']"/></xsl:element>
      </xsl:element>
      
      <xsl:element name="AC">
       <xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
       <xsl:element name="ACC">
        <xsl:attribute name="hint">Altro codice bene</xsl:attribute>
        <xsl:value-of select="cell[@name='IDK']"/> /R03</xsl:element>
      </xsl:element>
      
      <xsl:element name="OG">
       <xsl:attribute name="hint">OGGETTO</xsl:attribute>
       <xsl:element name="OGT">
        <xsl:attribute name="hint">OGGETTO</xsl:attribute>
        <xsl:element name="OGTD">
         <xsl:attribute name="hint">Definizione</xsl:attribute><xsl:value-of select="cell[@name='OGTD']"/></xsl:element>
        <xsl:if test="cell[@name='OGTT']">
         <xsl:element name="OGTT">
          <xsl:attribute name="hint">Tipologia</xsl:attribute><xsl:value-of select="cell[@name='OGTT']"/></xsl:element>
        </xsl:if>
        
       </xsl:element>
       
       <xsl:if test="cell[@name='SGTI']|cell[@name='SGTT']">
        <xsl:element name="SGT">
         <xsl:attribute name="hint">SOGGETTO</xsl:attribute>
         <xsl:apply-templates select="cell[@name='SGTI']"/>
         <xsl:apply-templates select="cell[@name='SGTT']"/>
        </xsl:element>
       </xsl:if>
       
      </xsl:element>

      <xsl:element name="LC">
       <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
       <xsl:element name="PVC">
        <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
       
        <xsl:element name="PVCS">
         <xsl:attribute name="hint">Stato</xsl:attribute><xsl:value-of select="cell[@name='PVCS']"/></xsl:element>
        <xsl:element name="PVCR">
         <xsl:attribute name="hint">Regione</xsl:attribute><xsl:value-of select="cell[@name='PVCR']"/></xsl:element>
        <xsl:element name="PVCP">
         <xsl:attribute name="hint">Provincia</xsl:attribute><xsl:value-of select="cell[@name='PVCP']"/></xsl:element>
        <xsl:element name="PVCC">
         <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="cell[@name='PVCC']"/></xsl:element>
       </xsl:element>
       
       <xsl:element name="LDC">
        <xsl:attribute name="hint">COLLOCAZIONE SPECIFICA</xsl:attribute>
       
        <xsl:element name="LDCT">
         <xsl:attribute name="hint">Tipologia</xsl:attribute><xsl:value-of select="cell[@name='LDCT']"/></xsl:element>
        <xsl:if test="cell[@name='LDCQ']">
         <xsl:element name="LDCQ">
          <xsl:attribute name="hint">Qualificazione</xsl:attribute><xsl:value-of select="cell[@name='LDCQ']"/></xsl:element>
        </xsl:if>
        <xsl:element name="LDCN">
         <xsl:attribute name="hint">Denominazione</xsl:attribute><xsl:value-of select="cell[@name='LDCN']"/></xsl:element>
        <xsl:element name="LDCU">
         <xsl:attribute name="hint">Denominazione spazio viabilistico</xsl:attribute><xsl:value-of select="cell[@name='LDCU']"/></xsl:element>
        <xsl:element name="LDCM">
         <xsl:attribute name="hint">Denominazione raccolta</xsl:attribute><xsl:value-of select="cell[@name='LDCM']"/><xsl:if test="cell[@name='LDCI']">. <xsl:value-of select="cell[@name='LDCI']"/></xsl:if></xsl:element>
       </xsl:element>
       
      </xsl:element>
      
      <xsl:element name="DT">
       <xsl:attribute name="hint">CRONOLOGIA</xsl:attribute>
       <xsl:if test="cell[@name='DTZG']|cell[@name='DTZS']">
        <xsl:element name="DTZ">
         <xsl:attribute name="hint">CRONOLOGIA GENERICA</xsl:attribute>
         <xsl:apply-templates select="cell[@name='DTZG']"/>
         <xsl:apply-templates select="cell[@name='DTZS']"/>
        </xsl:element>
       </xsl:if>
       <xsl:if test="cell[@name='DTSI']|cell[@name='DTSV']|cell[@name='DTSF']|cell[@name='DTSL']">
        <xsl:element name="DTS">
         <xsl:attribute name="hint">CRONOLOGIA SPECIFICA</xsl:attribute>
         <xsl:apply-templates select="cell[@name='DTSI']"/>
         <xsl:apply-templates select="cell[@name='DTSV']"/>
         <xsl:apply-templates select="cell[@name='DTSF']"/>
         <xsl:apply-templates select="cell[@name='DTSL']"/>
        </xsl:element>
       </xsl:if>
      </xsl:element>
      
      <xsl:element name="AU">
       <xsl:attribute name="hint">DEFINIZIONE CULTURALE</xsl:attribute>
      
       <xsl:if test="cell[@name='AUTN'] or cell[@name='AUTS'] or cell[@name='AUTA']">
	   <xsl:variable name="max" select="max((count(cell[@name='AUTN']), count(cell[@name='AUTA']), count(cell[@name='AUTS'])))"/>
       <xsl:variable name="autnCells" select="cell[@name='AUTN']"/>
       <xsl:variable name="autaCells" select="cell[@name='AUTA']"/>
	   <xsl:variable name="autsCells" select="cell[@name='AUTS']"/>
	   
	   <xsl:for-each select="1 to $max">
        <xsl:variable name="pos" select="."/>
		
	   <xsl:element name="AUT">
	   <xsl:attribute name="hint">AUTORE</xsl:attribute>
	   	   
		<xsl:if test="$autsCells[$pos]">
			<xsl:element name="AUTS">
			<xsl:attribute name="hint">Riferimento all'autore</xsl:attribute>
				<xsl:value-of select="$autsCells[$pos]"/>
			</xsl:element>
        </xsl:if>
		<xsl:if test="$autnCells[$pos]">
			<xsl:element name="AUTN">
			<xsl:attribute name="hint">Nome scelto</xsl:attribute>
				<xsl:value-of select="$autnCells[$pos]"/>
			</xsl:element>
        </xsl:if>
		<xsl:if test="$autaCells[$pos]">
			<xsl:element name="AUTA">
			<xsl:attribute name="hint">Dati anagrafici</xsl:attribute>
				<xsl:value-of select="$autaCells[$pos]"/>
			</xsl:element>
        </xsl:if>
	   </xsl:element>
	   
	   </xsl:for-each>
	   </xsl:if>
       
			<xsl:for-each select="cell[@name='ATBD']">
				<xsl:element name="ATB">
				<xsl:attribute name="hint">AMBITO CULTURALE</xsl:attribute>
					<xsl:element name="ATBD">
					<xsl:attribute name="hint">Denominazione</xsl:attribute>
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
       
      </xsl:element>
      
      <xsl:element name="MT">
       <xsl:attribute name="hint">DATI TECNICI</xsl:attribute>
       <xsl:apply-templates select="cell[@name='MTC']"/>
	   
       <xsl:if test="cell[@name='MISU']|cell[@name='MISA']|cell[@name='MISL']|cell[@name='MISP']|cell[@name='MISD']|cell[@name='MISN']">
			<xsl:variable name="max" select="max((count(cell[@name='MISU']), count(cell[@name='MISA']), count(cell[@name='MISL']), count(cell[@name='MISP']), count(cell[@name='MISD']), count(cell[@name='MISN'])))"/>
			<xsl:variable name="misuCells" select="cell[@name='MISU']"/>
			<xsl:variable name="misaCells" select="cell[@name='MISA']"/>
			<xsl:variable name="mislCells" select="cell[@name='MISL']"/>
			<xsl:variable name="mispCells" select="cell[@name='MISP']"/>
			<xsl:variable name="misdCells" select="cell[@name='MISD']"/>
			<xsl:variable name="misnCells" select="cell[@name='MISN']"/>
			
			<xsl:for-each select="1 to $max">
			<xsl:variable name="pos" select="."/>
			
			<xsl:element name="MIS">
			<xsl:attribute name="hint">MISURE</xsl:attribute>
			
				<xsl:if test="$misuCells[$pos]">
					<xsl:element name="MISU">
					<xsl:attribute name="hint">Unità</xsl:attribute>
						<xsl:value-of select="$misuCells[$pos]"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$misaCells[$pos]">
					<xsl:element name="MISA">
					<xsl:attribute name="hint">Altezza</xsl:attribute>
						<xsl:value-of select="$misaCells[$pos]"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$mislCells[$pos]">
					<xsl:element name="MISL">
					<xsl:attribute name="hint">Larghezza</xsl:attribute>
						<xsl:value-of select="$mislCells[$pos]"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$mispCells[$pos]">
					<xsl:element name="MISP">
					<xsl:attribute name="hint">Profondità</xsl:attribute>
						<xsl:value-of select="$mispCells[$pos]"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$misdCells[$pos]">
					<xsl:element name="MISD">
					<xsl:attribute name="hint">Diametro</xsl:attribute>
						<xsl:value-of select="$misdCells[$pos]"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$misnCells[$pos]">
					<xsl:element name="MISN">
					<xsl:attribute name="hint">Lunghezza</xsl:attribute>
						<xsl:value-of select="$misnCells[$pos]"/>
					</xsl:element>
				</xsl:if>
			</xsl:element>
			</xsl:for-each>
			
			</xsl:if> 
      
      </xsl:element>
      
      <xsl:if test="cell[@name='DESO']|cell[@name='NSC']">
       <xsl:element name="DA">
        <xsl:attribute name="hint">DATI ANALITICI</xsl:attribute>
        <xsl:apply-templates select="cell[@name='DESO']"/>
        <xsl:apply-templates select="cell[@name='NSC']"/>
       </xsl:element>
      </xsl:if>
      
      <xsl:if test="cell[@name='STCC']">
       <xsl:element name="CO">
        <xsl:attribute name="hint">CONSERVAZIONE</xsl:attribute>
        <xsl:element name="STC">
         <xsl:attribute name="hint">STATO DI CONSERVAZIONE</xsl:attribute>
         <xsl:element name="STCC">
          <xsl:attribute name="hint">Stato di conservazione</xsl:attribute>
         <xsl:value-of select="replace(cell[@name='STCC'],'\|\|','; ')"/>
         </xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:if>
      
      <xsl:if test="cell[@name='CDGG']">
       <xsl:element name="TU">
        <xsl:attribute name="hint">CONDIZIONE GIURIDICA E VINCOLI</xsl:attribute>
        <xsl:element name="CDG">
         <xsl:attribute name="hint">CONDIZIONE GIURIDICA</xsl:attribute>
         <xsl:element name="CDGG">
          <xsl:attribute name="hint">Indicazione generica</xsl:attribute>
          <xsl:value-of select="cell[@name='CDGG']"/>
         </xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:if>
      
      <xsl:element name="CM">
       <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
       <xsl:if test="cell[@name='CMPD']|cell[@name='CMPN']">
        <xsl:element name="CMP">
         <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
         <xsl:apply-templates select="cell[@name='CMPD']"/>
         <xsl:apply-templates select="cell[@name='CMPN']"/>
        </xsl:element>
       </xsl:if>
       <xsl:apply-templates select="cell[@name='RSR']"/>
       <xsl:apply-templates select="cell[@name='FUR']"/>
       <xsl:if test="cell[@name='RVMD']|cell[@name='RVMN']">
        <xsl:element name="RVM">
         <xsl:attribute name="hint">TRASCRIZIONE PER INFORMATIZZAZIONE</xsl:attribute>
         <xsl:apply-templates select="cell[@name='RVMD']"/>
         <xsl:apply-templates select="cell[@name='RVMN']"/>
        </xsl:element>
       </xsl:if>
       <xsl:if test="cell[@name='AGGD']|cell[@name='AGGN']|cell[@name='AGGE']|cell[@name='AGGF']">
        <xsl:element name="AGG">
         <xsl:attribute name="hint">AGGIORNAMENTO - REVISIONE</xsl:attribute>
         <xsl:apply-templates select="cell[@name='AGGD']"/>
         <xsl:apply-templates select="cell[@name='AGGN']"/>
         <xsl:apply-templates select="cell[@name='AGGE']"/>
		 <xsl:apply-templates select="cell[@name='AGGR']"/>
         <xsl:apply-templates select="cell[@name='AGGF']"/>
        </xsl:element>
       </xsl:if>
      </xsl:element>
      
      <xsl:if test="cell[@name='GPDPX' or @name='GPDX'] and cell[@name='GPDPY' or @name='GPDY']">
      <xsl:element name="GP">
       <xsl:attribute name="hint">GEOREFERENZIAZIONE TRAMITE PUNTO</xsl:attribute>
       <xsl:element name="GPD">
        <xsl:attribute name="hint">DESCRIZIONE DEL PUNTO</xsl:attribute>
         <xsl:element name="GPDP">
          <xsl:attribute name="hint">PUNTO</xsl:attribute>
          <xsl:apply-templates select="cell[@name='GPDPX' or @name='GPDX']"/>
          <xsl:apply-templates select="cell[@name='GPDPY' or @name='GPDY']"/>
         </xsl:element>
        </xsl:element>
      </xsl:element>
      </xsl:if>

     </xsl:element>

     <xsl:choose>
     
     <xsl:when test="cell[@name='WGS84_X'] and cell[@name='WGS84_Y']"><!-- Before -->
     <xsl:element name="harvesting">
      <xsl:element name="geocoding">
       <xsl:element name="x"><xsl:value-of select="cell[@name='WGS84_X']"/></xsl:element>		
       <xsl:element name="y"><xsl:value-of select="cell[@name='WGS84_Y']"/></xsl:element>
      </xsl:element>
     </xsl:element>
     </xsl:when>
     
     <xsl:when test="cell[@name='GPDX'] and cell[@name='GPDY']"><!-- After -->
     <xsl:element name="harvesting">
      <xsl:element name="geocoding">
       <xsl:element name="x"><xsl:value-of select="cell[@name='GPDX']"/></xsl:element>		
       <xsl:element name="y"><xsl:value-of select="cell[@name='GPDY']"/></xsl:element>
      </xsl:element>
     </xsl:element>
     </xsl:when>
     
     <xsl:otherwise/>
     
     </xsl:choose>

    </schede>
       
   </metadata>
  </record>
 </xsl:template>

 <xsl:template match="cell[@name='SGTI']">
  <xsl:element name="SGTI">
   <xsl:attribute name="hint">Identificazione</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='SGTT']">
  <xsl:element name="SGTT">
   <xsl:attribute name="hint">Titolo</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>

 <xsl:template match="cell[@name='DTZG']">
  <xsl:element name="DTZG">
   <xsl:attribute name="hint">Fascia cronologica di riferimento</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>	
 <xsl:template match="cell[@name='DTZS']">
  <xsl:element name="DTZS">
   <xsl:attribute name="hint">Frazione cronologica</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>		
 <xsl:template match="cell[@name='DTSI']">
  <xsl:element name="DTSI">
   <xsl:attribute name="hint">Da</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>		
 <xsl:template match="cell[@name='DTSV']">
  <xsl:element name="DTSV">
   <xsl:attribute name="hint">Validità</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>	
 <xsl:template match="cell[@name='DTSF']">
  <xsl:element name="DTSF">
   <xsl:attribute name="hint">A</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>	
 <xsl:template match="cell[@name='DTSL']">
  <xsl:element name="DTSL">
   <xsl:attribute name="hint">Validità</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>			
     
 <xsl:template match="cell[@name='DESO']">
  <xsl:element name="DES">
   <xsl:attribute name="hint">DESCRIZIONE</xsl:attribute>
   <xsl:element name="DESO">
    <xsl:attribute name="hint">Indicazioni sull'oggetto</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='NSC']">
  <xsl:element name="NSC">
   <xsl:attribute name="hint">Notizie storico-critiche</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
     
 <xsl:template match="cell[@name='CMPD']">
  <xsl:element name="CMPD">
   <xsl:attribute name="hint">Data</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='CMPN']">
  <xsl:element name="CMPN">
   <xsl:attribute name="hint">Nome</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
     
 <xsl:template match="cell[@name='RVMD']">
  <xsl:element name="RVMD">
   <xsl:attribute name="hint">Data</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='RVMN']">
  <xsl:element name="RVMN">
   <xsl:attribute name="hint">Nome</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
     
 <xsl:template match="cell[@name='AGGD']">
  <xsl:element name="AGGD">
   <xsl:attribute name="hint">Data</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='AGGN']">
  <xsl:element name="AGGN">
   <xsl:attribute name="hint">Nome</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='AGGE']">
  <xsl:element name="AGGE">
   <xsl:attribute name="hint">Ente</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='AGGR']">
  <xsl:element name="AGGR">
   <xsl:attribute name="hint">Referente scientifico</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='AGGF']">
  <xsl:element name="AGGF">
   <xsl:attribute name="hint">Funzionario responsabile</xsl:attribute>
   <xsl:value-of select="replace(.,'\|\|','; ')"/>
  </xsl:element>
 </xsl:template>
      
 <xsl:template match="cell[@name='GPDPX' or @name='GPDX']">
  <xsl:element name="GPDPX">
   <xsl:attribute name="hint">Coordinata X</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='GPDPY' or @name='GPDY']">
  <xsl:element name="GPDPY">
   <xsl:attribute name="hint">Coordinata Y</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>

 <xsl:template match="cell[@name='MTC']">
  <xsl:element name="MTC">
   <xsl:attribute name="hint">Materia e tecnica</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>

 <xsl:template match="cell[@name='RSR']">
  <xsl:element name="RSR">
   <xsl:attribute name="hint">Referente scientifico</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="cell[@name='FUR']">
  <xsl:element name="FUR">
   <xsl:attribute name="hint">Funzionario responsabile</xsl:attribute>
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 
</xsl:stylesheet>
