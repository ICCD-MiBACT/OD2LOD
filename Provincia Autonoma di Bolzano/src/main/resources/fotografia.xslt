<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="fn">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

 <xsl:param name="datestamp" select="'2022-03-11T00:00:00Z'"/>  
 <xsl:param name="xsltBase" select="''"/>  
 <xsl:variable name="comuniBZ" select="document(concat($xsltBase,'comuniBZ.xml'))"/>

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="row">
<record>
 <header>
  <xsl:element name="identifier">
   <xsl:value-of select="cell[@name='priref']"/>
  </xsl:element>
  <!--
  <datestamp><xsl:value-of select="cell[@name='modification']"/></datestamp>
  -->
  <datestamp><xsl:value-of select="$datestamp"/></datestamp>
 </header>
 <metadata>
  <schede>

   <xsl:element name="F">
    <xsl:attribute name="version">4.00</xsl:attribute>
    <xsl:element name="CD">
     <xsl:attribute name="hint">CODICI</xsl:attribute>
     <xsl:element name="TSK">
      <xsl:attribute name="hint">Tipo scheda</xsl:attribute>F</xsl:element>
     <xsl:element name="NCT">
      <xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
      <xsl:element name="NCTR">
       <xsl:attribute name="hint">Codice regione</xsl:attribute>04</xsl:element>
     </xsl:element>
     <xsl:element name="ESC">
      <xsl:attribute name="hint">Ente schedatore</xsl:attribute>P021</xsl:element>
      <xsl:element name="ECP">
       <xsl:attribute name="hint">Ente competente</xsl:attribute>P021</xsl:element>
    </xsl:element>
   
    <xsl:element name="OG">
     <xsl:attribute name="hint">BENE CULTURALE</xsl:attribute>
     <xsl:element name="OGT">
      <xsl:attribute name="hint">DEFINIZIONE BENE</xsl:attribute>
      <xsl:element name="OGTD">
      <xsl:attribute name="hint">Definizione</xsl:attribute>Positivo</xsl:element>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="AC">                  <!-- CI SONO 2 ACCC. PROBLEMA PER rdfizer? -->
     <xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
     <xsl:element name="ACC">
      <xsl:attribute name="hint">CODICE SCHEDA - ALTRI ENTI</xsl:attribute>
      <xsl:element name="ACCE">
       <xsl:attribute name="hint">Ente/soggetto responsabile</xsl:attribute>Provincia autonoma di Bolzano</xsl:element>
      <xsl:element name="ACCC">
       <xsl:attribute name="hint">Codice identificativo</xsl:attribute><xsl:value-of select="cell[@name='priref']"/></xsl:element>
     </xsl:element>
     <xsl:element name="ACC">
      <xsl:attribute name="hint">CODICE SCHEDA - ALTRI ENTI</xsl:attribute>
      <xsl:element name="ACCE">
       <xsl:attribute name="hint">Ente/soggetto responsabile</xsl:attribute>Provincia autonoma di Bolzano</xsl:element>
      <xsl:element name="ACCC">
       <xsl:attribute name="hint">Codice identificativo</xsl:attribute><xsl:value-of select="cell[@name='IN']"/></xsl:element>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="LC">
     <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
     <xsl:element name="PVC">
      <xsl:attribute name="hint">LOCALIZZAZIONE</xsl:attribute>
      <xsl:element name="PVCS">
       <xsl:attribute name="hint">Stato</xsl:attribute>Italia</xsl:element>
      <xsl:element name="PVCR">
       <xsl:attribute name="hint">Regione</xsl:attribute>Trentino-Alto Adige</xsl:element>
      <xsl:element name="PVCP">
       <xsl:attribute name="hint">Provincia</xsl:attribute>BZ</xsl:element>
      
      <xsl:for-each select="cell[@name='CP_it_syn'][normalize-space()=$comuniBZ//comune][1]">
       <xsl:element name="PVCC">
        <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element>
      </xsl:for-each>
       
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="UB">
     <xsl:attribute name="hint">DATI PATRIMONIALI/INVENTARI/STIME/COLLEZIONI</xsl:attribute>
     <xsl:element name="UBF">
      <xsl:attribute name="hint">UBICAZIONE BENE</xsl:attribute>
      <xsl:element name="UBFP">
       <xsl:attribute name="hint">Fondo</xsl:attribute><xsl:value-of select="cell[@name='CL_it']"/></xsl:element>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="AU">
     <xsl:attribute name="hint">DEFINIZIONE CULTURALE</xsl:attribute>
     <xsl:element name="AUT">
      <xsl:attribute name="hint">AUTORE/RESPONSABILITA'</xsl:attribute>
      <xsl:element name="AUTN">
       <xsl:attribute name="hint">Nome di persona o ente</xsl:attribute><xsl:value-of select="cell[@name='VV_it']"/></xsl:element>
      <xsl:choose>
       <xsl:when test="contains(cell[@name='VV_it'],',')">
        <xsl:element name="AUTP">
         <xsl:attribute name="hint">Tipo intestazione</xsl:attribute>P</xsl:element>
       </xsl:when>
       <xsl:otherwise>
        <xsl:element name="AUTP">
         <xsl:attribute name="hint">Tipo intestazione</xsl:attribute>E</xsl:element>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="SG">
     <xsl:attribute name="hint">SOGGETTO</xsl:attribute>
     <xsl:element name="SGT">
      <xsl:attribute name="hint">SOGGETTO</xsl:attribute>
      <xsl:for-each select="cell[@name='ip_it']">
       <xsl:element name="SGTI">
        <xsl:attribute name="hint">Identificazione</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element> 
      </xsl:for-each>
      <xsl:element name="SGTD">
       <xsl:attribute name="hint">Indicazioni sul soggetto</xsl:attribute><xsl:value-of select="cell[@name='BE_it']"/>
       <xsl:if test="cell[@name='B3_it']">. <xsl:value-of select="cell[@name='B3_it']"/></xsl:if>
       </xsl:element>                                                                                                             
     </xsl:element>
    </xsl:element>
    
    <xsl:if test="string-length(cell[@name='DS']) or string-length(cell[@name='DE'])">
     <xsl:element name="DT">
      <xsl:attribute name="hint">CRONOLOGIA</xsl:attribute>
      <xsl:element name="DTS">
       <xsl:attribute name="hint">CRONOLOGIA SPECIFICA</xsl:attribute>
       <xsl:if test="string-length(cell[@name='DS'])">
        <xsl:element name="DTSI">
         <xsl:attribute name="hint">Da</xsl:attribute><xsl:value-of select="substring-before(cell[@name='DS'], '.')"/>/<xsl:value-of select="substring(cell[@name='DS'], 6, 2)"/>/<xsl:value-of select="substring(cell[@name='DS'], string-length(cell[@name='DS']) - 1)"/></xsl:element>
       </xsl:if> 
       <xsl:if test="string-length(cell[@name='DS'])">
        <xsl:element name="DTSF">
         <xsl:attribute name="hint">A</xsl:attribute><xsl:value-of select="substring-before(cell[@name='DE'], '.')"/>/<xsl:value-of select="substring(cell[@name='DE'], 6, 2)"/>/<xsl:value-of select="substring(cell[@name='DE'], string-length(cell[@name='DE']) - 1)"/></xsl:element>
        </xsl:if> 
      </xsl:element>
     </xsl:element>
    </xsl:if>
    
    <xsl:element name="MT">
     <xsl:attribute name="hint">DATI TECNICI</xsl:attribute>
     <xsl:element name="MTC">
      <xsl:attribute name="hint">MATERIA E TECNICA</xsl:attribute>
      <xsl:if test="cell[@name='MA_it']">
       <xsl:element name="MTCM">
        <xsl:attribute name="hint">Materia</xsl:attribute><xsl:value-of select="cell[@name='MA_it']"/></xsl:element>
      </xsl:if>
   			<xsl:for-each select="cell[@name='TK_it']">
	 	  		<xsl:element name="MTCT">
		 		   <xsl:attribute name="hint">Tecnica</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element>
			   </xsl:for-each>
     </xsl:element>
     
     <xsl:apply-templates select="cell[@name='dim_it']"/>
     
    </xsl:element>
    
    <xsl:element name="CM">
     <xsl:attribute name="hint">CERTIFICAZIONE E GESTIONE DEI DATI</xsl:attribute>
     <xsl:element name="AGG">
      <xsl:attribute name="hint">AGGIORNAMENTO/REVISIONE</xsl:attribute>
      <xsl:element name="AGGD">
       <xsl:attribute name="hint">Anno di aggiornamento/revisione</xsl:attribute><xsl:value-of select="substring-before(cell[@name='modification'], '-')"/></xsl:element>
     </xsl:element>
    </xsl:element>
   
   </xsl:element>
   
   <xsl:element name="harvesting">
    <xsl:for-each select="cell[@name='B1p_url' and string-length(normalize-space())]">
     <xsl:element name="media"><xsl:value-of select="concat(.,'&amp;size=l')"/></xsl:element>
    </xsl:for-each>
    <xsl:if test="string-length(normalize-space(cell[@name='CP_geo']))">
     <xsl:element name="puntoPrincipale">
      <xsl:variable name="x" select="normalize-space(substring-after(cell[@name='CP_geo'], ','))"/>
      <xsl:element name="x">
       <xsl:choose><!-- ignore multiple points -->
        <xsl:when test="contains($x,',')"><xsl:value-of select="substring-before($x,',')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$x"/></xsl:otherwise>
       </xsl:choose>
      </xsl:element>
      <xsl:element name="y"><xsl:value-of select="substring-before(cell[@name='CP_geo'], ',')"/></xsl:element>
     </xsl:element>
    </xsl:if>
   </xsl:element>
   
  </schede>
 </metadata>
