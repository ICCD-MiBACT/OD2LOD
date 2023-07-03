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
 <xsl:variable name="identifier" select="concat('AA_CG_',$ID)"/> 
 
<record>
 <header>
  <xsl:element name="identifier">
   <xsl:value-of select="$identifier"/>
  </xsl:element>
  <datestamp><xsl:value-of select="$datestamp"/></datestamp>
 </header>
 <metadata>
  <schede>

 <xsl:element name="CG">
  <xsl:attribute name="version">4.00_IICD0</xsl:attribute>
  <xsl:element name="CD">
  <xsl:attribute name="hint">CODICI</xsl:attribute>
   <xsl:element name="TSK">
   <xsl:attribute name="hint">Tipo scheda</xsl:attribute>CG</xsl:element>
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
   <xsl:element name="CCF"><xsl:value-of select="concat('AA_CF_',$ID)"/></xsl:element>
   <xsl:element name="CCG"><xsl:value-of select="$identifier"/></xsl:element>
  </xsl:element>
  
  <xsl:element name="CG">
   <xsl:attribute name="hint">CONTENITORE GIURIDICO</xsl:attribute>
   <xsl:element name="CGT">
    <xsl:attribute name="hint">Tipologia</xsl:attribute>museo</xsl:element>
   <xsl:element name="CGN">
    <xsl:attribute name="hint">Denominazione raccolta</xsl:attribute><xsl:value-of select="cell[@name='BEZEICHNUNG_I']"/></xsl:element>
   <xsl:element name="CGD">
    <xsl:attribute name="hint">Descrizione</xsl:attribute><xsl:value-of select="cell[@name='BESCHREIBUNG_I']"/></xsl:element>
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
  
  <!-- NON INVIATO A FABIO -->
  <xsl:element name="info">
   <xsl:if test="cell[@name='TELEFON'][text()!='']"><xsl:element name="telefono"><xsl:value-of select="cell[@name='TELEFON']"/></xsl:element>
   </xsl:if>
   <xsl:if test="cell[@name='TELEFON 2'][text()!='']"><xsl:element name="telefono2"><xsl:value-of select="cell[@name='TELEFON 2']"/></xsl:element>
   </xsl:if>
   <xsl:if test="cell[@name='FAX'][text()!='']"><xsl:element name="fax"><xsl:value-of select="cell[@name='FAX']"/></xsl:element>
   </xsl:if>
   <xsl:if test="cell[@name='EMAIL_I'][text()!='']"><xsl:element name="email"><xsl:value-of select="cell[@name='EMAIL_I']"/></xsl:element>
   </xsl:if>
  </xsl:element>
  <xsl:if test="cell[@name='EINTRITT_I'][text()!='']"><xsl:element name="biglietto"><xsl:value-of select="cell[@name='EINTRITT_I']"/></xsl:element>
  </xsl:if>
  <xsl:if test="cell[@name='ÖFFNUNGSZEITEN_I'][text()!='']"><xsl:element name="orario"><xsl:value-of select="cell[@name='ÖFFNUNGSZEITEN_I']"/></xsl:element>
  </xsl:if>
  <!-- NON INVIATO A FABIO -->
 </xsl:element>
 
</schede>
</metadata>
</record>
</xsl:template>
</xsl:stylesheet>
