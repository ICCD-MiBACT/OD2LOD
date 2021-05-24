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
 <xsl:param name="NS" />
 <!-- 
 
 /scheda_RA/csm_def/ser_ra => /record/metadata/schede/RA/ser_ra
 <ser_ra xmlns:xw="http://www.3di.it/ns/xw-200303121136" xml:space="preserve">CRV-RA_0010664</ser_ra>
 
  => https://beniculturali.regione.veneto.it/xway-front/application/crv/engine/crv.jsp?verbo=queryplain&view=@completa&query=(%5bser_gen%5d=%22CRV-RA_0010664%22)

  NOTA: ci sono casi in cui RV/RSE esprime una relazione che sarebbe papabile per istanziare una RelatedWorkSituation (arco.xslt 29788) ma arco-fn:related-property non è efficace e l'omissione passa inosservata 

 -->
  
 <xsl:template match="/">
  <rdf:RDF 
   xml:base="https://w3id.org/arco/resource/Veneto/"
   xmlns="https://w3id.org/arco/resource/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:foaf="http://xmlns.com/foaf/0.1/"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   >
   <!-- 
   <xsl:message>entering post.xslt</xsl:message>
   -->
   <!-- as per dublin-core.xslt code -->
   <xsl:variable name="sheetType" select="name(record/metadata/schede/*[1])" />
   <xsl:variable name="itemURI">
    <xsl:choose>
     <xsl:when test="record/metadata/schede/*/CD/NCT/NCTN">
      <xsl:value-of select="concat(record/metadata/schede/*/CD/NCT/NCTR, record/metadata/schede/*/CD/NCT/NCTN, record/metadata/schede/*/CD/NCT/NCTS)" />
      <xsl:if test="record/metadata/schede/*/RV/RVE/RVEL">
       <xsl:value-of select="concat('-', arco-fn:urify(normalize-space(record/metadata/schede/*/RV/RVE/RVEL)))" />
      </xsl:if>
     </xsl:when>
     <xsl:when test="record/metadata/schede/*/CD/CBC">
      <xsl:value-of select="record/metadata/schede/*/CD/CBC" />
     </xsl:when>
     <xsl:otherwise>
      <xsl:variable name="accc-space" >
       <xsl:choose>
        <xsl:when test="record/metadata/schede/*/AC/ACC/ACCC">
         <xsl:value-of select="record/metadata/schede/*/AC/ACC[1]/ACCC" />
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="record/metadata/schede/*/CD/ACC[1]/ACCC" />
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <xsl:variable name="accc-nospace" select="translate($accc-space, ' ', '')" />
      <xsl:variable name="accc" select="translate($accc-nospace, '/', '_')" />
      <xsl:variable name="acc-space" select="record/metadata/schede/*/AC/ACC[1]" />
      <xsl:variable name="acc-nospace" select="translate($acc-space, ' ', '')" />
      <xsl:variable name="acc" select="translate($acc-nospace, '/', '_')" />
      <xsl:choose>
       <xsl:when test="record/metadata/schede/*/AC/ACC/ACCC">
        <xsl:value-of select="$accc" />
       </xsl:when>
       <xsl:when test="record/metadata/schede/*/CD/ACC/ACCC">
        <xsl:value-of select="$accc" />
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="$acc" />
       </xsl:otherwise>
      </xsl:choose>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <xsl:variable name="culturalProperty" select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI)" />
   <!-- /as per dublin-core.xslt code -->
   <xsl:element name="rdf:Description">
    <xsl:attribute name="rdf:about"><xsl:value-of select="$culturalProperty"/></xsl:attribute>
    <!-- 
    <xsl:for-each select="record/metadata/schede/*/DO/FTA/FTA_IMG/*[@agent.meta]">
    -->
    <xsl:for-each select="record/metadata/schede/*/DO/FTA/FTA_IMG/*[@name]">
     <xsl:element name="foaf:depiction">
      <!-- https://beniculturali.regione.veneto.it/xway-front/application/crv/engine/crv.jsp?verbo=attach&db=crv_back&id=ot/meBfC5zA%3d%2ejpg -->
      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat('https://beniculturali.regione.veneto.it/xway-front/application/crv/engine/crv.jsp?verbo=attach&amp;db=crv_back&amp;id=',encode-for-uri(@name))"/></xsl:attribute>
     </xsl:element>
    </xsl:for-each>
   </xsl:element>
   
   <xsl:for-each select="record/metadata/schede/*/DO/FTA">
    <xsl:if test="FTA_IMG/*[@name]">
     <xsl:element name="rdf:Description">
      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($NS, 'PhotographicDocumentation/', $itemURI, '-photographic-documentation-', position())"/></xsl:attribute>
      <xsl:element name="foaf:depiction">
       <xsl:attribute name="rdf:resource"><xsl:value-of select="concat('https://beniculturali.regione.veneto.it/xway-front/application/crv/engine/crv.jsp?verbo=attach&amp;db=crv_back&amp;id=',encode-for-uri(FTA_IMG/*/@name))"/></xsl:attribute>
      </xsl:element>
     </xsl:element>
    </xsl:if> 
   </xsl:for-each>
   
  </rdf:RDF>
 </xsl:template>
 
</xsl:stylesheet>
