<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:ogr="http://ogr.maptools.org/"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xalan="org.apache.xalan.xslt.extensions.Redirect" extension-element-prefixes="xalan"
  exclude-result-prefixes="fn">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 <xsl:param name="datestamp" select="'2022-08-12T00:00:00Z'"/>
  
 <xsl:template match="*">
  <xsl:apply-templates select="*"/>
 </xsl:template>
 
 <xsl:template match="*[local-name()='SELECT']">
  <xsl:variable name="denomN" select="normalize-space(*[lower-case(local-name())='denom'])"/>

  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="lc_denom"><xsl:value-of select="translate($denomN, $uppercase, $lowercase)" /></xsl:variable>
  <!--<xsl:variable name="lc_denom" select="lower-case($denomN)"/>-->

  <record>
   <header>
    <xsl:element name="identifier"><xsl:value-of select="*[lower-case(local-name())='cod_r']"/></xsl:element>
    <xsl:element name="datestamp"><xsl:value-of select="$datestamp"/></xsl:element>
   </header>
   <metadata>
    <schede>

     <xsl:element name="SI">
      <xsl:attribute name="version">3.00</xsl:attribute>
      <xsl:element name="CD">
       <xsl:attribute name="hint">CODICI</xsl:attribute>
       <xsl:element name="TSK"><xsl:attribute name="hint">Tipo scheda</xsl:attribute>SI</xsl:element>
       <xsl:element name="NCT"><xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
        <xsl:element name="NCTR"><xsl:attribute name="hint">Codice regione</xsl:attribute>17</xsl:element>
       </xsl:element>
       <xsl:element name="ESC"><xsl:attribute name="hint">Ente schedatore</xsl:attribute>S284</xsl:element>
       <xsl:element name="ECP"><xsl:attribute name="hint">Ente competente</xsl:attribute>S284</xsl:element>
      </xsl:element>
      
      <xsl:element name="AC">                  
      <xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
       <xsl:element name="ACC"><xsl:attribute name="hint">Altro codice bene</xsl:attribute><xsl:value-of select="*[lower-case(local-name())='cod_r']"/>/ S284</xsl:element>
      </xsl:element>

      <xsl:element name="OG">
       <xsl:attribute name="hint">OGGETTO</xsl:attribute>
       <xsl:element name="OGT">
        <xsl:attribute name="hint">OGGETTO</xsl:attribute>
        <xsl:element name="OGTD">
         <xsl:attribute name="hint">Definizione</xsl:attribute>
         <xsl:choose>
          <xsl:when test="ogr:tipo"><xsl:value-of select="ogr:tipo"/></xsl:when>
          <xsl:otherwise>aree archeologiche tutelate per decreto</xsl:otherwise>
         </xsl:choose>  
        </xsl:element>
        <xsl:element name="OGTN"><xsl:attribute name="hint">Denominazione</xsl:attribute><xsl:value-of select="*[lower-case(local-name())='denom']"/></xsl:element>
       </xsl:element>
      </xsl:element>
       
      <xsl:element name="LC">
       <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
       <xsl:element name="PVC">
        <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
        <xsl:element name="PVCS"><xsl:attribute name="hint">Stato</xsl:attribute>Italia</xsl:element>
        <xsl:element name="PVCR"><xsl:attribute name="hint">Regione</xsl:attribute>Basilicata</xsl:element>
        <xsl:element name="PVCP"><xsl:attribute name="hint">Provincia</xsl:attribute><xsl:value-of select="*[lower-case(local-name())='provincia']"/></xsl:element>
        <xsl:element name="PVCC"><xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="*[lower-case(local-name())='comune']"/></xsl:element>
       </xsl:element>
      </xsl:element>

      <xsl:element name="TU">
      <xsl:attribute name="hint">CONDIZIONE GIURIDICA E VINCOLI</xsl:attribute>
       <xsl:element name="NVC">
        <xsl:attribute name="hint">PROVVEDIMENTI DI TUTELA</xsl:attribute>
        <xsl:choose>
         <xsl:when test="contains(*[lower-case(local-name())='rif_norm'],'art. 10')">
          <xsl:element name="NVCT"><xsl:attribute name="hint">Tipo provvedimento</xsl:attribute>DLgs n. 42/2004, art.10-13</xsl:element>
         </xsl:when>
         <xsl:when test="contains(*[lower-case(local-name())='rif_norm'],'art. 45')">
          <xsl:element name="NVCT"><xsl:attribute name="hint">Tipo provvedimento</xsl:attribute>DLgs n. 42/2004, art.45</xsl:element>
         </xsl:when>
        </xsl:choose>
       </xsl:element>
       <xsl:element name="NVC">
        <xsl:attribute name="hint">PROVVEDIMENTI DI TUTELA</xsl:attribute>
        <xsl:element name="NVCT"><xsl:attribute name="hint">Tipo provvedimento</xsl:attribute><xsl:value-of select="*[lower-case(local-name())='decreto']"/></xsl:element>
       </xsl:element>
      </xsl:element>
      
      <xsl:for-each select="(ogr:GEOMETRY/gml:Polygon|ogr:GEOMETRY/gml:MultiPolygon/gml:polygonMember/gml:Polygon)//gml:coordinates">
       <xsl:element name="GA">
        <xsl:attribute name="hint">GEOREFERENZIAZIONE TRAMITE AREA</xsl:attribute>
        <xsl:element name="GAL"><xsl:attribute name="hint">Tipo di localizzazione</xsl:attribute>localizzazione fisica</xsl:element>
        <xsl:element name="GAD">
         <xsl:attribute name="hint">DESCRIZIONE DEL POLIGONO</xsl:attribute>
         <xsl:for-each select="tokenize(., ' ')"><!-- lng,lat lng,lat lng,lat...  -->
          <xsl:element name="GADP"><xsl:attribute name="hint">PUNTO DEL POLIGONO</xsl:attribute>
           <xsl:element name="GADPX"><xsl:attribute name="hint">Coordinata X</xsl:attribute><xsl:value-of select="substring-before(.,',')"/></xsl:element>
           <xsl:element name="GADPY"><xsl:attribute name="hint">Coordinata Y</xsl:attribute><xsl:value-of select="substring-after(.,',')"/></xsl:element>
          </xsl:element>
         </xsl:for-each>
        </xsl:element> 
       </xsl:element>
      </xsl:for-each>
     </xsl:element>
     <!--
     <xsl:element name="harvesting">
      <xsl:element name="media"><xsl:value-of select="cell[@name='B1p_url']"/></xsl:element>
      <xsl:element name="puntoPrincipale">
       <xsl:element name="x"><xsl:value-of select="normalize-space(substring-after(cell[@name='CP_geo'], ','))"/></xsl:element>
       <xsl:element name="y"><xsl:value-of select="substring-before(cell[@name='CP_geo'], ',')"/></xsl:element>
      </xsl:element>
     </xsl:element>
     -->
    </schede>
   </metadata> 
  </record>
 </xsl:template>
</xsl:stylesheet>