<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="fn">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

 <xsl:param name="datestamp" select="'2022-05-14T00:00:00Z'"/>  
 <xsl:param name="xsltBase" select="''"/>  
 <xsl:param name="itemid" select="''"/>

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="row">
 
 <xsl:variable name="translateIdFrom"> àèéìòù."'“”’`#@?![]():;,+=/\|%{}^&amp;&lt;&gt;&#160;</xsl:variable>
 <xsl:variable name="translateIdTo"  >_aeeiou_______________________________</xsl:variable><!--
 <xsl:variable name="ID"><xsl:value-of select="translate(normalize-space(cell[@name='BEZEICHNUNG_I']),$translateIdFrom,$translateIdTo)"/></xsl:variable>
 --><xsl:variable name="ID" select="translate(normalize-space($itemid),$translateIdFrom,$translateIdTo)"/>
 <xsl:variable name="identifier" select="concat('AA_CF_',$ID)"/> 
 
<record>
 <header>
  <xsl:element name="identifier">
   <xsl:value-of select="$identifier"/>
  </xsl:element>
  <datestamp><xsl:value-of select="$datestamp"/></datestamp>
 </header>
 <metadata>
  <schede>

 <xsl:element name="CF">
  <xsl:attribute name="version">4.00_IICD0</xsl:attribute>
  <xsl:element name="CD">
  <xsl:attribute name="hint">CODICI</xsl:attribute>
   <xsl:element name="TSK">
   <xsl:attribute name="hint">Tipo scheda</xsl:attribute>CF</xsl:element>
   <xsl:element name="LIR">
   <xsl:attribute name="hint">Livello</xsl:attribute>P</xsl:element>
   <xsl:element name="ESC">
   <xsl:attribute name="hint">Ente schedatore</xsl:attribute>P021</xsl:element>
   <xsl:element name="ACC">
   <xsl:attribute name="hint">ALTRA IDENTIFICAZIONE</xsl:attribute>
    <xsl:element name="ACCE">
    <xsl:attribute name="hint">Ente/soggetto responsabile</xsl:attribute>P021</xsl:element>
    <xsl:element name="ACCC">
    <xsl:attribute name="hint">Codice identificativo</xsl:attribute><xsl:value-of select="$identifier"/></xsl:element>
   </xsl:element>
   <xsl:element name="CCF"><xsl:value-of select="$identifier"/></xsl:element>
   <xsl:element name="CCG"><xsl:value-of select="concat('AA_CG_',$ID)"/></xsl:element>
  </xsl:element>
  
  <xsl:element name="CF">
   <xsl:attribute name="hint">CONTENITORE FISICO</xsl:attribute>
   <xsl:element name="CFT">
    <xsl:attribute name="hint">Tipologia</xsl:attribute>museo</xsl:element>
   <xsl:element name="CFN">
	  	<xsl:attribute name="hint">Denominazione attuale</xsl:attribute><xsl:value-of select="cell[@name='BEZEICHNUNG_I']"/></xsl:element>
		 <xsl:element name="CFD">
 		 <xsl:attribute name="hint">Descrizione</xsl:attribute><xsl:value-of select="cell[@name='BESCHREIBUNG_I']"/></xsl:element>
		 <xsl:element name="CFW">
		  <xsl:attribute name="hint">Sito web</xsl:attribute><xsl:value-of select="cell[@name='HOMEPAGE_I']"/></xsl:element>
  </xsl:element>
  
  <xsl:element name="LC">
   <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO - AMMINISTRATIVA</xsl:attribute>
   <xsl:element name="PVC">
    <xsl:attribute name="hint">LOCALIZZAZIONE</xsl:attribute>
    <xsl:element name="PVCS">
     <xsl:attribute name="hint">Stato</xsl:attribute>Italia</xsl:element>
    <xsl:element name="PVCR">
     <xsl:attribute name="hint">Regione</xsl:attribute>Regione Trentino-Alto Adige</xsl:element>
    <xsl:element name="PVCP">
     <xsl:attribute name="hint">Provincia</xsl:attribute>Provincia autonoma di Bolzano</xsl:element>
    
    <xsl:element name="PVCC">
     <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="cell[@name='ORTSCHAFT_I']"/></xsl:element>
    <xsl:element name="PVCI">
     <xsl:attribute name="hint">Indirizzo</xsl:attribute><xsl:value-of select="cell[@name='ADRESSE_I']"/></xsl:element>
    
   </xsl:element>
  </xsl:element>
  
  <xsl:element name="GE">	
   <xsl:attribute name="hint">GEOREFERENZIAZIONE</xsl:attribute>
   <xsl:element name="GEL">
    <xsl:attribute name="hint">Tipo di localizzazione</xsl:attribute>localizzazione fisica</xsl:element>
   <xsl:element name="GET">
    <xsl:attribute name="hint">Tipo di georeferenziazione</xsl:attribute>georeferenziazione puntuale</xsl:element>
   <xsl:element name="GEC">
    <xsl:attribute name="hint">COORDINATE</xsl:attribute>
    <xsl:element name="GECX">
  		 <xsl:attribute name="hint">Coordinata x</xsl:attribute><xsl:value-of select="cell[@name='GEOKOORDINATE_X']"/></xsl:element>
    <xsl:element name="GECY">
     <xsl:attribute name="hint">Coordinata y</xsl:attribute><xsl:value-of select="cell[@name='GEOKOORDINATE_Y']"/></xsl:element>
   </xsl:element>
  </xsl:element>  
  
  <xsl:element name="CM">	
   <xsl:attribute name="hint">CERTIFICAZIONE E GESTIONE DEI DATI</xsl:attribute>
   <xsl:element name="CMP">
    <xsl:attribute name="hint">REDAZIONE E VERIFICA SCIENTIFICA</xsl:attribute>
    <xsl:element name="CMPD">
     <xsl:attribute name="hint">Anno di redazione</xsl:attribute>2016</xsl:element>
   </xsl:element>
  </xsl:element>  
    
 </xsl:element>
 
 <xsl:element name="harvesting">
  <xsl:element name="label_de"><xsl:value-of select="cell[@name='BEZEICHNUNG_D']"/></xsl:element>
  <xsl:element name="city_de"><xsl:value-of select="cell[@name='ORTSCHAFT_D']"/></xsl:element>
  <xsl:element name="address_de"><xsl:value-of select="cell[@name='ADRESSE_D']"/></xsl:element>
 </xsl:element>
 
</schede>
</metadata>
</record>
</xsl:template>
</xsl:stylesheet>