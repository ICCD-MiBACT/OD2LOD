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

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="row">
 
 <xsl:variable name="identifier" select="concat('AA_CG_',cell[@name='Sigla'])"/>
 
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
   <xsl:element name="CCF"><xsl:value-of select="concat('AA_CF_',cell[@name='Sigla'])"/></xsl:element>
   <xsl:element name="CCG"><xsl:value-of select="$identifier"/></xsl:element>
		</xsl:element>
		
		<xsl:element name="CG">
		<xsl:attribute name="hint">CONTENITORE GIURIDICO</xsl:attribute>
			<xsl:choose>
				<xsl:when test="contains(cell[@name='Denominazione'],'Museo') or contains(cell[@name='Denominazione'],'Museum')">
					<xsl:element name="CGT">
					<xsl:attribute name="hint">Tipologia</xsl:attribute>museo</xsl:element>
				</xsl:when>
				<xsl:when test="contains(cell[@name='Denominazione'],'Archivio')">
					<xsl:element name="CGT">
					<xsl:attribute name="hint">Tipologia</xsl:attribute>archivio</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="CGT">
					<xsl:attribute name="hint">Tipologia</xsl:attribute>non identificato</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:element name="CGN">
			<xsl:attribute name="hint">Denominazione attuale</xsl:attribute><xsl:value-of select="cell[@name='Denominazione']"/></xsl:element>
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
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="CM">
		<xsl:attribute name="hint">CERTIFICAZIONE E GESTIONE DEI DATI</xsl:attribute>
			<xsl:element name="CMP">
			<xsl:attribute name="hint">REDAZIONE E VERIFICA SCIENTIFICA</xsl:attribute>
				<xsl:element name="CMPD">
				<xsl:attribute name="hint">Anno di redazione</xsl:attribute>2015</xsl:element>
			</xsl:element>
		</xsl:element>		
				
	</xsl:element>
</schede>
</metadata>
</record>
</xsl:template>
</xsl:stylesheet>