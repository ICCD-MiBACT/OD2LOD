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
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:arco="https://w3id.org/arco/ontology/arco/"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 
 <xsl:template match="*">
  <xsl:apply-templates select="*"/>
 </xsl:template>

 <xsl:template match="schede">
  <rdf:RDF 
   xml:base="https://w3id.org/arco/resource/AltoAdige/"
   xmlns="https://w3id.org/arco/resource/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:foaf="http://xmlns.com/foaf/0.1/"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   >  
   <xsl:element name="rdf:Description">
    <xsl:attribute name="rdf:about">PhotographicHeritage/<xsl:value-of select="translate(*/AC/ACC[1]/ACCC,'/ ','_')"/></xsl:attribute>
    <xsl:for-each select="harvesting/media">
     <xsl:element name="foaf:depiction">
      <xsl:attribute name="rdf:resource"><xsl:value-of select="replace(.,' ','%20')"/></xsl:attribute>
     </xsl:element>
    </xsl:for-each>
   </xsl:element>
  </rdf:RDF>
 </xsl:template>
 
</xsl:stylesheet>