</record>
 </xsl:template>

 <xsl:template match="cell[@name='dim_it']">
		
	 <xsl:element name="MIS">
	  <xsl:attribute name="hint">MISURE</xsl:attribute>
 		<xsl:element name="MISP">
	  	<xsl:attribute name="hint">Riferimento alla parte</xsl:attribute>supporto primario</xsl:element>
		 <xsl:element name="MISZ">
		  <xsl:attribute name="hint">Tipo di misura</xsl:attribute>altezzaxlunghezza</xsl:element>
		 <xsl:element name="MISU">
		  <xsl:attribute name="hint">Unità di misura</xsl:attribute><xsl:value-of select="substring(., string-length(.) - 1)"/></xsl:element>
		 <xsl:choose>
		  <xsl:when test="contains(.,'larghezza')">
  			<xsl:variable name="ALTcc" select="substring-after(.,',')"/>
 	 		<xsl:variable name="LARGcc" select="substring-before(.,',')"/>
 		 	<xsl:variable name="LARGc" select="substring-after($LARGcc,' ')"/>
 			 <xsl:variable name="ALTc" select="substring-after($ALTcc,' ')"/>
 		 	<xsl:variable name="LARG" select="substring-before($LARGc,' ')"/>
 		 	<xsl:variable name="ALT" select="substring-before($ALTc,' ')"/>
 		 	<xsl:element name="MISM">
    		<xsl:attribute name="hint">Valore</xsl:attribute><xsl:value-of select="$ALT"/>x<xsl:value-of select="$LARG"/></xsl:element>
		  </xsl:when>
		  <xsl:when test="contains(.,'lunghezza')">
  			<xsl:variable name="ALTcc" select="substring-after(.,',')"/>
 	 		<xsl:variable name="LARGcc" select="substring-before(.,',')"/>
 		 	<xsl:variable name="LARGc" select="substring-after($LARGcc,' ')"/>
 			 <xsl:variable name="ALTc" select="substring-after($ALTcc,' ')"/>
 		 	<xsl:variable name="LARG" select="substring-before($LARGc,' ')"/>
 		 	<xsl:variable name="ALT" select="substring-before($ALTc,' ')"/>
 		 	<xsl:element name="MISM">
    		<xsl:attribute name="hint">Valore</xsl:attribute><xsl:value-of select="$ALT"/>x<xsl:value-of select="$LARG"/></xsl:element>
		  </xsl:when>
  		<xsl:otherwise>
		  	<xsl:variable name="ALTc" select="normalize-space(substring-after(.,'x'))"/>
  			<xsl:variable name="LARG" select="normalize-space(substring-before(.,'x'))"/>
  			<xsl:variable name="ALT" select="substring-before($ALTc,' ')"/>
			  <xsl:element name="MISM">
    		<xsl:attribute name="hint">Valore</xsl:attribute><xsl:value-of select="$ALT"/>x<xsl:value-of select="$LARG"/></xsl:element>
  		</xsl:otherwise>
	  </xsl:choose>
		</xsl:element>

 </xsl:template>

</xsl:stylesheet>
