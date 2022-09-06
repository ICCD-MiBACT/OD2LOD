<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:ogr="http://ogr.maptools.org/"
  xmlns:gml="http://www.opengis.net/gml"
  exclude-result-prefixes="fn">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
 <xsl:template match="* | @* | text()"><xsl:copy><xsl:apply-templates select="* | @* | text()"/></xsl:copy></xsl:template>

 <xsl:template match="ogr:COD_R">
  <xsl:element name="ogr:cod_r">
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="ogr:COMUNE">
  <xsl:element name="ogr:comune">
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="ogr:DENOM">
  <xsl:element name="ogr:denom">
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="ogr:Decreto">
  <xsl:element name="ogr:decreto">
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="ogr:PROVINCIA">
  <xsl:element name="ogr:provincia">
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>
 <xsl:template match="ogr:RIF_NORM">
  <xsl:element name="ogr:rif_norm">
   <xsl:value-of select="."/>
  </xsl:element>
 </xsl:template>

</xsl:stylesheet>