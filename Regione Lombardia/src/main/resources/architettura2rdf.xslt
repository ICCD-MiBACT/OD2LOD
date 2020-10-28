<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:arco="https://w3id.org/arco/ontology/arco/"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
 <xsl:template match="/">
  <rdf:RDF xml:base="https://w3id.org/arco/resource/"
   xmlns="https://w3id.org/arco/resource/"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:owl="http://www.w3.org/2002/07/owl#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:foaf="http://xmlns.com/foaf/0.1/"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:cis="http://dati.beniculturali.it/cis/"
   xmlns:l0="https://w3id.org/italia/onto/l0/"
   xmlns:tiapit="https://w3id.org/italia/onto/TI/"
   xmlns:potapit="https://w3id.org/italia/onto/POT/"
   xmlns:cpevapit="https://w3id.org/italia/onto/CPEV/"
   xmlns:cpvapit="https://w3id.org/italia/onto/CPV/"
   xmlns:accessCondition="https://w3id.org/italia/onto/AccessCondition/"
   xmlns:smapit="https://w3id.org/italia/onto/SM/"
   xmlns:roapit="https://w3id.org/italia/onto/RO/"
   xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
   xmlns:covapit="https://w3id.org/italia/onto/COV/"
   xmlns:arco="https://w3id.org/arco/ontology/arco/"
   xmlns:arco-core="https://w3id.org/arco/ontology/core/"
   xmlns:arco-cd="https://w3id.org/arco/ontology/context-description/"
   xmlns:cataloguing-campaign="https://w3id.org/arco/ontology/cataloguing-campaign/"
   >  
   <xsl:apply-templates mode="b"/>
  </rdf:RDF>
 </xsl:template>

 <xsl:template match="row" mode="b">
	 <xsl:element name="rdf:Description">
  	<xsl:attribute name="rdf:about">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>/R03</xsl:attribute>
		 <xsl:element name="dc:source">
		  <xsl:attribute name="rdf:resource">http://www.lombardiabeniculturali.it/architetture/schede/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/></xsl:attribute>
		 </xsl:element>
		 <xsl:element name="dc:source">
		  <xsl:attribute name="rdf:resource">http://www.lombardiabeniculturali.it/architetture/schede-complete/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/></xsl:attribute>
		 </xsl:element>
		
 		<xsl:if test="cell[@name='COMPLESSITA_DEL_BENE']='bene componente'">
	 		<xsl:element name="arco:isCulturalPropertyComponentOf">
		  	<xsl:attribute name="rdf:resource">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_BENE_COMPLESSO']"/>/R03</xsl:attribute>
		 	</xsl:element>
	 	</xsl:if>
	 </xsl:element>		
  <!--
  <xsl:if test="cell[@name='COMPLESSITA_DEL_BENE']='bene componente'">
   <xsl:element name="rdf:Description">
    <xsl:attribute name="rdf:about">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>/R03</xsl:attribute>
    <xsl:element name="dcterms:isPartOf">
     <xsl:attribute name="rdf:resource">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_BENE_COMPLESSO']"/>/R03</xsl:attribute>
    </xsl:element>
   </xsl:element>
	 </xsl:if>
  -->
 </xsl:template>

</xsl:stylesheet>
