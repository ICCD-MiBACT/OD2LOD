<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
 xmlns:owl="http://www.w3.org/2002/07/owl#"
 xmlns:l0="https://w3id.org/italia/onto/l0/"
 xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
 xmlns:arco-fn="https://w3id.org/arco/saxon-extension"
 version="2.0">

 <xsl:param name="NS" />
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 
 <xsl:template name="CamelCase">
  <xsl:param name="text" />
  <xsl:choose>
   <xsl:when test="contains($text,' ')">
    <xsl:call-template name="CamelCaseWord">
     <xsl:with-param name="text" select="substring-before($text,' ')" />
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:call-template name="CamelCase">
     <xsl:with-param name="text" select="substring-after($text,' ')" />
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="CamelCaseWord">
     <xsl:with-param name="text" select="$text" />
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template name="CamelCaseWord">
  <xsl:param name="text" />
  <xsl:value-of select="translate(substring($text,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
  <xsl:value-of select="translate(substring($text,2,string-length($text)-1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
 </xsl:template>
 
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

 <xsl:if test="$sheetType='CF'">
  <rdf:Description>
   <xsl:attribute name="rdf:about">
    <xsl:value-of select="concat($NS, 'Address/', arco-fn:arcofy(concat(normalize-space(lower-case(record/metadata/schede/*/LC/PVC/PVCP)), normalize-space(lower-case(record/metadata/schede/*/LC/PVC/PVCC)), normalize-space(lower-case(record/metadata/schede/*/LC/PVC/PVCF)), normalize-space(lower-case(record/metadata/schede/*/LC/PVC/PVCL)), normalize-space(lower-case(record/metadata/schede/*/LC/PVC/PVCI)), normalize-space(lower-case(record/metadata/schede/*/LC/LDC/LDCU)))))" />
   </xsl:attribute>
   <clvapit:fullAddress xml:lang="de">
    <xsl:value-of select="normalize-space(record/metadata/schede/harvesting/address_de)" />
   </clvapit:fullAddress> 
   <clvapit:hasCity>
    <xsl:attribute name="rdf:resource">
     <xsl:value-of select="concat($NS, 'City/', arco-fn:urify(record/metadata/schede/*/LC/PVC/PVCC))" />
    </xsl:attribute>
   </clvapit:hasCity>
  </rdf:Description>
  
  <rdf:Description>
   <xsl:attribute name="rdf:about">
    <xsl:value-of select="concat($NS, 'City/', arco-fn:urify(record/metadata/schede/*/LC/PVC/PVCC))" />
   </xsl:attribute>
   <rdfs:label xml:lang="de">
    <xsl:call-template name="CamelCase">
     <xsl:with-param name="text" select="normalize-space(record/metadata/schede/harvesting/city_de)" />
    </xsl:call-template>
   </rdfs:label>
   <l0:name xml:lang="de">
    <xsl:call-template name="CamelCase">
     <xsl:with-param name="text" select="normalize-space(record/metadata/schede/harvesting/city_de)" />
    </xsl:call-template>
   </l0:name>
  </rdf:Description>
 </xsl:if>
 
</xsl:if>
 </rdf:RDF>
</xsl:template>        
</xsl:stylesheet>