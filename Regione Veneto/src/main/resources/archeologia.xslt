<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 <xsl:param name="datestamp" select="'2020-05-07T00:00:00Z'"/>
 
 <!--
 
  scheda_RA/storia/ultima_modifica/@data /scheda_RA/storia/ultima_modifica/@ora
    <ultima_modifica azione="" cod_oper="PI000669" cod_uff_oper="SI000118" data="20111120" oper="Gabucci Ada" ora="09:42:36" uff_oper="Museo Provinciale di Torcello">
   
  => header/datestamp 2011-11-20T09:42:36Z
  
  NB: negli xpath la / non è efficace perché la trasformazione lavora su element e non document 
 
 -->
 
 <xsl:template match="scheda_RA">
  <record>
   <header>
    
    <xsl:element name="datestamp">
     <xsl:choose>
      <xsl:when test="storia/ultima_modifica/@data">
       <xsl:value-of select="concat(substring(storia/ultima_modifica/@data,1,4),'-',substring(storia/ultima_modifica/@data,4,2),'-',substring(storia/ultima_modifica/@data,6,2),'T',storia/ultima_modifica/@ora,'Z')"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$datestamp"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:element>
    
   </header>
   <metadata>
    <schede>
    
     <xsl:element name="RA">
      <xsl:attribute name="version">3.00</xsl:attribute>
      <xsl:apply-templates select="csm_def/*"/>
     </xsl:element>
     
    </schede>
   </metadata>
  </record>
 </xsl:template>
 
 <xsl:template match="@xml:space"/>
 <xsl:template match="/*/scheda_RA/csm_def/DO/FTA/FTA_IMG/*/node()"/>
 <xsl:template match="* | @* | text() | comment()">
  <xsl:copy><xsl:apply-templates select="* | @* | text() | comment()"/></xsl:copy>
 </xsl:template>

</xsl:stylesheet>