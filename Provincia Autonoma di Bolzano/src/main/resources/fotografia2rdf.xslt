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
  xmlns:arco-fn="https://w3id.org/arco/saxon-extension"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 
 <xsl:template match="*">
  <xsl:apply-templates select="*"/>
 </xsl:template>
 
 <xsl:template name="mus">
  <xsl:variable name="nome">
   <xsl:value-of select="arco-fn:get-nome-ente-from-codice(.)"/>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="string-length($nome)>0"><xsl:value-of select="$nome"/></xsl:when>
   <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
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
    <xsl:attribute name="rdf:about">
     <xsl:choose>
      <xsl:when test="name(*[1])='F'">PhotographicHeritage/<xsl:value-of select="translate(*/AC/ACC[1]/ACCC,'/ ','_')"/></xsl:when>
      <xsl:otherwise>
       <xsl:variable name="amb" select="MODI/OG/AMB"/>
       <xsl:choose>
        <xsl:when test="$amb='archeologico'">ArchaeologicalProperty</xsl:when>
        <xsl:when test="$amb='architettonico e paesaggistico'">ArchitecturalOrLandscapeHeritage</xsl:when>
        <xsl:when test="$amb='etnoantropologico'">DemoEthnoAnthropologicalHeritage</xsl:when>
        <xsl:when test="$amb='storico artistico'">HistoricOrArtisticProperty</xsl:when>
        <xsl:when test="$amb='non individuabile'">CulturalProperty</xsl:when>
       </xsl:choose>
       <xsl:value-of select="concat('/', translate(*/CD/ACC[1]/ACCC,'/ ','_'))" />
      </xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
    <xsl:for-each select="harvesting/media">
     <xsl:element name="foaf:depiction"><!-- @see fotografia.xslt
      <xsl:attribute name="rdf:resource"><xsl:value-of select="replace(.,' ','%20')"/></xsl:attribute>
--><xsl:attribute name="rdf:resource"><xsl:value-of select="."/></xsl:attribute>
     </xsl:element>
    </xsl:for-each>
    
     <xsl:if test="*/SG/SGT/SGTD">
      <xsl:element name="rdfs:comment"><xsl:value-of select="*/SG/SGT/SGTD"/></xsl:element>
     </xsl:if>
     
     <xsl:for-each select="harvesting/rights">
      <xsl:element name="dc:rights">
       <xsl:variable name="rights">
        <xsl:choose>
         <xsl:when test="@decode='true'">
          <xsl:text>Copyright </xsl:text>
          <xsl:call-template name="mus"/>
         </xsl:when>
          <xsl:otherwise>
           <xsl:value-of select="."/>
           <xsl:if test="../xri and ../mus">
            <xsl:value-of select="../xri"/>
            <xsl:for-each select="../mus"><xsl:call-template name="mus"/></xsl:for-each>
           </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
       </xsl:variable>
       <xsl:value-of select="$rights"/>
      </xsl:element>
     </xsl:for-each>
     
   </xsl:element>
  </rdf:RDF>
 </xsl:template>
 
</xsl:stylesheet>
