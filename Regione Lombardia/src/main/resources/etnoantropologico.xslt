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
     <xsl:value-of select="cell[@name='IDK']"/>
    </xsl:element>
    <datestamp><xsl:value-of select="$datestamp"/></datestamp>
   </header>
   <metadata>
    <schede>
    
     <xsl:element name="{$TSKK}">
      <xsl:attribute name="version">2.00</xsl:attribute>
      
      <!-- CODICI -->
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
         <xsl:if test="string-length(cell[@name='NCTR'])=1">0</xsl:if>
         <xsl:value-of select="cell[@name='NCTR']"/>
        </xsl:element>
        <xsl:if test="cell[@name='NCTN'] and normalize-space(cell[@name='NCTN']) != ''">
         <xsl:element name="NCTN">
          <xsl:attribute name="hint">Numero catalogo generale</xsl:attribute>
          <xsl:value-of select="cell[@name='NCTN']"/>
         </xsl:element>
        </xsl:if>
       </xsl:element>
       
       <xsl:if test="cell[@name='ESC'] and normalize-space(cell[@name='ESC']) != ''">
        <xsl:element name="ESC">
         <xsl:attribute name="hint">Ente schedatore</xsl:attribute>
         <xsl:value-of select="cell[@name='ESC']"/>
        </xsl:element>
       </xsl:if>
      </xsl:element>

      <!-- OGGETTO -->
      <xsl:element name="OG">
       <xsl:attribute name="hint">OGGETTO</xsl:attribute>
       <xsl:element name="OGT">
        <xsl:attribute name="hint">DEFINIZIONE DELL'OGGETTO</xsl:attribute>
        <xsl:element name="OGTD">
         <xsl:attribute name="hint">Definizione</xsl:attribute>
         <xsl:value-of select="cell[@name='OGTD']"/>
        </xsl:element>
       </xsl:element>
       
	   <xsl:if test="cell[@name='QNT']">
        <xsl:element name="QNT">
         <xsl:attribute name="hint">Quantità</xsl:attribute>
			<xsl:value-of select="cell[@name='QNT']"/>
        </xsl:element>
       </xsl:if>
	   
       <xsl:if test="(cell[@name='SGTI'] and normalize-space(cell[@name='SGTI']) != '') or (cell[@name='SGTT'] and normalize-space(cell[@name='SGTT']) != '')">
        <xsl:element name="SGT">
         <xsl:attribute name="hint">SOGGETTO</xsl:attribute>
         <xsl:apply-templates select="cell[@name='SGTI']"/>
         <xsl:apply-templates select="cell[@name='SGTT']"/>
        </xsl:element>
       </xsl:if>
      </xsl:element>
   
      <!-- LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA -->
      <xsl:element name="LC">
       <xsl:attribute name="hint">LOCALIZZAZIONE</xsl:attribute>
       <xsl:element name="PVC">
        <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
        <xsl:element name="PVCS">
         <xsl:attribute name="hint">Stato</xsl:attribute><xsl:value-of select="cell[@name='PVCS']"/></xsl:element>
        <xsl:element name="PVCP">
         <xsl:attribute name="hint">Provincia</xsl:attribute><xsl:value-of select="cell[@name='PVCP']"/></xsl:element>
        <xsl:element name="PVCC">
         <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="cell[@name='PVCC']"/></xsl:element>
       </xsl:element>
       
       <xsl:element name="LDC">
        <xsl:attribute name="hint">COLLOCAZIONE SPECIFICA</xsl:attribute>
        <xsl:if test="cell[@name='LDCT'] and normalize-space(cell[@name='LDCT']) != ''">
         <xsl:element name="LDCT">
          <xsl:attribute name="hint">Tipologia</xsl:attribute><xsl:value-of select="cell[@name='LDCT']"/></xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='LDCQ'] and normalize-space(cell[@name='LDCQ']) != ''">
         <xsl:element name="LDCQ">
          <xsl:attribute name="hint">Qualificazione</xsl:attribute><xsl:value-of select="cell[@name='LDCQ']"/></xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='LDCN'] and normalize-space(cell[@name='LDCN']) != ''">
         <xsl:element name="LDCN">
          <xsl:attribute name="hint">Denominazione del contenitore architettonico/ambientale</xsl:attribute><xsl:value-of select="cell[@name='LDCN']"/></xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='LDCU'] and normalize-space(cell[@name='LDCU']) != ''">
         <xsl:element name="LDCU">
          <xsl:attribute name="hint">Denominazione dello spazio viabilistico</xsl:attribute><xsl:value-of select="cell[@name='LDCU']"/></xsl:element>
        </xsl:if>
        <xsl:if test="cell[@name='LDCM'] and normalize-space(cell[@name='LDCM']) != ''">
         <xsl:element name="LDCM">
          <xsl:attribute name="hint">Denominazione raccolta</xsl:attribute>
          <xsl:value-of select="cell[@name='LDCM']"/>
          <xsl:if test="cell[@name='LDCI'] and normalize-space(cell[@name='LDCI']) != ''">. <xsl:value-of select="cell[@name='LDCI']"/></xsl:if>
         </xsl:element>
        </xsl:if>
       </xsl:element>
      </xsl:element>
      
      <!-- DEFINIZIONE CULTURALE -->
      <xsl:if test="cell[@name='AUFN'] or cell[@name='AUFA'] or cell[@name='ATBD']">
		<xsl:variable name="max" select="max((count(cell[@name='AUFN']), count(cell[@name='AUFA']), count(cell[@name='ATBD'])))"/>
        <xsl:variable name="aufnCells" select="cell[@name='AUFN']"/>
        <xsl:variable name="aufaCells" select="cell[@name='AUFA']"/>
		<xsl:variable name="atbdCells" select="cell[@name='ATBD']"/>
		 
		 <xsl:for-each select="1 to $max">
         <xsl:variable name="pos" select="."/>
       
		<xsl:element name="AU">
		<xsl:attribute name="hint">AUTORE FABBRICAZIONE/ ESECUZIONE</xsl:attribute>

		<xsl:if test="$aufnCells[$pos] or $aufaCells[$pos]">
         
			<xsl:element name="AUF">
			<xsl:attribute name="hint">AUTORE</xsl:attribute>
          
           <xsl:if test="$aufnCells[$pos]">
            <xsl:element name="AUFN">
             <xsl:attribute name="hint">Nome</xsl:attribute>
             <xsl:value-of select="$aufnCells[$pos]"/>
            </xsl:element>
           </xsl:if>
			<xsl:if test="$aufaCells[$pos]">
				<xsl:element name="AUFA">
				<xsl:attribute name="hint">Dati anagrafici</xsl:attribute>
					<xsl:value-of select="$aufaCells[$pos]"/>
				</xsl:element>
			</xsl:if>
          
			</xsl:element>
		</xsl:if>

        <xsl:if test="$atbdCells[$pos]">
         <xsl:element name="ATB">
          <xsl:attribute name="hint">AMBITO DI PRODUZIONE</xsl:attribute>
            <xsl:element name="ATBD">
             <xsl:attribute name="hint">Denominazione</xsl:attribute>
             <xsl:value-of select="$atbdCells[$pos]"/>
            </xsl:element>
		 </xsl:element>
		</xsl:if>
         
       </xsl:element>
	   </xsl:for-each>
      </xsl:if>
   
      <!-- DATI TECNICI -->
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
          <xsl:if test="$mispCells[$pos] and normalize-space($mispCells[$pos]) != ''">
           <xsl:element name="MISP">
            <xsl:attribute name="hint">Profondità</xsl:attribute>
            <xsl:value-of select="$mispCells[$pos]"/>
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
   
      <!-- DATI ANALITICI -->
      <xsl:if test="(cell[@name='DESO'] and normalize-space(cell[@name='DESO']) != '') or (cell[@name='NSC'] and normalize-space(cell[@name='NSC']) != '')">
       <xsl:element name="DA">
        <xsl:attribute name="hint">DATI ANALITICI</xsl:attribute>
        <xsl:if test="cell[@name='DESO'] and normalize-space(cell[@name='DESO']) != ''">
         <xsl:element name="DES">
          <xsl:attribute name="hint">DESCRIZIONE</xsl:attribute>
          <xsl:apply-templates select="cell[@name='DESO']"/>
         </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="cell[@name='NSC']"/>
       </xsl:element>
      </xsl:if>
   
      <!-- CONSERVAZIONE -->
      <xsl:if test="cell[@name='STCC'] and normalize-space(cell[@name='STCC']) != ''">
       <xsl:element name="CO">
        <xsl:attribute name="hint">CONSERVAZIONE</xsl:attribute>
        <xsl:element name="STC">
         <xsl:attribute name="hint">STATO DI CONSERVAZIONE</xsl:attribute>
         <xsl:if test="cell[@name='STCC'] and normalize-space(cell[@name='STCC']) != ''">
          <xsl:element name="STCC">
           <xsl:attribute name="hint">Dati di conservazione</xsl:attribute>
           <xsl:value-of select="replace(cell[@name='STCC'],'\|\|','; ')"/>
          </xsl:element>
         </xsl:if>
        </xsl:element>
       </xsl:element>
      </xsl:if>
   
      <!-- CONDIZIONE GIURIDICA E VINCOLI -->
      <xsl:if test="cell[@name='CDGG'] and normalize-space(cell[@name='CDGG']) != ''">
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
   
      <!-- FONTI E DOCUMENTI DI RIFERIMENTO -->
      <xsl:element name="DO">
       <xsl:attribute name="hint">FONTI E DOCUMENTI DI RIFERIMENTO</xsl:attribute>
       <xsl:element name="FTA">
        <xsl:attribute name="hint">DOCUMENTAZIONE FOTOGRAFICA</xsl:attribute>
        <xsl:element name="FTAN">
         <xsl:attribute name="hint">Codice identificativo</xsl:attribute>
         <xsl:value-of select="cell[@name='IDK']"/>
        </xsl:element>
       </xsl:element>
      </xsl:element>
   
      <!-- COMPILAZIONE -->
      <xsl:element name="CM">
       <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
       <xsl:if test="(cell[@name='CMPD'] and normalize-space(cell[@name='CMPD']) != '') or (cell[@name='CMPN'] and normalize-space(cell[@name='CMPN']) != '')">
        <xsl:element name="CMP">
         <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
         <xsl:apply-templates select="cell[@name='CMPD']"/>
         <xsl:apply-templates select="cell[@name='CMPN']"/>
        </xsl:element>
       </xsl:if>
       <xsl:apply-templates select="cell[@name='FUR']"/>
       <xsl:if test="(cell[@name='RVMD'] and normalize-space(cell[@name='RVMD']) != '') or (cell[@name='RVMN'] and normalize-space(cell[@name='RVMN']) != '')">
        <xsl:element name="RVM">
         <xsl:attribute name="hint">TRASCRIZIONE</xsl:attribute>
         <xsl:apply-templates select="cell[@name='RVMD']"/>
         <xsl:apply-templates select="cell[@name='RVMN']"/>
        </xsl:element>
       </xsl:if>
       <xsl:if test="some $c in (cell[@name='AGGD'] | cell[@name='AGGN']) satisfies normalize-space($c) != ''">
	   <xsl:variable name="max" select="max((count(cell[@name='AGGD']), count(cell[@name='AGGN'])))"/>
        <xsl:variable name="aggdCells" select="cell[@name='AGGD']"/>
        <xsl:variable name="aggnCells" select="cell[@name='AGGN']"/>
        
        <xsl:for-each select="1 to $max">
         <xsl:variable name="pos" select="."/>
        <xsl:element name="AGG">
         <xsl:attribute name="hint">AGGIORNAMENTO</xsl:attribute>
		 
		 <xsl:if test="$aggdCells[$pos] and normalize-space($aggdCells[$pos]) != ''">
           <xsl:element name="AGGD">
            <xsl:attribute name="hint">Data</xsl:attribute>
            <xsl:value-of select="$aggdCells[$pos]"/>
           </xsl:element>
          </xsl:if>
		 <xsl:if test="$aggnCells[$pos] and normalize-space($aggnCells[$pos]) != ''">
           <xsl:element name="AGGN">
            <xsl:attribute name="hint">Nome</xsl:attribute>
            <xsl:value-of select="$aggnCells[$pos]"/>
           </xsl:element>
          </xsl:if>
		  
        </xsl:element>
		</xsl:for-each>
		
       </xsl:if>
      </xsl:element>

     </xsl:element>
     
     <!-- HARVESTING GEOCODING -->
     <xsl:choose>
      <xsl:when test="cell[@name='WGS84_X'] and cell[@name='WGS84_Y']">
       <xsl:element name="harvesting">
        <xsl:element name="geocoding">
         <xsl:element name="x"><xsl:value-of select="cell[@name='WGS84_X']"/></xsl:element>    
         <xsl:element name="y"><xsl:value-of select="cell[@name='WGS84_Y']"/></xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:when>
      <xsl:when test="cell[@name='GPDX'] and cell[@name='GPDY']">
       <xsl:element name="harvesting">
        <xsl:element name="geocoding">
         <xsl:element name="x"><xsl:value-of select="cell[@name='GPDX']"/></xsl:element>    
         <xsl:element name="y"><xsl:value-of select="cell[@name='GPDY']"/></xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:when>
     </xsl:choose>

    </schede>
   </metadata>
  </record>
 </xsl:template>

 <xsl:template match="cell[@name='SGTI']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="SGTI">
    <xsl:attribute name="hint">Identificazione</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="cell[@name='SGTT']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="SGTT">
    <xsl:attribute name="hint">Titolo</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="cell[@name='DESO']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="DESO">
    <xsl:attribute name="hint">Indicazioni sull'oggetto</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="cell[@name='NSC']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="NSC">
    <xsl:attribute name="hint">Notizie storico-critiche</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
     
 <xsl:template match="cell[@name='CMPD']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="CMPD">
    <xsl:attribute name="hint">Data</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="cell[@name='CMPN']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="CMPN">
    <xsl:attribute name="hint">Nome</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
     
 <xsl:template match="cell[@name='RVMD']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="RVMD">
    <xsl:attribute name="hint">Data</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="cell[@name='RVMN']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="RVMN">
    <xsl:attribute name="hint">Nome</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
      
 <xsl:template match="cell[@name='GPDPX' or @name='GPDX']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="GPDPX">
    <xsl:attribute name="hint">Coordinata X</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="cell[@name='GPDPY' or @name='GPDY']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="GPDPY">
    <xsl:attribute name="hint">Coordinata Y</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>

 <xsl:template match="cell[@name='FUR']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="FUR">
    <xsl:attribute name="hint">Funzionario responsabile</xsl:attribute>
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:if>
 </xsl:template>	

 <xsl:template match="cell[@name='MTC']">
  <xsl:if test="normalize-space(.) != ''">
   <xsl:element name="MTC">
    <xsl:attribute name="hint">Materia e tecnica</xsl:attribute>
		<xsl:choose>
		<xsl:when test="contains(.,'/')">
		<xsl:element name="MTCM">
		<xsl:attribute name="hint">Materia</xsl:attribute>
			<xsl:value-of select="normalize-space(substring-before(.,'/'))"/>
		</xsl:element>
		<xsl:element name="MTCT">
		<xsl:attribute name="hint">Tecnica</xsl:attribute>
			<xsl:value-of select="normalize-space(substring-after(.,'/'))"/>
		</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="MTCM">
			<xsl:attribute name="hint">Materia</xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:element>
  </xsl:if>
 </xsl:template>		

</xsl:stylesheet>
