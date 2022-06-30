<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:l0="https://w3id.org/italia/onto/l0/"
	xmlns:arco-fn="https://w3id.org/arco/saxon-extension"
 version="2.0">

	<xsl:param name="NS" />
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 
<xsl:template match="/">
	<rdf:RDF>
	<xsl:variable name="sheetType" select="name(record/metadata/schede/*[1])" />
 <xsl:if test="$sheetType='CF' or $sheetType='CG'" > 
 
 <xsl:variable name="id">
 	<xsl:if test="$sheetType='CF'" ><xsl:value-of select="record/metadata/schede/CF/CD/CCF" /></xsl:if>
  <xsl:if test="$sheetType='CG'" ><xsl:value-of select="record/metadata/schede/CG/CD/CCG" /></xsl:if>
 </xsl:variable>
 <xsl:variable name="label-it">
 	<xsl:if test="$sheetType='CF'" ><xsl:value-of select="record/metadata/schede/CF/CF/CFN" /></xsl:if>
  <xsl:if test="$sheetType='CG'" ><xsl:value-of select="record/metadata/schede/CG/CG/CGN" /></xsl:if>
 </xsl:variable>
 <xsl:variable name="contenitore" select="concat($NS, 'CulturalInstituteOrSite/', $id)" />
 <xsl:variable name="label-de" select="normalize-space(record/metadata/schede/harvesting/label_de)" />
 
	<rdf:Description>
		<xsl:attribute name="rdf:about">
  	<xsl:value-of select="$contenitore" />
		</xsl:attribute>
		<rdfs:label xml:lang="de"><xsl:value-of select="$label-de" /></rdfs:label>
		<l0:name xml:lang="de"><xsl:value-of select="$label-de" /></l0:name>
	</rdf:Description>
 
	<rdf:Description>
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="concat($NS,'DesignationInTime/', $id, '-', arco-fn:urify($label-it))" />
		</xsl:attribute>
		<rdfs:label xml:lang="de"><xsl:value-of select="$label-de" /></rdfs:label>
		<l0:name xml:lang="de"><xsl:value-of select="$label-de" /></l0:name>
	</rdf:Description>
 
</xsl:if>
	</rdf:RDF>
</xsl:template>								
</xsl:stylesheet>