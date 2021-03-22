<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:dcterms="http://purl.org/dc/terms/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:foaf="http://xmlns.com/foaf/0.1/"
 xmlns:pico="http://data.cochrane.org/ontologies/pico/"
 xmlns:arco="https://w3id.org/arco/ontology/arco/"
 xmlns:arco-fn="https://w3id.org/arco/saxon-extension">
 
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 
 <xsl:param name="item"/>
 <xsl:param name="NS"/>
 
 <xsl:variable name="sheetType" select="name(record/metadata/schede/*[1])"/>
 <xsl:variable name="sheetVersion" select="record/metadata/schede/*/@version"/>
 <xsl:variable name="itemURI">
  <xsl:choose>
   <xsl:when test="record/metadata/schede/*/CD/NCT/NCTN">
    <xsl:choose>
     <xsl:when test="record/metadata/schede/*/RV/RVE/RVEL">
      <xsl:value-of select="concat(record/metadata/schede/*/CD/NCT/NCTR, record/metadata/schede/*/CD/NCT/NCTN, record/metadata/schede/*/CD/NCT/NCTS, '-', arco-fn:urify(normalize-space(record/metadata/schede/*/RV/RVE/RVEL)))"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="concat(record/metadata/schede/*/CD/NCT/NCTR, record/metadata/schede/*/CD/NCT/NCTN, record/metadata/schede/*/CD/NCT/NCTS)"/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:when test="record/metadata/schede/*/CD/CBC">
    <xsl:value-of select="record/metadata/schede/*/CD/CBC"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:variable name="accc-space"/>
    <xsl:choose>
     <xsl:when test="record/metadata/schede/*/AC/ACC/ACCC">
      <xsl:value-of select="record/metadata/schede/*/AC/ACC[1]/ACCC"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="record/metadata/schede/*/CD/ACC[1]/ACCC"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="accc-nospace" select="translate($accc-space, ' ', '')"/>
    <xsl:variable name="accc" select="translate($accc-nospace, '/', '_')"/>
    <xsl:variable name="acc-space" select="record/metadata/schede/*/AC/ACC[1]"/>
    <xsl:variable name="acc-nospace" select="translate($acc-space, ' ', '')"/>
    <xsl:variable name="acc" select="translate($acc-nospace, '/', '_')"/>
    <xsl:choose>
     <xsl:when test="record/metadata/schede/*/AC/ACC/ACCC">
      <xsl:value-of select="$accc"/>
     </xsl:when>
     <xsl:when test="record/metadata/schede/*/CD/ACC/ACCC">
      <xsl:value-of select="$accc"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$acc"/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
 <xsl:variable name="culturalProperty" select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI)"/>
 
 <xsl:template match="/">
  <rdf:RDF>
   <rdf:Description>
    <xsl:attribute name="rdf:about">
     <xsl:value-of select="$culturalProperty"/>
    </xsl:attribute>
    <xsl:variable name="linkSource" select="record/metadata/schede/harvesting/linkSource"/>    
    <xsl:if test="string-length($linkSource)">
     <dc:source>
      <xsl:attribute name="rdf:resource">
       <xsl:value-of select="$linkSource"/>
      </xsl:attribute>
     </dc:source>
    </xsl:if>
    <xsl:variable name="linkMedia" select="record/metadata/schede/harvesting/linkMedia"/>
    <xsl:if test="string-length($linkMedia)">
     <xsl:variable name="tokens" select="tokenize($linkMedia, '// ')" as="xs:string+"/>
     <xsl:for-each select="$tokens">
      <xsl:variable name="token" select="normalize-space(.)"/>
      <xsl:if test="string-length($token)">
       <xsl:variable name="res">
        <xsl:choose>
         <xsl:when test="starts-with($token,'http')">
          <xsl:value-of select="$token"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:value-of select="concat('https://catalogo.sardegnacultura.it/media/',$token,'/watermark-view/')"/>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:variable>
       <foaf:depiction>
        <xsl:attribute name="rdf:resource">
         <xsl:value-of select="$res"/>
        </xsl:attribute>
       </foaf:depiction>
       <pico:preview>
        <xsl:attribute name="rdf:resource">
         <xsl:value-of select="$res"/>
        </xsl:attribute>
       </pico:preview>
      </xsl:if>
     </xsl:for-each>
    </xsl:if>
   </rdf:Description>
  </rdf:RDF>
 </xsl:template>
 
</xsl:stylesheet>
