<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
 xmlns:owl="http://www.w3.org/2002/07/owl#"
 xmlns:l0="https://w3id.org/italia/onto/l0/"
 xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
 xmlns:arco-fn="https://w3id.org/arco/saxon-extension"
 xmlns:smapit="https://w3id.org/italia/onto/SM/"
 xmlns:accessCondition="https://w3id.org/italia/onto/AccessCondition/"
 xmlns:potapit="https://w3id.org/italia/onto/POT/"
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
  <xsl:if test="$sheetType='CG'">
   <xsl:for-each select="record/metadata/schede[harvesting/orario]">
    <xsl:element name="accessCondition:hasAccessCondition">
     <xsl:element name="accessCondition:OpeningHoursSpecification">
      <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>OpeningHoursSpecification/Orari_di_apertura_<xsl:value-of select="$id"/></xsl:attribute>
      <xsl:element name="rdfs:label">
       <xsl:attribute name="xml:lang">it</xsl:attribute>Orari di apertura di: <xsl:value-of select="CG/CG/CGN"/>
      </xsl:element>
      <xsl:element name="l0:description">
       <xsl:attribute name="xml:lang">it</xsl:attribute>
       <xsl:value-of select="harvesting/orario"/>
      </xsl:element>
     </xsl:element>
    </xsl:element>
   </xsl:for-each>
   
   <xsl:apply-templates select="record/metadata/schede/harvesting/info" mode="info1"/><!--
   <xsl:apply-templates select="record/metadata/schede/harvesting/biglietto" mode="bigl1"/>
   -->
  </xsl:if>
 </rdf:Description>
 
 <xsl:if test="$sheetType='CG'">
  <xsl:apply-templates select="record/metadata/schede/harvesting/info" mode="info2"/>
  <xsl:apply-templates select="record/metadata/schede/harvesting/biglietto" mode="bigl2"/>
 </xsl:if>
 
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

 <xsl:variable name="translateIdFrom"> àèéìòù."'“”’`#@?![]():;,+=/\|%{}^&amp;&lt;&gt;&#160;</xsl:variable>
 <xsl:variable name="translateIdTo"  >_aeeiou_______________________________</xsl:variable>

 <xsl:template match="harvesting/info" mode="info1">
  <xsl:if test="email|telefono2|telefono|fax">
   <xsl:element name="smapit:hasOnlineContactPoint">
    <xsl:element name="smapit:OnlineContactPoint">
     <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>OnlineContactPoint/<xsl:if test="email">-<xsl:value-of select="translate(normalize-space(email),$translateIdFrom,$translateIdTo)"/></xsl:if><xsl:if test="telefono2">-<xsl:value-of select="translate(normalize-space(telefono2),$translateIdFrom,$translateIdTo)"/></xsl:if><xsl:if test="telefono">-<xsl:value-of select="translate(normalize-space(telefono),$translateIdFrom,$translateIdTo)"/></xsl:if><xsl:if test="fax">-<xsl:value-of select="translate(normalize-space(fax),$translateIdFrom,$translateIdTo)"/></xsl:if></xsl:attribute>
     <xsl:element name="rdfs:label">
      <xsl:attribute name="xml:lang">it</xsl:attribute>Contatti di: <xsl:value-of select="/record/metadata/schede/CG/CG/CGN"/>
     </xsl:element>
     <xsl:if test="email">
      <xsl:element name="smapit:hasEmail">
       <xsl:attribute name="rdf:resource"><xsl:value-of select="$NS"/>Email/<xsl:value-of select="translate(normalize-space(email),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      </xsl:element>
     </xsl:if>
     <xsl:if test="telefono2">
      <xsl:element name="smapit:hasTelephone">
       <xsl:attribute name="rdf:resource"><xsl:value-of select="$NS"/>Telephone/<xsl:value-of select="translate(normalize-space(telefono2),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      </xsl:element>
     </xsl:if>
     <xsl:if test="telefono">
      <xsl:element name="smapit:hasTelephone">
       <xsl:attribute name="rdf:resource"><xsl:value-of select="$NS"/>Telephone/<xsl:value-of select="translate(normalize-space(telefono),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      </xsl:element>
     </xsl:if>
     <xsl:if test="fax">
      <xsl:element name="smapit:hasTelephone">
       <xsl:attribute name="rdf:resource"><xsl:value-of select="$NS"/>Telephone/<xsl:value-of select="translate(normalize-space(fax),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      </xsl:element>
     </xsl:if>
    </xsl:element>
   </xsl:element>
  </xsl:if>
 </xsl:template>
  
 <xsl:template match="harvesting/info" mode="info2">
  <xsl:if test="email">
    <xsl:element name="smapit:Email">
      <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>Email/<xsl:value-of select="translate(normalize-space(email),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      <xsl:element name="smapit:emailAddress">mailto:<xsl:value-of select="email"/>
      </xsl:element>
      <xsl:element name="smapit:hasEmailType">
        <xsl:attribute name="rdf:resource">https://w3id.org/italia/controlled-vocabulary/classifications-for-public-services/channel/042</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:if>
  <xsl:if test="telefono2">
    <xsl:element name="smapit:Telephone">
      <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>Telephone/<xsl:value-of select="translate(normalize-space(telefono2),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      <xsl:element name="smapit:hasTelephoneType">
        <xsl:attribute name="rdf:resource">https://w3id.org/italia/controlled-vocabulary/classifications-for-public-services/channel/031</xsl:attribute>
      </xsl:element>
      <xsl:element name="smapit:telephoneNumber">
        <xsl:value-of select="normalize-space(telefono2)"/>
      </xsl:element>
    </xsl:element>
  </xsl:if>
  <xsl:if test="telefono">
    <xsl:element name="smapit:Telephone">
      <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>Telephone/<xsl:value-of select="translate(normalize-space(telefono),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      <xsl:element name="smapit:hasTelephoneType">
        <xsl:attribute name="rdf:resource">https://w3id.org/italia/controlled-vocabulary/classifications-for-public-services/channel/031</xsl:attribute>
      </xsl:element>
      <xsl:element name="smapit:telephoneNumber">
        <xsl:value-of select="normalize-space(telefono)"/>
      </xsl:element>
    </xsl:element>
  </xsl:if>
  <xsl:if test="fax">
    <xsl:element name="smapit:Telephone">
      <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>Telephone/<xsl:value-of select="translate(normalize-space(fax),$translateIdFrom,$translateIdTo)"/></xsl:attribute>
      <xsl:element name="smapit:hasTelephoneType">
        <xsl:attribute name="rdf:resource">https://w3id.org/italia/controlled-vocabulary/classifications-for-public-services/channel/033</xsl:attribute>
      </xsl:element>
      <xsl:element name="smapit:telephoneNumber">
        <xsl:value-of select="normalize-space(fax)"/>
      </xsl:element>
    </xsl:element>
  </xsl:if>
 </xsl:template>
 <!--
 <xsl:template match="harvesting/biglietto" mode="bigl1">
  <xsl:variable name="sheetType" select="name(/record/metadata/schede/*[1])" />
  <xsl:variable name="identifier">
   <xsl:if test="$sheetType='CF'" ><xsl:value-of select="/record/metadata/schede/CF/CD/CCF" /></xsl:if>
   <xsl:if test="$sheetType='CG'" ><xsl:value-of select="/record/metadata/schede/CG/CD/CCG" /></xsl:if>
  </xsl:variable>
  <xsl:element name="potapit:hasTicket">
   <xsl:element name="potapit:Ticket">
    <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>Ticket/<xsl:value-of select="$identifier"/></xsl:attribute>
   </xsl:element>
  </xsl:element>
 </xsl:template>
 -->
 <xsl:template match="harvesting/biglietto" mode="bigl2">
  <xsl:variable name="sheetType" select="name(/record/metadata/schede/*[1])" />
  <xsl:variable name="identifier">
   <xsl:if test="$sheetType='CF'" ><xsl:value-of select="/record/metadata/schede/CF/CD/CCF" /></xsl:if>
   <xsl:if test="$sheetType='CG'" ><xsl:value-of select="/record/metadata/schede/CG/CD/CCG" /></xsl:if>
  </xsl:variable>
  <xsl:element name="potapit:Offer">
   <xsl:attribute name="rdf:about"><xsl:value-of select="$NS"/>Offer/<xsl:value-of select="$identifier"/></xsl:attribute>
   <xsl:element name="rdfs:label">Offerta base</xsl:element><!--
   <xsl:element name="potapit:includes">
    <xsl:attribute name="rdf:resource"><xsl:value-of select="$NS"/>Ticket/<xsl:value-of select="$identifier"/></xsl:attribute>
   </xsl:element> -->
   <xsl:element name="l0:description"><xsl:value-of select="."/></xsl:element>
  </xsl:element>
 </xsl:template>

</xsl:stylesheet>